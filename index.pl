#!/usr/bin/perl
use warnings;
use CGI::Simple;
use DBI;
use Template;
use User::Simple;
use User::Simple::Admin;
use Digest::MD5 qw(md5_hex);
use Number::Format;
use MIME::Lite;
use GD::Thumbnail;
use File::Basename;
use Text::Markdown;
use DBIx::Simple;
use Data::Dumper;

$CGI::Simple::POST_MAX        = 1024 * 5000;
$CGI::Simple::DISABLE_UPLOADS = 0;

require "config.pl";    # Pull in store configuration information

$form{header}  = "$form{templates}/header.html";
$form{sidebar} = "$form{templates}/sidebar.html";
$form{footer}  = "$form{templates}/footer.html";

my %dateformats = (
    'yy-mm-dd' => 'set DateStyle to \'ISO\'',
    'mm/dd/yy' => 'set DateStyle to \'SQL, US\'',
    'mm-dd-yy' => 'set DateStyle to \'POSTGRES, US\'',
    'dd/mm/yy' => 'set DateStyle to \'SQL, EUROPEAN\'',
    'dd-mm-yy' => 'set DateStyle to \'POSTGRES, EUROPEAN\'',
    'dd.mm.yy' => 'set DateStyle to \'GERMAN\''
);

require "lib.pl";
$cgi = new CGI::Simple;
$dbh = DBI->connect( $dbinfo{dbconnect}, $dbinfo{dbuser}, $dbinfo{dbpasswd} ) or die($DBI::errstr);
$dbh->do( $dateformats{ $form{dateformat} } );
$db = DBIx::Simple->connect($dbh);

$user = User::Simple->new( db => $dbh, tbl => 'customerlogin', durat => 3600, debug => 5 );
$useradmin = User::Simple::Admin->new( $dbh, 'customerlogin' );

for (qw(gid pid rowcount oid iid page page2edit oldpage action notes search_text open closed fromdate todate)) { $form{$_} = $cgi->param($_) }
for (qw(gid pid rowcount oid iid)) { $form{$_} *= 1 if $form{$_} }
for (qw(page page2edit oldpage action notes search_text open closed fromdate todate)) { $form{$_} = $cgi->escapeHTML( $form{$_} ) }
for (
    qw(password email name firstname lastname phone fax address1 address2 city state zipcode country notes shiptoname shiptoaddress1 shiptoaddress2 shiptocity shiptostate shiptozipcode shiptocountry shiptocontact shiptophone shiptofax shiptoemail)
  )
{
    $form{$_} = $cgi->escapeHTML( $cgi->param($_) );
}

