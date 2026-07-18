CREATE TABLE IF NOT EXISTS persona (
    codigo INT(8),
    nombre VARCHAR(10) NOT NULL,
    PRIMARY KEY (codigo)
);

INSERT IGNORE INTO
    persona (codigo, nombre)
VALUES (1, 'Juan'),
    (2, 'María'),
    (3, 'Carlos');
