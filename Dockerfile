# Multi-stage build: React frontend + FastAPI backend (single service)
FROM node:20-alpine AS frontend-build
WORKDIR /app/frontend

# Install deps (better layer caching)
COPY frontend/package.json frontend/yarn.lock ./
RUN yarn install --frozen-lockfile

# Build
COPY frontend/ ./
RUN yarn build


FROM python:3.11-slim AS runtime
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app/backend

# Install Python deps
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ ./

# Copy built frontend into backend/static (served by FastAPI)
COPY --from=frontend-build /app/frontend/build ./static

# Railway provides PORT; default to 8000 locally
CMD ["sh", "-c", "uvicorn server:app --host 0.0.0.0 --port ${PORT:-8000}"]
