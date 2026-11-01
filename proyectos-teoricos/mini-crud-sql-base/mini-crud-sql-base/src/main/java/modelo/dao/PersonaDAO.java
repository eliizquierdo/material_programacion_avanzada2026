package modelo.dao;

import modelo.conexion.Conexion;
import modelo.vo.PersonaVO;
import java.sql.*;
import java.util.ArrayList;

public class PersonaDAO {

    // Temporal: los métodos que todavía no consultan la base trabajan sobre esta lista en memoria.
    // Se irán reemplazando por consultas a MySQL en las próximas clases.
    private ArrayList<PersonaVO> personasMemoria;

    public PersonaDAO() {
        personasMemoria = new ArrayList<>();
    }

    // ======================== Con base de datos ========================

    public ArrayList<PersonaVO> getLista() {
        ArrayList<PersonaVO> lista = new ArrayList<>();
        // FASE 1: Definir la sentencia SQL
        String sql = "SELECT * FROM personas";

        // FASES 2, 3 y 4: conexión, PreparedStatement y ejecución en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // FASE 5: Leer el ResultSet
            while (rs.next()) {
                lista.add(new PersonaVO(
                        rs.getInt("codigo"),
                        rs.getString("nombre")));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar personas: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    // ============ Todavía en memoria (se pasan a la base más adelante) ============

    public String agregar(PersonaVO p) {
        personasMemoria.add(p);
        return "Persona agregada correctamente.";
    }

    public boolean estaPersona(int cod) {
        for (PersonaVO p : personasMemoria) {
            if (p.getCodigo() == cod) {
                return true;
            }
        }
        return false;
    }

    public PersonaVO devolver(int pos) {
        if (pos >= 0 && pos < personasMemoria.size()) {
            return personasMemoria.get(pos);
        }
        return null;
    }

    public String eliminar(int codigo) {
        for (PersonaVO p : personasMemoria) {
            if (p.getCodigo() == codigo) {
                personasMemoria.remove(p);
                return "Persona eliminada.";
            }
        }
        return "Persona no encontrada.";
    }

    public int cantidad() {
        return personasMemoria.size();
    }

    public PersonaVO obtenerXCodigo(int cod) {
        for (PersonaVO p : personasMemoria) {
            if (p.getCodigo() == cod) {
                return p;
            }
        }
        return null;
    }

    public String actualizar(PersonaVO p) {
        for (int i = 0; i < personasMemoria.size(); i++) {
            if (personasMemoria.get(i).getCodigo() == p.getCodigo()) {
                personasMemoria.set(i, p);
                return "Persona actualizada.";
            }
        }
        return "Persona no encontrada.";
    }
}
