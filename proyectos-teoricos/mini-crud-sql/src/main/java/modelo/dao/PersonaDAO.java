package modelo.dao;

import modelo.conexion.Conexion;
import modelo.vo.PersonaVO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PersonaDAO {

    public List<PersonaVO> listarPersonas() {
        List<PersonaVO> lista = new ArrayList<>();
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

    public boolean agregarPersona(PersonaVO persona) {
        // FASE 1: Definir la sentencia SQL
        String sql = "INSERT INTO personas(codigo, nombre) VALUES (?, ?)";
        boolean exito = false;

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, persona.getCodigo());
            ps.setString(2, persona.getNombre());
            // FASE 4: Ejecutar (INSERT no tiene FASE 5)
            exito = ps.executeUpdate() > 0;
            System.out.println("Persona agregada: " + persona);
        } catch (SQLException e) {
            System.err.println("Error al agregar persona: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    public boolean actualizarPersona(PersonaVO persona) {
        // FASE 1: Definir la sentencia SQL
        String sql = "UPDATE personas SET nombre = ? WHERE codigo = ?";
        boolean exito = false;

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setString(1, persona.getNombre());
            ps.setInt(2, persona.getCodigo());
            // FASE 4: Ejecutar
            exito = ps.executeUpdate() > 0;

            if (exito) System.out.println("Persona actualizada: " + persona);
            else System.out.println("No se encontró persona con código " + persona.getCodigo());
        } catch (SQLException e) {
            System.err.println("Error al actualizar persona: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    public boolean eliminarPersona(int codigo) {
        // FASE 1: Definir la sentencia SQL
        String sql = "DELETE FROM personas WHERE codigo = ?";
        boolean exito = false;

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, codigo);
            // FASE 4: Ejecutar
            exito = ps.executeUpdate() > 0;

            if (exito) System.out.println("Persona " + codigo + " eliminada");
            else System.out.println("No se encontró persona con código " + codigo);
        } catch (SQLException e) {
            System.err.println("Error al eliminar persona: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    public PersonaVO obtenerPersonaPorCodigo(int codigo) {
        // FASE 1: Definir la sentencia SQL
        String sql = "SELECT * FROM personas WHERE codigo = ?";
        PersonaVO persona = null;

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, codigo);
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
