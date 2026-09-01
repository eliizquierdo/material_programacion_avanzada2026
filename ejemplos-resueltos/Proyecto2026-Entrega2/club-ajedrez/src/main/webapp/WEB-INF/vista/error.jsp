<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body>
    <h1>Club de Ajedrez</h1>
    <h2>Error</h2>
    <p class="error">${error}</p>
    <a href="${pageContext.request.contextPath}/socio">Volver al listado</a>
</body>
</html>
