Feature: Reproduce Confined Shelf benchmark solution
        In order to perform ice shelf simulations that are accurate
        As an MPAS Developer
        I want MPAS-Land Ice FO simulations to match the confined shelf benchmark solution across different decompositions.

	Scenario: 1 procs with confined-shelf first-order
		Given A "confined-shelf" test for "testing"
		When I perform a 1 processor MPAS "landice_model_testing" run
		Then I see a "confined-shelf" maximum speed near "1285" m/yr

	Scenario: 1 vs 4 procs with confined-shelf first-order
		Given A "confined-shelf" test for "testing"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0

	Scenario: 1 vs 1 procs with confined-shelf first-order against trusted
		Given A "confined-shelf" test for "testing"
		Given A "confined-shelf" test for "trusted"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 1 processor MPAS "landice_model_trusted" run
		When I compute the RMS of "normalVelocity"
		Then I see "normalVelocity" RMS of 0

