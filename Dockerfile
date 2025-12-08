FROM public.ecr.aws/docker/library/python:3.10-slim-bookworm

# Set the working directory
WORKDIR /app

# Install system dependencies needed by psycopg2 and SQLAlchemy
RUN apt update -y && \
    apt install -y gcc python3-dev libpq-dev build-essential && \
    apt clean

# Copy requirements first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Expose the default port your app uses
EXPOSE 5153

# Run your Flask app
CMD ["python", "app.py"]
