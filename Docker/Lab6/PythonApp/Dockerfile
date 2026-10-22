FROM python:3.12-slim

WORKDIR /app

# Install application dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user for security best practice
RUN useradd -m -u 1001 appuser && chown -R appuser:appuser /app

# Copy application source code
COPY app.py .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
