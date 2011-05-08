package App::Pstatus::Status::Cgit;

use strict;
use warnings;
use autodie;
use 5.010;

use File::Slurp;
use List::Util qw(first);
use Sort::Versions;

sub new {
	my ($obj, %conf) = @_;
	my $ref = {};
	$ref->{default} = \%conf;
	return bless($ref, $obj);
}

sub check {
	my ($self, %over_conf) = @_;
	my %conf = %{$self->{default}};

	for my $key (keys %over_conf) {
		$conf{$key} = $over_conf{$key};
	}
	my $p = $conf{name};

	my %res = (
		ok => 1,
		data => q{},
		href => sprintf($conf{href}, $p),
	);
	my $git_dir = sprintf($conf{git_dir}, $p);

	my @tags = split(/\n/, qx{git --git-dir=${git_dir} tag});
	if (@tags) {
		$res{data} = 'v' . (sort { versioncmp($a, $b) } @tags)[-1];
	}

	open(my $fh, '<', "${git_dir}/config");
	if (not first { $_ eq "\tsharedRepository = world\n" } read_file($fh)) {
		$res{ok} = 0;
		$res{data} = 'Repo not shared';
	}
	close($fh);

	if (not -e "${git_dir}/git-daemon-export-ok") {
		$res{ok} = 0;
		$res{data} = 'git-daemon-export-ok missing';
	}

	return \%res;
}

1;
