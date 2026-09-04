# Instalación de entorno de Bases de Datos (Ubuntu)

Script de instalación automatizada del entorno necesario para las clases de **Introducción a Bases de Datos**: Apache, MySQL, PHP, phpMyAdmin y el editor Geany.

> ⚠️ **Uso exclusivamente educativo.** El script configura el usuario `root` de MySQL con la contraseña fija `admin123`. Esta configuración es insegura y **no debe usarse en entornos de producción**.

## Qué instala

| Componente | Descripción |
|---|---|
| Apache2 | Servidor web |
| MySQL Server | Motor de base de datos |
| PHP + php-mysql | Soporte PHP para Apache y conexión a MySQL |
| phpMyAdmin | Administrador web de bases de datos |
| Geany | Editor de texto liviano para código |

## Requisitos previos

- Ubuntu (probado para uso en sala de informática).
- Permisos de `sudo`.
- Conexión a internet para descargar los paquetes.

## Uso

1. Descargar el script `instalar_bd_ubuntu.sh` en la máquina.
2. Darle permisos de ejecución:
   ```bash
   chmod +x instalar_bd_ubuntu.sh
   ```
3. Ejecutarlo:
   ```bash
   ./instalar_bd_ubuntu.sh
   ```
4. Esperar a que finalice. El script muestra en pantalla el progreso de cada instalación y, al final, un resumen de verificación.

## Qué hace el script paso a paso

1. Actualiza los repositorios (`apt update`).
2. Verifica si cada componente ya está instalado antes de instalarlo (evita reinstalaciones innecesarias).
3. Instala Apache, MySQL, PHP y phpMyAdmin (de forma desatendida con `DEBIAN_FRONTEND=noninteractive`).
4. Configura el usuario `root` de MySQL con la contraseña `admin123` (`mysql_native_password`).
5. Crea el enlace simbólico para acceder a phpMyAdmin desde Apache.
6. Se asegura de que `AllowNoPassword` esté en `false` en la configuración de phpMyAdmin (agregando la línea si no existe o corrigiéndola si estaba en `true`), ya que root requiere contraseña.
7. Reinicia Apache dos veces (tras instalar phpMyAdmin y tras ajustar su configuración).
8. Instala Geany.
9. Muestra un resumen final del estado (`OK` / `NO`) de cada componente.
10. Prueba el acceso a MySQL con `root` y la contraseña `admin123`, y confirma si funcionó.

## Acceso a phpMyAdmin

Una vez finalizada la instalación:

- URL: [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
- Usuario: `root`
- Contraseña: `admin123`

## Notas

- El script es **idempotente** para las verificaciones de instalación: puede volver a ejecutarse sin reinstalar lo que ya está presente.
- La contraseña `admin123` queda fija en el script; si se ejecuta varias veces, vuelve a fijarla al mismo valor.
- Recomendado solo para equipos de laboratorio/aula, no para máquinas con datos sensibles o expuestas a internet.
