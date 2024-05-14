from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import base64

app = Flask(__name__)
CORS(app)

orb = cv2.ORB_create()
bf = cv2.BFMatcher(cv2.NORM_HAMMING)

image_path2 = 'colgante.jpg'
image2 = cv2.imread(image_path2)
gray_image2 = cv2.cvtColor(image2, cv2.COLOR_BGR2GRAY)
keypoints2, descriptors2 = orb.detectAndCompute(gray_image2, None)

image_path3 = 'molino.png'
image3 = cv2.imread(image_path3)
gray_image3 = cv2.cvtColor(image3, cv2.COLOR_BGR2GRAY)
keypoints3, descriptors3 = orb.detectAndCompute(gray_image3, None)



def compare_images(image_path1, reference_images):
    # Convertir la imagen recibida en formato base64 a una imagen OpenCV
    nparr = np.frombuffer(base64.b64decode(image_path1.split(',')[1]), np.uint8)
    image1 = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # Convertir imagen a escala de grises y detectar puntos clave y descriptores
    gray_image1 = cv2.cvtColor(image1, cv2.COLOR_BGR2GRAY)
    keypoints1, descriptors1 = orb.detectAndCompute(gray_image1, None)

    max_similarity = 0
    best_match_id = None

    # Comparar con cada imagen de referencia
    for ref_id, (keypoints2, descriptors2) in reference_images.items():
        # Hacer coincidir los descriptores de características de las dos imágenes
        matches = bf.knnMatch(descriptors1, descriptors2, k=2)

        # Aplicar el filtro de razón de Lowe para eliminar coincidencias incorrectas
        good_matches = []
        for m, n in matches:
            if m.distance < 0.75 * n.distance:
                good_matches.append(m)

        # Calcular el puntaje de similitud basado en el número de buenas coincidencias
        similarity_score = len(good_matches) / min(len(keypoints1), len(keypoints2))

        # Actualizar el mejor puntaje y la mejor coincidencia
        if similarity_score > max_similarity:
            max_similarity = similarity_score
            best_match_id = ref_id

    return best_match_id, max_similarity

# Crear un diccionario de imágenes de referencia con sus identificadores
reference_images = {'1': (keypoints2, descriptors2), '2': (keypoints3, descriptors3)}

@app.route('/compare_images', methods=['POST'])
def compare_images_route():
    image1 = request.form['image1']
    best_match_id, similarity_score = compare_images(image1, reference_images)
    print("coincidió con: " + best_match_id + " con " + str(similarity_score))
    return jsonify({'best_match_id': best_match_id, 'similarity_score': similarity_score})

if __name__ == '__main__':
    app.run(debug=True)
