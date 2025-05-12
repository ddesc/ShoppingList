from flask import Blueprint, request, jsonify
import uuid
from datetime import datetime
from .db import get_connection

bp = Blueprint('main', __name__)

def execute_query(query, params=()):
    conn = get_connection()
    cursor = conn.cursor()
    
    rows = []
    cursor.execute(query, params)
    rows_affected = cursor.rowcount
    if rows_affected == -1: #indicates result set (i.e. SELECT)
        rows = cursor.fetchall()    

    conn.commit()
    conn.close()

    return (rows_affected, rows)

@bp.route('/list', methods=['GET'])
def get_list():
    sql = 'SELECT list_guid, text FROM ToDoList'
    result = execute_query(sql)

    jsonList = [{
        "id": row[0],
        "text": row[1]
    } for row in result[1]]
    
    return jsonify(jsonList)

@bp.route('/item', methods=['POST'])
def create_item():
    data = request.get_json()
    text = data.get('text', '')
    list_guid = str(uuid.uuid4())
    current_date = datetime.now()

    sql = """
        INSERT INTO ToDoList (list_guid, text, created_at, updated_at)
        VALUES (?, ?, ?, ?)
    """
    sqlParams = (list_guid, text, current_date, current_date)

    result = execute_query(sql, sqlParams)

    if result[0] > 0:
        return jsonify({"message": "Item created.", "id": list_guid}), 201
    else:
        return jsonify({"message": "Item failed to create."}), 400
    
@bp.route('/item/<string:list_guid>', methods=['DELETE'])
def delete_item(list_guid):
    sql = "DELETE FROM ToDoList WHERE list_guid = ?"
    
    result = execute_query(sql, list_guid)
    if result[0] == 0:
        return jsonify({"error": "Item not found."}), 404

    return jsonify({"message": "Item deleted."}), 200