FROM python:3.9
WORKDIR /app
COPY . /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
#EXPOSE 5000
#CMD ["python", "app.py"]
EXPOSE 8020
CMD gunicorn --bind 0.0.0.0:8020 app:app


