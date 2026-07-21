import modelo.dao.AlumnoDAO;
import modelo.vo.AlumnoVO;

import java.util.List;

/**
 * Programa de consola para probar AlumnoDAO (herencia + transacciones),
 * sin ninguna interfaz web (sin Servlet, sin JSP).
 *
 * Corresponde al Tema 4 (Base de Datos con Herencia) del Grupo B:
 * primero se aprende herencia + transacciones en consola, y recién
 * más adelante (Tema 2) se le agrega una interfaz web a este DAO.
 */
public class Main {

    public static void main(String[] args) {

        AlumnoDAO dao = new AlumnoDAO();

        System.out.println("===== 1) Listado inicial =====");
        imprimirLista(dao.listarAlumnos());

        System.out.println("\n===== 2) Agregar un alumno nuevo =====");
        AlumnoVO nuevo = new AlumnoVO(99, "Alumno de Prueba", "099123456");
        boolean agregado = dao.agregarAlumno(nuevo);
        System.out.println("¿Se agregó? " + agregado);

        System.out.println("\n===== 3) Listado después de agregar =====");
        imprimirLista(dao.listarAlumnos());

        System.out.println("\n===== 4) Demostración de TRANSACCIÓN: intentar agregar el mismo código de nuevo =====");
        System.out.println("(el INSERT en 'personas' va a fallar por código duplicado -> rollback -> no debe quedar nada a medio insertar en 'alumnos')");
        AlumnoVO duplicado = new AlumnoVO(99, "Alumno Duplicado", "099999999");
        boolean agregadoDuplicado = dao.agregarAlumno(duplicado);
        System.out.println("¿Se agregó el duplicado? " + agregadoDuplicado + " (debería ser false)");

        System.out.println("\n===== 5) Buscar por código =====");
        AlumnoVO encontrado = dao.obtenerAlumnoPorCodigo(99);
        System.out.println("Encontrado: " + encontrado);

        System.out.println("\n===== 6) Actualizar =====");
        if (encontrado != null) {
            encontrado.setTelefono("099000000");
            boolean actualizado = dao.actualizarAlumno(encontrado);
            System.out.println("¿Se actualizó? " + actualizado);
        }

        System.out.println("\n===== 7) Listado después de actualizar =====");
        imprimirLista(dao.listarAlumnos());

        System.out.println("\n===== 8) Eliminar (dispara ON DELETE CASCADE en 'alumnos') =====");
        boolean eliminado = dao.eliminarAlumno(99);
        System.out.println("¿Se eliminó? " + eliminado);

        System.out.println("\n===== 9) Listado final =====");
        imprimirLista(dao.listarAlumnos());
    }

    private static void imprimirLista(List<AlumnoVO> alumnos) {
        if (alumnos.isEmpty()) {
            System.out.println("(no hay alumnos registrados)");
            return;
        }
        for (AlumnoVO a : alumnos) {
            System.out.println(a);
        }
    }
}
