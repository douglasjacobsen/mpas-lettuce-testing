====================================================
====================================================
#   Using Lettuce for automated testing of MPAS
====================================================
====================================================

Lettuce is a python module for implementing automated testing.
<http://lettuce.it/tutorial/simple.html>
From the intro:
"Lettuce is an extremely useful and charming tool for BDD (Behavior Driven Development). 
It can execute plain-text functional descriptions as automated tests for Python projects, 
just as Cucumber does for Ruby.  Lettuce makes the development and testing process really 
easy, scalable, readable and - what is best - it allows someone who doesn't program to 
describe the behavior of a certain system, without imagining *how* those descriptions 
will automatically test the system during its development."

It is based on the BDD (Behavior Driven Development) paradigm, and we have tried 
to follow that to some extent.  (This is the reason for the somewhat unusual 
language you see when the tests run.)
<http://en.wikipedia.org/wiki/Behavior-driven_development>

If you just want to setup lettuce and test MPAS, read on.  If you are interested
in setting up new test cases, modifying existing ones, or interested in how
lettuce works, visit the lettuce website for more details. A brief summary is:
"Since Lettuce is used to test the behavior of a project, the behavior is broken up in to 
features of the system. After enumerating features, you need to create scenarios which 
will describe those feature. Thus, scenarios are components of a feature."
(from <http://lettuce.it/intro/wtf.html>)
Features and scenarios are written in what looks like plain English but is actually
a simple language that is interpreted by lettuce into commands to test the system.

Doug Jacobsen and Matt Hoffman have been setting up lettuce to 
work with MPAS.  We went through a couple of incarnations before settling on the
current organizational structure.  It follows MPAS itself where there is 
'framework' functionality that is independent of the core being tested, and then 
there is core-specific code to define the tests for each core and how to run 
and evaluate them.

===================
## Getting MPAS lettuce test suite
===================

The MPAS lettuce test suite is currently located here:
https://github.com/douglasjacobsen/mpas-lettuce-testing

Eventually we may move the lettuce repo into the MPAS Organization.

To get the testing code :
> git clone git@github.com:douglasjacobsen/mpas-lettuce-testing.git


===================
## Getting the Lettuce python module
===================
The Lettuce module itself is not in any typical repositories (Macports, Ubuntu),
so you have to install it manually.  The easiest way is to install lettuce via 'pip', 
which is a package manager for python modules.

--Linux (Ubuntu)--
        Setup PIP (if not already installed):
                sudo apt-get install pip

        Setup the python netCDF4 module (if not already installed):
                sudo -E C_INCLUDE_PATH=/usr/include/mpi pip install netcdf4

        Setup Lettuce:
                sudo -E pip install lettuce


--Mac (Macports)--
Setup PIP (if not already installed):
  > sudo port install py-pip

Setup the python netCDF4 module (if not already installed):
  > sudo port install py-netcdf4

Setup lettuce:
  > sudo pip install lettuce

Steve commented about installing pip on a Mac:
1) installing pip from macports puts it in /opt/local/bin/pip-2.7. 
Unless you then call "pip-2.7", you won't find it. I went in that same 
dir and did a sym link so that generic "pip" points to "pip-2.7" (or whatever 
version macports installs)
2) there's the standard proxy issue when trying to use pip to install 
lettuce (e.g., connection times out while looking to download / install the code). I used:
    sudo pip install lettuce --proxy=http://proxyout.lanl.gov:8080
and that worked.
3) I also then had to put a sym link somewhere in my path to the executable, 
which was buried in /opt/local/. From /opt/local/bin/, this worked for me (because 
/opt/local/bin/ is in my path):
    sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/lettuce ./
Or, one could append that ugly long path in their .bashrc file.


The official Lettuce install page may have more info (but did not have much at 
the time of this writing):
http://lettuce.it/intro/install.html


===================
## Running Lettuce
===================

Layout:
        Within this repository, each core gets it's own directory, with it's own
        feature and task definitions. The task directory contains shared tasks 
        that all cores should be able to use.
        
        Task files from the root of the features directory should be symlinked 
        into each of the component directories.

To use:
        You can edit the lettuce.CORE script to point to two separate
        repositories and branches on each repository. Once the config file is 
        setup properly, lettuce can be run as in `lettuce features/CORE` test 
        all of the pre-defined features the chosen CORE should have.  
        Currently supported cores are 'ocean' and 'landice'.

        Both repositories and branches are cloned and build separately. Test 
        cases for each version are downloaded separately as well.

        Tests are run in separate directories for each version of the 
        repository, and compared (if required by a scenario in defined in the 
        features).

Assuming you have succesfully built MPAS in your environment, running Lettuce 
should be easy.

Go to the root directory your mpas-lettuce repository and run:
  > lettuce *CORE*_features

Lettuce will automatically clone a 'trusted' and 'testing' version of the MPAS
code, build it, and run it for a series of test scenarios.  Because the 
'features' and 'scenarios' are written in plain English, it should be fairly
easy to understand what is going on.

Note that the URL of the 'trusted' and 'testing' repositories, as well
as some other options, can be specified in the lettuce.CORE file.
A common use scenario would be to have trusted be set to MPAS-Dev/MPAS/*CORE*/develop.
Testing would be set to a branch you are working on.  Note that you can point to a local repository
instead of a remote one by giving the absolute file path on your system to the head
of the repo.  Also note that at present it is not possible to test uncommitted 
code in your working copy.  You can, however, give hashes instead of branch names.


===================
## Current known issues / Notes:
=================== 

### General

* To run just a specific feature, add it as an argument:
> lettuce landice_features/HO/ho-bit-restartability.feature

* To run just a specific scenario of a specific feature, add it as an argument with the -s:
> lettuce landice_features/HO/ho-bit-restartability.feature -s 2

* We need to sort out how to deal with the fact that filenames and config 
option names have changed between various versions of the MPAS code.  So currently,
lettuce may fail if you try to use it with old versions of the code.

* the trusted and testing repositories get cloned into the 'builds' directory,
so go there if you want to inspect the actual code lettuce is using.  Note that
these are full git clones, so you can do whatever you normally would in a git repo
(including commit, push, etc.).  Note that lettuce checks out your requested branch
in detached head state.

* The actual runs get performed in the 'tests' directory.  There is a subdirectory
for each feature, subdirectories within each feature for each scenario, and
subdirectories within each scenario for each run in that scenario.  Thus it is easy
to go an inspect the output, log files, namelist, etc., for a run that failed.

* lettuce does not detect if tarball versions on oceans11 have changed.  So if you want
to force a new download of the tarballs, you should delete the 'tests' directory
(or more specifically, delete 'tests/testing_inputs/' and 'tests/trusted_inputs/')


### Land Ice

* To get lettuce to compile MPAS with Albany, use "flags = ALBANY=true" under the 
[building] section of lettuce.landice.

* I have the features organized in subdirectories called 'SIA', 'HO', and 'in-development'
To run just a specific group of features, add it as an argument:
> lettuce landice_features/HO

