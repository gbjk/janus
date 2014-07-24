package Janus::Controller;

use v5.16;

use Moose;

use DDP;
use HTTP::Throwable::Factory qw/http_throw/;
use Kavorka;

use common::sense;
use namespace::sweep;

has client => (
    isa => 'webXG::DB::Client',
    is  => 'ro',
    );

method process (OX::Request $r){
    return 42;
    }

1;
