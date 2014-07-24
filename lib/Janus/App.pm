package Janus::App;

use v5.16;

use OX;

use common::sense;
use namespace::sweep;

use DDP;

use webXG::Config;

has controller => (
    is      => 'ro',
    isa     => 'Janus::Controller',
    infer   => 1,
    );

router as {
    route "/janus/" => 'controller.process';
    };

1;

