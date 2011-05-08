package App::Pstatus::Status::Freshmeat;

use strict;
use warnings;
use autodie;
use 5.010;

use WWW::Freshmeat;

sub new {
	my ($obj, %conf) = @_;
	my $ref = {};
	$ref->{default} = \%conf;
	$ref->{default}->{href} //= 'http://freshmeat.net/projects/%s/';
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
	my $fm = WWW::Freshmeat->new(token => $conf{token});
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
