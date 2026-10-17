import modelo.dao.PersonaDAO;
import modelo.vo.PersonaVO;

import java.util.ArrayList;

/**
 * Programa de consola para probar el CRUD de PersonaDAO,
 * sin ninguna interfaz web (sin Servlet, sin JSP).
 *
 * Corresponde al Tema 3 (Conexión a Bases de Datos) del Grupo B:
 * primero se aprende JDBC en consola, y recién más adelante
 * (Tema 2) se le agrega una interfaz web a este mismo DAO.
 *
 * Los métodos agregar, actualizar y eliminar devuelven un mensaje
 * (String) que indica qué pasó; acá simplemente se imprime.
 */
public class Main {

    public static void main(String[] args) {

        PersonaDAO dao = new PersonaDAO();

        System.out.println("===== 1) Listado inicial =====");
        imprimirLista(dao.getLista());

        System.out.println("\n===== 2) Agregar una persona nueva =====");
        PersonaVO nueva = new PersonaVO(99, "Prueba");
        System.out.println(dao.agregar(nueva));

        System.out.println("\n===== 3) Listado después de agregar =====");
        imprimirLista(dao.getLista());

        System.out.println("\n===== 4) Buscar por código =====");
        PersonaVO encontrada = dao.obtenerXCodigo(99);
        System.out.println("Encontrada: " + (encontrada != null ? encontrada.getNombre() : "no existe"));

        System.out.println("\n===== 5) Actualizar =====");
        if (encontrada != null) {
            encontrada.setNombre("Editada");
            System.out.println(dao.actualizar(encontrada));
        }

        System.out.println("\n===== 6) Listado después de actualizar =====");
        imprimirLista(dao.getLista());

        System.out.println("\n===== 7) Eliminar =====");
        System.out.println(dao.eliminar(99));

        System.out.println("\n===== 8) Listado final =====");
        imprimirLista(dao.getLista());
    }

    private static void imprimirLista(ArrayList<PersonaVO> personas) {
        if (personas.isEmpty()) {
            System.out.println("(no hay personas registradas)");
            return;
        }
        for (PersonaVO p : personas) {
            System.out.println(p.getCodigo() + " - " + p.getNombre());
        }
    }
}
