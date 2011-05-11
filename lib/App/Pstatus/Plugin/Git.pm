package App::Pstatus::Plugin::Git;

use strict;
use warnings;
use autodie;
use 5.010;

use parent 'App::Pstatus::Plugin::Base';

use File::Slurp;
use List::Util qw(first);
use Sort::Versions;

sub check {
	my ($self, $res) = @_;

	my $git_dir = sprintf($self->{conf}->{git_dir}, $self->{conf}->{name});

	my @tags = split(/\n/, qx{git --git-dir=${git_dir} tag});
	if (@tags) {
		$res->{data} = 'v' . (sort { versioncmp($a, $b) } @tags)[-1];
	}

	open(my $fh, '<', "${git_dir}/config");
	if (not first { $_ eq "\tsharedRepository = world\n" } read_file($fh)) {
		$res->{ok} = 0;
		$res->{data} = 'Repo not shared';
	}
	close($fh);

	if (not -e "${git_dir}/git-daemon-export-ok") {
		$res->{ok} = 0;
		$res->{data} = 'git-daemon-export-ok missing';
	}
}

1;

=head1 NAME

B<App::Pstatus::Plugin::Git> - Check if bare git repo exists in a local
directory

=head1 SYNOPSIS

In F<pstatus/config>

    [git]
    git_dir = /home/user/var/git_root/%s
    href = http://git.example.org/%s/

=head1 DESCRIPTION

This plugin checks if a git repo exists on the local host and ensures it is
set as world-readable and contains the "git-daemon-export-ok" file.

=head1 CONFIGURATION

=over

=item git_dir

Path to bare git files, %s is replaced by B<name>.  Mandatory

=item href

Link to point to in output, again %s is replaced by B<name>

=back

=head1 DEPENDENCIES

L<File::Slurp>, L<List::Util>, L<Sort::Versions>.  The B<git> executable must
be available.

=head1 SEE ALSO

L<pstatus>

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
