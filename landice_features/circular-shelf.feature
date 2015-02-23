Feature: Reproduce Circular Shelf benchmark solution
        In order to perform ice shelf simulations that are accurate
        As an MPAS Developer
        I want MPAS-Land Ice FO simulations to match the circular shelf benchmark solution across different decompositions.

	Scenario: 1 procs with circular-shelf first-order
		Given A "circular-shelf" test for "testing"
		When I perform a 1 processor MPAS "landice_model_testing" run
		Then I see a "circular-shelf" maximum speed near "1918" m/yr

	Scenario: 1 vs 4 procs with circular-shelf first-order
		Given A "circular-shelf" test for "testing"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS smaller than "1.0e-12"

	Scenario: 1 vs 1 procs with circular-shelf first-order against trusted
		Given A "circular-shelf" test for "testing"
		Given A "circular-shelf" test for "trusted"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 1 processor MPAS "landice_model_trusted" run
		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0
