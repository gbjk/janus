package Janus::App;

use v5.16;

use OX;

use common::sense;
use namespace::sweep;

use DDP;

use webXG::Config;

has controller => (
    is      => 'ro',
    isa     => 'Janus::Controller::FogBugz',
    infer   => 1,
    );

router as {
    route "/.*/janus/fogbugz/:case_id/event/:event_id" => 'controller.case_event';
    };

1;

