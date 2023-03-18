FROM python:3
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt 
RUN pip install flask 
COPY . .
EXPOSE 80
CMD ["python","./python-flask.py","--host 0.0.0.0"]

