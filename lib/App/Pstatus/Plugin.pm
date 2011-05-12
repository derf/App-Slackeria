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

__END__

=head1 NAME

App::Pstatus::Plugin - Plugin wrapper for App::Pstatus

=head1 SYNOPSIS

    use App::Pstatus::Plugin;

    my $plugin = App::Pstatus::Plugin->new();
    my $result;

    $plugin->load('CPAN', %cpan_default_conf);

    $result->{pstatus}->{CPAN} = $plugin->run('CPAN', {
            name => 'App-Pstatus',
            # further pstatus-specific configuration (if needed)
    });

    # $result->{pstatus}->{CPAN} is like:
    # {
    #     ok => 1,
    #     data => 'v0.1',
    #     href => 'http://search.cpan.org/dist/App-Pstatus/'
    # }

=head1 DESCRIPTION

B<App::Pstatus::Plugin> loads and executes a number of B<pstatus> plugins.  It
also makes sure that any errors in plugins are catched and do not affect the
code using B<App::Pstatus::Plugin>.

=head1 METHODS

=over

=item $plugin = App::Pstatus::Plugin->new()

Returns a new App::Pstatus::Plugin object.  Does not take any arguments.

=item $plugin->load(I<plugin>, I<%conf>)

Create an internal App::Pstatus::Plugin::I<plugin> object by using it and
calling App::Pstatus::Plugin::I<plugin>->new(I<%conf>).  If I<plugin> does not
exist or fails during setup, B<load> prints an error message to STDERR.

=item $plugin->list()

Returns an array containing the names of all loaded plugins.

=item $plugin->run(I<plugin>, I<$conf_ref>)

Calls the B<run> method of I<plugin>:
$plugin_object->run(I<$conf_ref>).

If I<plugin> exists and is loaded, it returns the output of the run method,
otherwise undef.

=back

=head1 DEPENDENCIES

None.

=head1 SEE ALSO

L<pstatus>, L<App::Pstatus::Plugin::Base>.

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