# Change 'action' to a sub name
if ( substr( $form{action}, 0, 1 ) !~ /( |\.)/ ) {
    $form{action} = lc $form{action};
    $form{action} =~ s/( |-|,|\#|\/|\.$)/_/g;
}

# Allow white listed pages only.
my $allowed = 0;
$allowed = 1 if !$form{page};
for (@allowedpages) { $allowed = 1 if $_ eq $form{page} }
die("$form{page} not allowed") if !$allowed;

$form{page} = 'index'  if !$form{page};
$form{page} = 'list'   if $form{gid};
$form{page} = 'detail' if $form{pid};

$form{session_id} = $cgi->cookie('session_id');
$form{cart_id}    = $cgi->cookie('cart_id');

$form{callback} = &str_escape( $cgi->url( -path_info => 1, -query => 1 ) );

if ( !$form{cart_id} ) {
    $form{cart_id} = md5_hex( time() );    # TODO: Use a salt to create cart_id
    my $cookie1 = $cgi->cookie( -name => 'session_id', -value => $form{session_id}, -expires => '+6h' );
    my $cookie2 = $cgi->cookie( -name => 'cart_id',    -value => $form{cart_id},    -expires => '+12h' );
    $callback = $cgi->url( -path_info => 1, -query => 1 );
    print $cgi->redirect( -url => $callback, -cookie => [ $cookie1, $cookie2 ] );
}

if ( $user->ck_session( $form{session_id} ) ) {
    if ( $form{page} eq 'logout' ) {
        $user->end_session( $form{session_id} );
        $callback = &str_unescape( $cgi->param('callback') );
        print $cgi->redirect( -url => $callback );
    }
    $form{isadmin} = 1 if $form{admin_id} == $user->customer_id;
}

&actions;
&update_cart;
&create_links;
&{ $form{page} } if ( $form{page} =~ /(editpage|login|checkout|review|remind2|finish)/ );

my $file = "$form{templates}/$form{page}.html";
my $vars = {
    user => $user,
    cgi  => $cgi,
    nf   => $nf,
    tax  => \%tax,
    form => \%form,
};
my $template = Template->new();

if ( $form{login_new_customer} ) {
    print $cgi->header( -cookie => [ $form{cookie1}, $form{cookie2} ] );
}
else {
    print $cgi->header;
}
$template->process( $file, $vars ) || die "Template process failed: ", $template->error(), "\n";

# END OF MAIN

#----------------------------------
#
#  actions
#
#----------------------------------
sub actions {

    # action: update_page
    if ( $form{action} eq 'update_page' ) {
        open( CONF, ">$form{templates}/$form{page2edit}.html" ) or &error("$form{templates}/$form{page2edit}.html : $!");
        print CONF $cgi->param('page_contents');
        close CONF;
        $form{page} = $form{page2edit};
        $form{page} = 'index' if $form{page2edit} =~ /(header|footer|sidebar)/;
    }

    # action: update_item
    if ( $form{action} eq 'update_item' ) {
        $dbh->do(qq|UPDATE parts SET notes='$form{notes}' WHERE id = $form{pid}|);
    }

    # action: upload_image
    if ( $form{action} eq 'upload_image' and $form{isadmin} ) {
        my $safe_filename_characters = "a-zA-Z0-9_.-";
        my $filename                 = $cgi->param('image');
        if ( !$filename ) {
            &error( 'No file specified', 1 );
        }
        my ( $name, $path, $extension ) = fileparse( $filename, '\..*' );
        $filename = $name . $extension;
        $filename =~ tr/ /_/;
        $filename =~ s/[^$safe_filename_characters]//g;
        if ( $filename =~ /^([$safe_filename_characters]+)$/ ) {
            $filename = $1;
        }
        else {
            &error( "Filename contains invalid characters", 1 );
        }
        my $upload_filehandle = $cgi->upload("image");
        open( UPLOADFILE, ">products/$filename" ) or die "$!";
        binmode UPLOADFILE;

        while (<$upload_filehandle>) {
            print UPLOADFILE;
        }
        close UPLOADFILE;
        $dbh->do("UPDATE parts SET image = '$filename' WHERE id = $form{pid}");
        $form{action} = 'create_thumbnail';
    }

    # action: create_thumbnail
    if ( $form{action} eq 'create_thumbnail' and $form{isadmin} ) {
        my ($image) = $dbh->selectrow_array("SELECT image FROM parts WHERE id = $form{pid}");
        my $thumb = GD::Thumbnail->new;
        my $raw;

        for (qw(small medium thumb micro)) {
            $raw = $thumb->create( "products/$image", $form{$_} );
            open IMG, ">products/${_}.$image" or die "Error: $!";
            binmode IMG;
            print IMG $raw;
            close IMG;
        }
    }

    # action: update_profile
    if ( $form{action} eq 'update_profile' ) {
        if ( $cgi->param('old_password') and $cgi->param('password') ) {

            # Password change is requested.
            if ( $cgi->param('password') ne $cgi->param('password2') ) {
                $form{error_msg} = "Passwords don't match";
            }
            elsif ( $user->ck_login( $user->login, $cgi->param('old_password'), 1 ) ) {
                $ok = $user->set_passwd( $cgi->param('password') );
                if ($ok) {
                    $form{info_msg} = 'Password changed';
                }
                else {
                    $form{error_msg} = 'Could not change password';
                }
            }
            else {
                $form{error_msg} = "Incorrect existing password";
            }
        }    # if ($cgi->param('old_password')
             # Now update customer and related tables (contact, address)
        my %customer;
        my %contact;
        my %address;
        my $customer_id = $user->customer_id;

        # customer table
        $form{contact} = $form{firstname} . ' ' . $form{lastname};
        for (qw(name contact phone fax)) { $customer{$_} = $form{$_} }
        my ( $stmt, $bind ) = $db->update( 'customer', \%customer, { id => $customer_id } );

        # contact table
        for (qw(firstname lastname phone fax)) { $contact{$_} = $form{$_} }
        my ( $stmt, $bind ) = $db->update( 'contact', \%contact, { trans_id => $customer_id } );

        # address table
        for (qw(address1 address2 city state zipcode country)) { $address{$_} = $form{$_} }
        my ( $stmt, $bind ) = $db->update( 'address', \%address, { trans_id => $customer_id } );
        $form{info_msg} .= "<br/>Profile updated";
    }

    # action: hot
    if ( $form{action} eq 'hot' ) {
        $dbh->do("DELETE FROM partsattr WHERE hotnew = 'hot'");
        $dbh->do("INSERT INTO partsattr (parts_id, hotnew) SELECT parts_id, 'hot' FROM customercart WHERE cart_id = '$form{cart_id}'");
        $dbh->do("DELETE FROM customercart WHERE cart_id = '$form{cart_id}'");
        $form{info_msg} = 'Hot items updated';
    }

    # action: new
    if ( $form{action} eq 'new' ) {
        $dbh->do("DELETE FROM partsattr WHERE hotnew = 'new'");
        $dbh->do("INSERT INTO partsattr (parts_id, hotnew) SELECT parts_id, 'new' FROM customercart WHERE cart_id = '$form{cart_id}'");
        $dbh->do("DELETE FROM customercart WHERE cart_id = '$form{cart_id}'");
        $form{info_msg} = 'New items updated';
    }

    # action: add_to_cart
    if ( $form{action} eq 'add_to_cart' ) {
        my $qty = $cgi->param('qty');
        $qty *= 1;
        &error( 'Qty should be > 0', 1 ) if !$qty;
        my $query = qq|SELECT COUNT(*) FROM customercart WHERE cart_id = ? AND parts_id = ?|;
        my $sth   = $dbh->prepare($query);
        $sth->execute( $form{cart_id}, $form{pid} );
        my ($exists) = $dbh->selectrow_array($query);
        if ($exists) {
            my $query = qq|UPDATE customercart SET qty = qty + ? WHERE cart_id = ? AND parts_id = ?|;
            my $sth   = $dbh->prepare($query);
            $sth->execute( $qty, $form{cart_id}, $form{pid} );
        }
        else {
            my $taxaccounts = '';
            $query = qq|SELECT c.accno FROM chart c JOIN partstax pt ON (pt.chart_id = c.id) WHERE pt.parts_id = $form{pid}|;
            $sth   = $dbh->prepare($query);
            $sth->execute;
            while ( my $ref = $sth->fetchrow_hashref(NAME_lc) ) {
                $taxaccounts .= "$ref->{accno} ";
            }
            chop $taxaccounts;
            $query = qq|
	   		INSERT INTO customercart (cart_id, customer_id, parts_id, qty, price, taxaccounts)
	   		VALUES ('$form{cart_id}', 0, $form{pid}, $qty, (SELECT sellprice FROM parts WHERE id = $form{pid}), '$taxaccounts')
		|;
        }
        $dbh->do($query) or die($query);
        my ($item_description) = $dbh->selectrow_array("SELECT description FROM parts WHERE id = $form{pid}");
        $form{info_msg} = "<b>$item_description</b> added to cart. <a href=index.pl?page=cart>View cart</a>. <a href=index.pl?page=checkout>Checkout now</a>.";
        $form{page}     = $cgi->param('view');
    }
}

#----------------------------------
#
#  update_cart
#
#----------------------------------
sub update_cart {
    if ( $form{page} eq 'cart' and $form{action} eq 'update_cart' ) {
        for ( $i = 1 ; $i <= $form{rowcount} ; $i++ ) {
            my $parts_id = $cgi->param("parts_id_$i");
            my $qty      = $cgi->param("qty_$i");
            $parts_id *= 1;
            $qty      *= 1;
            if ( $qty <= 0 ) {
                my $result = $db->query( "DELETE FROM customercart WHERE cart_id = ? AND parts_id = ?", $form{cart_id}, $parts_id );
            }
            else {
                my $result = $db->query( "UPDATE customercart SET qty = ? WHERE cart_id = ? AND parts_id = ?", $qty, $form{cart_id}, $parts_id );
            }
        }
        $form{info_msg} = 'Cart updated';
    }
}

#----------------------------------
#
#  create_links
#
#----------------------------------
sub create_links {

    # default currency
    $query = qq|SELECT curr FROM curr WHERE rn = 1|;
    ( $form{defaultcurrency} ) = $dbh->selectrow_array($query);

    $query = qq|SELECT current_date|;
    ( $form{current_date} ) = $dbh->selectrow_array($query);

    # other links
    &tax_links( $user->customer_id );
    &customer_links;
    &parts_links;
    &invoice_links;
}

#----------------------------------
#
#  tax_links
#
#----------------------------------
sub tax_links {
    my ($customer_id) = @_;
    my $query;
    if ($customer_id) {

        # Lookup customer specific taxes
        $query = qq|
		 SELECT c.accno, c.description, t.rate
		 FROM chart c
		 JOIN tax t ON (t.chart_id = c.id)
		 JOIN customertax ct ON (ct.chart_id = c.id)
		 WHERE ct.customer_id = $customer_id
		 ORDER BY c.accno
      |;
    }
    else {

        # Lookup all taxes for use when creating new customer
        $query = qq|
		 SELECT c.accno, c.description, t.rate
		 FROM chart c
		 JOIN tax t ON (t.chart_id = c.id)
		 ORDER BY c.accno
      |;
    }
    $sth = $dbh->prepare($query);
    $sth->execute;
    while ( my $ref = $sth->fetchrow_hashref(NAME_lc) ) {
        $tax{ $ref->{accno} }{rate}        = $ref->{rate};
        $tax{ $ref->{accno} }{description} = $ref->{description};
    }
}

#----------------------------------
#
#  customer_links
#
#----------------------------------
sub customer_links {
    my $customer_id = $user->customer_id;
    if ($customer_id) {
        $form{customer} = $db->query(
            qq|
		SELECT c.name, c.contact, ct.firstname, ct.lastname, c.phone, c.fax, c.email, c.terms,
			a.address1, a.address2, a.city, a.state, a.zipcode, a.country,
			ct.firstname, ct.lastname, ct.contacttitle,
			s.shiptoname, s.shiptoaddress1, s.shiptoaddress2, s.shiptocity, s.shiptostate,
			s.shiptozipcode, s.shiptocountry, s.shiptocontact, s.shiptophone, s.shiptofax,
			s.shiptoemail
		FROM customer c
		JOIN address a ON (a.trans_id = c.id)
		JOIN contact ct ON (ct.trans_id = c.id)
		LEFT JOIN shipto s ON (s.trans_id = c.id)
		WHERE c.id = ?
     |, $customer_id
        )->hash;
    }
}

#----------------------------------
#
#  parts_links
#
#----------------------------------
sub parts_links {

    my @allgroups = $db->query("SELECT id, partsgroup FROM partsgroup WHERE pos ORDER BY partsgroup")->hashes;
    my @allgroups2;

    for (@allgroups) {
        @subgroups = split /:/, $_->{partsgroup};
        if ( @subgroups > 1 ) {
            push @allgroups2, { id => $_->{id}, partsgroup => $subgroups[1], indent => '&nbsp;&nbsp;&nbsp;' };
        }
        else {
            push @allgroups2, { id => $_->{id}, partsgroup => $_->{partsgroup}, indent => '' };
        }
    }

    $form{allgroups} = \@allgroups2;

    $form{cart} = $db->query( "
  	SELECT ca.parts_id id, ca.parts_id, p.partnumber, p.description,
		ca.qty, p.sellprice, ca.qty*p.sellprice AS extended, ca.taxaccounts,
		p.image
  	FROM customercart ca
  	JOIN parts p ON (p.id = ca.parts_id)
  	WHERE cart_id = ?
  	AND qty <> 0
  	ORDER BY p.partnumber", $form{cart_id} )->map_hashes('parts_id');

    ( $form{cartcount} ) = $db->query( "SELECT COUNT(*) FROM customercart WHERE cart_id = ? AND qty <> 0", $form{cart_id} )->list;

    # Taxes are calculated only when a user is logged in.
    if ( $user->customer_id ) {
        for $parts_id ( keys %{$cart} ) {
            for ( split / /, $cart->{$parts_id}{taxaccounts} ) {
                $tax{$_}{base} += $cart->{$parts_id}{extended};
            }
        }
        for ( keys %tax ) {
            $tax{$_}{amount} += $tax{$_}{base} * $tax{$_}{rate};
        }
    }

    if ( $form{gid} or $form{action} eq 'search' ) {
        my $where;
        if ( $form{search_text} ) {
            my $search = '%' . lc $form{search_text} . '%';
            $where = "LOWER(p.description) LIKE '$search'";
            $where .= " OR LOWER(pg.partsgroup) LIKE '$search'";
            $where .= " AND pg.pos AND p.pos";
            $form{page} = 'list';
        }
        else {
            $where .= "pg.id = $form{gid}";
        }
        $query = qq|
		SELECT p.id, p.partsgroup_id as gid, p.partnumber,
			p.description, pg.partsgroup, p.image,
			p.sellprice
		FROM parts p
		JOIN partsgroup pg ON (pg.id = p.partsgroup_id)
		WHERE $where
		AND pg.pos
		AND p.pos
		ORDER BY p.partnumber
    |;
        $form{allitems} = $dbh->selectall_hashref( $query, 'id' ) or &error( $query, 1 );

        for ( keys %{ $form{allitems} } ) {
            $form{allitems}{$_}{image} = 'blank.gif' if !-f "products/$form{allitems}{$_}{image}";
        }
    }

    if ( $form{page} eq 'index' ) {
        for (qw(hot new)) {
            $query = qq|
		SELECT p.id, p.partsgroup_id as gid, p.partnumber,
			p.description, pg.partsgroup, p.image, 
			p.sellprice, pa.hotnew
		FROM parts p
		JOIN partsgroup pg ON (pg.id = p.partsgroup_id)
		JOIN partsattr pa ON (pa.parts_id = p.id)
		WHERE pa.hotnew = '$_'
		AND pg.pos
		AND p.pos
		ORDER BY p.partnumber
      |;
            $form{"${_}items"} = $dbh->selectall_hashref( $query, 'id' ) or die($query) if $query;
            for ( keys %{ $form{allitems} } ) {
                $form{"${_}items"}{$_}{image} = 'blank.gif' if !-f "products/$form{allitems}{$_}{image}";
            }
        }
    }

    if ( $form{pid} ) {
        $form{pid} *= 1;
        my $query = qq|
		SELECT p.id, LOWER(p.partnumber) AS partnumber, p.description,
		  p.sellprice, p.notes, p.onhand,
		  p.partsgroup_id, pg.partsgroup, p.image, p.sellprice
		FROM parts p
		JOIN partsgroup pg ON (pg.id = p.partsgroup_id)
		WHERE p.id = $form{pid}
		AND pg.pos
		AND p.pos
		ORDER BY p.partnumber
    |;
        $form{itemdetail} = $dbh->selectrow_hashref($query) or die($query);
        $form{itemdetail}{image} = 'blank.gif' if !-f "products/$form{itemdetail}{image}";

        my @alternate_items = $db->query(
            qq|
	SELECT p.id, p.description, '' checked
	FROM parts p
	WHERE p.id IN (SELECT pa.alt_parts_id FROM parts_alt pa WHERE pa.parts_id = ?)
	UNION ALL 
	SELECT p.id, p.description, 'checked' checked
	FROM parts p
	WHERE p.id = ?
	ORDER BY 1|, $form{pid}, $form{pid}
        )->hashes;
        $form{alternate_items} = \@alternate_items;

        my $m         = Text::Markdown->new;
        my $htmlnotes = $m->markdown( $form{itemdetail}{notes} );
        $form{itemdetail}{htmlnotes} = $htmlnotes;

    }
}

#----------------------------------
#
#  price_matrix
#
#----------------------------------
sub price_matrix {

    # price matrix - this code is not functional yet and needs to be fixed.
    my $customer_id = $user->customer_id;
    if ($customer_id) {
        $query = qq|
		SELECT 1 AS id, p.id AS parts_id, 0 AS customer_id, 0 AS pricegroup_id,
		0 AS pricebreak, p.sellprice, NULL AS validfrom, NULL AS validto,
		'GBP' AS curr, '' AS pricegroup
		FROM parts p
		WHERE p.id = ?

		UNION

		SELECT 2 AS id, p.*, g.pricegroup
		FROM partscustomer p
		LEFT JOIN pricegroup g ON (g.id = p.pricegroup_id)
		WHERE p.parts_id = ?
		AND p.customer_id = $customer_id

		UNION

		SELECT 3 AS id, p.*, g.pricegroup
		FROM partscustomer p
		LEFT JOIN pricegroup g ON (g.id = p.pricegroup_id)
		JOIN customer c ON (c.pricegroup_id = g.id)
		WHERE p.parts_id = ?
		AND c.id = $customer_id

		UNION

		SELECT 4 AS id, p.*, '' AS pricegroup
		FROM partscustomer p
		WHERE p.customer_id = $customer_id
		AND p.pricegroup_id = 0
		AND p.parts_id = ?

		ORDER BY customer_id DESC, pricegroup_id DESC, pricebreak
      |;
    }
    else {
        $query = qq|
		SELECT 1 AS id, p.id AS parts_id, 0 AS customer_id, 0 AS pricegroup_id,
		0 AS pricebreak, p.sellprice, NULL AS validfrom, NULL AS validto,
		'GBP' AS curr, '' AS pricegroup
		FROM parts p
		WHERE p.id = ? AND p.id = ? AND p.id = ? AND p.id = ?

		ORDER BY customer_id DESC, pricegroup_id DESC, pricebreak
      |;
    }
    $sth = $dbh->prepare($query);
    for ( keys %{ $form{allitems} } ) {
        $sth->execute( $_, $_, $_, $_ );
        while ( my $ref = $sth->fetchrow_hashref(NAME_lc) ) {
            $form{allitems}->{$_}{sellprice} = $ref->{sellprice};
        }
    }

}

#----------------------------------
#
#  invoice_links
#
#----------------------------------
sub invoice_links {
    if ( $user->login ) {
        my $customer_id = $user->customer_id;
        $customer_id *= 1;

        my $where;
        if ( $form{open} and !$form{closed} ) {
            $where .= " AND netamount <> paid";
        }
        elsif ( $form{closed} and !$form{open} ) {
            $where .= " AND netamount = paid";
        }
        $where .= " AND transdate >= '$form{fromdate}'" if ( $form{fromdate} );
        $where .= " AND transdate <= '$form{todate}'"   if ( $form{todate} );

        # INVOICES
        my $query = qq|
		SELECT id, invnumber, description, transdate, amount, netamount, paid
		FROM ar
		WHERE customer_id = $customer_id
		$where
		ORDER BY invnumber
     |;
        $form{invoices} = $dbh->selectall_hashref( $query, 'id' ) or die($query);

        if ( $form{iid} ) {
            $query = qq|
		   SELECT ar.invnumber, ar.transdate, c.name, ar.amount, ar.netamount, ar.notes
		   FROM ar
		   JOIN customer c ON (c.id = ar.customer_id)
		   WHERE ar.id = $form{iid}
		   AND ar.customer_id = $customer_id
		|;
            $form{invoiceheader} = $dbh->selectrow_hashref($query) or die($query);

            $query = qq|
		   SELECT i.id, p.partnumber, p.description, i.qty, i.sellprice, i.qty * i.sellprice AS amount
		   FROM invoice i
		   JOIN ar ON (ar.id = i.trans_id)
		   JOIN parts p ON (p.id = i.parts_id)
		   WHERE i.trans_id = $form{iid}
		   AND ar.customer_id = $customer_id
		|;
            $form{invoicedetail} = $dbh->selectall_hashref( $query, 'id' ) or die($query);
        }

        # ORDERS
        $where = '';
        if ( $form{open} and !$form{closed} ) {
            $where .= " AND NOT closed";
        }
        elsif ( $form{closed} and !$form{open} ) {
            $where .= " AND closed";
        }
        $where .= " AND transdate >= '$form{fromdate}'" if ( $form{fromdate} );
        $where .= " AND transdate <= '$form{todate}'"   if ( $form{todate} );

        $query = qq|
		SELECT id, ordnumber, description, transdate, amount, netamount
		FROM oe
		WHERE customer_id = $customer_id
		$where
		ORDER BY ordnumber
     |;
        $form{orders} = $dbh->selectall_hashref( $query, 'id' ) or die($query);

        if ( $form{oid} ) {
            $query = qq|
		   SELECT oe.ordnumber, oe.transdate, c.name, oe.amount, oe.netamount, oe.notes
		   FROM oe
		   JOIN customer c ON (c.id = oe.customer_id)
		   WHERE oe.id = $form{oid}
		   AND oe.customer_id = $customer_id
		|;
            $form{orderheader} = $dbh->selectrow_hashref($query) or die($query);

            $query = qq|
		   SELECT i.id, p.partnumber, p.description, i.qty, i.sellprice, i.qty * i.sellprice AS amount
		   FROM orderitems i
		   JOIN oe ON (oe.id = i.trans_id)
		   JOIN parts p ON (p.id = i.parts_id)
		   WHERE i.trans_id = $form{oid}
		   AND oe.customer_id = $customer_id
		|;
            $form{orderdetail} = $dbh->selectall_hashref( $query, 'id' ) or die($query);
        }
    }
}

#----------------------------------
#
#  checkout
#
#----------------------------------
sub checkout {
    if ( !$form{cartcount} ) {
        &error( 'Cart is empty', 1 );
    }
}

#----------------------------------
#
#  review
#
#----------------------------------
sub review {
    &error( 'Passwords do not match', 1 ) if $cgi->param('password') ne $cgi->param('password2');

    for (qw(password email name firstname lastname address1 city state zipcode country)) {
        &error( "$_ cannot be blank", 1 ) if !( $cgi->param($_) or $user->customer_id );
    }
    for (
        qw(password email name firstname lastname address1 address2 city state zipcode country notes shiptoname shiptoaddress1 shiptoaddress2 shiptocity shiptostate shiptozipcode shiptocountry shiptocontact shiptophone shiptofax shiptoemail)
      )
    {
        $form{$_} = $cgi->escapeHTML( $cgi->param($_) );
    }

    if ( !$user->customer_id ) {

        # We are about to add a new customer. Check for duplicate email.
        # TODO: Check email address validity
        my $email = $cgi->param('email');
        my $query = qq|SELECT COUNT(*) FROM customer WHERE email = ?|;
        my $sth   = $dbh->prepare($query);
        $sth->execute($email);
        my ($count) = $sth->fetchrow_array;
        &error( 'Email already in use.', 1 ) if $count;
    }
}

#----------------------------------
#
#  finish
#
#----------------------------------
sub finish {
    if ( $user->login ) {
        $customer_id = $user->customer_id;
        ( $form{email} ) = $dbh->selectrow_array("SELECT email FROM customer WHERE id=$customer_id");
    }
    else {

        # first add a new customer/contact
        my $uid = localtime;
        $uid .= $$;

        # customer
        my $contact = $form{firstname} . ' ' . $form{lastname};
        my $query   = qq|INSERT INTO customer (customernumber, name, contact, phone, email, curr) VALUES (?, ?, ?, ?, ?, ?)|;
        $sth = $dbh->prepare($query) or die($query);
        $sth->execute( $uid, $form{name}, $contact, $form{phone}, $form{email}, $form{defaultcurrency} ) or die($query);

        $query = qq|SELECT id FROM customer WHERE customernumber = '$uid'|;
        ($customer_id) = $dbh->selectrow_array($query) or die($query);
        my $customernumber = &update_defaults('customernumber');
        $dbh->do("UPDATE customer SET customernumber = '$customernumber' WHERE id = $customer_id");

        # taxes
        for ( keys %tax ) {
            if ( $cgi->param("tax_$_") ) {
                $query = qq|INSERT INTO customertax VALUES ($customer_id, (SELECT id FROM chart WHERE accno = '$_'))|;
                $dbh->do($query);
            }
        }

        # customer contact information
        $query = qq|INSERT INTO contact (trans_id, firstname, lastname, phone, email) VALUES (?, ?, ?, ?, ?)|;
        $sth = $dbh->prepare($query) or die($query);
        $sth->execute( $customer_id, $form{firstname}, $form{lastname}, $form{phone}, $form{email} );

        # customer address information
        $query = qq|
		INSERT INTO address (trans_id, address1, address2, city, state, zipcode, country)
		VALUES (?, ?, ?, ?, ?, ?, ?)|;
        $sth = $dbh->prepare($query) or die($query);
        $sth->execute( $customer_id, $form{address1}, $form{address2}, $form{city}, $form{state}, $form{zipcode}, $form{country} );

        # shipto address
        if ( $form{shiptoname} ) {
            $query = qq|
		INSERT INTO shipto (
	  	  trans_id, shiptoname, shiptoaddress1, shiptoaddress2,
	  	  shiptocity, shiptostate, shiptozipcode, shiptocountry,
	  	  shiptocontact, shiptophone, shiptofax, shiptoemail)
		VALUES (?, ?, ?, ?,   ?, ?, ?, ?,  ?, ?, ?, ?)|;
            $sth = $dbh->prepare($query) or die($query);
            $sth->execute(
                $customer_id,         $form{shiptoname},    $form{shiptoaddress1}, $form{shiptoaddress2}, $form{shiptocity}, $form{shiptostate},
                $form{shiptozipcode}, $form{shiptocountry}, $form{shiptocontact},  $form{shiptophone},    $form{shiptofax},  $form{shiptoemail}
            );
        }

        # new login
        $ok = $useradmin->new_user( login => $form{email}, passwd => $form{password}, customer_id => $customer_id );

        &tax_links($customer_id);

        # generate session for newly created customer and login him/her.
        $user->ck_login( $form{email}, $form{password} );
        $form{session_id}         = $user->session;
        $form{cookie1}            = $cgi->cookie( -name => 'session_id', -value => $form{session_id}, -expires => '+6h' );
        $form{cookie2}            = $cgi->cookie( -name => 'cart_id', -value => $form{cart_id}, -expires => '+6h' );
        $form{login_new_customer} = 1;
        &customer_links;    # Update customer links for printing on order receipts/confirmation.
    }

    # Now add order for $customer_id
    $query = qq|SELECT SUM(qty*price) FROM customercart WHERE cart_id = '$form{cart_id}'|;
    my ($amount) = $dbh->selectrow_array($query);

    ## calc taxes
    $query = qq|SELECT qty*price AS extended, taxaccounts FROM customercart|;
    $sth   = $dbh->prepare($query);
    $sth->execute;
    $taxamount = 0;
    while ( my $ref = $sth->fetchrow_hashref(NAME_lc) ) {
        for ( split / /, $ref->{taxaccounts} ) { $taxamount += $ref->{extended} * $tax{$_}{rate} }
    }

    my $uid = localtime;
    $uid .= $$;
    $query = qq|INSERT INTO oe (ordnumber) VALUES ('$uid')|;
    $dbh->do($query) or die($query);
    my ($trans_id) = $dbh->selectrow_array("SELECT id FROM oe WHERE ordnumber='$uid'");
    $form{sonumber} = &update_defaults('sonumber');
    $query = qq|
      UPDATE oe SET
		ordnumber = ?, transdate = ?, customer_id = ?,
		amount = ?, netamount = ?, curr = ?,
		notes = ?
      WHERE id = ?
   |;
    $sth = $dbh->prepare($query);
    $sth->execute( $form{sonumber}, $form{current_date}, $customer_id, $amount + $taxamount, $amount, $form{defaultcurrency}, $form{notes}, $trans_id ) or die($query);

    # add shipto address to order
    if ( $form{shiptoname} ) {
        $query = qq|
		INSERT INTO shipto (
	  	  trans_id, shiptoname, shiptoaddress1, shiptoaddress2,
	  	  shiptocity, shiptostate, shiptozipcode, shiptocountry,
	  	  shiptocontact, shiptophone, shiptofax, shiptoemail)
		VALUES (?, ?, ?, ?,   ?, ?, ?, ?,  ?, ?, ?, ?)|;
        $sth = $dbh->prepare($query) or die($query);
        $sth->execute(
            $trans_id,            $form{shiptoname},    $form{shiptoaddress1}, $form{shiptoaddress2}, $form{shiptocity}, $form{shiptostate},
            $form{shiptozipcode}, $form{shiptocountry}, $form{shiptocontact},  $form{shiptophone},    $form{shiptofax},  $form{shiptoemail}
        ) or die($query);
    }

    # add order detail
    $query = qq|INSERT INTO orderitems (trans_id, parts_id, description, qty, sellprice, unit)
		SELECT $trans_id, c.parts_id, p.description, c.qty, c.price, p.unit
		FROM customercart c
		JOIN parts p ON (p.id = c.parts_id)
		WHERE c.cart_id = '$form{cart_id}'
   |;
    $dbh->do($query) or die($query);

    # Email order to customer
    my $vars = {
        user => $user,
        nf   => $nf,
        cgi  => $cgi,
        tax  => \%tax,
        form => \%form,
    };
    use MIME::Lite::TT::HTML;
    my $msg = MIME::Lite::TT::HTML->new(
        From       => $form{fromemail},
        To         => $form{email},
        Subject    => "$form{storename} order confirmation",
        Template   => { text => "$form{templates}/email.txt", html => "$form{templates}/email.html" },
        TmplParams => $vars,
    );
    $msg->send;

    # Empty the cart
    $query = qq|DELETE FROM customercart WHERE cart_id='$form{cart_id}'|;
    $dbh->do($query) or die($query);
}

#----------------------------------
#
#  remind2
#
#----------------------------------
sub remind2 {
    $form{email} = $cgi->param('email');

    #TODO validate email

    # check if the email is for a valid customer record.
    my $query = qq|SELECT id FROM customer WHERE email = ?|;
    $sth = $dbh->prepare($query) or die($query);
    $sth->execute( $form{email} );
    my ($customer_id) = $sth->fetchrow_array;
    &error( 'No such login', 1 ) if !$customer_id;

    # new password
    my $passwd = `$form{apg}`;
    chomp $passwd;

    my $ok;
    my $id = $useradmin->id( $form{email} );
    if ($id) {
        $ok = $useradmin->set_passwd( $id, $passwd );
    }
    else {
        $id = $useradmin->new_user( login => $form{email}, passwd => $passwd, customer_id => $customer_id );
    }

    my $subject = 'Password reset';
    my $data    = qq|
Someone (probably you) requested a new password.

Your login: $form{email}
Your new password: $passwd
|;
    $msg = MIME::Lite->new(
        From    => $form{fromemail},
        To      => $form{email},
        Cc      => $form{adminemail},
        Subject => $subject,
        Type    => 'TEXT',
        Data    => $data
    );
    $msg->send();
    $form{info_msg} = 'Password reset and email sent';
}

#----------------------------------
#
#  login
#
#----------------------------------
sub login {
    for (qw(login passwd)) {
        &error( "$_ cannot be blank", 1 ) if !$cgi->param($_);
    }
    if ( $user->ck_login( $cgi->param('login'), $cgi->param('passwd') ) ) {
        $form{session_id} = $user->session;
        $cookie1 = $cgi->cookie( -name => 'session_id', -value => $form{session_id}, -expires => '+6h' );
        $cookie2 = $cgi->cookie( -name => 'cart_id',    -value => $form{cart_id},    -expires => '+6h' );
        $callback = &str_unescape( $cgi->param('callback') );
        print $cgi->redirect( -url => $callback, -cookie => [ $cookie1, $cookie2 ] );
    }
    else {
        &error( "Login error", 1 );
    }
}

#----------------------------------
#
#  update_defaults
#
#----------------------------------
sub update_defaults {
    my ($fld) = @_;
    my $query = qq|SELECT fldname FROM defaults WHERE fldname='$fld'|;
    if ( !$dbh->selectrow_array($query) ) {
        $dbh->do("INSERT INTO defaults (fldname) VALUES ('$fld')");
    }
    $query = qq|SELECT fldvalue FROM defaults WHERE fldname='$fld' FOR UPDATE|;
    ($_) = $dbh->selectrow_array($query);
    $_ = "0" unless $_;

    my $num = $_;
    $num =~ s/.*?<%.*?%>//g;
    ($num) = $num =~ /(\d+)/;

    if ( defined $num ) {
        my $incnum;
        if ( $num =~ /^0/ ) {
            my $l = length $num;
            $incnum = $num + 1;
            $l -= length $incnum;

            my $padzero = "0" x $l;
            $incnum = ( "0" x $l ) . $incnum;
        }
        else {
            $incnum = $num + 1;
        }
        s/$num/$incnum/;
    }
    $query = qq|UPDATE defaults SET fldvalue='$_' WHERE fldname='$fld'|;
    $dbh->do($query);

    $_;
}

#----------------------------------
#
#  editpage
#
#----------------------------------
sub editpage {

    # TODO: file locking
    open( FH, "$form{templates}/$form{page2edit}.html" ) or &error( "$form{tempaltes}/$form{page2edit}.html: $!", 1 );
    undef $/;
    $form{page_contents} = <FH>;
    close FH;
    $form{page_contents} = $cgi->escapeHTML( $form{page_contents} );
}

# EOF

