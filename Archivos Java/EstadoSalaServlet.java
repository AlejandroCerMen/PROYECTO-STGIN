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
        int miIdUsuario = (Integer) session.getAttribute("id_usuario"); 
        
        Connection con = null;
        try {
            // Asegúrate que tu método se llama 'conectar' u 'obtenerConexion' según tu ConexionDB.java
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
            // CAMBIO 1: Añadimos 'j.IdJugador' al SELECT para saber el ID de cada uno
            String sqlJug = "SELECT j.IdJugador, j.Nombre, d.color FROM DetallesPartida d " +
                            "JOIN Jugadores j ON d.IdJugador = j.IdJugador " +
                            "WHERE d.IdPartida = ? ORDER BY d.Orden ASC";
                            
            ps = con.prepareStatement(sqlJug);
            ps.setInt(1, idPartida);
            ResultSet rsJ = ps.executeQuery();

            // 3. CONSTRUIR JSON
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"estado\": ").append(estado).append(", ");
            json.append("\"soyLider\": ").append(soyLider).append(", ");
            json.append("\"jugadores\": [");

            boolean primero = true;
            while (rsJ.next()) {
                if (!primero) json.append(",");
                
                String nombre = rsJ.getString("Nombre"); 
                if (nombre == null) nombre = "Jugador";
                
                // CAMBIO 2: Añadimos el campo "id" al JSON
                json.append("{");
                json.append("\"id\": ").append(rsJ.getInt("IdJugador")).append(","); // <--- IMPORTANTE
                json.append("\"nombre\": \"").append(nombre).append("\",");
                json.append("\"color\": ").append(rsJ.getInt("Color"));
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