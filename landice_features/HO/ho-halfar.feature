Feature: HO Halfar close to SIA Halfar
        In order to perform accurate higher-order simulations
        As an MPAS Developer
        I want MPAS-Land Ice HO simulations of the Halfar dome to be close to SIA simulations.



	Scenario: dome higher-order vs SIA
		Given A "dome" test for "testing" model version as run name "sia_run"
		When I set "sia_run" namelist group "time_management", option "config_stop_time" to "'0000-01-01_00:00:00'"
		When I set "sia_run" namelist group "velocity_solver", option "config_velocity_solver" to "'sia'"
		When I perform a 4 processor MPAS "landice_model_testing" run in "sia_run"

		Given A "dome" test for "testing" model version as run name "FO_run"
		When I set "FO_run" namelist group "time_management", option "config_stop_time" to "'0000-01-01_00:00:00'"
		When I set "FO_run" namelist group "velocity_solver", option "config_velocity_solver" to "'FO'"
		When I perform a 4 processor MPAS "landice_model_testing" run in "FO_run"

		When I compute the RMS of "normalVelocity"
		# 6.3419584e-7 = 20 m/yr
		Then I see "normalVelocity" RMS smaller than "6.3419584e-7"
