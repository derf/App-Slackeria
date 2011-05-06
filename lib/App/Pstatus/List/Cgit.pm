package App::Pstatus::List::Cgit;
use strict;
use warnings;
use autodie;
use 5.010;

sub get {
	my $p;
	open(my $fh, '<', '/etc/cgitrc');
	while (my $line = <$fh>) {
		if ($line =~ qr{ ^ repo\.url = (?<name> .+) $ }x) {
			$p->{$+{name}} = {};
		}
		elsif ($line =~ qr{ ^ section= }x) {
			last;
		}
	}
	close($fh);
	return $p;
}

1;
