#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Data::Dumper;

use lib '../';
use Telegram;

my $token = "12345654:SLKjf;sdlkjflakjOILSKJD";
my $callback = "https://localhost:8443/action";
my $cert = "./TestCert.pem";

my $bot = Telegram->new($token, $callback, $cert);

ok( $bot->{token} eq $token, "Checks initial variables: token");
ok( $bot->{callback} eq $callback, "Checks initial variables: callback");
ok( $bot->{certificate} eq $cert, "Checks initial variables: certificate");

done_testing();

