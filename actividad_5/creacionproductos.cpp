#include <iostream>
#include <fstream>
using namespace std;

int main(){
    ofstream csv("productos50.csv");
    if(!csv.is_open()){
        cerr<<"Error al abrir archivo"<<endl;
        return 1;
    }
    csv<<"id|nombre|precio"<<endl;
    for(int i = 1 ; i <= 50 ; i++){
        csv<<i<<"|producto"<<i<<"|"<<i<<endl;
    }
    csv.close();
    cout<<"Archivo creado con exito"<<endl;
    return 0;
}