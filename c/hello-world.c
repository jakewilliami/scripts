#include <stdio.h>
#include <stdint.h>

int main() {
	uint64_t dx = 0x357620655410;
	while (dx) putchar(0x726F6C6564574820 >> (((dx >>= 4) & 0377) << 3));
	return 0;
}
