Feature: Variable resolution mesh solutions
        In order to perform variable resolution simulations that are accurate
        As an MPAS Developer
        I want variable resolution dome solutions to be close to the analytic solution.


	Scenario: 1 procs with dome-varres shallow-ice against analytic solution
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I compute the Halfar RMS
		Then I see Halfar thickness RMS of <10m

	Scenario: 1 vs 4 procs with dome-varres shallow-ice bit reproducibility
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0

	Scenario: 1 vs 1 procs with dome-varres shallow-ice against trusted (no answer changes)
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		Given A "dome-varres" test for "trusted"
		When I set "trusted" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "trusted" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 1 processor MPAS "landice_model_trusted" run
		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0

	Scenario: 4 vs 4 procs with dome-varres shallow-ice bit restartability
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'0100-01-01_00:00:00'"
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run with restart
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0
