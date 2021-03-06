from lettuce import *
import subprocess
import ConfigParser
import os
import mpas_tasks

@before.all#{{{
def check_environment():
	if not os.environ.has_key("NETCDF"):
		print "Error: The NETCDF environment variable must be defined to use MPAS"
		exit()

	if not os.environ.has_key("PNETCDF"):
		print "Error: The PNETCDF environment variable must be defined to use MPAS"
		exit()

	if not os.environ.has_key("PIO"):
		print "Error: The PIO environment variable must be defined to use MPAS"
		exit()

	world.dev_null = open(os.devnull, "w")
	#world.dev_null = None # Turns on printing of messages from subprocess
	world.feature_count = 0
	world.namelist_ingested = False
#}}}

@before.each_feature#{{{
def setup_config(feature):
	world.base_dir = os.getcwd()

	# Setup feature directory
	world.feature_path = "%s/tests/%s"%(world.base_dir, feature.name.replace(" ", "_"))
	if not os.path.exists("%s"%(world.feature_path)):
		os.makedirs("%s"%(world.feature_path))

	# Setup builds directory
	world.builds_path = "%s/builds"%(world.base_dir)
	if not os.path.exists("%s"%(world.builds_path)):
		os.makedirs("%s"%(world.builds_path))

	world.feature_count += 1
	if world.feature_count == 1:  # the clone/checkout/build actions should only happen before the first feature

		calling_file = feature.described_at.file # get the path to the feature that called this step
		if 'ocean_' in calling_file:
			print "Using ocean core..."
			world.configfile = 'lettuce.ocean'
		elif 'landice_' in calling_file:
			print "Using landice core..."
			world.configfile = 'lettuce.landice'
		else:
			print "Error: Unknown MPAS core was requested."
			exit()

		if not os.path.exists("%s/%s"%(os.getcwd(), world.configfile)):
			print "Please copy %s into the current directory %s"%(world.configfile, os.getcwd())
			print " and configure appropriately for your tests."
			print ""
			exit()

		world.configParser = ConfigParser.SafeConfigParser()
		world.configParser.read(world.configfile)

		if world.configParser.has_option("lettuce_actions", "clone"):
		  world.clone = world.configParser.getboolean("lettuce_actions", "clone")
		else:
		  world.clone = False

		if world.configParser.has_option("lettuce_actions", "build"):
		  world.build = world.configParser.getboolean("lettuce_actions", "build")
		else:
		  world.build = False

		if world.configParser.has_option("lettuce_actions", "run"):
		  world.run = world.configParser.getboolean("lettuce_actions", "run")
		else:
		  world.run = False

		if world.clone == True:
		  print 'Lettuce will clone MPAS if needed.'
		else:
		  print 'Lettuce will NOT attempt to clone MPAS.'

		if world.build == True:
		  print 'Lettuce will build MPAS if needed.'
		else:
		  print 'Lettuce will NOT attempt to build MPAS.'

		if world.run == True:
		  print 'Lettuce will run MPAS.'
		else:
		  print 'Lettuce will NOT attempt to run MPAS.'

		world.compiler = world.configParser.get("building", "compiler")
		world.core = world.configParser.get("building", "core")
		if world.configParser.has_option("building", "flags"):
			world.build_flags = world.configParser.get("building", "flags")
		else:
			world.build_flags = ""

		world.testing_url = world.configParser.get("testing_repo", "test_cases_url")
		world.trusted_url = world.configParser.get("trusted_repo", "test_cases_url")

		if ( world.core == "ocean" ):
			world.executable = "ocean_forward_model"
		elif ( world.core == "landice" ):
			world.executable = "landice_model"

		print ' '

		# Clone the namelist generation script repo
		if world.clone:
			if not os.path.exists("%s/nml_gen/generate_namelist.py"%(world.builds_path)):
				os.chdir("%s"%(world.builds_path))
				NML_GEN_URL='git@github.com:douglasjacobsen/mpas-namelist-generator'
				subprocess.check_call(['git', 'clone', NML_GEN_URL, 'nml_gen'], stdout=world.dev_null, stderr=world.dev_null)  # this version checks out a detached head
			else:
				os.chdir("%s/nml_gen"%(world.builds_path))
				try:
					subprocess.check_call(['git', 'pull', '--ff-only', 'origin', 'master'], stdout=world.dev_null, stderr=world.dev_null)
				except:
					print "\n\nError updating namelist generation. Please do it manually...\n\n"
					quit(1)

		world.namelist_generator = "%s/nml_gen/generate_namelist.py"%(world.builds_path)

		# Setup both "trusted" and "testing" code directories.  This loop ensures they are setup identically.
		for testtype in ('trusted', 'testing'):
			need_to_build = False

			if ( world.clone == True ):
				print '----------------------------'

				# Clone repo
				# MH: Below I've switched to checkout a detached head rather than making a local branch.
				# Making a local branch failed if the branch name already existed (i.e., with 'master' which is automatically created during the clone)

				try:
					os.chdir("%s/%s"%(world.builds_path, testtype))
					HEAD_hash = subprocess.check_output(['git', 'rev-parse', 'HEAD'], stderr=world.dev_null).strip()
					need_to_clone = False # if the dir exists AND we got a hash, then this directory is a git repo
				except:
					need_to_clone = True  # if we fail to enter the dir or fail to get a hash then call this directory bad

				os.chdir(world.builds_path) # return to builds_path in case not already there

				if need_to_clone:
					need_to_build = True # set this for later - we definitely need to build if we don't even have a clone...
					# delete dir if it exists
					if os.path.exists("%s/%s"%(world.builds_path, testtype)):
						shutil.rmtree("%s/%s"%(world.builds_path, testtype))

					# Clone repo specified
					print "Cloning " + testtype + " repository."
					command = "git"
					arg1 = "clone"
					arg2 = "%s"%world.configParser.get(testtype+"_repo", "url")
					arg3 = testtype
					subprocess.check_call([command, arg1, arg2, arg3], stdout=world.dev_null, stderr=world.dev_null)
					os.chdir("%s/%s"%(world.builds_path, testtype))
					print "Checking out " + testtype + " branch."
					command = "git"
					arg1 = "checkout"
					arg2 = "origin/%s"%world.configParser.get(testtype+"_repo", "branch")
					try:
						subprocess.check_call([command, arg1, arg2], stdout=world.dev_null, stderr=world.dev_null)  # this version checks out a detached head
					except:
						# Try checking out a hash, if that's what they specified
						subprocess.check_call([command, arg1, world.configParser.get(testtype+"_repo", "branch")], stdout=world.dev_null, stderr=world.dev_null)

					os.chdir(world.builds_path) # return to builds_path in case not already there

				# ---- Didn't need to make a new clone -----
				else:  # We don't need to clone, but that doesn't mean the branch or the executable are up to date
					os.chdir("%s/%s"%(world.builds_path, testtype))
					# make a temporary remote to get the most current version of the specified repo
					remotes = subprocess.check_output(['git', 'remote'], stderr=world.dev_null).strip()
					#print "Remotes are: "+remotes
					if 'statuscheck' in remotes:
						# need to delete this remote first
						subprocess.check_call(['git', 'remote', 'rm', 'statuscheck'], stdout=world.dev_null, stderr=world.dev_null)

					subprocess.check_call(['git', 'remote', 'add', 'statuscheck', "%s"%world.configParser.get(testtype+"_repo", "url")], stdout=world.dev_null, stderr=world.dev_null)
					subprocess.check_call(['git', 'fetch', 'statuscheck'], stdout=world.dev_null, stderr=world.dev_null)
					# get the hash of the specified branch
					try:
						requested_hash = subprocess.check_output(['git', 'rev-parse', "statuscheck/%s"%world.configParser.get(testtype+"_repo", "branch")], stderr=world.dev_null).strip()
					except:
						# perhaps they just specified a hash instead of branch name, in which case don't include the remote - but still use rev-parse to get the FULL hash
						requested_hash = subprocess.check_output(['git', 'rev-parse', "%s"%world.configParser.get(testtype+"_repo", "branch")], stderr=world.dev_null).strip()

					if requested_hash == HEAD_hash:
						print 'Current ' + testtype + ' clone and branch are up to date.'
						need_to_build = False
						# Now remove the remote
						remotes = subprocess.check_output(['git', 'remote'], stderr=world.dev_null)
						if 'statuscheck' in remotes:
							subprocess.check_call(['git', 'remote', 'rm', 'statuscheck'], stdout=world.dev_null, stderr=world.dev_null)

					else:
						print 'Updating ' + testtype + ' HEAD to specified repository and branch.'
						need_to_build = True
						# Checkout the specified branch (as detached head) because it either is a different URL/branch or is newer (or older) than the current detached head
						try:
							subprocess.check_call(['git', 'reset', '--hard', 'HEAD'], stdout=world.dev_null, stderr=world.dev_null)
							subprocess.check_call(['git', 'checkout', requested_hash], stdout=world.dev_null, stderr=world.dev_null)
						except:
							#try:
							#	subprocess.check_call(['git', 'checkout', "statuscheck/"+world.configParser.get(testtype+"_repo", "branch")], stdout=world.dev_null, stderr=world.dev_null)
							#except:
							exit("Lettuce encountered an error in trying to git checkout: " + requested_hash)

						remotes = subprocess.check_output(['git', 'remote'], stderr=world.dev_null)
						if 'origin' in remotes:
							subprocess.check_call(['git', 'remote', 'rm', 'origin'], stdout=world.dev_null, stderr=world.dev_null)

						if 'statuscheck' in remotes:
							subprocess.check_call(['git', 'remote', 'rename', 'statuscheck', 'origin'], stdout=world.dev_null, stderr=world.dev_null)

						# Clean the build of the core we're trying to build
						print "   -- Running make clean CORE=%s"%world.configParser.get("building", "core")
						subprocess.check_call(['make', 'clean', "CORE=%s"%world.configParser.get("building", "core")], stdout=world.dev_null, stderr=world.dev_null)

						os.chdir(world.builds_path) # return to builds_path in case not already there

				if ( world.build == True ):
					# Build executable
					if need_to_build or not os.path.exists("%s/%s/%s"%(world.builds_path, testtype, world.executable)):
						print "Building " + testtype + " executable."
						os.chdir("%s/%s"%(world.builds_path, testtype))
						args = ["make",]
						args.append("%s"%world.compiler)
						args.append("CORE=%s"%world.core)
						# Add any optional build flags specified, but don't add empty strings cause subprocess doesn't like them.
						for argstring in [x for x in world.build_flags.split(" ") if x]:  # this list comprehension ignores empty strings because the emptry string is 'falsy' in python.
							args.append(argstring)

						subprocess.check_call(args, stdout=world.dev_null, stderr=world.dev_null)
						if testtype == 'trusted':
							world.trusted_executable = "%s/%s"%(os.getcwd(), world.executable)
						elif testtype == 'testing':
							world.testing_executable = "%s/%s"%(os.getcwd(), world.executable)

						os.chdir("%s"%(world.builds_path))

		print '----------------------------'
#}}}

@before.each_step#{{{
def setup_step(step):
	# Change directory to base_dir
	os.chdir(world.base_dir)
#}}}

@before.each_scenario#{{{
def setup_scenario(scenario):
	world.scenario_path = "%s/%s"%(world.feature_path, scenario.name.replace(" ", "_"))
	
	if not os.path.exists("%s"%(world.scenario_path)):
		os.makedirs("%s"%(world.scenario_path))
	else:
		subprocess.check_call(['rm', '-rf', "%s"%(world.scenario_path)], stdout=world.dev_null, stderr=world.dev_null)
		os.makedirs("%s"%(world.scenario_path))

	world.num_runs = 0
#}}}

@after.each_scenario#{{{
def teardown_some_scenario(scenario):
	  # print any messages that got loaded
	  try:
		print world.message
		del world.message
	  except:
		pass

	  # reset to world.base_dir so the next scenario can work
	  # in case we erred and were left stranded elsewhere
	  try:
		os.chdir(world.base_dir)
	  except:
		pass  # In some cases, if lettuce didn't get very far, world.base_dir is not defined yet.
#}}}

