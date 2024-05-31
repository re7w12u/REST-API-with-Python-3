# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.9.19-alpine3.20

EXPOSE 8000
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VERSION=1.1.11 


RUN apk add --no-cache python3-dev gcc libc-dev musl-dev openblas gfortran build-base postgresql-libs postgresql-dev libffi-dev curl

COPY runserver.py poetry.lock pyproject.toml requirements.txt ./
# use built-in pip to access poetry 
RUN pip install poetry
RUN pip install -r requirements.txt

# start installing things with poetry
COPY poetry.lock pyproject.toml ./
RUN poetry config virtualenvs.create false


RUN poetry install --no-interaction --no-ansi

COPY ./code /app

# # Creates a non-root user with an explicit UID and adds permission to access the /app folder
# # For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser
CMD ["poetry", "run", "-v", "python", "runserver.py"]
