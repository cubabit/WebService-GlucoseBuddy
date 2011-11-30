package WebService::GlucoseBuddy;
# ABSTRACT: Interface to a www.glucosebuddy.com log

use Moose 1.24;
use namespace::autoclean 0.13;
use WWW::Mechanize 1.70;
use Readonly 1.03;

#use WebService::GlucoseBuddy::Log;

Readonly my $SERVICE_URI = 'https://www.glucosebuddy.com';

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
    is      => 'ro',
    isa     => 'WWW::Mechanize',
    lazy    => 1,
);

sub _build__mech {
    my $self = shift;

    my $mech = WWW::Mechanize->new;
    $mech->get($SERVICE_URI . '/login');

    $mech->submit_form(
        with_fields => {
            username    => $self->username,
            password    => $self->password,
        }
    );

    return $mech;
}

=method get_log

Returns a L<WebService::GlucoseBuddy::Log> which is a fresh copy of the log from the
glucosebuddy.com site.

=cut

sub get_log {
    my $self = shift;

    my $mech = $self->_mech;
    $mech->get('/logs/MyExportedGlucoseBuddyLogs.csv');
    print $mech->content;
}

__PACKAGE__->meta->make_immutable;

1;
