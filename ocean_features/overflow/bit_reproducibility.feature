Feature: Overflow Bit-Reproducible simulations
	Simulations with the overflow configuration are:
		Bit-reproducible:
			- Using different decompositions
			- Using different halo widths
			- Using different numbers of blocks per processor
			- Using different physics options

	Scenario: 2 vs 16 procs with split explicit - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing2" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "split_explicit"
		When I configure the "testing2" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing16" run to have run_duration "'0000_00:01:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: 1 vs 24 procs with RK4 - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "RK4"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24" run to have run_duration "'0000_00:01:00'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: 1 vs 24 procs with unsplit_explicit - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing1" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "testing" test as "testing24" with integrator "unsplit_explicit"
		When I configure the "testing1" run to have run_duration "'0000_00:01:00'"
		When I configure the "testing24" run to have run_duration "'0000_00:01:00'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: 16 vs 16 procs with split explicit against trusted - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "split_explicit"
		Given A "10km" "100layer" "overflow" "trusted" test as "trusted16" with integrator "split_explicit"
		When I configure the "testing16" run to have run_duration "'0000_00:01:00'"
		When I configure the "trusted16" run to have run_duration "'0000_00:01:00'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: 16 vs 16 procs with RK4 against trusted - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "RK4"
		Given A "10km" "100layer" "overflow" "trusted" test as "trusted16" with integrator "RK4"
		When I configure the "testing16" run to have run_duration "'0000_00:01:00'"
		When I configure the "trusted16" run to have run_duration "'0000_00:01:00'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

	Scenario: 16 vs 16 procs with unsplit_explicit against trusted - Overflow
		Given A "10km" "100layer" "overflow" "testing" test as "testing16" with integrator "unsplit_explicit"
		Given A "10km" "100layer" "overflow" "trusted" test as "trusted16" with integrator "unsplit_explicit"
		When I configure the "testing16" run to have run_duration "'0000_00:01:00'"
		When I configure the "trusted16" run to have run_duration "'0000_00:01:00'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		Then I add the prognostic fields to be compared
		Then I compute RMSes of all of my fields
		Then I verify my RMSes are within my thresholds

