#!/usr/bin/perl
#####TAG####
##@10?MIN:##
####################################################################################################################################
############################################# CRONTAB SCRIPT: whataremyips.pl ######################################################
#################################### DomotRick whataremyips.pl, WILL PUSH INFOS EACH 10 MINTUTES ###################################
####################################################################################################################################
######################################### DEPENDENCIES, CORE SCRIPTS: getpublicip.sh, logmaker.pl  #################################
####################################################################################################################################

####################################################### PERL MODULES USED ##########################################################
use strict;
use warnings;
use Net::Address::IP::Local;

#################################################### VARIABLES DECLARATIONS ########################################################
my $ownname; my $langpref; my $argoption; my $debugmode; my $homefolder; my $domotrickfolder; my $corefolder; my $cronfolder; my $nodefolder;
my $logfile; my $corelogscript; my $message; my $corelogcmd; my $coredependency; my $coregetippubcmd;
my $publicip; my $localip; my $topic; my $payload; my $mqttclientid; my $mqttpub;

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
$corefolder = '/core-scripts';
$cronfolder = '/crontab-scripts';
$nodefolder = '/node-infos';

### LOG FILE NAME CORE SCRIPT COMMAND ###
$logfile = 'nodeipinfos.log';
$corelogscript = 'logmaker.pl';
$corelogcmd = $homefolder . $domotrickfolder . $corefolder . '/' . $corelogscript . ' ' . $logfile . ' ';

### CORE DEPENDENCY USE AND COMMAND ###
$coredependency = 'getpublicip.sh';
$coregetippubcmd = $homefolder . $domotrickfolder . $corefolder . '/' . $coredependency;

### MQTT INFOS ###
$mqttclientid = 'DtCRON' . $ownname;
$topic = '/networking/ip';

########################################### STARTING CRONTAB SCRIPT ###############################

######### GET THE PUBLIC IP ##############
$publicip = `$coregetippubcmd`;		chomp $publicip;	

print "Your public IP is: $publicip\n" if $debugmode == 1; ## ONLY FOR DEBUG ##

### IF ERROR LOG AND QUIT ###
unless ($publicip) {
	$message = "Error while getting PUBLIC IP address, check de core script dependency";
	print "$message\n" if $debugmode == 1; ## ONLY FOR DEBUG ##
	system ("$corelogcmd '$message'");	exit;
}

######### GET THE LOCAL IPv4 ##############
$localip = Net::Address::IP::Local->public_ipv4;

print "Your local IP is: $localip\n" if $debugmode == 1; ## ONLY FOR DEBUG ##

### IF ERROR LOG AND QUIT ###
unless ($localip) {
	$message = "Error while getting local IP address, Perl module problem?";
	print "$message\n" if $debugmode == 1; ## ONLY FOR DEBUG ##
	system ("$corelogcmd '$message'");	exit;
}

### IF BOTH SUCCESS LOG ###
$message = "Your local IP is: $localip and your public IP is: $publicip";
print "$message\n" if $debugmode == 1; ## ONLY FOR DEBUG ##
system ("$corelogcmd '$message'");

################################## MQTT PUBLISH WITH JSON PAYLOAD ##################################

### CREATING JSON PAYLOAD ###
$payload = '{"publicip":"' . $publicip .'","localip":"' . $localip .'"}';
$payload =~ s/\"/\\\"/ig; #TO ADD ( " ) WHEN PUBLISHED ##

### PUBLISH WITH RETAIN ###
$mqttpub = 'mosquitto_pub -r -i ' . $mqttclientid . ' -t "' . $topic . '" -m "' . $payload . '"';
system($mqttpub);

