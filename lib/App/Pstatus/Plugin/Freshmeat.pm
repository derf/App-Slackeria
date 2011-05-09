package App::Pstatus::Plugin::Freshmeat;

use strict;
use warnings;
use autodie;
use 5.010;

use parent 'App::Pstatus::Plugin';

use WWW::Freshmeat;

sub check {
	my ($self, $res) = @_;

	my $fm = WWW::Freshmeat->new(token => $self->{conf}->{token});
	my $fp = $fm->retrieve_project($self->{conf}->{name});

	$self->{conf}->{href} //= 'http://freshmeat.net/projects/%s/';

	$res->{href} = sprintf(
		$self->{conf}->{href},
		$self->{conf}->{name},
	);

	if (not defined $fp) {
		$res->{ok} = 0;
		$res->{data} = 'not found';
	}
	else {
		$res->{data} = 'v' . $fp->version();
		$res->{description} = $fp->description();
	}
}

1;

__END__

=head1 NAME

B<App::Pstatus::Plugin::Freshmeat> - Check project on freshmeat.net

=head1 SYNOPSIS

In F<pstatus/config>

    [freshmeat]
    token = something

=head1 DESCRIPTION

This plugin queries a project and its version on B<freshmeat.net>.

=head1 CONFIGURATION

=over

=item href

Link to point to.  Defaults to "http://freshmeat.net/projects/%s/", where %s
is replaced by the project name

=item token

Set this to your freshmeat access token (mandatory)

=back

=head1 DEPENDENCIES

Requires the L<WWW::Freshmeat> perl module.

=head1 SEE ALSO

L<pstatus>

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
