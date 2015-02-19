import sys, os, glob, shutil, numpy, math
import subprocess

from netCDF4 import *
from netCDF4 import Dataset as NetCDFFile
from pylab import *

from lettuce import *

from collections import defaultdict
import xml.etree.ElementTree as ET


@step('A "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" test')#{{{
def get_test_case(step, size, levs, test, time_stepper):
	for testtype in ('trusted', 'testing'):
		world.base_dir = os.getcwd()
		world.test = "%s_%s_%s"%(test, size, levs)
		world.num_runs = 0
		world.namelist = "namelist.ocean_forward"
		world.streams = "streams.ocean_forward"

		#Setup trusted...
		if not os.path.exists("%s/%s_tests"%(world.base_dir, testtype)):
			command = "mkdir"
			arg1 = "-p"
			arg2 = "%s/%s_tests"%(world.base_dir, testtype)
			subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)

		os.chdir("%s/%s_tests"%(world.base_dir, testtype))

		if world.clone:
			if not os.path.exists("%s/%s_tests/%s.tgz"%(world.base_dir, testtype, world.test)):
				command = "wget"
				arg1 = "%s/%s.tgz"%(world.trusted_url, world.test)
				subprocess.call([command, arg1], stdout=world.dev_null, stderr=world.dev_null)

		if not os.path.exists("%s/%s_tests/%s"%(world.base_dir, testtype, world.test)):
			command = "tar"
			arg1 = "xzf"
			arg2 = "%s.tgz"%world.test
			subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)
			command = "cp"
			arg1 = "%s/namelist.ocean_forward"%world.test
			arg2 = "%s/namelist.ocean_forward.default"%world.test
			subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)
			command = "cp"
			arg1 = "%s/streams.ocean_forward.xml"%world.test
			arg2 = "%s/streams.ocean_forward.default.xml"%world.test
			subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)

		os.chdir("%s/%s_tests/%s"%(world.base_dir, testtype, world.test))
		for exetype in ('trusted', 'testing'):
			command = "ln"
			arg1 = "-s"
			arg2 = "%s/%s/ocean_forward_model"%(world.base_dir, exetype)
			arg3 = "ocean_model_%s"%(exetype)
			subprocess.call([command, arg1, arg2, arg3], stdout=world.dev_null, stderr=world.dev_null)

		command = "cp"
		arg1 = "namelist.ocean_forward.default"
		arg2 = "namelist.ocean_forward"
		subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)

		command = "cp"
		arg1 = "streams.ocean_forward.default"
		arg2 = "streams.ocean_forward"
		subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)

		command = "rm"
		arg1 = "-f"
		arg2 = '\*.output.nc'
		subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)

		# {{{ Setup namelist file
		namelistfile = open(world.namelist, 'r+')
		lines = namelistfile.readlines()

		for line in lines:
				if line.find("config_dt") >= 0:
						line_split = line.split(" = ")
						world.dt = line_split[1]
						world.dt_sec = world.timestamp_to_seconds(line_split[1])
				if line.find("config_time_integrator") >= 0:
						line_split = line.split(" = ")
						world.old_time_stepper = line_split[1].replace("'","")

		world.time_stepper_change = False
		if world.old_time_stepper.find(time_stepper) < 0:
				world.time_stepper_change = True
				if world.old_time_stepper.find("split_explicit") >= 0:
						world.dt_sec /= 10.0
				elif time_stepper.find("split_explicit") >= 0:
						world.dt_sec *= 10.0

		duration = world.seconds_to_timestamp(int(world.dt_sec*2))

		namelistfile.seek(0)
		namelistfile.truncate()

		for line in lines:
				new_line = line
				if line.find("config_run_duration") >= 0:
						new_line = "	config_run_duration = '%s'\n"%(duration)
				elif line.find("config_output_interval") >= 0:
						new_line = "	config_output_interval = '0000_00:00:01'\n"
				elif line.find("config_restart_interval") >= 0:
						new_line = "	config_restart_interval = '1000_00:00:01'\n"
				elif line.find("config_stats_interval") >= 0:
						new_line = "	config_stats_interval = '1000_00:00:01'\n"
				elif line.find("config_dt") >= 0:
						new_line = "	config_dt = '%s'\n"%(world.seconds_to_timestamp(world.dt_sec))
				elif line.find("config_frames_per_outfile") >= 0:
						new_line = "	config_frames_per_outfile = 0\n"
				elif line.find("config_write_output_on_startup") >= 0:
						new_line = "	config_write_output_on_startup = .true.\n"
				elif world.time_stepper_change:
						if line.find("config_time_integrator") >= 0:
								new_line = "	config_time_integrator = '%s'\n"%(time_stepper)

				namelistfile.write(new_line)

		namelistfile.close()

		del lines
		#}}}

		#{{{ Setup streams file
		tree = ET.parse(world.streams)
		root = tree.getroot()

		# Remove all streams (leave the immutable streams)
		for stream in root.findall('stream'):
				root.remove(stream)

		# Create an output stream
		output = ET.SubElement(root, 'stream')
		output.set('name', 'output')
		output.set('type', 'output')
		output.set('filename_template', 'output.nc')
		output.set('filename_interval', 'none')
		output.set('output_interval', '01')

		# Add tracers to output stream
		member = ET.SubElement(output, 'var_array')
		member.set('name', 'tracers')

		# Add layerThickness to output stream
		member = ET.SubElement(output, 'var')
		member.set('name', 'layerThickness')

		# Add normalVelocity to output stream
		member = ET.SubElement(output, 'var')
		member.set('name', 'normalVelocity')

		tree.write(world.streams)

		del tree
		del root
		del output
		del member
		#}}}

		os.chdir(world.base_dir)
#}}}

