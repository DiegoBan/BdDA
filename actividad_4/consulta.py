# se debe instalar: Python3 -m pip install elasticsearch
# se debe instalar: Python3 -m pip install python-dotenv

from elasticsearch import Elasticsearch
from dotenv import load_dotenv
import os
import sys
import time

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

frase = input("Ingrese frase: ")
queryBod = {
    "query": {
        "match_phrase": {
            "Lyric": frase
        }
    }
}

startTime = time.time()
indices = client.cat.indices(format='json')
musicInd = [index['index'] for index in indices if index['index'].startswith('music-')]
res = client.search(index=','.join(musicInd), body=queryBod)

print(f"Canciones que contienen '{frase}'")
for cancion in res['hits']['hits']:
    source = cancion['_source']
    print(f"Artista: '{source['Artist']}' | Title: '{source['Title']}'")

endTime = time.time()
demora = endTime - startTime
print(f"La busqueda tomó un tiempo de {demora} segundos")