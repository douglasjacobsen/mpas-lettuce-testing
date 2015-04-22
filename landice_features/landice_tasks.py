import sys, os, glob, shutil, numpy, math
import subprocess
from netCDF4 import Dataset as NetCDFFile
from lettuce import *


# ==============================================================================
@step('A "([^"]*)" test for "([^"]*)" model version as run name "([^"]*)"')
def get_test_case(step, test, testtype, run_name):

	world.test = "%s"%(test)
	world.num_runs = 0
	world.namelist = "namelist.landice"
	world.streams = "streams.landice"

	# -- Set up storage area for test case tarballs
	if not os.path.exists("%s/tests/%s_inputs"%(world.base_dir, testtype)):
		os.makedirs("%s/tests/%s_inputs"%(world.base_dir, testtype))
	os.chdir("%s/tests/%s_inputs"%(world.base_dir, testtype))

	# -- Figure out test case archive name (tc_filename)
	if testtype == 'trusted':
		test_url = world.trusted_url
	elif testtype == 'testing':
		test_url = world.testing_url
	tc_version_info = test_url.split('release_')  # try to get the part of this string after the bit that says 'release_', i.e., the version number
	if len(tc_version_info) == 2:
		tc_filename = world.test + '-' + tc_version_info[1] + '.tar.gz'
	elif len(tc_version_info) == 1:
		tc_filename = world.test + '.tar.gz'
	else:
		print 'Error: Unable to determine test case filename!'
		assert testcase_filename_error

	# -- get test tarball if we don't already have it and stash it in the storage area
	# Only do this is we have network access (world.clone=True)
	if world.clone == True:
		if not os.path.exists(tc_filename):
			#print "Getting test case file.\n"
			try:
				subprocess.check_call(["wget", "--trust-server-names", test_url + "/" + tc_filename], stdout=world.dev_null, stderr=world.dev_null)
				# "--trust-server-names"  if the server redirects to an error page, this prevents that page from being named the test archive name - which is confusing!
			except:
				print "Error: unable to get test case archive: " + test_url + "/" + tc_filename + "\n"
				raise
		else:
			#print "Already have test case file.\n"
			pass
	else:
		print "       Skipping retrieval of test case archive for " + testtype + " test because 'clone=off' in lettuce.landice.\n"

	# -- Delete the run directory if already exists so we have a fresh run & cd into it
	run_directory_path = "%s/%s"%(world.scenario_path, run_name)
	if os.path.exists(run_directory_path):
		shutil.rmtree(run_directory_path)
	os.chdir("%s"%(world.scenario_path))

	# -- untar tarball into test directory
	try:
		subprocess.check_call(["tar", "xzf", '%s/tests/%s_inputs/%s'%(world.base_dir, testtype, tc_filename)], stdout=world.dev_null, stderr=world.dev_null)
		os.rename(world.test, run_name) # rename the untarred testcase directory to the specified run_name
	except:
		print "Error: unable to untar the archive file\n"
		raise

	# -- go into the test directory
	os.chdir(world.scenario_path + "/" + run_name)

	# -- link executable
	os.symlink(world.base_dir+'/builds/' + testtype + '/landice_model', 'landice_model_'+testtype)

	# (could also backup namelist and streams files but I don't think that's needed)

	os.chdir(world.base_dir)


# ==============================================================================
@step('I compute the Halfar RMS')
def compute_rms(step):
	world.halfarRMS=float(subprocess.check_output('python ' + world.run1dir + '/halfar.py -f ' + world.run1 + ' -n | grep "^* RMS error =" | cut -d "=" -f 2 \n', shell='/bin/bash'))
	world.message = "      -- Halfar RMS (m) = " + str(world.halfarRMS) + " --"


# ==============================================================================
@step('I see Halfar thickness RMS of <"([^"]*)"m')
def check_rms_values(step, eps):
	if world.halfarRMS == []:
		assert False, 'Calculation of Halfar RMS failed.'
	else:
		assert world.halfarRMS < eps, 'Halfar RMS of %s is greater than %s m'%(world.halfarRMS,eps)


# ==============================================================================
@step(u'Then I see a "([^"]*)" maximum speed near "([^"]*)" m/yr')
def then_i_see_a_maximum_speed_near_m_yr(step, testcase, expectedspeed):
	import netCDF4
	f = netCDF4.Dataset(world.run1)
	# Get surface speed at time 0
	uvel = f.variables['uReconstructX'][0,:,0]
	vvel = f.variables['uReconstructY'][0,:,0]
	speed = (uvel**2 + vvel**2)**0.5
	maxspeed = speed.max() * 365.0 * 24.0 * 3600.0
	print 'Maximum modeled speed is:', maxspeed, ' m/yr \n'
	assert abs(maxspeed - float(expectedspeed)) < 50.0, 'Maximum ice shelf speed of %s is different from expected speed of %s m/yr by more than 50 m/yr'%(maxspeed,expectedspeed)


# ==============================================================================
@step(u'EISMINT2 experiment "([^"]*)"')
def given_eismint2_experiment_group1(step, experiment):
	# Redefine the run directory to be the subdirectory where this experiment lives
	world.test = world.test + '/experiment_' + experiment
	# Setup the initial conditions for this test


# ==============================================================================
@step(u'I see a MPAS results within range of EISMINT2 experiment "([^"]*)" benchmarks.')
def then_i_see_a_mpas_results_within_range_of_eismint2_experiment_group1_benchmarks(step, experiment):
    assert False, 'This step must be implemented'




