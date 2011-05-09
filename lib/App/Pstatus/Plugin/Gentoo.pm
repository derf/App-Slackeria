package App::Pstatus::Plugin::Gentoo;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin::Whohas';

sub check {
	my ($self, $res) = @_;

	$self->run_whohas('gentoo', $self->{conf}->{name});
}

1;
