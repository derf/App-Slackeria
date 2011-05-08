package App::Pstatus::Plugin;

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

sub load {
	my ($obj, $plugin, %conf) = @_;
	my $ret;
	eval sprintf(
		'use App::Pstatus::Plugin::%s;'
		. '$ret = App::Pstatus::Plugin::%s->new(%%conf);',
		(ucfirst($plugin)) x 2,
	);
	if ($@) {
		die("Cannot load plugin ${plugin}:\n$@\n");
	}
	return $ret;
}

sub run {
	my ($self, %check_conf) = @_;
	my %conf = %{$self->{default}};
	my %res;

	for my $key (keys %check_conf) {
		$conf{$key} = $check_conf{$key};
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
