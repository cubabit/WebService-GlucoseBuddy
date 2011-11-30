package WebService::GlucoseBuddy;
# ABSTRACT: Interface to a www.glucosebuddy.com log

use Moose 1.24;
use namespace::autoclean 0.13;
use MooseX::Iterator 0.11;
use WWW::Mechanize 1.70;
use Readonly 1.03;
use Text::CSV 1.21;

#use WebService::GlucoseBuddy::Log;

Readonly my $SERVICE_URI => 'https://www.glucosebuddy.com';

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

    $mech->submit_form(
        with_fields => {
            login       => $self->username,
            password    => $self->password,
        }
    );

    return $mech;
}

=method logs

Returns an iterator L<WebService::GlucoseBuddy::Log> which is a fresh copy of the log from the
glucosebuddy.com site.

=cut

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

    while (my $row = $csv->getline($logs_fh)) {
        push @logs, $row;
    }

    return \@logs;
}

has logs => (
    metaclass       => 'Iterable',
    iterate_over    => '_logs',
);

__PACKAGE__->meta->make_immutable;

1;
