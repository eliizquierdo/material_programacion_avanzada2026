Tema 3: Mini CRUD con acceso a Base de datos (proyecto base para la Práctica 3)

- Parte del mini-crud2 del Tema 2: mismo controlador, con control de unicidad del código y mensajes de error en el formulario.
- Agrega la clase Conexion (modelo.conexion), db.properties y el conector de MySQL en el pom.xml.
- En PersonaDAO, solo getLista() consulta la base (SELECT). Los demás métodos siguen trabajando en memoria y se pasan a la base en las próximas clases.
- Por eso los botones Agregar, Editar y Eliminar del listado están deshabilitados.
- Antes de ejecutar: correr scrit-institutoWeb.sql en MySQL y revisar el usuario y la contraseña de db.properties.
