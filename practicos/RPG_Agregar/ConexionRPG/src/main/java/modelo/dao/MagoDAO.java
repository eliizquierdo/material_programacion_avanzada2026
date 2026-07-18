package modelo.dao;

import modelo.conexion.Conexion;
import modelo.vo.MagoVO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MagoDAO {

    public List<MagoVO> listarMagos() {
        List<MagoVO> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, poder, nivel FROM mago";

        try (Connection con = Conexion.obtener();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MagoVO mago = new MagoVO(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getInt("poder"),
                        rs.getInt("nivel"));
                lista.add(mago);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar guerreros: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public boolean agregarMago(MagoVO mago) {
        // completar <------------------------------------------------------

    }
}
