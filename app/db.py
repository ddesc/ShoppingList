import pyodbc

conn_str = (
    "Driver={ODBC Driver 18 for SQL Server};"
    "Server=tcp:dcjs-todolist.database.windows.net,1433;"
    "Database=ToDoList;"
    "Uid=apiuser;"
    "Pwd=DCJSPASS123!;"
    "Encrypt=yes;"
    "TrustServerCertificate=no;"
    "Connection Timeout=30;"
)

def get_connection():
    return pyodbc.connect(conn_str)