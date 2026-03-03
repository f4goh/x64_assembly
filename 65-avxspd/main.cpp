// Les intrinsics AVX sont des fonctions C++ qui génèrent directement des instructions SIMD (_mm256_mul_ps, etc.) 
// sans écrire d’ASM.
// L’ASM pur donne un contrôle total sur les registres et instructions, mais est moins lisible, moins portable et plus sujet aux erreurs.
// Avec les intrinsics, le compilateur peut optimiser la boucle, gérer l’alignement et adapter le code au CPU (SSE, AVX, AVX‑512).
// L’ASM est utile seulement pour des optimisations très fines ou des instructions spécifiques non générées par le compilateur.

#include <iostream>     // Pour cout / endl (affichage console)
#include <chrono>       // Pour mesurer le temps d'exécution
#include <immintrin.h>  // Pour les intrinsics AVX (__m256 et _mm256_*)

using namespace std;
using namespace std::chrono;

int main(){

    // Tableaux alignés sur 32 octets pour AVX
    alignas(32) float arr[8]={1.0f,2.0f,3.0f,4.0f,5.0f,6.0f,7.0f,8.0f};
    alignas(32) float mul[8]={1.00001f,1.00002f,1.00003f,1.00004f,1.00005f,1.00006f,1.00007f,1.00008f};

    // Nombre d'itérations de la boucle
    const int million = 1000000;

    // Variables pour mesurer le temps
    steady_clock::time_point t1,t2;
    duration<double,milli> span;

    // Charger les 8 floats dans des registres AVX
    __m256 v1= _mm256_load_ps(arr);
    __m256 v2= _mm256_load_ps(mul);

    // ==========================
    // TEST VERSION C++ classique
    // ==========================
    cout << "\nEight million operations:" << endl;

    t1=steady_clock::now();

    // Boucle externe : 1 million d'itérations
    for (int i=1;i<million;i++){
        // Boucle interne sur 8 floats
        for (int j=0;j<8;j++){
            // Multiplication élément par élément
            arr[j]*=mul[j];
        }
    }

    t2=steady_clock::now();
    span= t2-t1;

    // Affichage temps d'exécution C++
    cout << "\n\tC++: " << span.count() << " ms" << endl;

    // ==========================
    // TEST VERSION INTRINSICS AVX
    // ==========================
    t1=steady_clock::now();

    // Boucle externe : 1 million d'itérations
    for (int i=1;i<million;i++){
        // Multiplication SIMD AVX :
        // _mm256_mul_ps multiplie 8 floats en parallèle
        v1=_mm256_mul_ps(v1,v2);
    }

    t2=steady_clock::now();
    span= t2-t1;

    // Affichage temps d'exécution AVX
    cout << "\n\tAVX: " << span.count() << " ms" << endl;

    cout << "\n\t";

    return 0;
}
