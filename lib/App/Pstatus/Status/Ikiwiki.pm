package App::Pstatus::Status::Ikiwiki;

use strict;
use warnings;
use autodie;
use 5.010;

sub check {
	my ($self, $p) = @_;
	my %res = (
		ok => 1,
		data => q{},
		href => "http://derf.homelinux.org/projects/${p}/",
	);
	my $pfile = "/home/derf/web/org.homelinux.derf/in/projects/${p}.mdwn";
	my $re_title = qr{
		^ \[ \[ \! meta\s title = "
		$p (?: \s v (?<version> [0-9.-]+ ))?
		" ]] $
	}x;

	if (not -e $pfile) {
		$res{ok} = 0;
		$res{data} = 'Project file missing';
	}
	else {
		open(my $fh, '<', $pfile);
		my $ok = 0;
		while (my $line = <$fh>) {
			if ($line =~ $re_title) {
				$res{data} = $+{version} ? "v$+{version}" : q{};
				$ok = 1;
			}
		}
		if (not $ok) {
			$res{ok} = 0;
			$res{data} = 'Wrong name in title or no title';
		}
	}

	return \%res;
}

1;
