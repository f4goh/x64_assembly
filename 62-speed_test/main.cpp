#include <iostream>     // Pour cout / endl
#include <chrono>       // Pour mesurer le temps d'exécution

using namespace std;
using namespace std::chrono;

// Déclaration d'une fonction externe écrite en assembleur
// Elle prend :
//   - un pointeur vers float (arr)
//   - un pointeur vers float (mul)
//   - un entier (nombre d'itérations)
// Le "extern C" évite le name mangling C++
extern "C" int DoRun(float*, float*, int);

int main(){

 // Tableau de 64 floats
 // Seuls les 4 premiers sont initialisés explicitement
 // Les autres seront automatiquement initialisés à 0.0f
 float arr[64]={1.00000f,2.00000f,3.00000f,4.00000f};

 // Tableau multiplicateur
 // Même principe : 4 valeurs utiles, le reste à 0
 float mul[64]={1.00002f,1.00002f,1.00001f,1.00001f};

 // Nombre d'itérations de la boucle externe
 const int million = 1000000;

 // Variables pour mesurer le temps
 steady_clock::time_point t1,t2;
 duration<double,milli> span;

 // ==========================
 // TEST VERSION C++
 // ==========================

 // Début mesure
 t1=steady_clock::now();

 // Boucle externe (1 million d'itérations)
 for (int i=1;i<million;i++){

  // Boucle interne sur 4 floats
  for (int j=0;j<4;j++){

    // Multiplication élément par élément
    arr[j]*=mul[j];
  }
 }

 // Fin mesure
 t2=steady_clock::now();

 // Calcul durée
 span= t2-t1;

 // Affichage temps d'exécution C++
 cout << "\n\tC++: " << span.count() << " ms" << endl;

 // Affichage des 4 premières valeurs du tableau
 // Permet d'éviter que le compilateur optimise tout
 for (int n=0;n<4;n++){
  cout << "n=" << n << ":"<< arr[n] << endl;
 }

 // ==========================
 // TEST VERSION ASM
 // ==========================

 // Début mesure
 t1=steady_clock::now();

 // Appel de la fonction assembleur
 // Elle exécute la même logique en théorie
 DoRun(arr,mul,million);

 // Fin mesure
 t2=steady_clock::now();

 // Calcul durée
 span= t2-t1;

 // Affichage temps d'exécution ASM
 cout << "\n\tASM: " << span.count() << " ms" << endl;
 
 // Affichage des résultats après ASM
 for (int n=0;n<4;n++){
  cout << "n=" << n << ":"<< arr[n] << endl;
 }

 cout << "\n\t";

 return 0;
}
