Feature: Reproduce Halfar analytic solution
        In order to perform SIA simulations that are accurate
        As an MPAS Developer
        I want MPAS-Land Ice SIA simulations to reproduce the Halfar analytic solution across different decompositions.


	Scenario: Halfar 1 procs with dome shallow-ice
		Given A "dome" test for "testing" model version as run name "testingrun"
		When I perform a 1 processor MPAS "landice_model_testing" run in "testingrun"
		When I compute the Halfar RMS
		Then I see Halfar thickness RMS of <"10"m


	Scenario: Halfar 4 procs with dome shallow-ice
		Given A "dome" test for "testing" model version as run name "testingrun"
		When I perform a 1 processor MPAS "landice_model_testing" run in "testingrun"
		When I compute the Halfar RMS
		Then I see Halfar thickness RMS of <"10"m

