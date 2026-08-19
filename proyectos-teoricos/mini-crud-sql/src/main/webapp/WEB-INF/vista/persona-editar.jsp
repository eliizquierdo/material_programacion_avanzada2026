<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <title>Editar Persona</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
  </head>
  <body>
    <div class="form-container">
      <h1>Editar Persona</h1>

      <form action="${pageContext.request.contextPath}/persona" method="post">
        <input type="hidden" name="action" value="editar" />

        <label>Código</label>
        <input
          type="number"
          name="codigo"
          value="${requestScope.persona.codigo}"
          readonly
          required
        />

        <label>Nombre</label>
        <input
          type="text"
          name="nombre"
          value="${requestScope.persona.nombre}"
          required
        />

        <button class="btn" type="submit">Actualizar</button>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/persona">Volver</a>
      </form>
    </div>
  </body>
</html>
