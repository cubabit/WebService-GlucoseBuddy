package WebService::GlucoseBuddy::Log::Reading;
# ABSTRACT: A reading from a glucosebuddy log

use Moose 1.24;
use namespace::autoclean 0.13;

=attr type

The type of reading

=cut

has type => (
    is  => 'ro',
    isa => 'Str',
);

=attr value

Teh value of the reading

=cut

has value => (
    is  => 'ro',
    isa => 'Num',
);

=attr unit

The units used for the reading

=cut

has unit => (
    is  => 'ro',
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;

1;

