package App::Pstatus::Plugin::Whohas;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin';

sub run_whohas {
	my ($self, $distro, $name) = @_;

	my $out = qx{whohas --no-threads --strict -d $distro $name};

	if (not defined $out or $out eq q{}) {
		$self->{res}->{ok} = 0;
		$self->{res}->{data} = 'not found';
		return;
	}

	$out = (split(/\n/, $out))[-1];

	$self->{res}->{data} = substr($out, 51, 10);
	$self->{res}->{href} = substr($out, 112);
}

1;
