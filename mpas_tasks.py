import sys, os, glob, shutil, numpy, math
import subprocess
import ConfigParser

from netCDF4 import *
from netCDF4 import Dataset as NetCDFFile
from pylab import *

from lettuce import *

from collections import defaultdict
import xml.etree.ElementTree as ET

from namelist_python.namelist import read_namelist_file
try:
	from collections import OrderedDict
except ImportError:
	from utils import OrderedDict

@world.absorb
def seconds_to_timestamp(seconds):#{{{
	days = 0
	hours = 0
	minutes = 0

	if seconds >= 24*3600:
		days = int(seconds/(24*3600))
		seconds = seconds - int(days * 24 * 3600)

	if seconds >= 3600:
		hours = int(seconds/3600)
		seconds = seconds - int(hours*3600)

	if seconds >= 60:
		minutes = int(seconds/60)
		seconds = seconds - int(minutes*60)

	timestamp = "%4.4d_%2.2d:%2.2d:%2.2d"%(days, hours, minutes, seconds)
	return timestamp
#}}}

@world.absorb
def timestamp_to_seconds(timestamp):#{{{
	in_str = timestamp.translate(None, "'")
	days = 0
	hours = 0
	minutes = 0
	seconds = 0
	if timestamp.find("_") > 0:
		parts = in_str.split("_")

		ymd = parts[0]
		tod = parts[1]

		if ymd.find("-") == 0:
			days = days + float(ymd)
		elif ymd.find("-") == 1:
			parts = ymd.split("-")
			days = days + 30 * float(parts[0])
			days = days + float(parts[1])
		elif ymd.find("-") == 2:
			parts = ymd.split("-")
			days = days + 365 * float(parts[0])
			days = days + 30 * float(parts[1])
			days = days + float(parts[2])
	else:
		tod = in_str

	if tod.find(":") == 0:
		seconds = float(tod)
	elif tod.find(":") == 1:
		parts = tod.split(":")
		minutes = float(parts[0])
		seconds = float(parts[1])
	elif tod.find(":") == 2:
		parts = tod.split(":")
		hours = float(parts[0])
		minutes = float(parts[1])
		seconds = float(parts[2])

	seconds = seconds + minutes * 60 + hours * 3600 + days * 24 * 3600

	return seconds
#}}}

@step('I perform a (\d+) processor MPAS "([^"]*)" run')#{{{
def run_mpas(step, procs, executable):

	if ( world.run == True ):
		if executable.find("testing") >= 0:
			rundir = "%s/testing_tests/%s"%(world.base_dir, world.test)
		elif executable.find("trusted") >= 0:
			rundir = "%s/trusted_tests/%s"%(world.base_dir, world.test)

		os.chdir(rundir)
		command = "mpirun"
		arg1 = "-n"
		arg2 = "%s"%procs
		arg3 = "./%s"%executable
		try:
			subprocess.check_call([command, arg1, arg2, arg3], stdout=world.dev_null, stderr=world.dev_null)  # check_call will throw an error if return code is not 0.
		except:
			os.chdir(world.base_dir)  # return to base_dir before err'ing.
			raise
		if os.path.exists('output.nc'):
			outfile = 'output.nc'
		else:
			outfile = "output.0000-01-01_00.00.00.nc"
		command = "mv"
		arg1 = outfile
		arg2 = "%sprocs.output.nc"%procs
		try:
			subprocess.check_call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)  # check_call will throw an error if return code is not 0.
		except:
			os.chdir(world.base_dir)  # return to base_dir before err'ing.
			raise
		if world.num_runs == 0:
			world.num_runs = 1
			world.run1 = "%s/%s"%(rundir, arg2)
			world.run1dir = rundir
			try:
				del world.rms_values
				world.rms_values = defaultdict(list)
			except:
				world.rms_values = defaultdict(list)
		elif world.num_runs == 1:
			world.num_runs = 2
			world.run2 = "%s/%s"%(rundir, arg2)
			world.run2dir = rundir
		os.chdir(world.base_dir)
#}}}

