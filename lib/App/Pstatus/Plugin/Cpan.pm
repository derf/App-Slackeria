package App::Pstatus::Plugin::Cpan;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin';

use CPANPLUS;

sub new {
	my ($obj, %conf) = @_;
	my $ref = {};
	$ref->{default} = \%conf;
	$ref->{cb} = CPANPLUS::Backend->new();
	return bless($ref, $obj);
}

sub check {
	my ($self, $res) = @_;
	my $cb = $self->{cb};
	my $mod = $cb->parse_module(module => $self->{conf}->{name});

	$self->{conf}->{href} //= 'http://search.cpan.org/dist/%s/';

	if ($mod) {
		$res->{data} = 'v' . $mod->version();
		$res->{href} = sprintf($self->{conf}->{href},
			$self->{conf}->{name});
	}
	else {
		$res->{ok} = 0;
	}
}

1;

__END__

=head1 NAME

B<App::Pstatus::Plugin::Cpan> - Check module distribution on CPAN

=head1 SYNOPSIS

In F<pstatus/config>

    [cpan]

=head1 DESCRIPTION

This plugin queries the Comprehensive Perl Archive Network and checks if it
contains a given module.  Note that its B<name> option may be a module name
(like "App::Pstatus") as well as a distribution name (like "App-Pstatus").

=head1 CONFIGURATION

None.

=head1 DEPENDENCIES

L<CPANPLUS>.

=head1 SEE ALSO

L<pstatus>

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
