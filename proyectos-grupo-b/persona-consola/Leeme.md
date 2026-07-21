# persona-consola

Proyecto de consola (sin Servlet, sin JSP) para aprender JDBC — Tema 3, orden Grupo B.

Reutiliza exactamente las mismas clases `Conexion`, `PersonaDAO` y `PersonaVO` que usa `mini-crud-sql` en la wiki — la diferencia es que acá no hay ninguna capa web todavía.

## Cómo correrlo

1. **Descomprime** esta carpeta y ábrela con VS Code (o cualquier IDE con soporte de Maven).

2. **Crea la base de datos**: abre tu consola de MySQL/MariaDB (o MySQL Workbench) y ejecuta el contenido del archivo `institutoWeb.sql` que viene en esta carpeta. Esto crea la base `institutoWeb` con su tabla y datos de ejemplo.

3. **Revisa las credenciales**: abre `src/main/resources/db.properties` y confirma que el usuario y la contraseña coincidan con los de tu MySQL local (por defecto: `java_dev` / `java2026`). Si tu MySQL usa otro usuario, cámbialo ahí.

4. **Abre una terminal en la carpeta del proyecto**: en VS Code, Terminal → New Terminal (se abre ya parada en la carpeta). O en el Explorador de Windows, entra a la carpeta y escribe `cmd` en la barra de direcciones.

5. **Compila y ejecuta**:

```
mvn compile exec:java
```

La primera vez puede tardar un poco (Maven descarga el conector de MySQL). Vas a ver en la consola el resultado de listar, agregar, buscar, actualizar y eliminar una persona, paso por paso.

## Si da error de conexión

Si aparece `Public Key Retrieval is not allowed`: es un tema de MySQL 8+, no del código. La URL en `db.properties` ya incluye `allowPublicKeyRetrieval=true` para evitarlo — si igual aparece, revisa que no se haya pisado esa línea al editar las credenciales.

## Más adelante (Tema 2, Grupo B)

Este mismo `PersonaDAO` se reutiliza sin cambios cuando se agregue la interfaz web (Servlet + JSP) — no hace falta reescribir la lógica de acceso a datos.
