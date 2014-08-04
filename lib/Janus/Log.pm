package Janus::Log;

use Moose;

use DateTime::HiRes;
use DateTime::Format::Strptime;
use DDP;
use Data::Dumper;
use Log::Dispatch;
use Log::Dispatch::Screen;
use Log::Dispatch::Message::Passing;
use Message::Passing::Filter::Encoder::JSON;
use Message::Passing::Filter::Mangle;
use Message::Passing::Output::Socket::UDP;
use Sys::Hostname::FQDN qw/fqdn/;

use common::sense;

has log => (
    isa         => 'Log::Dispatch',
    is          => 'bare',
    lazy_build  => 1,
    handles     => [qw/debug info warn error/],
    );
has upstream_hostname => (
    is      => 'ro',
    isa     => 'Str',
    default => 'logs.thermeon.eu',
    );
has upstream_port => (
    is      => 'ro',
    isa     => 'Int',
    default => 2122,
    );

sub _build_log {
    my ($self) = @_;
    my $log = Log::Dispatch->new;

    $log->add( $self->screen_logger );
    $log->add( $self->upstream_logger );

    return $log;
    }

# This could become an attribute, but I'm really not seeing a need yet
sub screen_logger {
    Log::Dispatch::Screen->new(
        autoflush   => 1,
        min_level   => 'debug',
        binmode     => ':encoding(UTF-8)',
        newline     => 1,
        callbacks   => sub {
            my %args = @_;
            state $log_dtf = DateTime::Format::Strptime->new(pattern => '%F %T');
            sprintf "[%s] %s", $log_dtf->format_datetime(DateTime->now), $args{message};
            }
        );
    }

sub upstream_logger {
    my ($self) = @_;
    state $fqdn = fqdn;
    state $log_dtf = DateTime::Format::Strptime->new(pattern => '%F %T.%4N');
    Log::Dispatch::Message::Passing->new(
        min_level   => 'debug',
        output  => Message::Passing::Filter::Mangle->new(
            filter_function => sub {
                my ($p) = @_;
                $p->{type}              = 'janus';
                $p->{real_host}         = $fqdn;
                $p->{real_timestamp}    = $log_dtf->format_datetime( DateTime::HiRes->now );
                $p->{pid}               = $$;
                return $p;
                },
            output_to => Message::Passing::Filter::Encoder::JSON->new(
                output_to => Message::Passing::Output::Socket::UDP->new(
                    hostname    => $self->upstream_hostname,
                    port        => $self->upstream_port,
                    )
                )
            )
        );
    }

__PACKAGE__->meta->make_immutable;
