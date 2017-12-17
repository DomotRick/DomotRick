#!/usr/bin/perl
#####TAG####
##@10?MIN:##
####################################################################################################################################
############################################# CRONTAB SCRIPT: getmyuptime.pl #######################################################
#################################### DomotRick getmyuptime.pl, WILL PUSH INFOS EACH 10 MINTUTES ####################################
####################################################################################################################################
######################################### DEPENDENCIES, CORE SCRIPTS: logmaker.pl  #################################################
####################################################################################################################################

####################################################### PERL MODULES USED ##########################################################
use strict;
use warnings;

#################################################### VARIABLES DECLARATIONS ########################################################
my $ownname; my $langpref; my $argoption; my $debugmode; my $homefolder; my $domotrickfolder;my $corefolder; my $cronfolder; my $nodefolder;
my $logfile; my $corelogscript; my $message; my $corelogcmd; my $getuptimecmd; my $uptime; my $topic; my $payload; my $mqttclientid; my $mqttpub;

################################ CHECK IF SOME OPTIONS HAS BEEN ADD IN ARGUMENTS ###################
$argoption = $ARGV[0];

unless ($argoption) {
	$debugmode = 0;
}elsif ($argoption =~ /\-d/) {
	print "DEBUG MODE is activated, all outputs at each steps will be shown, with a one second delay\n";
	$debugmode = 1;
}

######################################## FILL SOME VARIABLES ########################################
$ownname = $0; 		$ownname =~ s/\.\///ig;
$langpref = 'EN';
$homefolder = '/home/pi';
$domotrickfolder = '/DomotRick';
$corefolder = "/core-scripts";
$cronfolder = '/crontab-scripts';
$nodefolder = '/node-infos';

### LOG FILE NAME CORE SCRIPT COMMAND ###
$logfile = 'uptime.log';
$corelogscript = 'logmaker.pl';
$corelogcmd = $homefolder . $domotrickfolder . $corefolder . '/' . $corelogscript . ' ' . $logfile . ' ';

### MQTT INFOS ###
$mqttclientid = 'DtCRON' . $ownname;
$topic = '/domotrick/uptime';

#################################### STARTING CRONTAB SCRIPT ########################################
$getuptimecmd = "uptime -p";

$uptime = `$getuptimecmd`;		$uptime =~ s/up\ //ig;		chomp $uptime;
$message = "DomotRick uptime is: $uptime";


### CHECK FOR ERROR ###
unless ($uptime) {
	$message = "ERROR, Unable to get the UPTIME";
}

### LOG IF SUCCES ###
print "$message\n" if $debugmode == 1; ## ONLY FOR DEBUG ##
system ("$corelogcmd '$message'");

########################################### MQTT PUBLISH #############################################
$payload = $uptime;

$mqttpub = 'mosquitto_pub -r -i ' . $mqttclientid . ' -t "' . $topic . '" -m "' . $payload . '"';
system ($mqttpub);
