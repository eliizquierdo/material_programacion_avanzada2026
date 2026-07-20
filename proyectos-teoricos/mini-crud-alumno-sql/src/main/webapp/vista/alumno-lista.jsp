<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <title>Listado de Alumnos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
  </head>
  <body>
    <div class="page-container">
      <h1>Listado de Alumnos</h1>

      <div class="table-wrap">
        <table class="table">
          <thead>
            <tr>
              <th>Código</th>
              <th>Nombre</th>
              <th>Teléfono</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:if test="${not empty requestScope.alumnos}">
              <c:forEach var="a" items="${requestScope.alumnos}">
                <tr>
                  <td>${a.codigo}</td>
                  <td>${a.nombre}</td>
                  <td>${a.telefono}</td>
                  <td class="actions">
                    <a
                      class="btn btn-edit"
                      href="${pageContext.request.contextPath}/alumno?action=editar&id=${a.codigo}"
                      >Editar</a
                    >
                    <a
                      class="btn btn-danger"
                      href="${pageContext.request.contextPath}/alumno?action=eliminar&id=${a.codigo}"
                      onclick="return confirm('¿Eliminar alumno?');"
                      >Eliminar</a
                    >
                  </td>
                </tr>
              </c:forEach>
            </c:if>
            <c:if test="${empty requestScope.alumnos}">
              <tr>
                <td colspan="4">No hay alumnos cargados.</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <a class="btn" href="${pageContext.request.contextPath}/alumno?action=agregar"
        >Agregar Alumno</a
      >
    </div>
  </body>
</html>
