package App::Pstatus::Plugin::Debian;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin';

use LWP::Simple;

sub check {
	my ($self, $res) = @_;
	my $p = $self->{conf}->{name};

	$res->{href} //= sprintf(
		'http://packages.qa.debian.org/%s',
		$p
	);

	my $madison = "http://qa.debian.org/madison.php?package=${p}&text=on&s=sid";
	my $qa = sprintf(
		'http://packages.qa.debian.org/%s/%s.html',
		substr($p, 0, 1),
		$p
	);

	# madison.php is slow, so only use it if we know the package exists
	if (not get($qa)) {
		$res->{ok} = 0;
		$res->{data} = 'not found';
		return;
	}

	my $text = get($madison);

	if (not defined $text or not length($text)) {
		$res->{ok} = 0;
		$res->{data} = 'empty reply';
		return;
	}

	$text = (split(/\n/, $text))[-1];

	$res->{data} = (split(qr{ \| }ox, (split(/\n/, $text))[-1]))[1];
}

1;
