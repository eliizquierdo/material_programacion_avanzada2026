<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Saludo</title>
</head>
<body>
  <h1>¡Hola, ${nombre}!</h1>
  <p>Tu nombre tiene ${fn:length(nombre)} letras.</p>

  <a href="formulario.jsp">← Volver</a>
</body>
</html>
