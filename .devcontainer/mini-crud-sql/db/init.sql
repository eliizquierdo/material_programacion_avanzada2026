CREATE TABLE IF NOT EXISTS personas (
    codigo INT(8),
    nombre VARCHAR(10) NOT NULL,
    PRIMARY KEY (codigo)
);

INSERT IGNORE INTO
    personas (codigo, nombre)
VALUES (1, 'Juan'),
    (2, 'María'),
    (3, 'Carlos');
