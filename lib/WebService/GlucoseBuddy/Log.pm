package WebService::GlucoseBuddy::Log;
# ABSTRACT: A log from a glucosebuddy logfile

use Moose 1.24;
use namespace::autoclean 0.13;

=attr reading

A L<WebService::GlucoseBuddy::Log::Reading> object for the reading

=cut

has reading => (
    is  => 'ro',
    isa => 'WebService::GlucoseBuddy::Log::Reading',
);

=attr name

The name given for the log entry

=cut

has name => (
    is  => 'ro',
    isa => 'Str',
);

=attr event

The event name for the log entry

=cut

has event => (
    is  => 'ro',
    isa => 'Str',
);

=attr time

A L<DateTime> object for the time of the reading. This has a floating timezone as glucosebuddy.com
does not provide one.

=cut

has time => (
    is  => 'ro',
    isa => 'DateTime',
);

=attr notes

Notes for the log entry

=cut

has notes => (
    is  => 'ro',
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;

1;