@step('I perform a (\d+) processor MPAS "([^"]*)" run with restart')#{{{
def run_mpas_with_restart(step, procs, executable):

	if ( world.run == True ):
		if executable.find("testing") >= 0:
			rundir = "%s/testing_tests/%s"%(world.base_dir, world.test)
		elif executable.find("trusted") >= 0:
			rundir = "%s/trusted_tests/%s"%(world.base_dir, world.test)

		os.chdir(rundir)

		# Previous run should be setup to:
		#  * be 2 time steps long
		#  * have output interval set to the timestep length
		#  * have restart interval set to the timestep length

		# Now set up a run that does one time step, stops, then restarts for one more
		# Setup the cold start for the first time step
		namelistfile = open(world.namelist, 'r+')
		lines = namelistfile.readlines()
		# first grab the config_dt as a string
		for line in lines:
			if line.find('config_dt') >= 0:
				timestep_string = line.split("=")[1].strip().strip("'")
			else:
				new_line = line
			namelistfile.write(new_line)
		# now re-write the namelist file, updating run_duration to be 1 dt
		namelistfile.seek(0)
		namelistfile.truncate()
		for line in lines:
			if line.find('config_run_duration') >= 0:
				new_line = "	config_run_duration = '%s'\n"%timestep_string
			else:
				new_line = line
			namelistfile.write(new_line)
		namelistfile.close()
		del lines

		# Perform the cold start to get half way through the standard run
		try:
			subprocess.check_call(["mpirun", "-n", "%s"%procs, "./%s"%executable], stdout=world.dev_null, stderr=world.dev_null)  # check_call will throw an error if return code is not 0.
		except:
			os.chdir(world.base_dir)  # return to base_dir before err'ing.
			raise
		# No need to keep/copy output, just continue on below

		# Set namelist file to perform restart from last restart file (which you should have set up to land at the end of the run)
		namelistfile = open(world.namelist, 'r+')
		lines = namelistfile.readlines()
		namelistfile.seek(0)
		namelistfile.truncate()
		for line in lines:
			if line.find('config_do_restart') >= 0:
				new_line = "	config_do_restart = .true.\n"
			elif line.find('config_start_time') >= 0:
				new_line = "	config_start_time = 'file'\n"
			elif line.find('config_run_duration') >= 0:
				new_line = "	config_run_duration = '%s'\n"%timestep_string  # Already set above, but setting again for clarity
			else:
				new_line = line
			namelistfile.write(new_line)
		namelistfile.close()
		del lines

		# Run the restarted run to get to the end of the standard run
		try:
			subprocess.check_call(["mpirun", "-n", "%s"%procs, "./%s"%executable], stdout=world.dev_null, stderr=world.dev_null)
		except:
			os.chdir(world.base_dir)  # return to base_dir before err'ing.
			raise

		# Keep a copy of the completed restart run
		try:
			restart_output_file = "%sprocs.restarted.output.nc"%procs
			subprocess.check_call(["mv", "output.nc", restart_output_file], stdout=world.dev_null, stderr=world.dev_null)
		except:
			os.chdir(world.base_dir)  # return to base_dir before err'ing.
			raise

		# Augment the world metadata with this run
		if world.num_runs == 0:
			world.num_runs = 1
			world.run1 = "%s/%s"%(rundir,restart_output_file)
			world.run1dir = rundir
			try:
				del world.rms_values
				world.rms_values = defaultdict(list)
			except:
				world.rms_values = defaultdict(list)
		elif world.num_runs == 1:
			world.num_runs = 2
			world.run2 = "%s/%s"%(rundir,restart_output_file)
			world.run2dir = rundir
		os.chdir(world.base_dir)
#}}}

@step('I compute the RMS of "([^"]*)"')#{{{
def compute_rms(step, variable):
	if ( world.run == True ):
		if world.num_runs == 2:
			f1 = NetCDFFile("%s"%(world.run1),'r')
			f2 = NetCDFFile("%s"%(world.run2),'r')
			if len(f1.dimensions['Time']) == 1:
				timeindex = 0
			else:
				timeindex = -1
			if len(f1.variables["%s"%variable].shape) == 3:
				field1 = f1.variables["%s"%variable][timeindex,:,:]
				field2 = f2.variables["%s"%variable][timeindex,:,:]
			elif len(f1.variables["%s"%variable].shape) == 2:
				field1 = f1.variables["%s"%variable][timeindex,:]
				field2 = f2.variables["%s"%variable][timeindex,:]
			else:
				assert False, "Unexpected number of dimensions in output file."

			field1 = field1 - field2
			field1 = field1 * field1
			rms = sum(field1)
			rms = rms / sum(field1.shape[:])
			rms = math.sqrt(rms)
			world.rms_values[variable].append(rms)
			f1.close()
			f2.close()
			os.chdir(world.base_dir)
		else:
			print 'Less than two runs. Skipping RMS computation.'
#}}}

@step('I see "([^"]*)" RMS of 0')#{{{
def check_rms_values(step, variable):
	if ( world.run ):
		if world.num_runs == 2:
			assert world.rms_values[variable][0] == 0.0, '%s RMS failed with value %s'%(variable, world.rms_values[variable][0])
		else:
			print 'Less than two runs. Skipping RMS check.'
#}}}

