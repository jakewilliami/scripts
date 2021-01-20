// compile using g++ -std=c++11 convert-arab-rom.c
// run using a.out <ints> | awk 'NF > 0'
// help from https://www.unicodeit.net/
// and https://www.branah.com/unicode-converter

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <locale>

typedef struct radix {
    int  digit;
    char roman;
    char romanNext;
} RADIX;

// typedef std::basic_string<char32_t> stringUTF32;
// constexpr char32_t overline_m = U'\U0000004d\U00000305';
// constexpr char32_t overline_d = U'\U0000FEFF';
// constexpr char32_t overline_c = U'\U0000FEFF';
// constexpr char32_t overline_l = U'\U0000FEFF';
// constexpr char32_t overline_x = U'\U0000FEFF';
// constexpr char32_t overline_v = U'\U0000FEFF';

std::string *roman(int num, std::string *buff) {
    static RADIX table[]={
        // { 1ei, 'rom(i)', 'rom(5*i)' }
        // { 1000000, '\x4d\xcc\x85', '?' },// M̅
        // {  100000, '\x43\xcc\x85', '\x44\xcc\x85' },// C̅, D̅
        // {   10000, '\x58\xcc\x85', '\x4c\xcc\x85' },// X̅, L̅
        // {    1000, 'M',            '\x56\xcc\x85' },// V̅
        // {     100, 'C',            'D' },
        // {      10, 'X',            'L' },
        // {       1, 'I',            'V' }
        // { 1000000, '\x4d\xcc\x85', '?' },// M̅
        // {  100000, '\x43\xcc\x85', '\x44\xcc\x85' },// C̅, D̅
        // {   10000, '\x58\xcc\x85', '\x4c\xcc\x85' },// X̅, L̅
        // {    1000, 'M',            '\x56\xcc\x85' },// V̅
        // {     100, 'C',            'D' },
        // {      10, 'X',            'L' },
        // {       1, 'I',            'V' }
        { 1000000, 'M̅', '?' },
        {  100000, 'C̅', 'D̅' },
        {   10000, 'X̅', 'L̅' },
        {    1000, 'M', 'V̅' },
        {     100, 'C', 'D' },
        {      10, 'X', 'L' },
        {       1, 'I', 'V' }
    };
    int tableSize = sizeof(table)/sizeof(RADIX);
    int i, j, n;
    char *p;

    // if(num < 0 || num >=4000){
    if(num < 0 || num >1000000){
        *buff='\0';
        return NULL;
    }
    for(i=0,p=buff;i<tableSize;i++){
        n = num / table[i].digit;
        if( 1 <= n && n <=3 ){
            for(j=0;j<n;j++)
                *p++=table[i].roman;
        } else if(n == 4){
            *p++=table[i].roman;
            *p++=table[i].romanNext;
        } else if(n == 5){
            *p++=table[i].romanNext;
        } else if(6<= n && n <=8){
            *p++=table[i].romanNext;
            for(j=0;j< n-5;++j)
                *p++=table[i].roman;
        } else if(n == 9){
            *p++=table[i].roman;
            *p++=table[i-1].roman;
        }
        num -= n * table[i].digit;
    }
    *p='\0';
    return buff;
}

int main(int argc, char** argv){
    char buff[16];

    for (int i = 0; i < argc; ++i){
        if(roman(atoi(argv[i]), buff))
            // printf("%s\n", buff);
            // std::cout << overline_m;
            std::cout << buff;
    }
    return 0;
}
