from elasticsearch import Elasticsearch
from dotenv import load_dotenv
import os
import sys

load_dotenv()
CLOUD_ID = os.getenv("CLOUD_ID")
ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD")

client = Elasticsearch(
    cloud_id=CLOUD_ID,
    basic_auth=("elastic", ELASTIC_PASSWORD)
)

if client.ping():
    print("Conexión exitosa")
else:
    print("No se pudo establecer conexión")
    sys.exit()

indices = client.indices.get_alias(index="music*")
print("Índices encontrados:")
for index_name in indices:
    print(index_name)

for index_name in indices:
    response = client.indices.delete(index=index_name)
    if response['acknowledged']:
        print(f"Índice {index_name} eliminado exitosamente")
    else:
        print(f"Error al eliminar el índice {index_name}")