Feature: Bit-Restartable simulations
	In order to perform simulations using restarts
	As an MPAS Developer
	I want MPAS-Land Ice simulations to be bit-restartable across different decompositions.

	Scenario: Bit-Restartable 1 vs 1 procs with dome shallow-ice
		Given A "dome" test for "testing" model version as run name "standard_run"
		When I set "standard_run" namelist group "time_integration", option "config_dt" to "'0001-00-00_00:00:00'"
		When I set "standard_run" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the immutable_stream named "restart" in the "standard_run" stream file'
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "standard_run" stream file'
		When I perform a 1 processor MPAS "landice_model_testing" run in "standard_run"

		Given A "dome" test for "testing" model version as run name "run_with_restart"
		When I set "run_with_restart" namelist group "time_integration", option "config_dt" to "'0001-00-00_00:00:00'"
		When I set "run_with_restart" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the immutable_stream named "restart" in the "run_with_restart" stream file'
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "run_with_restart" stream file'
		When I perform a 1 processor MPAS "landice_model_testing" run with restart in "run_with_restart"

		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0



	Scenario: Bit-Restartable 4 vs 4 procs with dome shallow-ice
		Given A "dome" test for "testing" model version as run name "standard_run"
		When I set "standard_run" namelist group "time_integration", option "config_dt" to "'0001-00-00_00:00:00'"
		When I set "standard_run" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the immutable_stream named "restart" in the "standard_run" stream file'
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "standard_run" stream file'
		When I perform a 4 processor MPAS "landice_model_testing" run in "standard_run"

		Given A "dome" test for "testing" model version as run name "run_with_restart"
		When I set "run_with_restart" namelist group "time_integration", option "config_dt" to "'0001-00-00_00:00:00'"
		When I set "run_with_restart" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the immutable_stream named "restart" in the "run_with_restart" stream file'
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "run_with_restart" stream file'
		When I perform a 4 processor MPAS "landice_model_testing" run with restart in "run_with_restart"

		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0

