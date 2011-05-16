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

	return $self->{file}->{$name}->{$section} // {};
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

__END__

=head1 NAME

App::Pstatus::Plugin - Get config values for App::Pstatus and plugins

=head1 SYNOPSIS

    use App::Pstatus::Config;

    my $conf = App::Pstatus::Config->new();
    for my $name ($conf->plugins()) {
        my $plugin_conf = $conf->get('config', $name);
        # load plugin
    }
    for my $project ($conf->projects()) {
        for my $name ($conf->plugins()) {
            my $plugin_conf = $conf->get($project, $name);
            # run plugin
        }
    }

=head1 DESCRIPTION

B<App::Pstatus::Config> uses L<Config::Tiny> to load config files.

=head1 METHODS

=over

=item $config = App::Pstatus::Config->new()

Returns a new App::Pstatus::Config object.  Does not take any arguments.

=item $config->get(I<$name>, I<$section>)

Returns a hashref containing the I<section> of the config file I<name>.  If
I<name> does not exist or does not contain I<section>, returns a reference to
an empty hash.  If I<name> is not B<config> and I<section> does not have a
B<name> field, sets B<name> to I<name> in the hashref.

=item $config->load(I<$name>)

Loads $XDG_CONFIG_HOME/pstatus/I<name> (defaulting to
~/.config/pstatus/I<name>) and saves its content internally. If the config
file does not exist, saves an empty hashref.

$config->get automatically calls this, so there should be no need for you to
use it.

=item $config->projects()

Returns an array of all projects, as listed in the B<list> key in the
B<projects> section of the B<config> file.

=item $config->plugins()

Returns an array of all plugins, which is actually just a list off all
sections in the B<config> file.

=back

=head1 DEPENDENCIES

L<Config::Tiny>, L<File::BaseDir>.

=head1 SEE ALSO

L<pstatus>

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
