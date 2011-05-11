package App::Pstatus::Plugin;

use strict;
use warnings;
use autodie;
use 5.010;

sub new {
	my ($obj, %conf) = @_;
	my $ref = {};
	return bless($ref, $obj);
}

sub load {
	my ($self, $plugin, %conf) = @_;
	my $obj;
	eval sprintf(
		'use App::Pstatus::Plugin::%s;'
		. '$obj = App::Pstatus::Plugin::%s->new(%%conf);',
		(ucfirst($plugin)) x 2,
	);
	if ($@) {
		print STDERR "Cannot load plugin ${plugin}:\n$@\n";
	}
	else {
		$self->{plugin}->{$plugin} = $obj;
	}
}

sub list {
	my ($self) = @_;
	return sort keys %{$self->{plugin}};
}

sub run {
	my ($self, $name, $conf) = @_;

	if ($self->{plugin}->{$name}) {
		return $self->{plugin}->{$name}->run($conf);
	}
	else {
		return undef;
	}
}

1;
