# use official Python image

FROM python:3.11-slim 



WORKDIR /app

#install dependencies

COPY app/requirements.txt .

RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

#copy app
COPY app/ .

#Run with uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

