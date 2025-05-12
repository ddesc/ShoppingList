from app.db import get_connection
from flask import Blueprint, request, jsonify
import json

def execute_query(query, params=()):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    rows_affected = cursor.rowcount
    rows = cursor.fetchall()
    conn.commit()
    conn.close()

    return (rows_affected, rows)


sql = 'select list_guid, text from ToDoList'
var = execute_query(sql)

result = [{
    "id": row[0],
    "text": row[1]
} for row in var[1]]
        
# json = jsonify(result)

print(json.dumps(result, indent=4))