<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Listado de Personas</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<div class="page-container">
  <h1>Listado de Personas</h1>

  <div class="table-wrap">
    <table class="table">
      <thead>
        <tr>
          <th>Código</th>
          <th>Nombre</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
      <c:if test="${not empty requestScope.personas}">
        <c:forEach var="p" items="${requestScope.personas}">
        <tr>
          <td>${p.codigo}</td>
          <td>${p.nombre}</td>
          <td class="actions">
            <%-- Por ahora el DAO solo trae datos de la base: Editar y Eliminar quedan deshabilitados --%>
            <button disabled class="btn-disabled" title="Funcionalidad no disponible">Editar</button>
            <button disabled class="btn-disabled" title="Funcionalidad no disponible">Eliminar</button>

            <%-- Botones activos: se habilitan cuando actualizar(), eliminar() y obtenerXCodigo() usen la base
            <a class="btn btn-edit"
               href="${pageContext.request.contextPath}/persona?action=cargarEditar&codigo=${p.codigo}">
              Editar
            </a>

            <form action="${pageContext.request.contextPath}/persona?action=eliminar" method="post" style="display: inline;">
              <input type="hidden" name="codigo" value="${p.codigo}">
              <button type="submit" class="btn btn-danger"
                      onclick="return confirm('¿Eliminar el registro ${p.nombre}?');">
                Eliminar
              </button>
            </form>
            --%>
          </td>
        </tr>
        </c:forEach>
      </c:if>
      <c:if test="${empty requestScope.personas}">
        <tr>
          <td colspan="3" style="text-align: center; color: #6b7280;">
            No hay personas registradas
          </td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <div class="section-gap">
    <%-- Agregar queda deshabilitado hasta que agregar() use la base --%>
    <button disabled class="btn-disabled" title="Funcionalidad no disponible">Agregar Persona</button>

    <%-- Botón activo: se habilita cuando agregar() y obtenerXCodigo() usen la base
    <a class="btn" href="${pageContext.request.contextPath}/persona?action=agregar">Agregar Persona</a>
    --%>
  </div>
</div>
</body>
</html>
