#!/usr/bin/perl -- # -*- Perl -*-

use strict;
use English;

# Hack hack hack

print <<EOF1;
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>ndw/specification</title>
</head>
<body>
<h1>Published files from ndw/specification</h1>

<p>This site hosts Norman Walsh's “private” drafts of
<cite>XProc 2.0: An XML Pipeline Language</cite> baked fresh
automagically by <a href="http://travis-ci.org/">Travis CI</a> after
every commit.</p>
EOF1

my @branches = ();
opendir (DIR, "langspec");
while (my $fn = readdir(DIR)) {
    next if $fn =~ /^\.\.?$/;
    next if $fn eq 'xproc20';
    push (@branches, $fn) if -d "langspec/$fn";
}
closedir (DIR);

my $pubdate = pubdate("langspec", "xproc20");

print <<EOF2;
<dl>
<dt>My “stable” branch:</dt>
<dd>
<ul>
<li><a href="/specification/langspec/xproc20/head">XProc 2.0: An XML Pipeline Language</a>
specification ($pubdate)</li>
<li><a href="/specification/langspec/xproc20/head/ns/xproc.html">Namespace document</a>
for <code>http://www.w3.org/ns/xproc</code></li>
<li><a href="/specification/langspec/xproc20/head/ns/xproc-step.html">Namespace document</a>
for <code>http://www.w3.org/ns/xproc-step</code></li>
<li><a href="/specification/langspec/xproc20/head/ns/xproc-error.html">Namespace document</a>
for <code>http://www.w3.org/ns/xproc-error</code></li>
</ul>
</dd>
EOF2

foreach my $branch (sort { $a cmp $b } @branches) {
    $pubdate = pubdate("langspec", $branch);
    print "<dt>$branch</dt>\n";
    print "<dd>\n";
    print "<ul>\n";
    print "<li><a href=\"/specification/langspec/$branch/head\">XProc 2.0: An XML Pipeline Language</a> specification ($pubdate)</li>\n";
    print "<li><a href=\"/specification/langspec/$branch/head/ns/xproc.html\">Namespace document</a> for <code>http://www.w3.org/ns/xproc</code></li>\n";
    print "<li><a href=\"/specification/langspec/$branch/head/ns/xproc-step.html\">Namespace document</a> for <code>http://www.w3.org/ns/xproc-step</code></li>\n";
    print "<li><a href=\"/specification/langspec/$branch/head/ns/xproc-error.html\">Namespace document</a> for <code>http://www.w3.org/ns/xproc-error</code></li>\n";
    print "</ul>\n</dd>\n\n";
}

print "</dl>\n\n";

print <<EOF3;
<p>These documents have all the normative force one would expect of the
scribblings of a mad man.</p>

<p>If you have a question or comment about the XProc specification, please
raise it as
<a href="https://github.com/xproc/specification/issues">an issue</a>
on the specification repository.</p>

</body>
</html>
EOF3

exit 0;

sub pubdate {
    my $spec = shift;
    my $branch = shift;
    open (F, "$spec/$branch/head/index.html") || return "date unknown";
    read (F, $_, 4096);
    close (F);
    s/^.*?<h2>(.*?)<\/h2>.*$/$1/s;

    if (/\d+\s+\S+\s+\d+/) {
        $_ = $MATCH;
    } else {
        $_ = "date unknown"
    }

    return $_;
}
