import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

public class EstadoSalaServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        
        response.setContentType("application/json"); 
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        if (session.getAttribute("id_partida") == null) {
            out.print("{\"error\": \"No hay partida\"}");
            return;
        }

        int idPartida = (Integer) session.getAttribute("id_partida");
        int miIdUsuario = (Integer) session.getAttribute("id_usuario"); // Obtenemos MI ID
        
        Connection con = null;
        try {
            con = ConexionDB.obtenerConexion();

            // 1. VER ESTADO Y QUIÉN ES EL LÍDER
            int estado = 1;
            boolean soyLider = false;
            
            String sqlPartida = "SELECT IdEstado, IdJugadorTurno FROM Partidas WHERE IdPartida = ?";
            PreparedStatement ps = con.prepareStatement(sqlPartida);
            ps.setInt(1, idPartida);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                estado = rs.getInt("IdEstado");
                // Comparamos si el dueño de la sala (IdJugadorTurno) soy YO
                if (rs.getInt("IdJugadorTurno") == miIdUsuario) {
                    soyLider = true;
                }
            }
            rs.close(); ps.close();

            // 2. OBTENER JUGADORES
            String sqlJug = "SELECT j.Nombre, d.Orden FROM DetallesPartida d " +
                            "JOIN Jugadores j ON d.IdJugador = j.IdJugador " +
                            "WHERE d.IdPartida = ? ORDER BY d.Orden ASC";
                            
            ps = con.prepareStatement(sqlJug);
            ps.setInt(1, idPartida);
            ResultSet rsJ = ps.executeQuery();

            // 3. CONSTRUIR JSON (Añadimos el campo "soyLider")
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"estado\": ").append(estado).append(", ");
            json.append("\"soyLider\": ").append(soyLider).append(", "); // <--- NUEVO CAMPO
            json.append("\"jugadores\": [");

            boolean primero = true;
            while (rsJ.next()) {
                if (!primero) json.append(",");
                String nombre = rsJ.getString("Nombre"); 
                if (nombre == null) nombre = "Jugador";
                
                json.append("{");
                json.append("\"nombre\": \"").append(nombre).append("\",");
                json.append("\"color\": ").append(rsJ.getInt("Orden"));
                json.append("}");
                primero = false;
            }
            json.append("]");
            json.append("}");

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Error SQL\"}");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}