# use official Python image

FROM python:3.11-slim 



WORKDIR /app

#install dependencies

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

#copy app
COPY . .

#Run with uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

