Feature: Bit-Reproducible simulations
	MPAS-Ocean simulations are bit-repdoducible
	across different decompositions, and against trusted versions of the model.

	Scenario: 4 vs 16 procs with split explicit - RealWorld
		Given A "QU" "240km" "worldOcean" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "testing" test as "testing16"
		When I configure the "testing4" run to have integrator "'split_explicit'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		When I configure the "testing16" run to have integrator "'split_explicit'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 4 vs 16 procs with RK4 - RealWorld
		Given A "QU" "240km" "worldOcean" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "testing" test as "testing16"
		When I configure the "testing4" run to have integrator "'RK4'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		When I configure the "testing16" run to have integrator "'RK4'", dt "'0000_00:10:00'", run_duration "'0000_00:20:00'"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 2 vs 16 procs with split explicit - BC
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing2"
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing16"
		When I configure the "testing2" run to have integrator "'split_explicit'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		When I configure the "testing16" run to have integrator "'split_explicit'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 1 vs 24 procs with RK4 - BC
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing1"
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing24"
		When I configure the "testing1" run to have integrator "'RK4'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		When I configure the "testing24" run to have integrator "'RK4'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 2 vs 16 procs with split explicit - Overflow
		Given A "10km" "40layer" "overflow" "testing" test as "testing2"
		Given A "10km" "40layer" "overflow" "testing" test as "testing16"
		When I configure the "testing2" run to have integrator "'split_explicit'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		When I configure the "testing16" run to have integrator "'split_explicit'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 1 vs 24 procs with RK4 - Overflow
		Given A "10km" "40layer" "overflow" "testing" test as "testing1"
		Given A "10km" "40layer" "overflow" "testing" test as "testing24"
		When I configure the "testing1" run to have integrator "'RK4'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		When I configure the "testing24" run to have integrator "'RK4'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run in "testing24"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 4 vs 16 procs with split explicit against trusted - RealWorld
		Given A "QU" "240km" "worldOcean" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "trusted" test as "trusted16"
		When I configure the "testing4" run to have integrator "'split_explicit'", dt "'0000_00:10:00'", run_duration "'0000_00:10:00'"
		When I configure the "trusted16" run to have integrator "'split_explicit'", dt "'0000_00:10:00'", run_duration "'0000_00:10:00'"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 4 vs 16 procs with RK4  against trusted- RealWorld
		Given A "QU" "240km" "worldOcean" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "trusted" test as "trusted16"
		When I configure the "testing4" run to have integrator "'RK4'", dt "'0000_00:10:00'", run_duration "'0000_00:10:00'"
		When I configure the "trusted16" run to have integrator "'RK4'", dt "'0000_00:10:00'", run_duration "'0000_00:10:00'"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0


	Scenario: 16 vs 16 procs with RK4 against trusted - BC
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing16"
		Given A "10000m" "20levs" "baroclinic_channel" "trusted" test as "trusted16"
		When I configure the "testing16" run to have integrator "'RK4'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		When I configure the "trusted16" run to have integrator "'RK4'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 16 vs 16 procs with split explicit against trusted - BC
		Given A "10000m" "20levs" "baroclinic_channel" "testing" test as "testing16"
		Given A "10000m" "20levs" "baroclinic_channel" "trusted" test as "trusted16"
		When I configure the "testing16" run to have integrator "'split_explicit'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		When I configure the "trusted16" run to have integrator "'split_explicit'", dt "'0000_00:00:30'", run_duration "'0000_00:00:30'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 16 vs 16 procs with RK4 against trusted - Overflow
		Given A "10km" "40layer" "overflow" "testing" test as "testing16"
		Given A "10km" "40layer" "overflow" "trusted" test as "trusted16"
		When I configure the "testing16" run to have integrator "'RK4'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		When I configure the "trusted16" run to have integrator "'RK4'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 16 vs 16 procs with split explicit against trusted - Overflow
		Given A "10km" "40layer" "overflow" "testing" test as "testing16"
		Given A "10km" "40layer" "overflow" "trusted" test as "trusted16"
		When I configure the "testing16" run to have integrator "'split_explicit'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		When I configure the "trusted16" run to have integrator "'split_explicit'", dt "'0000_00:01:00'", run_duration "'0000_00:01:00'"
		Given I perform a 16 processor MPAS "ocean_model_testing" run in "testing16"
		Given I perform a 16 processor MPAS "ocean_model_trusted" run in "trusted16"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

