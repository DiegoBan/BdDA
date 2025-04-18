#include <iostream>
#include <fstream>
#include <random>
using namespace std;

bool one(int n){
    if(n < 10) return true;
    else return false;
}

string date(int dia, int mes, int year){
    string date = to_string(year)+"-";
    if(one(mes)) date += "0"+to_string(mes)+"-";
    else date += to_string(mes)+"-";
    if(one(dia)) date += "0"+to_string(dia);
    else date += to_string(dia);
    return date;
}

int cant(mt19937& generate){
    uniform_int_distribution<int> cant(1,10);
    return cant(generate);
}

int sellsDay(mt19937& generate){
    uniform_int_distribution<int> dias(5,40);
    return dias(generate);
}

int main(){
    random_device randomizer;
    mt19937 generate(randomizer());
    int producto = 1;
    int maxday[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int year = 2015, mes = 0, dia = 1, cliente = 1, count = 0;
    int sells = sellsDay(generate);
    ofstream csv("ventas50mil.csv");
    if(!csv.is_open()){
        cerr<<"Error al abrir archivo"<<endl;
        return 1;
    }
    csv<<"id|codigo_cliente|codigo_producto|cantidad|fecha_venta"<<endl;
    for(int i = 1 ; i <= 50000 ; i++){
        producto = producto > 50 ? 1 : producto;
        cliente = cliente > 5000 ? 1 : cliente;
        if(dia > maxday[mes]){
            dia = 1;
            mes++;
        }
        if(mes > 11){
            mes = 0;
            year++;
        }
        csv<<i<<"|"<<cliente<<"|"<<producto<<"|"<<cant(generate)<<"|"<<date(dia,mes+1,year)<<endl;
        if(count == sells){
            dia++;
            count = 0;
            sells = sellsDay(generate);
        }
        count++;
        producto++;
        cliente++;
    }
    csv.close();
    cout<<"Archivo creado con exito"<<endl;
    return 0;
}