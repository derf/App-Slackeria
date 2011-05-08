package App::Pstatus::Plugin::Ikiwiki;

use strict;
use warnings;
use autodie;
use 5.010;

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
	my $pfile = sprintf($conf{source_file}, $p);
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
