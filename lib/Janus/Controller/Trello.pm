package Janus::Controller::Trello;

use v5.16;

use Moose;

use DDP;
use HTTP::Throwable::Factory qw/http_throw/;
use Kavorka;
use WebService::FogBugz::XML;
use WebService::Trello::Card;
use JSON;

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

method event (OX::Request $r){
    my $event = decode_json $r->content;

    my $action = $event->{action};
    return "Not a card event" unless $action->{type} =~ /Card/;
    
    my $card = WebService::Trello::Card->new(
        $action->{data}{card},
        );
    
    my @fb_cases = $self->fb->search('trello_id' => $card->id);

    return "More than one case?" unless scalar @fb_cases == 1;
    my $case = @fb_cases[0];

    if ($action->{data}{listBefore} && $action->{data}{listAfter}) {
        my $comment = sprintf('Moved task from %s to %s', map $_->{name}, @{$action->{data}}{qw/listBefore listAfter/});
        $case->add_comment($comment);
        }

    return "Ok";
    }

1;
