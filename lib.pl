1;

sub error {
  my ($error, $header) = @_;
  print $cgi->header if $header;
  print qq|<h1>Error:$error</h1>|;
  exit;
}

sub dberror {
  my ($header, $error) = @_;
  print $cgi->header if $header;
  print qq|<h1>Error:</h1>$error<br/>|. $DBI::errstr;
  die;
}

sub get_datetimestamp {
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
   my $stamp = sprintf "%4d-%02d-%02d %02d:%02d:%02d\n",$year+1900,$mon+1,$mday,$hour,$min,$sec;
   $stamp;
}

sub str_escape {
   my ($str) = @_;
   $str =~ s/([^a-zA-Z0-9_.-])/sprintf("%%%02x", ord($1))/ge;
   $str;
}

sub str_unescape {
  my ($str) = @_;
  
  $str =~ tr/+/ /;
  $str =~ s/\\$//;

  $str =~ s/%([0-9a-fA-Z]{2})/pack("c",hex($1))/eg;
  $str =~ s/\r?\n/\n/g;

  $str;
}

# EOF
