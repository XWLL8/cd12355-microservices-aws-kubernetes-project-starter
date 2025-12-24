FROM public.ecr.aws/docker/library/python:3.10-slim-bookworm

WORKDIR /app

RUN apt update -y && \
    apt install -y gcc python3-dev libpq-dev build-essential && \
    apt clean

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 5153

CMD ["python", "app.py"]
