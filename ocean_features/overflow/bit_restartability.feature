Feature: Overflow Bit-Restartable simulations
	Simulations with the overflow configuration are:
		Bit-restartable:
			- Using different decompositions
			- Using different halo widths
			- Using different numbers of blocks per processor
			- Using different physics options

	Scenario: Decomp 2 vs 16 procs with split explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:06:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:06:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Decomp 2 vs 16 procs with RK4
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16wRst" with integrator "RK4"
		When I configure the "testing2" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:01:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Decomp 2 vs 16 procs with unsplit_explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16wRst" with integrator "unsplit_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:01:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Halos 1 vs 24 procs with split explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "split_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:06:00'"
		When I configure the "testing24" run to have run_duration "'0000_00:06:00'"
		When I set "testing1" namelist group "decomposition", option "config_num_halos" to "5"
		When I set "testing24" namelist group "decomposition", option "config_num_halos" to "7"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Halos 4 vs 8 procs with RK4
		Given A "10km" "100layer" "overflow" "testing" test as "testing4" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing8" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing8" run to have run_duration "'0000_00:01:00'"
		When I set "testing4" namelist group "decomposition", option "config_num_halos" to "4"
		When I set "testing8" namelist group "decomposition", option "config_num_halos" to "6"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 8 processor MPAS "ocean_model_testing" run in "testing8"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Halos 2 vs 16 procs with unsplit_explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "unsplit_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing16" run to have run_duration "'0000_00:01:00'"
		When I set "testing2" namelist group "decomposition", option "config_num_halos" to "3"
		When I set "testing16" namelist group "decomposition", option "config_num_halos" to "5"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Blocks 1 vs 24 procs with split explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "split_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:06:00'"
		When I configure the "testing24" run to have run_duration "'0000_00:06:00'"
		When I set "testing1" namelist group "decomposition", option "config_number_of_blocks" to "4"
		When I set "testing24" namelist group "decomposition", option "config_number_of_blocks" to "8"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Blocks 4 vs 8 procs with RK4
		Given A "10km" "100layer" "overflow" "testing" test as "testing4" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing8" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing8" run to have run_duration "'0000_00:01:00'"
		When I set "testing4" namelist group "decomposition", option "config_number_of_blocks" to "8"
		When I set "testing8" namelist group "decomposition", option "config_number_of_blocks" to "8"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 8 processor MPAS "ocean_model_testing" run in "testing8"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Blocks 2 vs 16 procs with unsplit_explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "unsplit_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing16" run to have run_duration "'0000_00:01:00'"
		When I set "testing2" namelist group "decomposition", option "config_number_of_blocks" to "8"
		When I set "testing16" namelist group "decomposition", option "config_number_of_blocks" to "24"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

