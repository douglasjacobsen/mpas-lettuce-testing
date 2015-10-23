Feature: Run MISMIP3D experiment
        In order to perform marine ice sheet simulations that are accurate
        As an MPAS Developer
        I want MPAS-Land Ice FO simulations to be able to run the MISMIP3D steady state experiment for a few time steps.

	Scenario: 1 vs 8 procs with MISMIP3D-10km first-order
                Given A "mismip10km" test for "testing" model version as run name "1p_run"
                When I set "1p_run" namelist group "time_management", option "config_stop_time" to "'0000-02-01_00:00:00'"
		When I perform a 1 processor MPAS "landice_model_testing" run in "1p_run"

		Given A "mismip10km" test for "testing" model version as run name "8p_run"
                When I set "8p_run" namelist group "time_management", option "config_stop_time" to "'0000-02-01_00:00:00'"
		When I perform a 8 processor MPAS "landice_model_testing" run in "8p_run"

		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS smaller than "1.0e-12"



	Scenario: 8 vs 8 procs with MISMIP3D-10km first-order against trusted
		Given A "mismip10km" test for "trusted" model version as run name "trusted_run"
                When I set "trusted_run" namelist group "time_management", option "config_stop_time" to "'0000-10-01_00:00:00'"
		When I perform a 8 processor MPAS "landice_model_trusted" run in "trusted_run"

		Given A "mismip10km" test for "testing" model version as run name "testing_run"
                When I set "testing_run" namelist group "time_management", option "config_stop_time" to "'0000-10-01_00:00:00'"
		When I perform a 8 processor MPAS "landice_model_testing" run in "testing_run"

		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0

		When I compute the RMS of "uReconstructX"
                Then I see "uReconstructX" RMS of 0

		When I compute the RMS of "uReconstructY"
                Then I see "uReconstructY" RMS of 0

		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0
