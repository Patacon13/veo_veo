FROM python:3.9-slim


WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copia las credenciales del servicio
COPY service.json /app/service.json

# Establece la variable de entorno para Google Cloud Storage
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/service.json

EXPOSE 8000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
