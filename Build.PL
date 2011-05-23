#!/usr/bin/env perl

use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	build_requires => {
		'Test::Compile' => 0,
		'Test::More' => 0,
		'Test::Pod' => 0,
	},
	dist_name => 'App-Slackeria',
	dist_version_from => 'bin/slackeria',
	license => 'unrestricted',
	recommends => {
		'autodie' => 0,
		'CPANPLUS' => 0,
		'File::Slurp' => 0,
		'List::Util' => 0,
		'Net::GitHub' => 0,
		'Sort::Versions' => 0,
		'WWW::Freshmeat' => 0,
	},
	requires => {
		'perl' => '5.10.0',
		'Config::Tiny' => 0,
		'File::BaseDir' => 0,
		'HTML::Template' => 0,
	},
	script_files => 'bin/',
	sign => 1,
);
$build->create_build_script();
