#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/QuantumChemistry/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for PHYSICAL CALCULATIONS (CHEM303; Winter, 2020)
Unitful adds the stripping of units, `ustrip`, method.
"""


using PhysicalConstants.CODATA2018, Unitful, SymPy, LinearAlgebra, RowEchelon


"""
Question One
"""

# Length = 1.27e-9
# N_HOMO = 5
# N_LUMO = N_HOMO + 1
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


"""
Question Two
"""

# ls=1.5e-10
# ld=1.34e-10
#
# Radius = (2*ls) + (2*ld)
# Length = 2 * pi * Radius
#
# FirstLowestEnergyLevel = 0
# SecondLowestEnergyLevel = FirstLowestEnergyLevel + 1
#
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


"""
Question Three
"""

# FundamentalOvertoneStretch = 1213.6
# FirstOvertoneStretch = 0
# SecondOvertoneStretch = 3564.6
#
# @vars ν ωe xe
#
# G(ν) = (ν + 0.5)*ωe - (ν - 0.5)^2*ωe*xe # measured in per cm
#
# ωe = 1213.6
# xe = 12.7 / ωe
#
# FundamentalTransition = G(1) - G(0)
# FirstTransition = G(2) - G(0)
# SecondTransition = G(3) - G(0)
# ThirdTransition = G(4) - G(0)
# FourthTransition = G(5) - G(0)

# println(FourthTransition)
#
# Wavelength = ωe/(ωe*xe)
# Energy = ustrip(((PlanckConstant * SpeedOfLightInVacuum) / (Wavelength))) / (1e-9)
#
#
# println("De in wavelength:\t", Wavelength, "λ")
# println("De in Joules:\t", Energy, "J")
#
# # FundamentalTransition = ωe
# # SecondTransition = ωe*xe
#
# ### Use linear algebra rref to solve for ωe and ωexe
#
# De = (FundamentalOvertoneStretch^2) / (4*SecondOvertoneStretch)
# De = (FundamentalTransition^2) / (4*SecondTransition)

# println(FundamentalTransition, " = ", FundamentalOvertoneStretch)
# println(SecondTransition, "=", SecondOvertoneStretch, "\n")
#
# A = [1 0 FundamentalOvertoneStretch; 3 -6 SecondOvertoneStretch]
#
# println(rref(A))

# println(De) # measured in per cm


"""
Question Four
"""

Wavelength = 260e-9
Energy = ustrip(((PlanckConstant * SpeedOfLightInVacuum) / (Wavelength))) / (1e-9)
EnergyeV = ustrip(Energy / ElementaryCharge)

# println("Wavelength:\t", Wavelength, " λ")
# println("Energy in J:\t", Energy, " J \n")
# println("Energy in eV:\t", EnergyeV, " eV \n")

eqn1 = (7.46e-10) / ((cos((2*pi*4)/(28) - (cos((2*pi*3)/(28))))))

println(eqn1)

eqn = abs((2.4*1.602e-19)*(cos((8*pi)/(28))-cos((6*pi)/(28))))

eqneV = eqn / 1.602e-19

Wavelength = ustrip(((PlanckConstant * SpeedOfLightInVacuum) / (eqn))) / (1e-9)

# println("Wavelength now:\t",Wavelength)
