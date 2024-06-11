#include <iostream>
#include <fstream>
#include <random>
using namespace std;

bool one(int n){
    if(n < 10) return true;
    else return false;
}

string date(mt19937& generate){
    int maxday[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    uniform_int_distribution<int> year(2014, 2024);
    uniform_int_distribution<int> month(1, 12);
    int y = year(generate);
    int m = month(generate);
    uniform_int_distribution<int> day(1, maxday[m - 1]);
    int d = day(generate);
    string date;
    date = to_string(y)+"-";
    if(one(m)) date += "0"+to_string(m)+"-";
    else date += to_string(m)+"-";
    if(one(d)) date += "0"+to_string(d);
    else date += to_string(d);
    return date;
}

int cant(mt19937& generate){
    uniform_int_distribution<int> cant(1,10);
    return cant(generate);
}

int main(){
    random_device randomizer;
    mt19937 generate(randomizer());
    int producto = 1;
    ofstream csv("ventas50mil.csv");
    if(!csv.is_open()){
        cerr<<"Error al abrir archivo"<<endl;
        return 1;
    }
    csv<<"codigo_cliente|codigo_producto|cantidad|fecha_venta"<<endl;
    for(int i = 1 ; i <= 5000 ; i++){
        for(int j = 0 ; j < 10 ; j++){
            producto = producto > 50 ? 1 : producto;
            csv<<i<<"|"<<producto<<"|"<<cant(generate)<<"|"<<date(generate)<<endl;
            producto++;
        }
    }
    csv.close();
    cout<<"Archivo creado con exito"<<endl;
    return 0;
}
