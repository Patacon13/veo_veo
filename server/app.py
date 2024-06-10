from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import base64
from google.cloud import storage
import os

app = Flask(__name__)
CORS(app)
orb = cv2.ORB_create()
bf = cv2.BFMatcher(cv2.NORM_HAMMING)

# Configuracion
cliente = storage.Client.from_service_account_json('service.json')
bucket = 'veo-veo-9d124.appspot.com'
directorio = 'reconocimiento/'
diccionario = {}

def cargar_imagenes_repositorio():
    global diccionario
    diccionario = {} 
    blobs = cliente.list_blobs(bucket, prefix=directorio)
    for blob in blobs:
        bin_imagen = blob.download_as_string()
        if bin_imagen:
            cv2_imagen = cv2.imdecode(np.frombuffer(bin_imagen, np.uint8), cv2.IMREAD_COLOR)
            if cv2_imagen is not None:
                gray_image = cv2.cvtColor(cv2_imagen, cv2.COLOR_BGR2GRAY)
                keypoints, descriptores = orb.detectAndCompute(gray_image, None)
                nombre_archivo, _ = os.path.splitext(blob.name.replace(directorio, ''))
                diccionario[nombre_archivo] = (keypoints, descriptores)
            else:
                print(f'Error decodificando: {blob.name}')
        else:
            print(f'No hay data: {blob.name}')

# Cargar imágenes del repositorio al inicio
cargar_imagenes_repositorio()

def reconocer_imagen(image_usuario_path, diccionario_imagenes):
    nparr = np.frombuffer(base64.b64decode(image_usuario_path.split(',')[1]), np.uint8)
    imagen_usuario = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    gray_image_usuario = cv2.cvtColor(imagen_usuario, cv2.COLOR_BGR2GRAY)
    keypoints_usuario, descriptores_usuario = orb.detectAndCompute(gray_image_usuario, None)

    max_coincidencia = 0
    mejor_coincidencia_id = None

    for punto_id, (keypoint_punto, descriptor_punto) in diccionario_imagenes.items():
        matches = bf.knnMatch(descriptores_usuario, descriptor_punto, k=2)
        good_matches = []
        for m, n in matches:
            if m.distance < 0.75 * n.distance:
                good_matches.append(m)

        score = len(good_matches) / min(len(keypoints_usuario), len(keypoint_punto))

        if score > max_coincidencia:
            max_coincidencia = score
            mejor_coincidencia_id = punto_id

    return mejor_coincidencia_id, max_coincidencia

@app.route('/procesar', methods=['POST'])
def compare_images_route():
    imagen = request.form['imagen']
    punto_id, score = reconocer_imagen(imagen, diccionario)
    print("coincidió con: " + str(punto_id) + " con " + str(score))
    return jsonify({'punto': punto_id, 'coincidencia': score})

@app.route('/recalcular', methods=['GET']) # se podria hacer post y recibir algun token para validar 
def recalcular_vectores():
    cargar_imagenes_repositorio()
    return jsonify({'status': 'Vectores recalculados con éxito'})

if __name__ == '__main__':
    app.run(debug=True)
