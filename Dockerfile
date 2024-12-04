# Stage 1: Build dependencies
FROM python:3.11-slim

RUN pip install poetry

# Set working directory
WORKDIR /app

# Copy only dependency files first
COPY pyproject.toml poetry.lock ./

# Configure poetry to not create virtual environment
RUN poetry config virtualenvs.create false

# Install dependencies
RUN poetry install

# Copy application code
COPY . .

# Add the application directory to PYTHONPATH
ENV PYTHONPATH=/app:$PYTHONPATH

# Expose the port FastAPI runs on
EXPOSE 80

# Run the prestart script and start the server
CMD ["sh", "-c", "poetry run bash ./prestart.sh && poetry run uvicorn app.main:app --host 0.0.0.0 --port 80 --reload"]
