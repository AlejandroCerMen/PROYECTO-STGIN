import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    // Configuración para XAMPP
    private static final String URL = "jdbc:mysql://localhost:3306/proyecto_oca?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = ""; // Vacío en XAMPP por defecto

    public static Connection obtenerConexion() {
        Connection con = null;
        try {
            // Cargar el driver antiguo (com.mysql.jdbc.Driver) o el nuevo (com.mysql.cj.jdbc.Driver)
            // Probamos el moderno primero, si falla, el catch capturará el error.
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            
            con = DriverManager.getConnection(URL, USER, PASS);
            
        } catch (ClassNotFoundException e) {
            System.out.println("Error: Driver no encontrado. Revisa la carpeta WEB-INF/lib");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Error de SQL al conectar.");
            e.printStackTrace();
        }
        return con;
    }
}