package modelo.dao;

import modelo.conexion.Conexion;
import modelo.vo.GuerreroVO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuerreroDAO {

    public List<GuerreroVO> listarGuerreros() {

        List<GuerreroVO> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, fuerza, nivel FROM guerrero";

        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                GuerreroVO guerrero = new GuerreroVO(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getInt("fuerza"),
                        rs.getInt("nivel"));
                lista.add(guerrero);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar guerreros: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public boolean agregarGuerrero(GuerreroVO guerrero) {

        String sql = "INSERT INTO guerrero(nombre, fuerza, nivel) VALUES (?, ?, ?)";
        boolean exito = false;

        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, guerrero.getNombre());
            ps.setInt(2, guerrero.getFuerza());
            ps.setInt(3, guerrero.getNivel());

            int filasAfectadas = ps.executeUpdate();
            exito = filasAfectadas > 0;

            System.out.println("Guerrero agregado: " + guerrero.toString());

        } catch (SQLException e) {
            System.err.println("Error al agregar guerrero: " + e.getMessage());
            e.printStackTrace();
        }
        return exito;
    }
}
