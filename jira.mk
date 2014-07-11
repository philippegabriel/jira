#!/usr/bin/make -f
# philippeg jul2014
# common definition to access a jira db with psql
#
########################end of custom section##################################################
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
configFile:=$(SELF_DIR)/.config
#jira server params, read from .config file
config=$(lastword $(shell grep $(1) $(configFile)))
host:=$(call config,'host')
dbname:=$(call config,'dbname')
username:=$(call config,'username')
password:=$(call config,'password')
#psql generic methods
setJiraPass=export PGPASSWORD=$(password)
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
#Define function to set multiple argument list in a compatible psql format, i.e. 'item1','item2',...
qw=$(shell echo $(1) | sed "s/\([^,]*\)/'\1'/g")
###############################################################################################

