-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS eestp_virtual;
USE eestp_virtual;

-- Tabla: secciones
CREATE TABLE secciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20),
    enlace_meet TEXT
);

-- Tabla: cursos
CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla: usuarios (admin, docente, estudiante)
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    dni VARCHAR(10) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'docente', 'estudiante') NOT NULL,
    seccion_id INT,
    FOREIGN KEY (seccion_id) REFERENCES secciones(id)
);

-- Tabla: horario de clases
CREATE TABLE horario_clases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion_id INT,
    curso_id INT,
    dia_semana VARCHAR(10), -- 'lunes', 'martes', etc.
    hora_inicio TIME,
    hora_fin TIME,
    FOREIGN KEY (seccion_id) REFERENCES secciones(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- Tabla: asistencia
CREATE TABLE asistencia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT,
    fecha DATE,
    hora TIME,
    presente BOOLEAN,
    FOREIGN KEY (estudiante_id) REFERENCES usuarios(id)
);

-- Tabla: evaluaciones
CREATE TABLE evaluaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255),
    curso_id INT,
    seccion_id INT,
    docente_id INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id),
    FOREIGN KEY (seccion_id) REFERENCES secciones(id),
    FOREIGN KEY (docente_id) REFERENCES usuarios(id)
);

-- Tabla: preguntas
CREATE TABLE preguntas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluacion_id INT,
    enunciado TEXT,
    tipo ENUM('opcion_multiple', 'verdadero_falso'),
    FOREIGN KEY (evaluacion_id) REFERENCES evaluaciones(id)
);

-- Tabla: opciones de respuesta
CREATE TABLE opciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pregunta_id INT,
    texto TEXT,
    es_correcta BOOLEAN,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);

-- Tabla: respuestas de los estudiantes
CREATE TABLE respuestas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT,
    pregunta_id INT,
    opcion_id INT,
    fecha_respuesta DATETIME,
    FOREIGN KEY (estudiante_id) REFERENCES usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id),
    FOREIGN KEY (opcion_id) REFERENCES opciones(id)
);
