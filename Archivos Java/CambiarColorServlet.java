import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CambiarColorServlet")
public class CambiarColorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer idUsuario = (Integer) session.getAttribute("id_usuario");
        Integer idPartida = (Integer) session.getAttribute("id_partida");
        
        String colorStr = request.getParameter("color");

        if (idUsuario != null && idPartida != null && colorStr != null) {
            try {
                int nuevoColor = Integer.parseInt(colorStr);
                // Asegúrate de que este método se llama así en tu clase ConexionDB
                Connection con = ConexionDB.obtenerConexion(); 
                
                // SQL: El primer ? es Color, el segundo es IdPartida, el tercero es IdJugador
                String sql = "UPDATE detallespartida SET color = ? WHERE IdPartida = ? AND IdJugador = ?";
                
                PreparedStatement ps = con.prepareStatement(sql);
                
                // --- AQUÍ ESTABA EL ERROR ---
                ps.setInt(1, nuevoColor); // 1º interrogante: Color
                ps.setInt(2, idPartida);  // 2º interrogante: IdPartida (Antes pusiste idUsuario)
                ps.setInt(3, idUsuario);  // 3º interrogante: IdJugador (Antes pusiste idPartida)
                
                int filas = ps.executeUpdate();
                System.out.println("Filas actualizadas: " + filas); // Para ver en la consola si funciona
                
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}