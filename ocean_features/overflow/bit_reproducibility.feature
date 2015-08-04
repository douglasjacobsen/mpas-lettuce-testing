Feature: Overflow Bit-Reproducible simulations
	Simulations with the overflow configuration are:
		Bit-reproducible:
			- Using different decompositions
			- Using different halo widths
			- Using different numbers of blocks per processor
			- Using different physics options

	Scenario: Repro Decomp 2 vs 16 procs with split explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:03:00'"
		When I configure the "testing16" run to have run_duration "'0000_00:03:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Decomp 1 vs 24 procs with RK4
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "RK4"
		When I configure the "testing1" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing24" run to have run_duration "'0000_00:00:30'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Decomp 1 vs 24 procs with unsplit_explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "unsplit_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing24" run to have run_duration "'0000_00:00:30'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Halos 1 vs 24 procs with split explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "split_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:03:00'"
		When I configure the "testing24" run to have run_duration "'0000_00:03:00'"
		When I set "testing1" namelist group "decomposition", option "config_num_halos" to "5"
		When I set "testing24" namelist group "decomposition", option "config_num_halos" to "7"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Halos 4 vs 8 procs with RK4
		Given A "10km" "100layer" "overflow" "testing" test as "testing4" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing8" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing8" run to have run_duration "'0000_00:00:30'"
		When I set "testing4" namelist group "decomposition", option "config_num_halos" to "4"
		When I set "testing8" namelist group "decomposition", option "config_num_halos" to "6"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 8 processor MPAS "ocean_model_testing" run in "testing8"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Halos 2 vs 16 procs with unsplit_explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "unsplit_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing16" run to have run_duration "'0000_00:00:30'"
		When I set "testing2" namelist group "decomposition", option "config_num_halos" to "3"
		When I set "testing16" namelist group "decomposition", option "config_num_halos" to "5"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Blocks 1 vs 24 procs with split explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "split_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:03:00'"
		When I configure the "testing24" run to have run_duration "'0000_00:03:00'"
		When I set "testing1" namelist group "decomposition", option "config_number_of_blocks" to "4"
		When I set "testing24" namelist group "decomposition", option "config_number_of_blocks" to "8"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Blocks 4 vs 8 procs with RK4
		Given A "10km" "100layer" "overflow" "testing" test as "testing4" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing8" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing8" run to have run_duration "'0000_00:00:30'"
		When I set "testing4" namelist group "decomposition", option "config_number_of_blocks" to "8"
		When I set "testing8" namelist group "decomposition", option "config_number_of_blocks" to "8"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 8 processor MPAS "ocean_model_testing" run in "testing8"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Blocks 2 vs 16 procs with unsplit_explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "unsplit_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing16" run to have run_duration "'0000_00:00:30'"
		When I set "testing2" namelist group "decomposition", option "config_number_of_blocks" to "8"
		When I set "testing16" namelist group "decomposition", option "config_number_of_blocks" to "24"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Physics 2 vs 16 procs with split explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:03:00'"
		When I configure the "testing16" run to have run_duration "'0000_00:03:00'"
		When I add all physics to the "testing2" run
		When I add all physics to the "testing16" run
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Physics 1 vs 24 procs with RK4
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "RK4"
		When I configure the "testing1" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing24" run to have run_duration "'0000_00:00:30'"
		When I add all physics to the "testing1" run
		When I add all physics to the "testing24" run
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Physics 1 vs 24 procs with unsplit_explicit
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "unsplit_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:00:30'"
		When I configure the "testing24" run to have run_duration "'0000_00:00:30'"
		When I add all physics to the "testing1" run
		When I add all physics to the "testing24" run
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Trusted 16 vs 16 procs with split explicit against trusted
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "trusted" test as "trusted16" with integrator "split_explicit"
		When I configure the "testing16" run to have run_duration "'0000_00:03:00'"
		When I configure the "trusted16" run to have run_duration "'0000_00:03:00'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Trusted 16 vs 16 procs with RK4 against trusted
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "trusted" test as "trusted16" with integrator "RK4"
		When I configure the "testing16" run to have run_duration "'0000_00:00:30'"
		When I configure the "trusted16" run to have run_duration "'0000_00:00:30'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Repro Trusted 16 vs 16 procs with unsplit_explicit against trusted
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "trusted" test as "trusted16" with integrator "unsplit_explicit"
		When I configure the "testing16" run to have run_duration "'0000_00:00:30'"
		When I configure the "trusted16" run to have run_duration "'0000_00:00:30'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

