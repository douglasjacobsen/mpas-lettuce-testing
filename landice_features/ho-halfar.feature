Feature: HO Halfar close to SIA Halfar
        In order to perform accurate higher-order simulations
        As an MPAS Developer
        I want MPAS-Land Ice HO simulations of the Halfar dome to be close SIA simulations.

	Scenario: 1 proc dome higher-order vs SIA
		Given A "dome" test for "testing"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0

	Scenario: 1 vs 4 procs with dome shallow-ice
		Given A "dome" test for "testing"
		When I perform a 1 processor MPAS "landice_model_testing" run
		When I perform a 4 processor MPAS "landice_model_testing" run
		When I compute the RMS of "thickness"
		Then I see "thickness" RMS of 0

