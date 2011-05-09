package App::Pstatus::Plugin::Ubuntu;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin::Whohas';

sub check {
	my ($self, $res) = @_;

	$self->run_whohas('ubuntu', $self->{conf}->{name});
}

1;
