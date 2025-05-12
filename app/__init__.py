from flask import Flask

def create_app():
    app = Flask(__name__)
    
    # Register blueprints or routes
    from .routes import bp
    app.register_blueprint(bp)
    
    return app