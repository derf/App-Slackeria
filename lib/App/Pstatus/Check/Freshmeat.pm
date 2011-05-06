package App::Pstatus::Check::Freshmeat;

use strict;
use warnings;
use autodie;
use 5.010;

use WWW::Freshmeat;

sub run {
	my ($self, $p, $token) = @_;
	my %res = (
		ok => 1,
		data => q{},
		href => "http://freshmeat.net/projects/${p}/",
	);
	my $fm = WWW::Freshmeat->new(token => $token);
	my $fp = $fm->retrieve_project($p);

	if (not defined $fp) {
		$res{ok} = 0;
		$res{data} = 'not found';
	}
	else {
		$res{data} = 'v' . $fp->version();
		$res{description} = $fp->description();
	}

	return \%res;
}

1;
