#include <iostream>
#include <stdlib.h>
#include <vector>

// vector <pair<int, float>> a;
// a[5].first;
// a[4].second;


std::string bin2rzym(std::string binary)
{

    int decimal = std::stoi(binary, nullptr, 2);
    if(decimal > 3999) exit(0);



    std::string roman;
    while (decimal >= 1000) {
        roman = roman + 'M';
        decimal = decimal - 1000;
    }
    if (decimal >= 900) {
        roman = roman + "CM";
        decimal = decimal - 900;
    }
    while (decimal >= 500) {
        roman = roman + 'D';
        decimal = decimal - 500;
    }
    if (decimal >= 400) {
        roman = roman + "CD";
        decimal = decimal - 400;
    }
    while (decimal >= 100) {
        roman = roman + 'C';
        decimal = decimal - 100;
    }
    if (decimal >= 90) {
        roman = roman + "XC";
        decimal = decimal - 90;
    }
    while (decimal >= 50) {
        roman = roman + 'L';
        decimal = decimal - 50;
    }
    if (decimal >= 40) {
        roman = roman + "XL";
        decimal = decimal - 40;
    }
    while (decimal >= 10) {
        roman = roman + 'X';
        decimal = decimal - 10;
    }
    if (decimal >= 9) {
        roman = roman + "IX";
        decimal = decimal - 9;
    }
    while (decimal >= 5) {
        roman = roman + 'V';
        decimal = decimal - 5;
    }
    if (decimal >= 4) {
        roman = roman + "IV";
        decimal = decimal - 4;
    }
    while (decimal >= 1) {
        roman = roman + 'I';
        decimal = decimal - 1;
    }
    return roman;
}


int main(int argc, char* argv[])
{
    for(int i = 1; i < argc; i++){
        // int binary = std::stoi(argv[i], nullptr, 2);
        std::cout << bin2rzym(argv[i]) << "\n";
    }
    return 0;
}