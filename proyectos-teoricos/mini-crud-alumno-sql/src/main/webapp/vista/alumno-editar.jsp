<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <title>Editar Alumno</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
  </head>
  <body>
    <div class="form-container">
      <h1>Editar Alumno</h1>

      <c:if test="${requestScope.alumno == null}">
        <div class="alert danger">No se encontró el alumno a editar.</div>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/alumno">Volver</a>
      </c:if>
      <c:if test="${requestScope.alumno != null}">
        <!-- POST al Servlet con action=actualizar -->
        <form action="${pageContext.request.contextPath}/alumno" method="post">
          <input type="hidden" name="action" value="actualizar" />

          <label>Código</label>
          <input
            type="number"
            name="codigo"
            value="${requestScope.alumno.codigo}"
            readonly
          />

          <label>Nombre</label>
          <input
            type="text"
            name="nombre"
            value="${requestScope.alumno.nombre}"
            required
          />

          <label>Teléfono</label>
          <input
            type="text"
            name="telefono"
            value="${requestScope.alumno.telefono}"
            required
          />

          <button class="btn" type="submit">Actualizar</button>
          <a class="btn btn-secondary" href="${pageContext.request.contextPath}/alumno">Volver</a>
        </form>
      </c:if>
    </div>
  </body>
</html>
