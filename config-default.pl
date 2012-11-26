#-------------------------- SITE CONFIGURATION ------------------------------
%dbinfo = (
   dbconnect => "dbi:Pg:dbname=ledgercart;host='';port=''",
   dbhost => '',
   dbport => '',
   dbuser => 'postgres',
   dbpasswd => '',
);

$form{storename} = 'My Store';
$form{tagline} = 'Best prices all year - your tag line here';

$form{templates} = 'default';
$form{css} = 'default/blue.css';

# Auto-created image sizes
$form{medium} = 300; # Displayed on item detail when small image is clicked
$form{small} = 120; # Displayed on item detail
$form{thumb} = 60; # Displayed on item list
$form{micro} = 30; # Displayed on cart

$form{dateformat} = 'dd/mm/yy'; # Can be yy-mm-dd, mm/dd/yy, mm-dd-yy, dd/mm/yy, dd-mm-yy, dd.mm.yy
$form{curr} = '$';
$form{admin_id} = 10118;
$form{fromemail} = 'saqib@ledger123.com';
$form{adminemail} = 'saqib@ledger123.com';

@allowedpages = qw(about sidebar cart checkout contact detail editpage finish index invoices invoicedetail list login logout orders orderdetail profile remind remind2 review finish);

$nf = Number::Format->new(
	-thousands_sep => ',',
	-decimal_point => '.',
	-decimal_digits => 2, 
	-decimal_fill => 1,
	-mon_thousands_sep => ',',
	-mon_decimal_point => '.',
	-int_curr_symbol => '$',
);

$form{apg} = '/usr/bin/apg -a 0 -n 1 -m 6 -x 6 -c change_this'; # Replace change_this with a unique string

#----------------------------------------------------------------------------

