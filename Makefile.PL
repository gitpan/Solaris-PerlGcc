#
# ident	"@(#)Makefile.PL	1.2	03/05/13 SMI"
#
# Copyright 2002-2003 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

BEGIN { $^W = 1; };
use strict;
use ExtUtils::MakeMaker;
use POSIX qw(uname);

# Check we are on the correct OS and version, and running the Solaris perl.
my ($os, $host, $rel, $ver, $arch) = uname();
my $hw = $arch;
$hw = 'x86' if ($hw eq 'i86pc');
$hw = 'sparc' if ($hw =~ /^sun4/);
my $exe = qx{/bin/ksh -pc "whence $^X"};
chomp($exe);
die("Invalid OS $os, this module is for Solaris only\n")
    unless ($os eq 'SunOS');
die("Invalid Solaris version $rel, this module is for Solaris 8, 9 & 10 only\n")
    unless ($rel =~ /^5\.(?:8|9|10)$/);
if ($] == 5.00503) {
	die ("This is not the 5.005_03 shipped as part of Solaris\n")
	    unless (system("cmp -s $exe /usr/perl5/5.00503/bin/perl5.00503")
	    == 0);
} elsif ($] == 5.006001) {
	die ("This is not the 5.6.1 shipped as part of Solaris\n")
	    unless (system("cmp -s $exe /usr/perl5/5.6.1/bin/perl5.6.1") == 0);
} else {
	die("Invalid perl version $], ",
	    "this module is for 5.005_03 and 5.6.1 only\n")
}

# Figure out the appropriate Config.pm and MakeMaker.pm
my $configpm = "config/$]/$rel/$hw/Config.pm";
my $makemakerpm = "config/$]/MakeMaker.pm";
die("Unsupported OS version/Architecture/Perl version $rel/$hw/$]\n")
    unless (-f $configpm && -f $makemakerpm);

# .pm files.
my %pm = (
    $configpm		=> "\$(INST_LIBDIR)/PerlGcc/Config.pm",
    $makemakerpm	=> "\$(INST_LIBDIR)/PerlGcc/ExtUtils/MakeMaker.pm",
);

# Manual pages.
my %man1pods = (
    'pod/perlgcc.pod'	=> '$(INST_MAN1DIR)/perlgcc.$(MAN1EXT)',
);

WriteMakefile(
    NAME		=> 'Solaris::PerlGcc',
    VERSION_FROM	=> 'perlgcc.PL',
    PL_FILES		=> { 'perlgcc.PL' => 'perlgcc' },
    EXE_FILES		=> [ 'perlgcc' ],
    PM			=> \%pm,
    MAN1PODS		=> \%man1pods,
    MAN3PODS		=> { },	# Stop autopodification of MakeMaker.pm.
    clean		=> { FILES => 'perlgcc' },
);
