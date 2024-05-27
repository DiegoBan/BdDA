from elasticsearch import Elasticsearch
from dotenv import load_dotenv
import asyncio
import csv
import os
import sys
import time

async def main():
    load_dotenv()
    CLOUD_ID = os.getenv("CLOUD_ID")
    ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD")
    client = Elasticsearch(
        cloud_id=CLOUD_ID,
        basic_auth=("elastic", ELASTIC_PASSWORD),
        timeout=30,
        retry_on_timeout=True
    )

    if client.ping():
        print("Conexión exitosa")
    else:
        print("No se pudo establecer conexión")
        sys.exit()

    startTime = time.time()
    carpeta = os.path.abspath('output')
    archivos_csv = [archivo for archivo in os.listdir(carpeta) if archivo.endswith('.csv')]

    for archivo in archivos_csv:
        name = "music-" + archivo.replace('.csv', '')
        StartInsertion = time.time()
        try:
            resp = await asyncio.to_thread(client.indices.create, index=name)
            print(f"Indice: {name} Respuesta: {resp['acknowledged']}")
        except Exception as e:
            print(f"Error al crear el índice {name}: {e}")

        with open(os.path.join(carpeta, archivo), 'r', newline='', encoding='latin-1') as csv_file:
            lector_csv = csv.reader(csv_file, delimiter='|')
            ID = 1
            for fila in lector_csv:
                doc = {
                    'Url': fila[0],
                    'Artist': fila[1],
                    'Title': fila[2],
                    'Lyric': fila[3]
                }
                try:
                    await asyncio.to_thread(client.index, index=name, id=ID, body=doc)
                except Exception as e:
                    print(f"Error al indexar el documento ID {ID} en el índice {name}: {e}")
                ID += 1
        EndInsertion = time.time()
        FinalInsertion = EndInsertion - StartInsertion
        print(f"Inserción de csv tomó un timepo de: {FinalInsertion} segundos")

    endTime = time.time()
    demora = endTime - startTime

    print(f"El tiempo total de la inserción es {demora} segundos")

asyncio.run(main())
