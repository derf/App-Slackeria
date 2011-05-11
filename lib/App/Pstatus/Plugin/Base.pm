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
	my $ret;

	for my $key (keys %{$check_conf}) {
		$conf{$key} = $check_conf->{$key};
	}

	if (
			(defined $conf{enable} and $conf{enable} == 0)
			or $conf{disable} ) {
		return {
			data => q{},
			skip => 1,
		};
	}

	$self->{conf} = \%conf;

	$ret = eval { $self->check() };

	if ($@ or not defined $ret) {
		return {
			ok => 0,
			data => $@,
		};
	}

	if ($conf{href} and not defined $ret->{href}) {
		$ret->{href} = sprintf($conf{href}, $conf{name});
	}
	$ret->{ok} = 1;
	return $ret;
}

1;
