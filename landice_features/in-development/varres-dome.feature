Feature: Variable resolution mesh solutions
        In order to perform variable resolution simulations that are accurate
        As an MPAS Developer
        I want variable resolution dome solutions to be close to the analytic solution.


	Scenario: 1 procs with dome-varres shallow-ice against analytic solution
		Given A "dome-varres" test for "testing" model version as run name "testingrun"
		When I set "testingrun" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "testingrun" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run in "testingrun"
		When I compute the Halfar RMS
		Then I see Halfar thickness RMS of <"25"m



	Scenario: 1 vs 4 procs with dome-varres shallow-ice bit reproducibility
		Given A "dome-varres" test for "testing" model version as run name "1p_run"
		When I set "1p_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "1p_run" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run in "1p_run"

		Given A "dome-varres" test for "testing" model version as run name "4p_run"
		When I set "4p_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "4p_run" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run in "4p_run"

		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0



	Scenario: 1 vs 1 procs with dome-varres shallow-ice against trusted (no answer changes)
		Given A "dome-varres" test for "trusted" model version as run name "trusted_run"
		When I set "trusted_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "trusted_run" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_trusted" run in "trusted_run"

		Given A "dome-varres" test for "testing" model version as run name "testing_run"
		When I set "testing_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "testing_run" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run in "testing_run"

		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0



	Scenario: 4 vs 4 procs with dome-varres shallow-ice bit restartability
		Given A "dome-varres" test for "testing" model version as run name "standard_run"
		When I set "standard_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "standard_run" namelist group "time_integration", option "config_dt" to "'0001-00-00_00:00:00'"
		When I set "standard_run" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the immutable_stream named "restart" in the "standard_run" stream file'
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "standard_run" stream file'
		When I perform a 4 processor MPAS "landice_model_testing" run in "standard_run"

		Given A "dome-varres" test for "testing" model version as run name "run_with_restart"
		When I set "run_with_restart" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "run_with_restart" namelist group "time_integration", option "config_dt" to "'0001-00-00_00:00:00'"
		When I set "run_with_restart" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the immutable_stream named "restart" in the "run_with_restart" stream file'
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "run_with_restart" stream file'
		When I perform a 4 processor MPAS "landice_model_testing" run in "run_with_restart"

		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0
