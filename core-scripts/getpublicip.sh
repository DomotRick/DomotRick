#!/bin/bash
#######################################################
###### THIS SCRIPT GET YOUR PUBLIC IP ADRESS ##########
############# FROM DomotRick v1.12 ####################
#######################################################
curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
