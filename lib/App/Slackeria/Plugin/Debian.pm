package App::Slackeria::Plugin::Debian;

use strict;
use warnings;
use 5.010;

use parent 'App::Slackeria::Plugin::Whohas';

our $VERSION = '0.02';

sub check {
	my ($self) = @_;

	return $self->run_whohas( 'debian', $self->{conf}->{name} );
}

1;

__END__

=head1 NAME

App::Slackeria::Plugin::Debian - Check project version in Debian

=head1 SYNOPSIS

In F<slackeria/config>

    [Debian]

=head1 VERSION

version 0.02

=head1 DESCRIPTION

This plugin queries a project and its version in Debian Sid using whohas(1).

=head1 CONFIGURATION

None.

=head1 DEPENDENCIES

whohas(1).

=head1 BUGS AND LIMITATIONS

This plugin depends entirely on the external program whohas(1).  Since it
parses its text output, there may be problems with long package names or
descriptions.

=head1 SEE ALSO

slackeria(1)

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
