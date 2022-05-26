FROM python:3.7-slim

WORKDIR /webapp

COPY main.py .
COPY requirements.txt .
ADD ./app app

RUN pip install -r requirements.txt

EXPOSE 8080/tcp

CMD ["python", "main.py"]