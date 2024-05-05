nombre_archivo = 'millones50'

with open(nombre_archivo, 'r') as archivo_lectura:
    with open('millones50-nuevo', 'w') as archivo_escritura:
        for linea in archivo_lectura:
            linea_sin_espacios =linea.replace(" ", "")
            archivo_escritura.write(linea_sin_espacios)


