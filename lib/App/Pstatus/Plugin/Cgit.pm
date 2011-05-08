package App::Pstatus::Plugin::Cgit;

use strict;
use warnings;
use autodie;
use 5.010;

use parent 'App::Pstatus::Plugin';

use File::Slurp;
use List::Util qw(first);
use Sort::Versions;

sub check {
	my ($self, $res) = @_;

	my $git_dir = sprintf($self->{conf}->{git_dir}, $self->{conf}->{name});

	my @tags = split(/\n/, qx{git --git-dir=${git_dir} tag});
	if (@tags) {
		$res->{data} = 'v' . (sort { versioncmp($a, $b) } @tags)[-1];
	}

	open(my $fh, '<', "${git_dir}/config");
	if (not first { $_ eq "\tsharedRepository = world\n" } read_file($fh)) {
		$res->{ok} = 0;
		$res->{data} = 'Repo not shared';
	}
	close($fh);

	if (not -e "${git_dir}/git-daemon-export-ok") {
		$res->{ok} = 0;
		$res->{data} = 'git-daemon-export-ok missing';
	}
}

1;
