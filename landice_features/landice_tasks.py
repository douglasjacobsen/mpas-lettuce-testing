import sys, os, glob, shutil, numpy, math
import subprocess
from netCDF4 import Dataset as NetCDFFile
from lettuce import *


# ==============================================================================
@step('A "([^"]*)" test for "([^"]*)"')
def get_test_case(step, test, testtype):

	world.test = "%s"%(test)
	world.num_runs = 0
	world.namelist = "namelist.landice"
	world.streams = "streams.landice"

	# -- Figure out test case archive name
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

	# -- make trusted/testing_tests directory it it doesn't already exist and cd to it.
	testpath = world.base_dir + '/' + testtype + '_tests'
	try:
		os.makedirs(testpath)
	except OSError:
		if not os.path.isdir(testpath):  # if the directory already exists, don't raise an error
			raise
	os.chdir(testpath)

	# -- get test tarball if we don't already have it
	if world.clone == True:
		if not os.path.exists(testpath + '/' + tc_filename):
			#print "Getting test case file.\n"
			try:
				print testpath + '/' + tc_filename +"\n"
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

	# -- Delete test dir if it already exists.  Then untar it
	thistestpath = world.base_dir + '/' + testtype + '_tests/' + world.test
	if os.path.exists(thistestpath):
		shutil.rmtree(thistestpath)
	try:
		subprocess.check_call(["tar", "xzf", tc_filename], stdout=world.dev_null, stderr=world.dev_null)
	except:
		print "Error: unable to untar the archive file\n"
		raise
	#		try:
	#			command = "cp"
	#			arg1 = "%s/namelist.input"%world.test
	#			arg2 = "%s/namelist.input.default"%world.test
	#			subprocess.check_call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)
	#		except:
	#			print "Error: unable to backup namelist\n"
	#			raise

	# go into the test directory
	os.chdir(world.base_dir + "/" + testtype + "_tests/" + world.test)

	# link executable
	os.symlink(world.base_dir+'/' + testtype + '/landice_model', 'landice_model_'+testtype)

	#	# copy default namelist to standard namelist
	#	command = "cp"
	#	arg1 = "namelist.input.default"
	#	arg2 = "namelist.input"
	#	subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)

	# remove any output files
	command = "rm"
	arg1 = "-f"
	arg2 = '\*.output.nc'
	subprocess.call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)

	os.chdir(world.base_dir)


# ==============================================================================
@step('I compute the Halfar RMS')
def compute_rms(step):
	world.halfarRMS=float(subprocess.check_output('python ' + world.run1dir + '/halfar.py -f ' + world.run1 + ' -n | grep "^* RMS error =" | cut -d "=" -f 2 \n', shell='/bin/bash'))
	world.message = "      -- Halfar RMS (m) = " + str(world.halfarRMS) + " --"


# ==============================================================================
@step('I see Halfar thickness RMS of <10m')
def check_rms_values(step):
	if world.halfarRMS == []:
		assert False, 'Calculation of Halfar RMS failed.'
	else:
		assert world.halfarRMS < 10.0, 'Halfar RMS of %s is greater than 10.0 m'%world.halfarRMS


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



