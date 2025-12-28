# =========================
# Stage 1.0: Build dependencies
# =========================
FROM python:3.10-slim AS builder

WORKDIR /app

# Install build tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file
COPY requirements.txt .

# Create venv and install deps
RUN python -m venv /venv \
    && /venv/bin/pip install --upgrade pip \
    && /venv/bin/pip install -r requirements.txt

# =========================
# Stage 2: Final runtime image
# =========================
FROM python:3.10-slim

WORKDIR /app

# Copy venv from builder
COPY --from=builder /venv /venv
ENV PATH="/venv/bin:$PATH"

# Copy project files
COPY . .

# Run migrations + collect static
RUN python manage.py migrate && \
    python manage.py collectstatic --noinput

EXPOSE 8000

# Run Django app with Gunicorn (production-ready)
CMD ["gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000", "--workers=3"]
