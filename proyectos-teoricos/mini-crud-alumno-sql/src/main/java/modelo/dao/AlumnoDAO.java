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

        // FASE 1: Definir la sentencia SQL (INNER JOIN une las tablas por el código)
        String sql = "SELECT p.codigo, p.nombre, a.telefono " +
                "FROM personas p " +
                "INNER JOIN alumnos a ON p.codigo = a.codigo";

        // FASES 2, 3 y 4: conexión, PreparedStatement y ejecución en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // FASE 5: Leer el ResultSet
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
        // FASE 1: Definir la sentencia SQL
        String sql = "SELECT p.codigo, p.nombre, a.telefono " +
                "FROM personas p " +
                "INNER JOIN alumnos a ON p.codigo = a.codigo " +
                "WHERE p.codigo = ?";
        AlumnoVO alumno = null;

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, codigo);
            // FASE 4: Ejecutar (ResultSet en try anidado)
            try (ResultSet rs = ps.executeQuery()) {
                // FASE 5: Leer el ResultSet (if, porque codigo es clave única)
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

        // FASE 1: Definir las sentencias SQL
        String sql1 = "INSERT INTO personas(codigo, nombre) VALUES (?, ?)";
        String sql2 = "INSERT INTO alumnos(codigo, telefono) VALUES (?, ?)";

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps1 = con.prepareStatement(sql1);
             PreparedStatement ps2 = con.prepareStatement(sql2)) {

            // 1. INICIO DE LA TRANSACCIÓN: Desactivar el guardado automático
            con.setAutoCommit(false);

            try {
                // FASE 3: Asignar parámetros  |  FASE 4: Ejecutar
                ps1.setInt(1, codigo);
                ps1.setString(2, alumno.getNombre());
                ps1.executeUpdate();                 // INSERT en personas

                ps2.setInt(1, codigo);
                ps2.setString(2, alumno.getTelefono());
                ps2.executeUpdate();                 // INSERT en alumnos

                // 2. CONFIRMACIÓN: ambas inserciones fueron exitosas
                con.commit();
                exito = true;
                System.out.println("Alumno agregado: " + alumno);
            } catch (SQLException e) {
                // 3. REVERSIÓN: cualquier fallo (por ejemplo, código duplicado) deshace todo
                con.rollback();
                System.out.println("Error: no se pudo agregar el alumno. Transacción revertida.");
                throw e;                             // lo informa el catch de afuera
            }
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

        // FASE 1: Definir las sentencias SQL
        String sql1 = "UPDATE personas SET nombre = ? WHERE codigo = ?";
        String sql2 = "UPDATE alumnos SET telefono = ? WHERE codigo = ?";

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps1 = con.prepareStatement(sql1);
             PreparedStatement ps2 = con.prepareStatement(sql2)) {

            con.setAutoCommit(false);            // INICIO DE LA TRANSACCIÓN

            try {
                // FASE 3: Asignar parámetros
                ps1.setString(1, alumno.getNombre());
                ps1.setInt(2, alumno.getCodigo());

                ps2.setString(1, alumno.getTelefono());
                ps2.setInt(2, alumno.getCodigo());

                // FASE 4: Ejecutar
                int filasPersona = ps1.executeUpdate();
                int filasAlumno = ps2.executeUpdate();

                if (filasPersona > 0 && filasAlumno > 0) {
                    con.commit();                // ambos UPDATE afectaron filas → confirmar
                    exito = true;
                    System.out.println("Alumno actualizado: " + alumno);
                } else {
                    con.rollback();              // el código no existe → revertir
                    System.out.println("No se encontró alumno con código " + alumno.getCodigo());
                }
            } catch (SQLException e) {
                con.rollback();                  // cualquier error → revertir todo
                throw e;                         // lo informa el catch de afuera
            }
        } catch (SQLException e) {
            System.err.println("Error al actualizar alumno: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }

    // ============== ELIMINAR ALUMNO ==============
    public boolean eliminarAlumno(int codigo) {
        // FASE 1: Solo eliminamos de personas, el CASCADE eliminará de alumnos automáticamente
        String sql = "DELETE FROM personas WHERE codigo = ?";
        boolean exito = false;

        // FASES 2 y 3: conexión y PreparedStatement en try-with-resources
        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // FASE 3: Asignar parámetros
            ps.setInt(1, codigo);
            // FASE 4: Ejecutar
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
