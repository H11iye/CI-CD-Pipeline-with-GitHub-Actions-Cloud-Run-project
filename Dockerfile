# use official Python image

FROM python:3.11-slim 



WORKDIR /app

#install dependencies

COPY app/requirements.txt .

RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

#copy app
COPY app/ .

# Expose port for Cloud Run
EXPOSE 8080

#Run FastAPI with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]

