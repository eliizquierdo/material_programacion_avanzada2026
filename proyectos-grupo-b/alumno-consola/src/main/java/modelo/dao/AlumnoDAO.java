package modelo.dao;

import modelo.conexion.Conexion;
import modelo.vo.AlumnoVO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlumnoDAO {

    // ============== LISTAR ALUMNOS ==============
    public List<AlumnoVO> listarAlumnos() {
        List<AlumnoVO> lista = new ArrayList<>();
        String sql = "SELECT p.codigo, p.nombre, a.telefono " +
                "FROM personas p " +
                "INNER JOIN alumnos a ON p.codigo = a.codigo";

        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new AlumnoVO(
                        rs.getInt("codigo"),
                        rs.getString("nombre"),
                        rs.getString("telefono")));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar alumnos: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    // ============== OBTENER ALUMNO POR CÓDIGO ==============
    public AlumnoVO obtenerAlumnoPorCodigo(int codigo) {
        String sql = "SELECT p.codigo, p.nombre, a.telefono " +
                "FROM personas p " +
                "INNER JOIN alumnos a ON p.codigo = a.codigo " +
                "WHERE p.codigo = ?";
        AlumnoVO alumno = null;

        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, codigo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    alumno = new AlumnoVO(
                            rs.getInt("codigo"),
                            rs.getString("nombre"),
                            rs.getString("telefono"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener alumno: " + e.getMessage());
            e.printStackTrace();
        }
        return alumno;
    }

    // ============== AGREGAR ALUMNO (CON TRANSACCIÓN) ==============
    /**
     * Agrega un Alumno en dos tablas utilizando una transacción para garantizar
     * que ambas inserciones se completen o ninguna lo haga (Atomicidad).
     */
    public boolean agregarAlumno(AlumnoVO alumno) {
        boolean exito = false;
        int codigo = alumno.getCodigo();

        String sql1 = "INSERT INTO personas(codigo, nombre) VALUES (?, ?)";
        String sql2 = "INSERT INTO alumnos(codigo, telefono) VALUES (?, ?)";

        try (Connection con = Conexion.obtener();
             PreparedStatement ps1 = con.prepareStatement(sql1);
             PreparedStatement ps2 = con.prepareStatement(sql2)) {

            // 1. INICIO DE LA TRANSACCIÓN: Desactivar el guardado automático
            con.setAutoCommit(false);

            ps1.setInt(1, codigo);
            ps1.setString(2, alumno.getNombre());
            int filasPersona = ps1.executeUpdate();

            ps2.setInt(1, codigo);
            ps2.setString(2, alumno.getTelefono());
            int filasAlumno = ps2.executeUpdate();

            // 2. CONFIRMACIÓN: si ambas fueron exitosas, guardamos los cambios
            if (filasPersona > 0 && filasAlumno > 0) {
                con.commit();
                exito = true;
                System.out.println("Alumno agregado: " + alumno);
            } else {
                // Si falla alguna, deshacemos lo que se haya hecho
                con.rollback();
                System.out.println("Error: no se pudo agregar el alumno. Transacción revertida.");
            }
            // Si hay excepción antes del commit, la conexión se cierra sin commit → rollback automático
        } catch (SQLException e) {
            System.err.println("Error al agregar alumno: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    // ============== ACTUALIZAR ALUMNO (CON TRANSACCIÓN) ==============
    /**
     * Actualiza un Alumno en dos tablas utilizando una transacción para garantizar
     * que ambos UPDATE se completen o ninguno lo haga (Atomicidad).
     */
    public boolean actualizarAlumno(AlumnoVO alumno) {
        boolean exito = false;

        String sql1 = "UPDATE personas SET nombre = ? WHERE codigo = ?";
        String sql2 = "UPDATE alumnos SET telefono = ? WHERE codigo = ?";

        try (Connection con = Conexion.obtener();
             PreparedStatement ps1 = con.prepareStatement(sql1);
             PreparedStatement ps2 = con.prepareStatement(sql2)) {

            con.setAutoCommit(false);

            ps1.setString(1, alumno.getNombre());
            ps1.setInt(2, alumno.getCodigo());

            ps2.setString(1, alumno.getTelefono());
            ps2.setInt(2, alumno.getCodigo());

            int filasPersona = ps1.executeUpdate();
            int filasAlumno = ps2.executeUpdate();

            if (filasPersona > 0 && filasAlumno > 0) {
                con.commit();
                exito = true;
                System.out.println("Alumno actualizado: " + alumno);
            } else {
                con.rollback();
                System.out.println("No se encontró alumno con código " + alumno.getCodigo());
            }
        } catch (SQLException e) {
            System.err.println("Error al actualizar alumno: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    // ============== ELIMINAR ALUMNO ==============
    public boolean eliminarAlumno(int codigo) {
        String sql = "DELETE FROM personas WHERE codigo = ?";
        boolean exito = false;

        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, codigo);
            exito = ps.executeUpdate() > 0;

            if (exito) System.out.println("Alumno " + codigo + " eliminado");
            else System.out.println("No se encontró alumno con código " + codigo);
        } catch (SQLException e) {
            System.err.println("Error al eliminar alumno: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }
}
