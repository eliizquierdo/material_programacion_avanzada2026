CREATE TABLE IF NOT EXISTS guerrero (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fuerza INT NOT NULL,
    nivel INT NOT NULL
);

CREATE TABLE IF NOT EXISTS mago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    poder INT NOT NULL,
    nivel INT NOT NULL
);

INSERT IGNORE INTO
    guerrero (id, nombre, fuerza, nivel)
VALUES (1, 'Conan', 85, 12),
    (2, 'Thorin', 78, 10);

INSERT IGNORE INTO
    mago (id, nombre, poder, nivel)
VALUES (1, 'Gandalf', 95, 15),
    (2, 'Merlin', 90, 14);
