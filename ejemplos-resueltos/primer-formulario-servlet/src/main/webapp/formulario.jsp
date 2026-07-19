<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Mi primer formulario</title>
</head>
<body>
  <h1>¿Cuál es tu nombre?</h1>

  <form action="saludo" method="post">
    <label>Nombre:
      <input type="text" name="nombre" required>
    </label>
    <button type="submit">Saludar</button>
  </form>
</body>
</html>
