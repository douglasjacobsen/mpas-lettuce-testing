Feature: Bit-Restartable simulations
	MPAS-Ocean simulations are bit-repstartable
	across different decompositions.

	Scenario: 4 vs 16 procs with split explicit - RealWorld
		Given A "QU" "240km" "worldOcean" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "testing" test as "testing16wRst"
		When I configure the "testing4" run to have integrator "'split_explicit'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		When I configure the "testing16wRst" run to have integrator "'split_explicit'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 4 vs 16 procs with RK4 - RealWorld
		Given A "QU" "240km" "worldOcean" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "testing" test as "testing16wRst"
		When I configure the "testing4" run to have integrator "'RK4'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		When I configure the "testing16wRst" run to have integrator "'RK4'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 2 vs 16 procs with split explicit - BC
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing2"
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing16wRst"
		When I configure the "testing2" run to have integrator "'split_explicit'", dt "'0000_00:00:30'", run_duration "'0000_00:01:00'"
		When I configure the "testing16wRst" run to have integrator "'split_explicit'", dt "'0000_00:00:30'", run_duration "'0000_00:01:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 1 vs 2 procs with RK4 - BC
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing1"
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing2wRst"
		When I configure the "testing1" run to have integrator "'RK4'", dt "'0000_00:00:30'", run_duration "'0000_00:01:00'"
		When I configure the "testing2wRst" run to have integrator "'RK4'", dt "'0000_00:00:30'", run_duration "'0000_00:01:00'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 2 processor MPAS "ocean_model_testing" run with restart in "testing2wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 2 vs 16 procs with split explicit - Overflow
		Given A "10km" "40layer" "overflow" "testing" test as "testing2"
		Given A "10km" "40layer" "overflow" "testing" test as "testing16wRst"
		When I configure the "testing2" run to have integrator "'split_explicit'", dt "'0000_00:01:00'", run_duration "'0000_00:02:00'"
		When I configure the "testing16wRst" run to have integrator "'split_explicit'", dt "'0000_00:01:00'", run_duration "'0000_00:02:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 2 vs 16 procs with RK4 - Overflow
		Given A "10km" "40layer" "overflow" "testing" test as "testing2"
		Given A "10km" "40layer" "overflow" "testing" test as "testing16wRst"
		When I configure the "testing2" run to have integrator "'RK4'", dt "'0000_00:00:10'", run_duration "'0000_00:00:20'"
		When I configure the "testing16wRst" run to have integrator "'RK4'", dt "'0000_00:00:10'", run_duration "'0000_00:00:20'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

