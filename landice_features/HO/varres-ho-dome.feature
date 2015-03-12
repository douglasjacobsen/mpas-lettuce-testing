Feature: Variable resolution mesh solutions
        In order to perform variable resolution FO simulations that are accurate
        As an MPAS Developer
        I want variable resolution dome FO solutions to be close to the analytic solution.


	Scenario: 1 procs with dome-varres FO against analytic solution
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'FO'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "testing" stream file
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'010-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I compute the Halfar RMS
		Then I see Halfar thickness RMS of <"25"m

	Scenario: 1 vs 4 procs with dome-varres FO bit reproducibility
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'FO'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "testing" stream file
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS smaller than "1.0e-10"

	Scenario: 1 vs 1 procs with dome-varres FO against trusted (no answer changes)
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'FO'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "testing" stream file
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'0001-01-01_00:00:00'"
		Given A "dome-varres" test for "trusted"
		When I set "trusted" namelist group "velocity_solver", option "config_velocity_solver" to "'FO'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "trusted" stream file
		When I set "trusted" namelist group "time_management", option "config_stop_time" to "'0001-01-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 1 processor MPAS "landice_model_trusted" run
		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0

	Scenario: 4 vs 4 procs with dome-varres FO bit restartability
		Given A "dome-varres" test for "testing"
		When I set "testing" namelist group "velocity_solver", option "config_velocity_solver" to "'FO'"
		When I set "output_interval" to "0001-00-00_00:00:00" in the stream named "output" in the "testing" stream file
		When I set "testing" namelist group "time_management", option "config_stop_time" to "'0002-01-01_00:00:00'"
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run with restart
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0
