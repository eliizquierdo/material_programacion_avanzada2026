<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Club de Ajedrez</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body>
    <h1>Club de Ajedrez</h1>
    <nav>
        <a href="${pageContext.request.contextPath}/socio">Ver socios</a> |
        <a href="${pageContext.request.contextPath}/socio?action=agregar">Agregar socio</a>
    </nav>
</body>
</html>
