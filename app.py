from flask import Flask
app = Flask(__name__)

@app.route("/")
def inicio():
    return "Bienvenido al sistema EESTP-CUSCO-VIRTUAL"

if __name__ == "__main__":
    app.run(debug=True)