@step('I see "([^"]*)" RMS smaller than "([^"]*)"')#{{{
def check_rms_min_value(step, variable, threshold):
	if ( world.run ):
		if world.num_runs == 2:
			print 'RMS =',world.rms_values[variable][0], '\n'
			assert world.rms_values[variable][0] < float(threshold), '%s RMS failed with value %s, which is larger than threshold of %s'%(variable, world.rms_values[variable][0], threshold)
		else:
			print 'Less than two runs. Skipping RMS check.'
#}}}

@step('I clean the test directory')#{{{
def clean_test(step):
	if ( world.run ):
		command = "rm"
		arg1 = "-rf"
		arg2 = "%s/trusted_tests/%s"%(world.base_dir,world.test)
		subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)
		command = "rm"
		arg1 = "-rf"
		arg2 = "%s/testing_tests/%s"%(world.base_dir,world.test)
		subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)
#}}}

@step('I set "([^"]*)" namelist group "([^"]*)", option "([^"]*)" to "([^"]*)"')#{{{
def modify_namelist(step, testtype, groupOwningOption, optionToChange, valueToSet):

	nl_file = "%s/%s_tests/%s/%s"%(world.base_dir, testtype, world.test, world.namelist)
	namelist = read_namelist_file(nl_file)
	try:
		namelist.groups[groupOwningOption][optionToChange] = str(valueToSet)  # The 'str' here is to convert from unicode to string format
	except:  # If the group doesn't already exist, we'd get an error.
		namelist.groups[groupOwningOption] = OrderedDict()
		namelist.groups[groupOwningOption][optionToChange] = str(valueToSet)  # The 'str' here is to convert from unicode to string format

	with open(nl_file, 'w') as f:
		f.write(namelist.dump())
#}}}

@step('I remove all streams from the "([^"]*)" stream file')#{{{
def flush_streams(step, testtype):
	st_file = "%s/%s_tests/%s/%s"%(world.base_dir, testtype, world.test, world.streams)

	tree = ET.parse(st_file)
	root = tree.getroot()

	for stream in root.findall('stream'):
		root.remove(stream)

	tree.write(st_file)

	del tree
	del root
#}}}

@step('I create a "([^"]*)" stream named "([^"]*)" in the "([^"]*)" stream file')#{{{
def create_stream(step, streamtype, streamname, testtype):
	st_file = "%s/%s_tests/%s/%s"%(world.base_dir, testtype, world.test, world.streams)

	tree = ET.parse(st_file)
	root = tree.getroot()

	for stream in root.findall('stream'):
		if stream.get('name') == streamname:
			print " ERROR: Stream %s already exists. Returning...\n"%(streamname)
			return

	stream = ET.SubElement(root, 'stream')
	stream.set('name', streamname)
	stream.set('type', streamtype)
	stream.set('filename_template', 'none')
	stream.set('filename_interval', 'none')
	stream.set('output_interval', 'none')
	stream.set('input_interval', 'none')

	tree.write(st_file)
#}}}

@step('I set "([^"]*)" to "([^"]*)" in the stream named "([^"]*)" in the "([^"]*)" stream file')#{{{
def modify_stream_attribute(step, option, value, streamname, testtype):
	st_file = "%s/%s_tests/%s/%s"%(world.base_dir, testtype, world.test, world.streams)

	tree = ET.parse(st_file)
	root = tree.getroot()

	for stream in root.findall('stream'):
		if stream.get('name') == streamname:
			stream.set(option, value)
			tree.write(st_file)
			return
#}}}

@step('I set "([^"]*)" to "([^"]*)" in the immutable_stream named "([^"]*)" in the "([^"]*)" stream file')#{{{
def modify_stream_attribute(step, option, value, streamname, testtype):
	st_file = "%s/%s_tests/%s/%s"%(world.base_dir, testtype, world.test, world.streams)

	tree = ET.parse(st_file)
	root = tree.getroot()

	for stream in root.findall('immutable_stream'):
		if stream.get('name') == streamname:
			stream.set(option, value)
			tree.write(st_file)
			return
#}}}

@step('I add a "([^"]*)" named "([^"]*)" to the stream named "([^"]*)" in the "([^"]*)" stream file')#{{{
def add_stream_member(step, elementtype, elementname, streamname, testtype):
	st_file = "%s/%s_tests/%s/%s"%(world.base_dir, testtype, world.test, world.streams)

	tree = ET.parse(st_file)
	root = tree.getroot()

	for stream in root.findall('stream'):
		if stream.get('name') == streamname:
			member = ET.SubElement(stream, elementtype)
			member.set('name', elementname)
			tree.write(st_file)
			return
#}}}
