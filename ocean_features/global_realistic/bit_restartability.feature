Feature: Global Realistic Simulations Bit Restartability
	Simulations with the global realistic configuration are:
		Bit-restartable:
			- Using different decompositions
			- Using different halo widths
			- Using different numbers of blocks per processor
			- Using different physics options

	Scenario: Restart Decomp 4 vs 16 procs with split explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "split_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing4" run to have run_duration "'0000_04:00:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_04:00:00'"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Decomp 4 vs 16 procs with RK4
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "RK4"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:40:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:40:00'"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Decomp 4 vs 16 procs with unsplit_explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "unsplit_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "unsplit_explicit"
		When I configure the "testing4" run to have run_duration "'0000_00:40:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:40:00'"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Halos 4 vs 16 procs with split explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "split_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing4" run to have run_duration "'0000_02:00:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_02:00:00'"
		When I set "testing4" namelist group "decomposition", option "config_num_halos" to "4"
		When I set "testing16wRst" namelist group "decomposition", option "config_num_halos" to "5"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Halos 4 vs 16 procs with RK4
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "RK4"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:20:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:20:00'"
		When I set "testing4" namelist group "decomposition", option "config_num_halos" to "4"
		When I set "testing16wRst" namelist group "decomposition", option "config_num_halos" to "7"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Halos 4 vs 16 procs with unsplit_explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "unsplit_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "unsplit_explicit"
		When I configure the "testing4" run to have run_duration "'0000_00:20:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:20:00'"
		When I set "testing4" namelist group "decomposition", option "config_num_halos" to "5"
		When I set "testing16wRst" namelist group "decomposition", option "config_num_halos" to "3"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Blocks 4 vs 16 procs with split explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "split_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing4" run to have run_duration "'0000_02:00:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_02:00:00'"
		When I set "testing4" namelist group "decomposition", option "config_number_of_blocks" to "8"
		When I set "testing16wRst" namelist group "decomposition", option "config_number_of_blocks" to "16"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Blocks 4 vs 16 procs with RK4
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "RK4"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:20:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:20:00'"
		When I set "testing4" namelist group "decomposition", option "config_number_of_blocks" to "16"
		When I set "testing16wRst" namelist group "decomposition", option "config_number_of_blocks" to "24"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Blocks 4 vs 16 procs with unsplit_explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "unsplit_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "unsplit_explicit"
		When I configure the "testing4" run to have run_duration "'0000_00:20:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:20:00'"
		When I set "testing4" namelist group "decomposition", option "config_number_of_blocks" to "4"
		When I set "testing16wRst" namelist group "decomposition", option "config_number_of_blocks" to "32"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Physics 4 vs 16 procs with split explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "split_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing4" run to have run_duration "'0000_04:00:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_04:00:00'"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I add all physics to the "testing4" run
		When I add all physics to the "testing16wRst" run
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Physics 4 vs 16 procs with RK4
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "RK4"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "RK4"
		When I configure the "testing4" run to have run_duration "'0000_00:40:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:40:00'"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I add all physics to the "testing4" run
		When I add all physics to the "testing16wRst" run
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: Restart Physics 4 vs 16 procs with unsplit_explicit
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing4" with integrator "unsplit_explicit"
		Given A "QU_240km" "40levels" "global_realistic" "testing" test as "testing16wRst" with integrator "unsplit_explicit"
		When I configure the "testing4" run to have run_duration "'0000_00:40:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:40:00'"
		When I set "testing4" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing4" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing4" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_do_restart" to ".true."
		When I set "testing16wRst" namelist group "time_management", option "config_start_time" to "'file'"
		When I set "testing16wRst" namelist group "debug", option "config_read_nearest_restart" to ".true."
		When I add all physics to the "testing4" run
		When I add all physics to the "testing16wRst" run
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

