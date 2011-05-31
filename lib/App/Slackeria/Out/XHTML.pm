package App::Slackeria::Out::XHTML;
use strict;
use warnings;
use autodie;
use 5.010;

use HTML::Template;

our $VERSION = '0.1';

sub format_check {
	my ( $self, $res ) = @_;
	my ( $class, $href, $data );

	if ( not $res->{skip} and $res->{ok} and $res->{data} eq q{} ) {
		$data = 'ok';
	}

	if ( $res->{ok} and $res->{href} ) {
		$href = $res->{href};
	}

	if ( not $res->{skip} ) {
		$data //= $res->{data};
		if ( $res->{ok} ) {
			$class = 'ok';
		}
		else {
			$class = 'fail';
		}
	}

	return {
		class => $class // q{},
		data  => $data,
		href  => $href,
	};
}

sub write_out {
	my ( $self, $filename, $project ) = @_;
	my @project_lines;
	my @headers;

	my $tmpl = HTML::Template->new(
		filehandle => *DATA,
		title      => 'Software version matrix',
	);

	for my $p ( sort keys %{$project} ) {

		my @plugins = sort keys %{ $project->{$p} };

		my @project_plugins
		  = map { $self->format_check( $project->{$p}->{$_} ) } @plugins;

		if ( @headers == 0 ) {
			push( @headers, map { { plugin => $_ } } @plugins );
		}

		push(
			@project_lines,
			{
				project => $p,
				plugin  => [@project_plugins]
			}
		);

	}

	$tmpl->param(
		header => [@headers],
		line   => [@project_lines],
	);

	open( my $fh, '>', $filename );
	print $fh $tmpl->output();
	close($fh);

	return;
}

1;

=pod

=head1 NAME

App::Slackeria::Out::XHTML - XHTML output for App::Slackeria

=head1 SYNOPSIS

	# $project looks like this:
	# {
	#     perl => {
	#         Debian    => { ok => 1, data => '5.12.3-7' },
	#         Freshmeat => { ok => 1, data => '5.14.0' },
	#     },
	#     irssi => {
	#         Debian    => { ok => 1, data => '0.8.15-3+b1' },
	#         Freshmeat => { ok => 1, data => '0.8.12' },
	#     },
	# }
	App::Slackeria::Out::XHTML->write_out( '/tmp/out.html', $project );

=head1 VERSION

version 0.1

=head1 DESCRIPTION

App::Slackeria::Out::XHTML takes a hashref of projects, which themselves are
hashrefs of plugin name => plugin output pairs, and stuffs it into a nicely
formatted (X)HTML table.

=head1 FUNCTIONS

=over

=item App::Slackeria::Out::XHTML->write_out(I<$filename>, I<\%data>)

Creates HTML in I<filename> based on I<data>.

=back

=head1 DEPENDENCIES

HTML::Template(3pm)

=head1 SEE ALSO

slackeria(1)

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel <derf@finalrewind.org>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.

=cut

__DATA__

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<title><TMPL_VAR title></title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
	<style type="text/css">
		html {
			font-family: Sans-Serif;
			text-align: center;
		}

		a {
			text-decoration: none;
			color: #000099;
		}

		table, th, td {
			border: solid black 1px;
		}

		table {
			border-collapse: collapse;
		}

		td.ok {
			background-color: #ccffcc;
		}

		td.fail {
			background-color: #ffcccc;
		}
	</style>
</head>
<body>
<div>
<table>
<tr>
<th>name</th>
<TMPL_LOOP header>
	<th><TMPL_VAR plugin></th>
</TMPL_LOOP>
</tr>
<TMPL_LOOP line>
	<tr>
	<td><TMPL_VAR project></td>
	<TMPL_LOOP plugin>
		<td class="<TMPL_VAR class>">
		<TMPL_IF href><a href="<TMPL_VAR href>"></TMPL_IF>
		<TMPL_VAR data>
		<TMPL_IF href></a></TMPL_IF>
		</td>
	</TMPL_LOOP>
	</tr>
</TMPL_LOOP>
</table>
</div>
</body>
</html>
