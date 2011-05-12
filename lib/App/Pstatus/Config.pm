package App::Pstatus::Config;

use strict;
use warnings;
use autodie;
use 5.010;

use Config::Tiny;
use Carp;
use File::BaseDir qw(config_files);

sub new {
	my ($obj) = @_;
	my $ref = {};
	return bless($ref, $obj);
}

sub get {
	my ($self, $name, $section) = @_;
	$self->load($name);

	if ($name ne 'config') {
		$self->{file}->{$name}->{$section}->{name} //= $name;
	}

	return $self->{file}->{$name}->{$section};
}


sub load {
	my ($self, $name) = @_;
	my $file = config_files("pstatus/${name}");

	if (defined $self->{file}->{$name}) {
		return;
	}

	if ($file) {
		$self->{file}->{$name} = Config::Tiny->read($file);
	}
	else {
		$self->{file}->{$name} = {};
	}

	if ($name eq 'config') {
		$self->{projects} = [ split(/ /,
				$self->{file}->{$name}->{projects}->{list}) ];
		delete $self->{file}->{$name}->{projects};
	}
}

sub projects {
	my ($self) = @_;
	$self->load('config');
	return @{$self->{projects}};
}

sub plugins {
	my ($self) = @_;
	$self->load('config');
	return keys %{$self->{file}->{config}};
}

1;
