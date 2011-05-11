package App::Pstatus::Plugin::Ikiwiki;

use strict;
use warnings;
use autodie;
use 5.010;

use parent 'App::Pstatus::Plugin::Base';

sub check {
	my ($self, $res) = @_;

	my $p = $self->{conf}->{name};

	my $re_p = $self->{conf}->{title_name} // $p;

	my $pfile = sprintf($self->{conf}->{source_file}, $p);
	my $re_title = qr{
		^ \[ \[ \! meta\s title = "
		$re_p (?: \s v (?<version> [0-9.-]+ ))?
		" ]] $
	}x;

	if (not -e $pfile) {
		$res->{ok} = 0;
		$res->{data} = 'Project file missing';
	}
	else {
		open(my $fh, '<', $pfile);
		my $ok = 0;
		while (my $line = <$fh>) {
			if ($line =~ $re_title) {
				$res->{data} = $+{version} ? "v$+{version}" : q{};
				$ok = 1;
			}
		}
		if (not $ok) {
			$res->{ok} = 0;
			$res->{data} = 'Wrong name in title or no title';
		}
	}
}

1;
