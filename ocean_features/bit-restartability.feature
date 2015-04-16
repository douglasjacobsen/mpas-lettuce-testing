Feature: Bit-Restartable simulations
	MPAS-Ocean simulations are bit-repstartable
	across different decompositions.

	Scenario: 4 vs 16 procs with split explicit - RealWorld
		Given A "QU" "240km" "worldOcean" "split_explicit" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "split_explicit" "testing" test as "testing16wRst"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 4 vs 16 procs with RK4 - RealWorld
		Given A "QU" "240km" "worldOcean" "RK4" "testing" test as "testing4"
		Given A "QU" "240km" "worldOcean" "RK4" "testing" test as "testing16wRst"
		Given I perform a 4 processor MPAS "ocean_model_testing" run in "testing4"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 2 vs 16 procs with split explicit - BC
		Given A "10000m" "20levs" "baroclinic_channel" "split_explicit" "testing" test as "testing2"
		Given A "10000m" "20levs" "baroclinic_channel" "split_explicit" "testing" test as "testing16wRst"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 1 vs 24 procs with RK4 - BC
		Given A "10000m" "20levs" "baroclinic_channel" "RK4" "testing" test as "testing1"
		Given A "10000m" "20levs" "baroclinic_channel" "RK4" "testing" test as "testing24wRst"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 2 vs 16 procs with split explicit - Overflow
		Given A "10km" "40layer" "overflow" "split_explicit" "testing" test as "testing2"
		Given A "10km" "40layer" "overflow" "split_explicit" "testing" test as "testing16wRst"
		Given I perform a 2 processor MPAS "ocean_model_testing" run in "testing2"
		Given I perform a 16 processor MPAS "ocean_model_testing" run with restart in "testing16wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

	Scenario: 1 vs 24 procs with RK4 - Overflow
		Given A "10km" "40layer" "overflow" "RK4" "testing" test as "testing1"
		Given A "10km" "40layer" "overflow" "RK4" "testing" test as "testing24wRst"
		Given I perform a 1 processor MPAS "ocean_model_testing" run in "testing1"
		Given I perform a 24 processor MPAS "ocean_model_testing" run with restart in "testing24wRst"
		When I compute the RMS of "temperature"
		When I compute the RMS of "layerThickness"
		Then I see "temperature" RMS of 0
		Then I see "layerThickness" RMS of 0

