package Janus::App;

use v5.16;

use OX;

use common::sense;
use namespace::sweep;

use DDP;

has controller => (
    is      => 'ro',
    isa     => 'Janus::Controller::FogBugz',
    infer   => 1,
    );

has trello_controller => (
    is      => 'ro',
    isa     => 'Janus::Controller::Trello',
    infer   => 1,
    );

router as {
    route "/.*/janus/fogbugz/:case_id/event/:event_id" => 'controller.case_event';
    route "/.*/janus/trello"                           => 'trello_controller.event';
    };

1;

