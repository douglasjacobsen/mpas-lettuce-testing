Feature: Baroclinic Channel Simulations Bit Restartability
	Simulations with the baroclinic channel configuration are:
		Bit-restartable:
			- Using different decompositions
			- Using different halo widths
			- Using different numbers of blocks per processor
			- Using different physics options

	Scenario: Restart Decomp 2 vs 16 procs with split explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:10:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:10:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Decomp 1 vs 2 procs with RK4
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing1" with integrator "RK4"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing2wRst" with integrator "RK4"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing2wRst" run to have run_duration "'0000_00:01:00'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 2 processor MPAS "ocean_model_testing" run with restart in "testing2wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Decomp 4 vs 24 procs with unsplit_explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing4" with integrator "unsplit_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing24wRst" with integrator "unsplit_explicit"
		When I configure the "testing4" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24wRst" run to have run_duration "'0000_00:01:00'"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Halos 2 vs 16 procs with split explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:10:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:10:00'"
		When I set "testing2" namelist group "decomposition", option "config_num_halos" to "4"
		When I set "testing16wRst" namelist group "decomposition", option "config_num_halos" to "6"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Halos 1 vs 24 procs with RK4
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing1" with integrator "RK4"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing24wRst" with integrator "RK4"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24wRst" run to have run_duration "'0000_00:01:00'"
		When I set "testing1" namelist group "decomposition", option "config_num_halos" to "5"
		When I set "testing24wRst" namelist group "decomposition", option "config_num_halos" to "6"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Halos 1 vs 24 procs with unsplit_explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing1" with integrator "unsplit_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing24wRst" with integrator "unsplit_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24wRst" run to have run_duration "'0000_00:01:00'"
		When I set "testing1" namelist group "decomposition", option "config_num_halos" to "3"
		When I set "testing24wRst" namelist group "decomposition", option "config_num_halos" to "7"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Blocks 2 vs 16 procs with split explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:10:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:10:00'"
		When I set "testing2" namelist group "decomposition", option "config_number_of_blocks" to "8"
		When I set "testing16wRst" namelist group "decomposition", option "config_number_of_blocks" to "16"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 5 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Blocks 1 vs 24 procs with RK4
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing1" with integrator "RK4"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing24wRst" with integrator "RK4"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24wRst" run to have run_duration "'0000_00:01:00'"
		When I set "testing1" namelist group "decomposition", option "config_number_of_blocks" to "24"
		When I set "testing24wRst" namelist group "decomposition", option "config_number_of_blocks" to "24"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Blocks 1 vs 24 procs with unsplit_explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing1" with integrator "unsplit_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing24wRst" with integrator "unsplit_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24wRst" run to have run_duration "'0000_00:01:00'"
		When I set "testing1" namelist group "decomposition", option "config_number_of_blocks" to "4"
		When I set "testing24wRst" namelist group "decomposition", option "config_num_halos" to "8"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Physics 2 vs 16 procs with split explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:10:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:10:00'"
		When I add all physics to the "testing2" run
		When I add all physics to the "testing16wRst" run
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Physics 1 vs 2 procs with RK4
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing1" with integrator "RK4"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing2wRst" with integrator "RK4"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing2wRst" run to have run_duration "'0000_00:01:00'"
		When I add all physics to the "testing1" run
		When I add all physics to the "testing2wRst" run
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 2 processor MPAS "ocean_model_testing" run with restart in "testing2wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Physics 4 vs 24 procs with unsplit_explicit
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing4" with integrator "unsplit_explicit"
		Given A "10km" "20levs" "baroclinic_channel" "testing" test as "testing24wRst" with integrator "unsplit_explicit"
		When I configure the "testing4" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24wRst" run to have run_duration "'0000_00:01:00'"
		When I add all physics to the "testing4" run
		When I add all physics to the "testing24wRst" run
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds



