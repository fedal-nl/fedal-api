FROM python:3.13-slim

# Install uv
RUN pip install uv

# Set workdir
WORKDIR /app

# Copy project files
COPY pyproject.toml /app/
COPY . /app/

# Install dependencies with uv
RUN uv sync --no-dev --frozen

ENV PATH="/app/.venv/bin:$PATH"

# Collect static files during build
RUN uv run python manage.py collectstatic --noinput

# Expose port
EXPOSE 8000

# Run Django with uvicorn via ASGI
CMD ["uv", "run", "uvicorn", "fedal_api.asgi:application", "--host", "0.0.0.0", "--port", "8000"]