Feature: Greenland Ice Sheet 20km simulation
        In order to perform simulations on realistic geometries that are accurate
        As an MPAS Developer
        I want gis20km solutions that work.


	Scenario: 1 vs 16 procs with gis20km shallow-ice bit reproducibility
		Given A "gis20km" test for "testing" model version as run name "1p_run"
		When I set "1p_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I perform a 1 processor MPAS "landice_model_testing" run in "1p_run"

		Given A "gis20km" test for "testing" model version as run name "16p_run"
		When I set "16p_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I perform a 1 processor MPAS "landice_model_testing" run in "16p_run"

		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0



	Scenario: 8 vs 8 procs with gis20km shallow-ice against trusted (no answer changes)
		Given A "gis20km" test for "trusted" model version as run name "trusted_run"
		When I set "trusted_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I perform a 8 processor MPAS "landice_model_trusted" run in "trusted_run"

		Given A "gis20km" test for "testing" model version as run name "testing_run"
		When I set "testing_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I perform a 8 processor MPAS "landice_model_testing" run in "testing_run"

		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0



	Scenario: 4 vs 4 procs with gis20km shallow-ice bit restartability
		Given A "gis20km" test for "testing" model version as run name "standard_run"
		When I set "standard_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "standard_run" namelist group "time_integration", option "config_dt" to "'0000-00-01_00:00:00'"
		When I set "standard_run" namelist group "time_management", option "config_stop_time" to "'0000-01-03_00:00:00'"
		When I set "output_interval" to "0000-00-01_00:00:00" in the immutable_stream named "restart" in the "standard_run" stream file'
		When I set "output_interval" to "0000-00-01_00:00:00" in the stream named "output" in the "standard_run" stream file'
		When I perform a 4 processor MPAS "landice_model_testing" run in "standard_run"

		Given A "gis20km" test for "testing" model version as run name "run_with_restart"
		When I set "run_with_restart" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "run_with_restart" namelist group "time_integration", option "config_dt" to "'0000-00-01_00:00:00'"
		When I set "run_with_restart" namelist group "time_management", option "config_stop_time" to "'0000-01-03_00:00:00'"
		When I set "output_interval" to "0000-00-01_00:00:00" in the immutable_stream named "restart" in the "run_with_restart" stream file'
		When I set "output_interval" to "0000-00-01_00:00:00" in the stream named "output" in the "run_with_restart" stream file'
		When I perform a 4 processor MPAS "landice_model_testing" run with restart in "run_with_restart"

		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0
