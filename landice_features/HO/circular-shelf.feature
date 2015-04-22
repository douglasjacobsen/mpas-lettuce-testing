Feature: Reproduce Circular Shelf benchmark solution
        In order to perform ice shelf simulations that are accurate
        As an MPAS Developer
        I want MPAS-Land Ice FO simulations to match the circular shelf benchmark solution across different decompositions.



	Scenario: 1 procs with circular-shelf first-order against benchmark solution
		Given A "circular-shelf" test for "testing" model version as run name "testingrun"
		When I perform a 1 processor MPAS "landice_model_testing" run in "testingrun"

		Then I see a "circular-shelf" maximum speed near "1918" m/yr



	Scenario: 1 vs 4 procs with circular-shelf first-order
		Given A "circular-shelf" test for "testing" model version as run name "1p_run"
		When I perform a 1 processor MPAS "landice_model_testing" run in "1p_run"

		Given A "circular-shelf" test for "testing" model version as run name "4p_run"
		When I perform a 4 processor MPAS "landice_model_testing" run in "4p_run"

		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS smaller than "1.0e-12"



	Scenario: 1 vs 1 procs with circular-shelf first-order against trusted
		Given A "circular-shelf" test for "trusted" model version as run name "trusted_run"
		When I perform a 1 processor MPAS "landice_model_trusted" run in "trusted_run"

		Given A "circular-shelf" test for "testing" model version as run name "testing_run"
		When I perform a 1 processor MPAS "landice_model_testing" run in "testing_run"

		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0
