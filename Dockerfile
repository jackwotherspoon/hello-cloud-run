# Use a Python image with uv pre-installed
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim

# Add Docker labels
LABEL org.opencontainers.image.source=https://github.com/jackwotherspoon/hello-cloud-run
LABEL org.opencontainers.image.description="Hello World application with FastAPI deployed to Cloud Run."
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Install the project into `/app`
WORKDIR /app

# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy

ADD . /app

# Install the project's dependencies using the lockfile and settings
RUN uv sync --frozen --no-install-project --no-dev

# Then, add the rest of the project source code and install it
# Installing separately from its dependencies allows optimal layer caching
RUN uv sync --frozen --no-dev

# Place executables in the environment at the front of the path
ENV PATH="/app/.venv/bin:$PATH"

# Reset the entrypoint, don't invoke `uv`
ENTRYPOINT []

# Run the FastAPI application by default
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]