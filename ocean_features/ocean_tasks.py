import sys, os, glob, shutil, numpy, math, stat
import subprocess

from netCDF4 import *
from netCDF4 import Dataset as NetCDFFile
from pylab import *

from lettuce import *

from collections import defaultdict
import xml.etree.ElementTree as ET

@step('A "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" test as "([^"]*)"')#{{{
def get_test_case(step, size, levs, test, testtype, run_name):
	world.test = "%s_%s_%s"%(test, size, levs)
	world.num_runs = 0
	world.namelist = "namelist.ocean_forward"
	world.streams = "streams.ocean_forward"

	if not os.path.exists("%s/tests/%s_inputs"%(world.base_dir, testtype)):
		os.makedirs("%s/tests/%s_inputs"%(world.base_dir, testtype))

 	os.chdir("%s/tests/%s_inputs"%(world.base_dir, testtype))

	if world.clone:
		if not os.path.exists("%s/tests/%s_inputs/%s.tgz"%(world.base_dir, testtype, world.test)):
			command = "wget"
			arg1 = "%s/%s.tgz"%(world.trusted_url, world.test)
			subprocess.call([command, arg1], stdout=world.dev_null, stderr=world.dev_null)

	if os.path.exists("%s/%s"%(world.scenario_path, run_name)):
		subprocess.check_call(['rm', '-rf', "%s/%s"%(world.scenario_path, run_name)], stdout=world.dev_null, stderr=world.dev_null)

	os.chdir("%s"%(world.scenario_path))

	subprocess.check_call(['tar', 'xzf', '%s/tests/%s_inputs/%s.tgz'%(world.base_dir, testtype, world.test)], stdout=world.dev_null, stderr=world.dev_null)
	subprocess.check_call(['mv', '%s'%(world.test), '%s'%(run_name)], stdout=world.dev_null, stderr=world.dev_null)

	os.chdir("%s/%s"%(world.scenario_path, run_name))
	subprocess.check_call(['cp', '%s'%(world.namelist), '%s.default'%(world.namelist)], stdout=world.dev_null, stderr=world.dev_null)
	subprocess.check_call(['cp', '%s'%(world.streams), '%s.default'%(world.streams)], stdout=world.dev_null, stderr=world.dev_null)
	os.chdir("%s/%s"%(world.scenario_path, run_name))
	executable = stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH
	for filename in os.listdir('%s/%s'%(world.builds_path, testtype)):
		full_filename = "%s/%s/%s"%(world.builds_path, testtype, filename)
		if os.path.isfile(full_filename):
			st = os.stat(full_filename)
			mode = st.st_mode
			if mode & executable:
				command = "ln"
				arg1 = "-s"
				arg2 = "%s/%s/%s"%(world.builds_path, testtype, filename)
				arg3 = "ocean_model_%s"%(testtype)
				subprocess.call([command, arg1, arg2, arg3], stdout=world.dev_null, stderr=world.dev_null)

	os.chdir(world.base_dir)

#}}}

@step('I configure the "([^"]*)" run to have integrator "([^"]*)", dt "([^"]*)", run_duration "([^"]*)"')#{{{
def setup_namelist(step, run_name, integrator, dt, run_duration):
	os.chdir("%s/%s"%(world.scenario_path, run_name))

	# Find namelist filename
	for filename in os.listdir('%s/%s'%(world.scenario_path, run_name)):
		if os.path.isfile(filename):
			if filename.find('namelist') >= 0 and filename.find('default') < 0:
				world.namelist = filename
			elif filename.find('streams') >= 0 and filename.find('default') < 0:
				world.streams = filename
	
	nl_file = "%s/%s/%s"%(world.scenario_path, run_name, world.namelist)
	world.ingest_namelist(nl_file)

	world.set_namelist_option('time_management', 'config_run_duration', run_duration)
	world.set_namelist_option('time_integration', 'config_time_integrator', integrator)
	world.set_namelist_option('time_integration', 'config_dt', dt)

	world.write_namelist(nl_file)
	world.clear_namelist()

	world.flush_streams(step, run_name)
	world.create_stream(step, 'output', 'output', run_name)
	world.modify_stream_attribute(step, 'filename_template', 'output.nc', 'output', run_name)
	world.modify_stream_attribute(step, 'output_interval', dt.strip("'"), 'output', run_name)
	world.modify_stream_attribute(step, 'clobber_mode', 'truncate', 'output', run_name)

	world.add_stream_member(step, 'var_array', 'tracers', 'output', run_name)
	world.add_stream_member(step, 'var', 'layerThickness', 'output', run_name)
	world.add_stream_member(step, 'var', 'normalVelocity', 'output', run_name)
	world.add_stream_member(step, 'var', 'xtime', 'output', run_name)

	world.modify_immutable_stream_attribute(step, 'output_interval', dt.strip("'"), 'restart', run_name)
#}}}

