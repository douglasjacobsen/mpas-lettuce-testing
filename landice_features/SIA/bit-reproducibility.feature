Feature: Bit-Reproducible simulations
        In order to perform simulations using varying decompositions
        As an MPAS Developer
        I want MPAS-Land Ice simulations to be bit-reproducible across different decompositions.


	Scenario: Bit-Reproducible 1 vs 4 procs with dome shallow-ice
		Given A "dome" test for "testing" model version as run name "testing_run_1p"
		When I perform a 1 processor MPAS "landice_model_testing" run in "testing_run_1p"
		Given A "dome" test for "testing" model version as run name "testing_run_4p"
		When I perform a 4 processor MPAS "landice_model_testing" run in "testing_run_4p"
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0


	Scenario: Bit-Reproducible 2 vs 4 procs with dome shallow-ice
		Given A "dome" test for "testing" model version as run name "testing_run_2p"
		When I perform a 2 processor MPAS "landice_model_testing" run in "testing_run_2p"
		Given A "dome" test for "testing" model version as run name "testing_run_4p"
		When I perform a 4 processor MPAS "landice_model_testing" run in "testing_run_4p"
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0

