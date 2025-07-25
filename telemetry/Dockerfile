FROM python:3.10-slim

WORKDIR /app
COPY telemetry_server.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "telemetry_server.py"]
