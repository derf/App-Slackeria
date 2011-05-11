package App::Pstatus::Plugin::Base;

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

sub run {
	my ($self, $check_conf) = @_;
	my %conf = %{$self->{default}};
	my %res;

	for my $key (keys %{$check_conf}) {
		$conf{$key} = $check_conf->{$key};
	}

	%res = (
		ok => 1,
		data => q{},
	);

	if (
			(defined $conf{enable} and $conf{enable} == 0)
			or $conf{disable} ) {
		$res{skip} = 1;
		return \%res;
	}

	if ($conf{href}) {
		$res{href} = sprintf($conf{href}, $conf{name});
	}

	$self->{conf} = \%conf;
	$self->{res} = \%res;

	$self->check(\%res);

	return $self->{res};
}

1;
