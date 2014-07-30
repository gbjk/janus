package Janus::Controller::FogBugz;

use v5.16;

use Moose;

use DDP;
use HTTP::Throwable::Factory qw/http_throw/;
use Kavorka;
use WebService::FogBugz::XML;
use WebService::Trello::Card;
use WebService::Trello::Organization;

use common::sense;
use namespace::sweep;

has log => (
    is  => 'ro',
    isa => 'Janus::Log',
    handles     => [qw/debug/],
    );

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
    );

method case_event (OX::Request $r, Num $case_id, Num $event_id){
    my $case = $self->case( $case_id );

    if ($case->last_scout_occurrence){
        $self->debug("Skipping BugScout case");
        return "SKIPPED";
        }

    # Do I already have a trello?
    my $trello_id = $case->trello_id;

    if ($case->status =~ /Closed|Resolved/){
        $self->debug("Case is resovled or closed, cleaning up, trello id: $trello_id");
        if ($trello_id){

            # Delete it off the case upfront
            $case->trello_order("0");
            $case->trello_id("0");
            $case->update;

            if (my $card = WebService::Trello::Card->get($trello_id)){
                $self->debug("Deleting trello card $trello_id");
                $card->delete;
                return "{message:'Archived completed case in trello'}";
                }
            else {
                $self->debug("trello card $trello_id doesn't appear to exist");
                return "{message:'trello case $trello_id does not exist'}";
                }
            }
        else {
            return "{message:'Ignoring completed case'}";
            }
        }

    my $assignee = $case->assignee->full_name;
    my $org = WebService::Trello::Organization->new();
    my $trello_member = $org->find_member_by_name( $assignee );

    if ($trello_id) {
        my $card = WebService::Trello::Card->get( $trello_id );

        return "Didn't create anything" unless $card;

        my $addmember = 1;
        foreach my $member ($card->members) {
            if ($member->id ne $trello_member->id) {
                $card->delete_member( $member );
                }
            else {
                $addmember = 0;
                }
            }

        if ($addmember) {
            $card->add_member( $trello_member );
            }

        return "Found a card, might've updated it";
        }
    else {
        my $card = WebService::Trello::Card->new(
            name    => 'FB' . $case->number . ': ' . $case->title,
            members => [ $trello_member ],
            )->create;
        $case->trello_id( $card->id );
        $case->trello_order( $card->pos );
        $case->trello_list( $card->list->name );
        $case->update;
        $self->debug("Created Trello card ".$card->id ." position ".$card->pos);

        $card->add_comment( $case->url );
        return "Created Trello card ".$card->id ." position ".$card->pos;
        }

    $self->debug("Didn't create anything");

    return "Didn't create anything";
    }

1;
