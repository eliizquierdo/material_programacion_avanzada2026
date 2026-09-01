<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Listado de Socios</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body>
    <h1>Club de Ajedrez</h1>
    <h2>Listado de Socios</h2>
    <nav>
        <a href="${pageContext.request.contextPath}/socio?action=agregar">Agregar socio</a> |
        <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
    </nav>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Apellido</th>
                <th>Edad</th>
                <th>Categoría</th>
                <th>Pago al día</th>
                <th>Acción</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="s" items="${socios}">
                <tr>
                    <td>${s.id}</td>
                    <td>${s.nombre}</td>
                    <td>${s.apellido}</td>
                    <td>${s.edad}</td>
                    <td>${s.categoria}</td>
                    <td>${s.pagoAlDia ? 'Sí' : 'No'}</td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/socio">
                            <input type="hidden" name="action" value="eliminar">
                            <input type="hidden" name="id" value="${s.id}">
                            <button type="submit" class="btn-baja">Dar de baja</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
