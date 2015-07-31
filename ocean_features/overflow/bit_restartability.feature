Feature: Overflow Bit-Restartable simulations
	Simulations with the overflow configuration are:
		Bit-restartable:
			- Using different decompositions
			- Using different halo widths
			- Using different numbers of blocks per processor
			- Using different physics options

	Scenario: 2 vs 16 procs with split explicit - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16wRst" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:06:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:06:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: 2 vs 16 procs with RK4 - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16wRst" with integrator "RK4"
		When I configure the "testing2" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:01:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: 2 vs 16 procs with unsplit_explicit - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16wRst" with integrator "unsplit_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing16wRst" run to have run_duration "'0000_00:01:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

