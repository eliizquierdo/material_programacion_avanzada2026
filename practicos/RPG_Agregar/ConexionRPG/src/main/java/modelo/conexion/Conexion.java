package modelo.conexion;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Conexion {

    private static final String ARCHIVO = "db.properties";
    // Registrar el driver JDBC explícitamente (evita "No suitable driver found" en Tomcat)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("ERROR: No se encontró el driver de MySQL en el classpath.");
            e.printStackTrace();
        }
    }
    private static final Properties config = cargarPropiedades();

    private static Properties cargarPropiedades() {
        Properties props = new Properties();
        try (InputStream input = Conexion.class
                .getClassLoader()
                .getResourceAsStream(ARCHIVO)) {

            if (input == null) {
                System.err.println("ERROR: No se encontró " + ARCHIVO);
                return props;
            }
            props.load(input);

        } catch (Exception e) {
            System.err.println("ERROR al leer " + ARCHIVO);
            e.printStackTrace();
        }
        return props;
    }

    public static Connection obtener() throws SQLException {
        String url      = config.getProperty("db.url");
        String usuario  = config.getProperty("db.username");
        String password = config.getProperty("db.password");
        return DriverManager.getConnection(url, usuario, password);
    }
}
