#!/usr/bin/env python

from optparse import OptionParser
import ConfigParser

parser = OptionParser()
parser.add_option("-f", "--file", dest="filename", help="Path to config file", metavar="FILE")
parser.add_option("-s", "--section", dest="section", help="Section to modify value in", metavar="SECTION")
parser.add_option("-k", "--key", dest="key", help="Key to modify value of", metavar="KEY")
parser.add_option("-v", "--value", dest="value", help="Value to give to option", metavar="VALUE")

options, args = parser.parse_args()

if not options.filename:
	parser.error("A config file is required")

if not options.section:
	parser.error("A section is required")

if not options.key:
	parser.error("A key is required")

if not options.value:
	parser.error("A value is required for the key")
	

configParser = ConfigParser.RawConfigParser()

try:
	configParser.read(options.filename)
except:
	print "Error while trying to read file %s\n"%(options.filename)
	exit()

try:
	configParser.set(options.section, options.key, options.value)
except:
	print "Error while setting %s to %s in section %s of file %s\n"%(options.key, options.value, options.section, options.filename)
	exit()

config_file = open(options.filename, "w+")

try:
	configParser.write(config_file)
except:
	print "Error trying to write file %s\n"%(options.filename)
	exit()

config_file.close()
