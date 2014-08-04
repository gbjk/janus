#!/usr/bin/env perl

use lib 'lib';

use Janus::App;
use Plack::Middleware::LogDispatch;
use Try::Tiny;
use Data::Dumper;

my $self = Janus::App->new;

$app = $self->to_app;

# Note that this wraps directly around $app manually, precluding other middleware.
my $logger = sub {
    my $env = shift;
    my $res = try {
        $app->($env);
        }
    catch {
        $self->log->critical($_);
        die $_;
        };
    return $res;
    };

return $logger;
