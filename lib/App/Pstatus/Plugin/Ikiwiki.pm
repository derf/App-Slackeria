package App::Pstatus::Plugin::Ikiwiki;

use strict;
use warnings;
use autodie;
use 5.010;

use parent 'App::Pstatus::Plugin::Base';

sub check {
	my ($self) = @_;

	my $p = $self->{conf}->{name};

	my $re_p = $self->{conf}->{title_name} // $p;

	my $pfile = sprintf($self->{conf}->{source_file}, $p);
	my $re_title = qr{
		^ \[ \[ \! meta\s title = "
		$re_p (?: \s v (?<version> [0-9.-]+ ))?
		" ]] $
	}x;

	if (not -e $pfile) {
		die("No project file\n");
	}
	else {
		open(my $fh, '<', $pfile);
		my $ok = 0;
		while (my $line = <$fh>) {
			if ($line =~ $re_title) {
				return {
					data => $+{version} // q{},
				};
			}
		}
		die("Wrong name or no title\n");
	}
}

1;
