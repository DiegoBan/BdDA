nombre_archivo = 'diezmil'

duplicados = set() #aca se almacenan los valores unicos encontrados


with open(nombre_archivo, 'r') as archivo_lectura:
    with open('diezmil-nuevo', 'w') as archivo_escritura:
        for linea in archivo_lectura:
            rut = linea.strip().split('|')[0]
            #vericar si el valor esta duplicado
            if rut not in duplicados:
                archivo_escritura.write(linea) #escribir la linea en el archivo de salida
                duplicados.add(rut) #agregar valor a los duplicados
