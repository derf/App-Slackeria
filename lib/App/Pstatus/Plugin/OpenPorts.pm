package App::Pstatus::Plugin::OpenPorts;

use strict;
use warnings;
use 5.010;

use parent 'App::Pstatus::Plugin';

use LWP::UserAgent;
use XML::LibXML;

sub check {
	my ($self) = @_;

	my $name  = $self->{conf}->{name};
	my $ua    = LWP::UserAgent->new( timeout => 10 );
	my $reply = $ua
		->get("http://openports.se/search.php?stype=folder&so=${name}");

	if ( not $reply->is_success() ) {
		die( $reply->status_line() );
	}

	my $html = $reply->decoded_content();
	my $tree = XML::LibXML->load_html( string => $html );

	my $xp_main = XML::LibXML::XPathExpression->new('//div[@id="main"]/b');
	my $xp_url  = XML::LibXML::XPathExpression->new('following::a[1]');
	my $xp_ver  = XML::LibXML::XPathExpression->new('following::em/b[1]');

	for my $node ( @{ $tree->findnodes($xp_main) } ) {
		if ( $node->textContent() eq '*** Exact match ***' ) {
			my $category = $node->findnodes($xp_url)->[0]->textContent();
			my $version = $node->findnodes($xp_ver)->[0]->textContent();

			$version =~ s{ ^ version \s }{}x;

			return {
				data => $version,
			};
		}
	}
}

1;

__END__

=head1 NAME

App::Pstatus::Plugin::OpenPorts - Check project version in OpenBSD Ports

=head1 SYNOPSIS

In F<pstatus/config>

    [OpenPorts]

=head1 DESCRIPTION

This plugin queries a project's port on openports.se.

=head1 CONFIGURATION

None.

=head1 AUTHOR

Copyright (C) 2011 by Daniel Friesel E<lt>derf@finalrewind.orgE<gt>

=head1 LICENSE

  0. You just DO WHAT THE FUCK YOU WANT TO.
