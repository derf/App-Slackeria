package App::Pstatus::Plugin::Freshmeat;

use strict;
use warnings;
use autodie;
use 5.010;

use parent 'App::Pstatus::Plugin';

use WWW::Freshmeat;

sub check {
	my ($self, %over_conf) = @_;

	my %res = $self->setup(%over_conf);

	my $fm = WWW::Freshmeat->new(token => $self->{conf}->{token});
	my $fp = $fm->retrieve_project($self->{conf}->{name});

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
