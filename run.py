from app import create_app
import os
from flask_cors import CORS

port = int(os.environ.get("PORT", 5000))

app = create_app()

CORS(app)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=port)