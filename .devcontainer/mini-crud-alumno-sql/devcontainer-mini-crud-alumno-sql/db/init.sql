CREATE TABLE IF NOT EXISTS personas (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS alumnos (
    codigo INT PRIMARY KEY,
    telefono VARCHAR(10),
    FOREIGN KEY (codigo) REFERENCES personas (codigo) ON DELETE CASCADE
);

INSERT IGNORE INTO
    personas (codigo, nombre)
VALUES (1, 'Juan'),
    (2, 'María'),
    (3, 'Carlos');

INSERT IGNORE INTO
    alumnos (codigo, telefono)
VALUES (1, '23644747'),
    (2, '23654539'),
    (3, '23659090');
