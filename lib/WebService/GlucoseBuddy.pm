package WebService::GlucoseBuddy;
# ABSTRACT: Interface to a glucosebuddy.com account

use Moose 1.24;
use namespace::autoclean 0.13;
use MooseX::Iterator 0.11;
use WWW::Mechanize 1.70;
use Readonly 1.03;
use Text::CSV 1.21;
use DateTime::Format::Strptime 1.5;
use Carp 1.20;

use WebService::GlucoseBuddy::Log;
use WebService::GlucoseBuddy::Log::Reading;

Readonly my $SERVICE_URI    => 'https://www.glucosebuddy.com';
Readonly my $DT_FORMAT      => '%m/%d/%Y %T';

=attr username

=cut

has username => (
    is  => 'ro',
    isa => 'Str',
);

=attr password

=cut

has password => (
    is  => 'ro',
    isa => 'Str',
);

has _mech => (
    is          => 'ro',
    isa         => 'WWW::Mechanize',
    lazy_build  => 1,
);

sub _build__mech {
    my $self = shift;

    my $mech = WWW::Mechanize->new;
    $mech->get($SERVICE_URI . '/login');

    unless ($mech->success) {
        carp 'Could not connect to glucosebuddy.com';
    }

    $mech->submit_form(
        with_fields => {
            login       => $self->username,
            password    => $self->password,
        }
    );

    unless ($mech->uri->path eq '/logs/new') {
        carp 'Log in failed';
    }

    return $mech;
}

has _logs => (
    is          => 'ro',
    isa         => 'ArrayRef',
    lazy_build  => 1,
);

sub _build__logs {
    my $self = shift;

    my $mech = $self->_mech;
    $mech->get('/logs/MyExportedGlucoseBuddyLogs.csv');

    my $logs_file = $mech->content;
    open my $logs_fh, '<', \$logs_file;

    my $csv = Text::CSV->new;

    my @logs;

    # throw away header
    <$logs_fh>;

    while (my $row = $csv->getline($logs_fh)) {
        push @logs, $row;
    }

    return \@logs;
}

=method logs

Returns an iterator of L<WebService::GlucoseBuddy::Log> objects, each 
representing a log

=cut

{
    my $dt_formatter = DateTime::Format::Strptime->new(
        pattern     => $DT_FORMAT,
        on_error    => 'croak',
    );

    sub logs {
        my $self = shift;
        
        my @logs;
        for (@{ $self->_logs }) {
            my $reading = WebService::GlucoseBuddy::Log::Reading->new(
                type    => $_->[0],
                value   => $_->[1],
                unit    => $_->[2],
            );

            my $time = $dt_formatter->parse_datetime($_->[5]);

            push @logs => WebService::GlucoseBuddy::Log->new(
                reading => $reading,
                time    => $time,
                name    => $_->[3],
                event   => $_->[4],
                notes   => $_->[6],
            );
        }

        return MooseX::Iterator::Array->new(collection => \@logs);
    }
}

__PACKAGE__->meta->make_immutable;

1;
