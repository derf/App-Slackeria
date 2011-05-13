package App::Pstatus::Plugin::GitHub;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin::Base';

use Net::GitHub;
use Sort::Versions;

sub check {
	my ($self) = @_;

	my $github = Net::GitHub->new(
		owner => $self->{conf}->{owner},
		repo => $self->{conf}->{name},
	);

	$self->{conf}->{href} //= 'http://github.com/%s/%s';
	my $href = sprintf(
		$self->{conf}->{href},
		$self->{conf}->{owner},
		$self->{conf}->{name},
	);


	my $tags = $github->repos()->tags();

	if ($tags->{error}) {
		die($tags->{error});
	}

	if (not keys %{$tags}) {
		return {
			data => q{},
			href => $href,
		}
	}

	return {
		data => 'v' . (sort { versioncmp($a, $b) } keys %{$tags})[-1],
		href => $href,
	};
}

1;

__END__

=head1 NAME

B<App::Pstatus::Plugin::GitHub> - Check project on github.com

=head1 SYNOPSIS

In F<pstatus/config>

    [GitHub]
    owner = your github username

=head1 DESCRIPTION

This plugin queries a project and its version on B<github.com>

=head1 CONFIGURATION

=over

=item href

Link to point to.  Defaults to "http://github.com/%s/%s", where the first %s
is replaced by B<owner>, and the second by B<name>

=item owner

Repository owner.  Mandatory

=back

=head1 DEPENDENCIES

Requires L<Net::GitHub> and L<Sort::Versions>.

=head1 SEE ALSO

L<pstatus>

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
