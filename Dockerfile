# The python and operational system version
FROM python:3.12.1-alpine3.18

# The maintainer email
LABEL mantainer="diogodandrea@outlook.com"

# This environment variable is used to tell python if it should write ".pyc" files
ENV PYTHONDONTWRITEBYTECODE 1

# Defines that the python output will be immediately exhibited on the console, no buffer
ENV PYTHONUNBUFFERED 1

# Copies the "djangoapp" folder and "scripts" to the container
COPY djangoapp /djangoapp
COPY scripts /scripts

# Navigates to the "djangoapp" directory to avoid typing djangoapp/manage.py
WORKDIR /djangoapp

# The port 8000 will be avaiable for external conections. We will use it for Django
EXPOSE 8000

# RUN executes commands in a shell inside the container to build an image
# The result of the execution of the command is stored in the file system of the image as a new layer
# Grouping the commands in a single RUN can reduce the amount of layers in the image, therefore making it more efficient.
RUN python -m venv /venv && \
  /venv/bin/pip install --upgrade pip && \
  /venv/bin/pip install -r /djangoapp/requirements.txt && \
  adduser --disabled-password --no-create-home duser && \
  mkdir -p /data/web/static && \
  mkdir -p /data/web/media && \
  chown -R duser:duser /venv && \
  chown -R duser:duser /data/web/static && \
  chown -R duser:duser /data/web/media && \
  chmod -R 755 /data/web/static && \
  chmod -R 755 /data/web/media && \
  chmod -R +x /scripts

# Adds the scripts and venv/bin folders to the $PATH of the container
ENV PATH="/scripts:/venv/bin:$PATH"

# Changes the user to duser
USER duser

# Executes the file scripts/commands.sh
CMD ["commands.sh"]