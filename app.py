from flask import Flask
from flask_wtf.csrf import CSRFProtect

app = Flask(__name__)

# REQUIRED for CSRF protection
app.config["SECRET_KEY"] = "change-this-to-a-secure-random-value"

csrf = CSRFProtect(app)

@app.route("/")
def home():
    return "DevSecOps Pipeline Running in AWS!"
