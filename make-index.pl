#!/usr/bin/perl -- # -*- Perl -*-

use strict;
use English;

# Hack hack hack

print "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n";
print "<head>\n";
print "<title>ndw/specification</title>\n";
print "</head>\n";
print "<body>\n";
print "<h1>Published files from ndw/specification</h1>\n";
print "\n";
print "<p>This site hosts Norman Walsh&apos;s “private” drafts of\n";
print "<cite>XProc 2.0: An XML Pipeline Language</cite> baked fresh\n";
print "automagically by <a href=\"http://travis-ci.org/\">Travis CI</a> after\n";
print "every commit.</p>\n";

my @specs = ();
open(FIND, "find langspec -type f \\( -name \"index.html\" -o -name \"Overview.html\" \\) -print |");
while (<FIND>) {
    chop;
    push (@specs, $_);
}
close (FIND);

print "<ul>\n";
foreach my $spec (@specs) {
    my $linktext = $spec;
    $linktext =~ s/\/Overview.html$//;
    $linktext =~ s/\/index.html$//;
    my $pubdate = pubdate($spec);
    print "<li><a href='$spec'>$linktext</a>";
    print ", $pubdate" if $pubdate ne '';
    print "</li>\n";
}
print "</ul>\n";

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
    open (F, $spec) || return "date unknown";
    read (F, $_, 4096);
    close (F);
    s/^.*?<h2>(.*?)<\/h2>.*$/$1/s;

    if (/\d+\s+\S+\s+\d+/) {
        $_ = $MATCH;
    } else {
        $_ = "";
    }

    return $_;
}
