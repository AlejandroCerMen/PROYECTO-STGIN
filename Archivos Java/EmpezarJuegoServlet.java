import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class EmpezarJuegoServlet extends HttpServlet {
    
    // Usamos doPost porque estamos enviando una orden de cambio
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        
        HttpSession session = request.getSession();
        
        // 1. SEGURIDAD: Verificar que hay usuario y partida en la sesión
        if (session.getAttribute("id_partida") == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No hay partida");
            return;
        }

        int idPartida = (Integer) session.getAttribute("id_partida");
        
        Connection con = null;
        try {
            con = ConexionDB.obtenerConexion();

            // 2. EL CAMBIO CLAVE: Actualizar el estado a 2 (JUGANDO)
            String sql = "UPDATE Partidas SET IdEstado = 2 WHERE IdPartida = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idPartida);
            
            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("Partida " + idPartida + " iniciada correctamente.");
                response.setStatus(HttpServletResponse.SC_OK); // Responder "Todo OK"
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo actualizar");
            }
            
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error SQL");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}