#
# ident	"@(#)perlgcc.PL	1.2	03/01/19 SMI"
#
# Copyright 2002 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

BEGIN { $^W = 1; };
use strict;
use Config;
use vars qw{$VERSION};
$VERSION = "1.2";

my $fh = do { local *FH; *FH; };
open($fh, ">$ARGV[0]") || die("Can't open perlgcc: $!\n");

my $startperl = $Config{startperl};
my $perlpath = $Config{perlpath};
my $sitelib  = "$Config{installsitelib}/Solaris/PerlGcc";

if ($] == 5.00503) {
print $fh <<EOF;
$startperl
#
# ident	"@(#)$ARGV[0]	1.2	03/01/19 SMI"
#
# Copyright 2002 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

require 5.00503;
BEGIN { \$^W = 1; };
use strict;
use vars qw{\$VERSION};
\$VERSION = '1.2';

if (exists(\$ENV{PERL5LIB})) {
	\$ENV{PERL5LIB} =
	    "$sitelib:\$ENV{PERL5LIB}";
} else {
	\$ENV{PERL5LIB} =
	    '$sitelib';
}
exec('$perlpath', \@ARGV)
    || die("Can't exec $perlpath: \$!\\n");
EOF

} elsif ($] == 5.006001) {
print $fh <<EOF;
$startperl
#
# ident	"@(#)$ARGV[0]	1.2	03/01/19 SMI"
#
# Copyright 2002 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

use 5.6.1;
use strict;
use warnings;
our \$VERSION = '1.2';

if (exists(\$ENV{PERL5LIB})) {
	\$ENV{PERL5LIB} =
	    "$sitelib:\$ENV{PERL5LIB}";
} else {
	\$ENV{PERL5LIB} =
	    '$sitelib';
}
exec('$perlpath', \@ARGV)
    || die("Can't exec $perlpath: \$!\\n");
EOF

} else {
	die("Unsupported perl version\n");
}

close($fh);
exit(0);
