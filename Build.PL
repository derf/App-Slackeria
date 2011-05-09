#!/usr/bin/env perl

use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	build_requires => {
	},
	dist_name => 'App-Pstatus',
	dist_version_from => 'bin/pstatus',
	license => 'unrestricted',
	recommends => {
		'File::Slurp' => 0,
		'List::Util' => 0,
		'Net::GitHub' => 0,
		'Sort::Versions' => 0,
		'WWW::Freshmeat' => 0,
	},
	requires => {
		'perl' => '5.10.0',
		'autodie' => 0,
		'Config::Tiny' => 0,
		'File::BaseDir' => 0,
	},
	script_files => 'bin/',
);
$build->create_build_script();
