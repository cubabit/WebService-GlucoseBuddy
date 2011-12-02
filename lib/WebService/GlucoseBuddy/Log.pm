package WebService::GlucoseBuddy::Log;
# ABSTRACT: A log from a glucosebuddy logfile

use Moose 1.24;
use namespace::autoclean 0.13;

=attr reading

=cut

has reading => (
    is  => 'ro',
    isa => 'WebService::GlucoseBuddy::Log::Reading',
);

=attr name

=cut

has name => (
    is  => 'ro',
    isa => 'Str',
);

=attr event

=cut

has event => (
    is  => 'ro',
    isa => 'Str',
);

=attr time

=cut

has time => (
    is  => 'ro',
    isa => 'DateTime',
);

=attr notes

=cut

has notes => (
    is  => 'ro',
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;

1;

