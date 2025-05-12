# Start with a Python base image
FROM python:3.10-slim

# Install required packages and the ODBC driver
RUN apt-get update && \
    apt-get install -y curl gnupg lsb-release sudo && \
    # Add Microsoft's key and package list for ODBC Driver
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list && \
    # Update the apt package list again
    apt-get update && \
    # Install ODBC Driver 18 for SQL Server
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    # Optional: Install mssql-tools (bcp, sqlcmd)
    ACCEPT_EULA=Y apt-get install -y mssql-tools18 && \
    # Add mssql-tools to the path
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc && \
    source ~/.bashrc && \
    # Optional: Install unixODBC development headers
    apt-get install -y unixodbc-dev

# Set the working directory in the container
WORKDIR /app

# Copy your project files into the container
COPY . .

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port your app runs on (e.g., 5000 for Flask/FastAPI)
EXPOSE 5000

# Run the application (adjust if necessary)
CMD ["python", "run.py"]