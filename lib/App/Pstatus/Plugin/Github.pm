package App::Pstatus::Plugin::Github;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin';

use Net::GitHub;
use Sort::Versions;

sub check {
	my ($self, $res) = @_;

	my $github = Net::GitHub->new(
		owner => $self->{conf}->{owner},
		repo => $self->{conf}->{name},
	);

	$self->{conf}->{href} //= 'http://github.com/%s/%s';

	my $tags = $github->repos()->tags();

	if ($tags->{error}) {
		$res->{data} = $tags->{error};
		$res->{ok} = 0;
		return;
	}

	if (not keys %{$tags}) {
		return;
	}

	$res->{data} = 'v' . (sort { versioncmp($a, $b) } keys %{$tags})[-1];
	$res->{href} = sprintf(
		$self->{conf}->{href},
		$self->{conf}->{owner},
		$self->{conf}->{name},
	);
}

1;
