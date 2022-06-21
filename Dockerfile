FROM python:3.7-slim

WORKDIR /webapp

COPY main.py .
COPY requirements.txt .
ADD ./app app
#update base image libs
RUN apt-get update
RUN pip install -r requirements.txt
#This is for documentation purpose
EXPOSE 8080/tcp
#This runs the application
CMD ["python", "main.py"]