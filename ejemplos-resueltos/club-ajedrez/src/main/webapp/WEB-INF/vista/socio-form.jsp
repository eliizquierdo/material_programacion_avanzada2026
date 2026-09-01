<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Agregar Socio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body>
    <h1>Club de Ajedrez</h1>
    <h2>Agregar Socio</h2>
    <nav>
        <a href="${pageContext.request.contextPath}/socio">Ver socios</a> |
        <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
    </nav>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error">${error}</p>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/socio">
        <input type="hidden" name="action" value="agregar">

        <label for="nombre">Nombre:</label>
        <input type="text" id="nombre" name="nombre" value="${nombre}" required>

        <label for="apellido">Apellido:</label>
        <input type="text" id="apellido" name="apellido" value="${apellido}" required>

        <label for="fechaNacimiento">Fecha de nacimiento:</label>
        <input type="date" id="fechaNacimiento" name="fechaNacimiento" value="${fechaNacimiento}" required>

        <label for="categoria">Categoría:</label>
        <select id="categoria" name="categoria">
            <option value="Juvenil" ${categoria == 'Juvenil' ? 'selected' : ''}>Juvenil</option>
            <option value="Adulto" ${categoria == 'Adulto' ? 'selected' : ''}>Adulto</option>
            <option value="Senior" ${categoria == 'Senior' ? 'selected' : ''}>Senior</option>
        </select>

        <button type="submit">Agregar</button>
    </form>
</body>
</html>
