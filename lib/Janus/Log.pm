package Janus::Log;

use Moose;

sub debug {
    my ($self) = shift;
    say STDERR @_;
    }

__PACKAGE__->meta->make_immutable;
