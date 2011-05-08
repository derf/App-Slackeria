package App::Pstatus::Status::Cgit;

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

sub prepare_check {
	my ($self, %check_conf) = @_;
	my %conf = %{$self->{default}};
	my %res;

	for my $key (keys %check_conf) {
		$conf{$key} = $check_conf{$key};
	}

	$self->{conf} = \%conf;

	%res = (
		ok => 1,
		data => q{},
	);

	if ($conf{href}) {
		$res{href} = sprintf($conf{href}, $conf{name});
	}

	return %res;
}

1;
