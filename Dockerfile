FROM python:3.10-slim

# Install OS tools and configure Microsoft ODBC repo
RUN apt-get update && \
    apt-get install -y curl gnupg2 apt-transport-https lsb-release sudo && \
    UBUNTU_VERSION=$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2) && \
    if ! echo "20.04 22.04 24.04 24.10" | grep -q "$UBUNTU_VERSION"; then \
        echo "Ubuntu $UBUNTU_VERSION is not currently supported."; exit 1; \
    fi && \
    curl -sSL -O https://packages.microsoft.com/config/ubuntu/$UBUNTU_VERSION/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev && \
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc && \
    apt-get clean

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "run.py"]