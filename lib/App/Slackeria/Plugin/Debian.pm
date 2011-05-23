package App::Slackeria::Plugin::Debian;

use strict;
use warnings;
use 5.010;

use parent 'App::Slackeria::Plugin::Whohas';

sub check {
	my ($self) = @_;

	return $self->run_whohas('debian', $self->{conf}->{name});
}

1;

__END__

=head1 NAME

B<App::Slackeria::Plugin::Debian> - Check project version in Debian

=head1 SYNOPSIS

In F<slackeria/config>

    [Debian]

=head1 DESCRIPTION

This plugin queries a project and its version in Debian Sid using L<whohas>.

=head1 CONFIGURATION

None.

=head1 SEE ALSO

L<slackeria>

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
