package modelo.dao;

import modelo.conexion.Conexion;
import modelo.vo.PersonaVO;
import java.sql.*;
import java.util.ArrayList;

public class PersonaDAO {

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

    public String agregar(PersonaVO p) {
        // FASE 1: Definir la sentencia SQL
        String sql = "INSERT INTO personas(codigo, nombre) VALUES (?, ?)";

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, p.getCodigo());
            ps.setString(2, p.getNombre());
            // FASE 4: Ejecutar (INSERT no tiene FASE 5)
            ps.executeUpdate();
            return "Persona agregada correctamente.";
        } catch (SQLException e) {
            System.err.println("Error al agregar persona: " + e.getMessage());
            e.printStackTrace();
            return "Error al agregar persona.";
        }
    }

    public String actualizar(PersonaVO p) {
        // FASE 1: Definir la sentencia SQL
        String sql = "UPDATE personas SET nombre = ? WHERE codigo = ?";

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setString(1, p.getNombre());
            ps.setInt(2, p.getCodigo());
            // FASE 4: Ejecutar (devuelve cuántas filas cambiaron)
            if (ps.executeUpdate() > 0) {
                return "Persona actualizada.";
            }
            return "Persona no encontrada.";
        } catch (SQLException e) {
            System.err.println("Error al actualizar persona: " + e.getMessage());
            e.printStackTrace();
            return "Error al actualizar persona.";
        }
    }

    public String eliminar(int codigo) {
        // FASE 1: Definir la sentencia SQL
        String sql = "DELETE FROM personas WHERE codigo = ?";

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, codigo);
            // FASE 4: Ejecutar (devuelve cuántas filas se borraron)
            if (ps.executeUpdate() > 0) {
                return "Persona eliminada.";
            }
            return "Persona no encontrada.";
        } catch (SQLException e) {
            System.err.println("Error al eliminar persona: " + e.getMessage());
            e.printStackTrace();
            return "Error al eliminar persona.";
        }
    }

    public PersonaVO obtenerXCodigo(int cod) {
        // FASE 1: Definir la sentencia SQL
        String sql = "SELECT * FROM personas WHERE codigo = ?";
        PersonaVO persona = null;

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, cod);
            // FASE 4: Ejecutar (ResultSet en try anidado)
            try (ResultSet rs = ps.executeQuery()) {
                // FASE 5: Leer el ResultSet (if, porque codigo es clave única)
                if (rs.next()) {
                    persona = new PersonaVO(
                            rs.getInt("codigo"),
                            rs.getString("nombre"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener persona: " + e.getMessage());
            e.printStackTrace();
        }
        return persona;
    }
}
