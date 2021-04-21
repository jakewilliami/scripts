import sys, math

def nztm2latlong(X, Y):
    a = 6378137
    f = 1 / 298.257222101
    phizero = 0
    lambdazero = 173
    Nzero = 10000000
    Ezero = 1600000
    kzero = 0.9996
    N, E  = Y, X
    b = a * (1 - f)
    esq = 2 * f - pow(f, 2)
    Z0 = 1 - esq / 4 - 3 * pow(esq, 2) / 64 - 5 * pow(esq, 3) / 256
    A2 = 0.375 * (esq + pow(esq, 2) / 4 + 15 * pow(esq, 3) / 128)
    A4 = 15 * (pow(esq, 2) + 3 * pow(esq, 2) / 4) / 256
    A6 = 35 * pow(esq, 3) / 3072
    Nprime = N - Nzero
    mprime = Nprime / kzero
    smn = (a - b) / (a + b)
    G = a * (1 - smn) * (1 - pow(smn, 2)) * (1 + 9 * pow(smn, 2) / 4 + 225 * pow(smn, 4) / 64) * math.pi / 180.0
    sigma = mprime * math.pi / (180 * G)
    phiprime = sigma + (3 * smn / 2 - 27 * pow(smn, 3) / 32) * math.sin(2 * sigma) + (21 * pow(smn, 2) / 16 - 55 * pow(smn, 4) / 32) * math.sin(4 * sigma) + (151 * pow(smn, 3) / 96) * math.sin(6 * sigma) + (1097 * pow(smn, 4) / 512) * math.sin(8 * sigma)
    rhoprime = a * (1 - esq) / pow(pow((1 - esq * math.sin(phiprime)), 2), 1.5)
    upsilonprime = a / math.sqrt(1 - esq * pow(math.sin(phiprime), 2))
    psiprime = upsilonprime / rhoprime
    tprime = math.tan(phiprime)
    Eprime = E - Ezero
    chi = Eprime / (kzero * upsilonprime)
    term_1 = tprime * Eprime * chi / (kzero * rhoprime * 2)
    term_2 = term_1 * pow(chi, 2) / 12 * (-4 * pow(psiprime, 2) + 9 * psiprime * (1 - pow(tprime, 2)) + 12 * pow(tprime, 2))
    term_3 = tprime * Eprime * pow(chi, 5) / (kzero * rhoprime * 720) * (8 * pow(psiprime, 4) * (11 - 24 * pow(tprime, 2)) - 12 * pow(psiprime, 3) * (21 - 71 * pow(tprime, 2)) + 15 * pow(psiprime, 2) * (15 - 98 * pow(tprime, 2) + 15 * pow(tprime, 4)) + 180 * psiprime * (5 * pow(tprime, 2) - 3 * pow(tprime, 4)) + 360 * pow(tprime, 4))
    term_4 = tprime * Eprime * pow(chi, 7) / (kzero * rhoprime * 40320) * (1385 + 3633 * pow(tprime, 2) + 4095 * pow(tprime, 4) + 1575 * pow(tprime, 6))
    term1 = chi * (1 / math.cos(phiprime))
    term2 = pow(chi, 3) * (1 / math.cos(phiprime)) / 6 * (psiprime + 2 * pow(tprime, 2))
    term3 = pow(chi, 5) * (1 / math.cos(phiprime)) / 120 * (-4 * pow(psiprime, 3) * (1 - 6 * pow(tprime, 2)) + pow(psiprime, 2) * (9 - 68 * pow(tprime, 2)) + 72 * psiprime * pow(tprime, 2) + 24 * pow(tprime, 4))
    term4 = pow(chi, 7) * (1 / math.cos(phiprime)) / 5040 * (61 + 662 * pow(tprime, 2) + 1320 * pow(tprime, 4) + 720 * pow(tprime, 6))
    latitude = (phiprime - term_1 + term_2 - term_3 + term_4) * 180 / math.pi
    longitude = lambdazero + 180 / math.pi * (term1 - term2 + term3 - term4)
    return (latitude,  longitude)


print(nztm2latlong(int(sys.argv[1]), int(sys.argv[2])))
