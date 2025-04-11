from flask import Flask, render_template, request, redirect, session, url_for
import mysql.connector
from flask_bcrypt import Bcrypt

app = Flask(__name__)
app.secret_key = 'clave_secreta_para_sesiones'
bcrypt = Bcrypt(app)

# Conexión a MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",        # ← cambia esto
    password="", # ← cambia esto
    database="eestp_virtual"
)
cursor = db.cursor(dictionary=True)

# Ruta de inicio (login)
@app.route('/')
def login():
    return render_template('login.html')

# Proceso de inicio de sesión
@app.route('/iniciar_sesion', methods=['POST'])
def iniciar_sesion():
    dni = request.form['dni']
    password = request.form['password']

    cursor.execute("SELECT * FROM usuarios WHERE dni = %s", (dni,))
    user = cursor.fetchone()

    if user and bcrypt.check_password_hash(user['password'], password):
        session['usuario'] = user

        if user['rol'] == 'admin':
            return redirect(url_for('admin'))
        elif user['rol'] == 'docente':
            return redirect(url_for('docente'))
        elif user['rol'] == 'estudiante':
            return redirect(url_for('estudiante'))
    else:
        return "DNI o contraseña incorrectos"

# Panel del administrador
@app.route('/admin')
def admin():
    if 'usuario' in session and session['usuario']['rol'] == 'admin':
        return "Bienvenido, administrador"
    return redirect(url_for('login'))

# Panel del docente
@app.route('/docente')
def docente():
    if 'usuario' in session and session['usuario']['rol'] == 'docente':
        return "Bienvenido, docente"
    return redirect(url_for('login'))

# Panel del estudiante
from datetime import datetime

@app.route('/estudiante')
def estudiante():
    if 'usuario' in session and session['usuario']['rol'] == 'estudiante':
        seccion_id = session['usuario']['seccion_id']
        hoy = datetime.today().strftime('%A').lower()  # lunes, martes...

        cursor.execute("""
            SELECT hc.hora_inicio, hc.hora_fin, c.nombre AS curso, s.enlace_meet
            FROM horario_clases hc
            JOIN cursos c ON hc.curso_id = c.id
            JOIN secciones s ON hc.seccion_id = s.id
            WHERE hc.seccion_id = %s AND LOWER(hc.dia_semana) = %s
            ORDER BY hc.hora_inicio
        """, (seccion_id, hoy))

        clases = cursor.fetchall()
        return render_template('estudiante_panel.html', clases=clases)
    return redirect(url_for('login'))


# Cierre de sesión
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# Iniciar servidor
if __name__ == '__main__':
    app.run(debug=True)
