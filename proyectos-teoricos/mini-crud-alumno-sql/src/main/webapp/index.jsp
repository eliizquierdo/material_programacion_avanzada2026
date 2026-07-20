<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <title>CRUD con herencia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
  </head>
  <body>
    <div class="form-container">
      <h1>Bienvenidos al CRUD de alumnos</h1>

      <a class="btn" href="${pageContext.request.contextPath}/alumno?action=agregar"
        >Agregar Alumnos</a
      >
      <a class="btn" href="${pageContext.request.contextPath}/alumno?action=listar"
        >Listar Alumno</a
      >
    </div>
  </body>
</html>
