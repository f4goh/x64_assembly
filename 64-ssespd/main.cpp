// Les intrinsics SSE sont des fonctions C++ qui génèrent directement des instructions SIMD (_mm_mul_ps, etc.) sans écrire d’ASM.
// L’ASM pur donne un contrôle total sur les registres et instructions, mais est moins lisible, moins portable et plus sujet aux erreurs.
// Avec les intrinsics, le compilateur peut optimiser la boucle, gérer l’alignement et adapter le code au CPU (SSE, AVX, AVX‑512).
// L’ASM est utile seulement pour des optimisations très fines ou des instructions spécifiques non générées par le compilateur.


#include <iostream>     // Pour cout / endl (affichage console)
#include <chrono>       // Pour mesurer le temps d'exécution
#include <xmmintrin.h>  // Pour les intrinsics SSE (__m128, _mm_mul_ps)

using namespace std;
using namespace std::chrono;

int main(){


 float arr[4]={1.00000f,2.00000f,3.00000f,4.00000f};
 float mul[4]={1.00001f,1.00002f,1.00003f,1.00004f};

 __m128 v1= _mm_load_ps(arr);

 __m128 v2= _mm_load_ps(mul);

 // Nombre d'itérations de la boucle
 const int million = 1000000;

 // Variables pour mesurer le temps
 steady_clock::time_point t1,t2;
 duration<double,milli> span;


 // ==========================
 // TEST VERSION C++
 // ==========================

  cout << "\nFour million operations:" << endl;

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


 // ==========================
 // TEST VERSION INTRINSICS SSE
 // ==========================

 // Capture du temps avant la boucle
 t1=steady_clock::now();

 // Boucle exécutée 1 million de fois
 for (int i=1;i<million;i++){

  // Multiplication SIMD :
  // _mm_mul_ps = multiply packed single precision
  // Multiplie les 4 floats de v1 par ceux de v2 en parallèle
  // v1[i] = v1[i] * v2[i]
  v1=_mm_mul_ps(v1,v2);
 }

 // Capture du temps après la boucle
 t2=steady_clock::now();

 // Calcul de la durée en millisecondes
 span= t2-t1;

 // Affichage du temps mesuré
 cout << "\n\tSSE: " << span.count() << " ms" << endl;

// ==========================
 // Affichage du contenu de v1
 // ==========================

 float result[4];                // tableau temporaire
 _mm_storeu_ps(result, v1);      // copie le contenu du registre dans le tableau

 cout << "\n\tRésultat :" << endl;
 for(int i=0;i<4;i++){
  cout << "v1[" << i << "] = " << result[i] << endl;
 }

 cout << "\n\t";

 return 0;
}

