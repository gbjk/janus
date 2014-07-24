package Janus::Controller::FogBugz;

use v5.16;

use Moose;

use DDP;
use HTTP::Throwable::Factory qw/http_throw/;
use Kavorka;
use WebService::FogBugz::XML;
use WebService::Trello::Card;

use common::sense;
use namespace::sweep;

has fb => (
    is      => 'ro',
    isa     => 'WebService::FogBugz::XML',
    default => sub { WebService::FogBugz::XML->new },
    handles => {
        case    => 'get_case',
        },
    );
has trello => (
    is      => 'ro',
    isa     => 'WebService::Trello',
    default => sub { WebService::Trello->new },
    handles => {
        },
    );

method case_event (OX::Request $r, Num $case_id, Num $event_id){
    my $case = $self->case( $case_id );

    # Do I already have a trello?
    my $trello_id = $case->trello_id;

    unless ($trello_id){
        my $resp = WebService::Trello::Card->new(
            name    => $case->title,
            )->create;
        warn "Got back ". p $resp;
        return "Created Trello case";
        }

    return "Didn't create anything":
    }

1;
