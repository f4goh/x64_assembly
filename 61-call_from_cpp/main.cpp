

#include <iostream>

using namespace std;

extern "C" int DoSum(int, int);


int main(){
 int num, plus =0;
 cout << "Enter Number: "; cin >> num;
 cout << "Enter Another: "; cin >> plus;
 cout << "Total: " << DoSum(num,plus) << endl;
 return 0;
}
