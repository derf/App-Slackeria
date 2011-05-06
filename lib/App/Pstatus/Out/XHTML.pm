package App::Pstatus::Out::XHTML;
use strict;
use warnings;
use autodie;
use 5.010;

sub show_check {
	my ($res) = @_;

	if ($res->{ok} and $res->{data} eq q{}) {
		$res->{data} = 'ok';
	}

	if ($res->{ok} and $res->{href}) {
		$res->{data} = sprintf(
			'<a href="%s">%s</a>',
			$res->{href},
			$res->{data},
		);
	}

	printf(
		'<td class="%s">%s</td>',
		($res->{ok} ? "ok" : "fail"),
		$res->{data},
	);
}

sub write {
	my ($self, $project) = @_;
	my $firstline = 1;

	print(<<'EOF');
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<title>derf software QA</title>
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
EOF

	for my $p (sort keys %{$project}) {
		if ($firstline) {
			print '<tr><th>';
			print join('</th><th>', 'name', sort keys %{$project->{$p}});
			print '</th></tr>';
			$firstline = 0;
		}
		say("<tr><td>${p}</td>");
		for my $check (sort keys %{$project->{$p}}) {
			show_check($project->{$p}->{$check});
		}
		say ('</tr>');
	}

	print(<<'EOF');
</table>
</div>
</body>
</html>
EOF

}

1;
