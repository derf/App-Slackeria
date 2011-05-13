package App::Pstatus::Out::XHTML;
use strict;
use warnings;
use autodie;
use 5.010;

sub format_check {
	my ($res) = @_;
	my $class = q{};

	if (not $res->{skip} and $res->{ok} and $res->{data} eq q{}) {
		$res->{data} = 'ok';
	}

	if ($res->{ok} and $res->{href}) {
		$res->{data} = sprintf(
			'<a href="%s">%s</a>',
			$res->{href},
			$res->{data},
		);
	}

	if (not $res->{skip}) {
		if ($res->{ok}) {
			$class = 'ok';
		}
		else {
			$class = 'fail';
		}
	}

	return sprintf(
		'<td class="%s">%s</td>',
		$class,
		$res->{data},
	);
}

sub write {
	my ($self, $filename, $project) = @_;
	my $firstline = 1;

	my $html = <<'EOF';
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
			$html .= '<tr><th>';
			$html .= join('</th><th>', 'name', sort keys %{$project->{$p}});
			$html .= '</th></tr>';
			$firstline = 0;
		}
		$html .= "<tr><td>${p}</td>\n";
		for my $check (sort keys %{$project->{$p}}) {
			$html .= format_check($project->{$p}->{$check});
		}
		$html .= "</tr>";
	}

	$html .= <<'EOF';
</table>
</div>
</body>
</html>
EOF

	open (my $fh, '>', $filename);
	print $fh $html;
	close($fh);

}

1;
