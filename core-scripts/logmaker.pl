#!/usr/bin/perl
use strict;
use warnings;
####################################################################################################################################
############################################### CORE SCRIPT: logmaker.pl ###########################################################
#################################### DomotRick LOG MAKER, WILL BE CALL BY OTHER SCRIPTS ############################################
####################################################################################################################################
##################################### USAGE logmaker.pl "FileName" "Message to be log" #############################################
####################################################################################################################################

################################# VARIABLE DECLARATION ############################################
my $ownname;
my $langpref;
my $homefolder;
my $domotrickfolder;
my $corefolder;
my $nodefolder;
my $logfile;
my $fulllogfilename;
my $message;
my $timecmd;
my $timestamp;

######################################## FILL SOME VARIABLES ########################################
$ownname = $0; 		$ownname =~ s/\.\///ig;
$langpref = 'EN';
$homefolder = "/home/pi";
$domotrickfolder = "/DomotRick";
$corefolder = "/core-scripts";
$nodefolder = "/node-infos";

######################################## VERIFY ARGUMENTS #########################################

### CHECK IF LOG FILE ARGUMENT EXIST ###
$logfile = $ARGV[0];
unless ($logfile) {print "Please specify a file name\n";exit;};
$fulllogfilename = $homefolder . $domotrickfolder . $nodefolder . '/' . $logfile;

### CHECK IF ARGUMENT MESSAGE EXIST ###
$message = $ARGV[1];
unless ($message) {print "Please specify a log Message\n";exit;};

######################################### WRITE THE LOG ###########################################
open (my $WRITE, '>>', $fulllogfilename) or die;

### CREATE A TIMESTAMP ###
$timecmd = 'date "+%D %T"';		$timestamp = `$timecmd`;	chomp $timestamp;

### WRITE THE FILE ###
print $WRITE "[" . $timestamp . "]:$message\n";

close $WRITE;








