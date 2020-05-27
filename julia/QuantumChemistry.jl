#! /usr/bin/env julia


# import Pkg; Pkg.add("PhysicalConstants")
# import Pkg; Pkg.add("Unitful") # adds the stripping of units, `ustrip`, method.
using PhysicalConstants.CODATA2018, Unitful

#########################################################################
# EXAMPLE for PHYSICAL CALCULATIONS (CHEM303; Winter, 2020)
#########################################################################

#####################################################################################################################################
# QUESTION ONE
#####################################################################################################################################

# Length = (1.4 * 22) / 1e10
# N_HOMO = 11
# N_LUMO = 12
#
# EnergyHOMO = ustrip((ReducedPlanckConstant^2 * pi^2 * N_HOMO^2) / (2 * ElectronMass * Length^2))
# EnergyHOMOeV = ustrip(EnergyHOMO / ElementaryCharge)
#
# EnergyLUMO = ustrip((ReducedPlanckConstant^2 * pi^2 * N_LUMO^2) / (2 * ElectronMass * Length^2))
# EnergyLUMOeV = ustrip(EnergyLUMO / ElementaryCharge)
#
# EnergyTransition = EnergyLUMO - EnergyHOMO
# EnergyTransitioneV = EnergyLUMOeV - EnergyHOMOeV
#
# Wavelength = ustrip(((PlanckConstant * SpeedOfLightInVacuum) / (EnergyTransition))) / (1e-9)
#
# println("HOMO Energy:\t\t\t\t", EnergyHOMO, " J")
# println("HOMO Energy in eV:\t\t\t", EnergyHOMOeV, " eV\n")
#
# println("LUMO Energy:\t\t\t\t", EnergyLUMO, " J")
# println("LUMO Energy in eV:\t\t\t", EnergyLUMOeV, " eV\n")
#
# println("HOMO-LUMO Transition Energy:\t\t", EnergyTransition, " J")
# println("HOMO-LUMO Transition Energy in eV:\t", EnergyTransition, " eV\n")
# #
# println("HOMO-LUMO Transition Wavelength:\t", Wavelength, " nm\n")


#####################################################################################################################################
# QUESTION TWO
#####################################################################################################################################

# Radius = 0.529 / 1e10
# Length = 2 * pi * Radius
#
# FirstLowestEnergyLevel = 0
# SecondLowestEnergyLevel = 1
#
# FirstLowestEnergy = ustrip((2 * pi^2 * PlanckConstant^2 * FirstLowestEnergyLevel^2) / (ElectronMass * Length^2))
# SecondLowestEnergy = ustrip((2 * pi^2 * PlanckConstant^2 * SecondLowestEnergyLevel^2) / (ElectronMass * Length^2))
#
# FirstLowestEnergyeV = ustrip(FirstLowestEnergy / ElementaryCharge)
# SecondLowestEnergyeV = ustrip(SecondLowestEnergy / ElementaryCharge)
#
#
# EnergyDifference = SecondLowestEnergy - FirstLowestEnergy
#
# Wavelength = ustrip(((PlanckConstant * SpeedOfLightInVacuum) / (EnergyDifference))) / (1e-9)
#
# println("Energy at j=0:\t\t\t", FirstLowestEnergy, " J")
# println("Energy at j=0 in eV:\t\t", FirstLowestEnergyeV, " eV\n")
#
# println("Energy at j=1:\t\t\t", SecondLowestEnergy, " J")
# println("Energy at j=1 in eV:\t\t", SecondLowestEnergyeV, " eV\n")
#
# println("Transitional Wavelength:\t", Wavelength, " nm")

#####################################################################################################################################
# QUESTION FOUR
#####################################################################################################################################

eqn = abs((2.4*1.602e-19)*(cos((8*pi)/(28))-cos((6*pi)/(28))))

eqneV = eqn / 1.602e-19

Wavelength = ustrip(((PlanckConstant * SpeedOfLightInVacuum) / (eqn))) / (1e-9)

println(Wavelength)
