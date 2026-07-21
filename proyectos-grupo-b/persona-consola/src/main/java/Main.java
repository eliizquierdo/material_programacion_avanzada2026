import modelo.dao.PersonaDAO;
import modelo.vo.PersonaVO;

import java.util.List;

/**
 * Programa de consola para probar el CRUD de PersonaDAO,
 * sin ninguna interfaz web (sin Servlet, sin JSP).
 *
 * Corresponde al Tema 3 (Conexión a Bases de Datos) del Grupo B:
 * primero se aprende JDBC en consola, y recién más adelante
 * (Tema 2) se le agrega una interfaz web a este mismo DAO.
 */
public class Main {

    public static void main(String[] args) {

        PersonaDAO dao = new PersonaDAO();

        System.out.println("===== 1) Listado inicial =====");
        imprimirLista(dao.listarPersonas());

        System.out.println("\n===== 2) Agregar una persona nueva =====");
        PersonaVO nueva = new PersonaVO(99, "Persona de Prueba");
        boolean agregado = dao.agregarPersona(nueva);
        System.out.println("¿Se agregó? " + agregado);

        System.out.println("\n===== 3) Listado después de agregar =====");
        imprimirLista(dao.listarPersonas());

        System.out.println("\n===== 4) Buscar por código =====");
        PersonaVO encontrada = dao.obtenerPersonaPorCodigo(99);
        System.out.println("Encontrada: " + (encontrada != null ? encontrada.getNombre() : "no existe"));

        System.out.println("\n===== 5) Actualizar =====");
        if (encontrada != null) {
            encontrada.setNombre("Persona de Prueba (editada)");
            boolean actualizado = dao.actualizarPersona(encontrada);
            System.out.println("¿Se actualizó? " + actualizado);
        }

        System.out.println("\n===== 6) Listado después de actualizar =====");
        imprimirLista(dao.listarPersonas());

        System.out.println("\n===== 7) Eliminar =====");
        boolean eliminado = dao.eliminarPersona(99);
        System.out.println("¿Se eliminó? " + eliminado);

        System.out.println("\n===== 8) Listado final =====");
        imprimirLista(dao.listarPersonas());
    }

    private static void imprimirLista(List<PersonaVO> personas) {
        if (personas.isEmpty()) {
            System.out.println("(no hay personas registradas)");
            return;
        }
        for (PersonaVO p : personas) {
            System.out.println(p.getCodigo() + " - " + p.getNombre());
        }
    }
}
