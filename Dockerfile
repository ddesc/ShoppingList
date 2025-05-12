# FROM ubuntu:22.04

# # Install dependencies
# RUN apt-get update && apt-get install -y \
#     curl \
#     apt-transport-https \
#     ca-certificates \
#     gnupg \
#     unixodbc \
#     unixodbc-dev \
#     && rm -rf /var/lib/apt/lists/*

# # Add Microsoft package and install ODBC tools
# RUN curl -sSL https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
#     && dpkg -i packages-microsoft-prod.deb \
#     && rm packages-microsoft-prod.deb \
#     && apt-get update \
#     && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev \
#     && echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /etc/profile

# # Add your app files
# WORKDIR /app
# COPY . .

# # Your install/run commands go here, e.g.:
# RUN pip install -r requirements.txt
# CMD ["python", "app.py"]

FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl gnupg apt-transport-https unixodbc unixodbc-dev \
    && curl -sSL https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 \
    && echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /etc/profile \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy code
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt
RUN pip install flask-cors

# Start the app (update this to match your entry point)
CMD ["python", "main.py"]