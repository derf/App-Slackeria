package App::Pstatus::Status::Cgit;

use strict;
use warnings;
use autodie;
use 5.010;

use File::Slurp;
use List::Util qw(first);
use Sort::Versions;

sub check {
	my ($self, $p) = @_;
	my %res = (
		ok => 1,
		data => q{},
		href => "http://derf.homelinux.org/git/${p}/",
	);
	my $git_dir = "/home/derf/var/git_root/${p}";

	my @tags = split(/\n/, qx{git --git-dir=${git_dir} tag});
	if (@tags) {
		$res{data} = 'v' . (sort { versioncmp($a, $b) } @tags)[-1];
	}

	open(my $fh, '<', "/home/derf/var/git_root/${p}/config");
	if (not first { $_ eq "\tsharedRepository = world\n" } read_file($fh)) {
		$res{ok} = 0;
		$res{data} = 'Repo not shared';
	}
	close($fh);

	if (not -e "/home/derf/var/git_root/${p}/git-daemon-export-ok") {
		$res{ok} = 0;
		$res{data} = 'git-daemon-export-ok missing';
	}

	return \%res;
}

1;
