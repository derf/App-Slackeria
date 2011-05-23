package App::Slackeria::Plugin::Whohas;

use strict;
use warnings;
use 5.010;

use parent 'App::Slackeria::Plugin::Base';

our $VERSION = '0.1';

sub run_whohas {
	my ($self, $distro, $name) = @_;

	my $out = qx{whohas --no-threads --strict -d $distro $name};

	if (not defined $out or $out eq q{}) {
		die("not found\n");
	}

	$out = (split(/\n/, $out))[-1];

	return {
		data => substr($out, 51, 10),
		href => substr($out, 112),
	};
}

1;
