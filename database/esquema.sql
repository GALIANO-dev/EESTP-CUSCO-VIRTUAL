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
    id INT AUTO_INCREMENT PRIMARY KEY_
