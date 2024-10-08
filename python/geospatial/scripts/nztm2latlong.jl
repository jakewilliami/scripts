function nztm2latlong(X, Y)
    a = 6378137
    f = 1 / 298.257222101
    ϕ0 = 0
    λ0 = 173
    N0 = 10000000
    E0 = 1600000
    k0 = 0.9996
    N, E  = Y, X
    b = a * (1 - f)
    esq = 2 * f - (f ^ 2)
    Z0 = 1 - esq / 4 - 3 * (esq ^ 2) / 64 - 5 * (esq ^ 3) / 256
    A2 = 0.375 * (esq + (esq ^ 2) / 4 + 15 * (esq ^ 3) / 128)
    A4 = 15 * ((esq ^ 2) + 3 * (esq ^ 2) / 4) / 256
    A6 = 35 * (esq ^ 3) / 3072
    N′ = N - N0
    m′ = N′ / k0
    smn = (a - b) / (a + b)
    G = a * (1 - smn) * (1 - (smn ^ 2)) * (1 + 9 * (smn ^ 2) / 4 + 225 * (smn ^ 4) / 64) * π / 180.0
    σ = m′ * π / (180 * G)
    ϕ′ = σ + (3 * smn / 2 - 27 * (smn ^ 3) / 32) * sin(2 * σ) + (21 * (smn ^ 2) / 16 - 55 * (smn ^ 4) / 32) * sin(4 * σ) + (151 * (smn ^ 3) / 96) * sin(6 * σ) + (1097 * (smn ^ 4) / 512) * sin(8 * σ)
    ρ′ = a * (1 - esq) / (((1 - esq * sin(ϕ′)) ^ 2) ^ 1.5)
    υ′ = a / sqrt(1 - esq * (sin(ϕ′) ^ 2))
    ψ′ = υ′ / ρ′
    t′ = tan(ϕ′)
    E′ = E - E0
    χ = E′ / (k0 * υ′)
    term_1 = t′ * E′ * χ / (k0 * ρ′ * 2)
    term_2 = term_1 * (χ ^ 2) / 12 * (-4 * (ψ′ ^ 2) + 9 * ψ′ * (1 - (t′ ^ 2)) + 12 * (t′ ^ 2))
    term_3 = t′ * E′ * (χ ^ 5) / (k0 * ρ′ * 720) * (8 * (ψ′ ^ 4) * (11 - 24 * (t′ ^ 2)) - 12 * (ψ′ ^ 3) * (21 - 71 * (t′ ^ 2)) + 15 * (ψ′ ^ 2) * (15 - 98 * (t′ ^ 2) + 15 * (t′ ^ 4)) + 180 * ψ′ * (5 * (t′ ^ 2) - 3 * (t′ ^ 4)) + 360 * (t′ ^ 4))
    term_4 = t′ * E′ * (χ ^ 7) / (k0 * ρ′ * 40320) * (1385 + 3633 * (t′ ^ 2) + 4095 * (t′ ^ 4) + 1575 * (t′ ^ 6))
    term1 = χ * (1 / cos(ϕ′))
    term2 = (χ ^ 3) * (1 / cos(ϕ′)) / 6 * (ψ′ + 2 * (t′ ^ 2))
    term3 = (χ ^ 5) * (1 / cos(ϕ′)) / 120 * (-4 * (ψ′ ^ 3) * (1 - 6 * (t′ ^ 2)) + (ψ′ ^ 2) * (9 - 68 * (t′ ^ 2)) + 72 * ψ′ * (t′ ^ 2) + 24 * (t′ ^ 4))
    term4 = (χ ^ 7) * (1 / cos(ϕ′)) / 5040 * (61 + 662 * (t′ ^ 2) + 1320 * (t′ ^ 4) + 720 * (t′ ^ 6))
    latitude = (ϕ′ - term_1 + term_2 - term_3 + term_4) * 180 / π
    longitude = λ0 + 180 / π * (term1 - term2 + term3 - term4)
    return latitude, longitude
end

println(nztm2latlong(parse(Int128, ARGS[1]), parse(Int128, ARGS[2])))
