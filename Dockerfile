FROM python:3.9-slim
WORKDIR /app
COPY analytics/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY analytics/ .
EXPOSE 5153
CMD ["python", "app.py"]
