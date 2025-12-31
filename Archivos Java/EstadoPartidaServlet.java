import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.*;

@WebServlet(name = "EstadoPartidaServlet", urlPatterns = {"/EstadoPartidaServlet"})
public class EstadoPartidaServlet extends HttpServlet {
    
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json"); 
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        if (session.getAttribute("id_partida") == null) { out.print("{}"); return; }
        int idPartida = (Integer) session.getAttribute("id_partida");
        int miId = (Integer) session.getAttribute("id_usuario");
        
        Connection con = null;
        try {
            con = ConexionDB.obtenerConexion();

            // 1. OBTENER DATOS + TEXTO DEL MENSAJE (JOIN)
            // Unimos la tabla Partidas con Mensajes para sacar el texto
            String sqlP = "SELECT p.IdJugadorTurno, p.UltimoValorDado, p.IdEstado, p.IdUltimoMensaje, m.TextoTemplate " +
                          "FROM Partidas p " +
                          "JOIN Mensajes m ON p.IdUltimoMensaje = m.IdMensaje " +
                          "WHERE p.IdPartida = ?";
            PreparedStatement ps = con.prepareStatement(sqlP);
            ps.setInt(1, idPartida);
            ResultSet rs = ps.executeQuery();
            
            int idTurno = 0;
            int valorDado = 0;
            int estadoPartida = 0;
            int idMensaje = 1;
            String textoTemplate = "";

            if (rs.next()) {
                idTurno = rs.getInt("IdJugadorTurno");
                valorDado = rs.getInt("UltimoValorDado");
                estadoPartida = rs.getInt("IdEstado");
                idMensaje = rs.getInt("IdUltimoMensaje");
                textoTemplate = rs.getString("TextoTemplate");
            }
            rs.close(); ps.close();

            // 2. OBTENER JUGADORES (Para saber en qué casilla cayó el jugador del turno)
            String sqlJ = "SELECT j.IdJugador, j.Nombre, d.Orden, d.CasillaActual " +
                          "FROM DetallesPartida d JOIN Jugadores j ON d.IdJugador = j.IdJugador " +
                          "WHERE d.IdPartida = ? ORDER BY d.Orden ASC";
            ps = con.prepareStatement(sqlJ);
            ps.setInt(1, idPartida);
            ResultSet rsJ = ps.executeQuery();

            StringBuilder jsonJugadores = new StringBuilder("[");
            int casillaJugadorTurno = 1; // Para rellenar el mensaje

            boolean primero = true;
            while (rsJ.next()) {
                if (!primero) jsonJugadores.append(",");
                int idJ = rsJ.getInt("IdJugador");
                int casilla = rsJ.getInt("CasillaActual");
                
                // Si este es el jugador que acaba de tirar, guardamos su casilla para el mensaje
                if (idJ == idTurno) { 
                    casillaJugadorTurno = casilla; 
                }

                jsonJugadores.append("{");
                jsonJugadores.append("\"nombre\": \"").append(rsJ.getString("Nombre")).append("\",");
                jsonJugadores.append("\"orden\": ").append(rsJ.getInt("Orden")).append(",");
                jsonJugadores.append("\"casilla\": ").append(casilla);
                jsonJugadores.append("}");
                primero = false;
            }
            jsonJugadores.append("]");

            // 3. FORMATEAR EL MENSAJE FINAL
            // Rellenamos el {0} del mensaje.
            // Si es mensaje 1 (Dado), usamos el valor del dado.
            // Si es otro (Oca, Puente...), usamos la casilla de destino.
            String mensajeFinal = "";
            if (idMensaje == 1) {
                mensajeFinal = textoTemplate.replace("{0}", String.valueOf(valorDado));
            } else {
                mensajeFinal = textoTemplate.replace("{0}", String.valueOf(casillaJugadorTurno));
            }

            // 4. GENERAR JSON
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"esMiTurno\": ").append(idTurno == miId).append(", ");
            json.append("\"valorDado\": ").append(valorDado).append(", ");
            json.append("\"estadoPartida\": ").append(estadoPartida).append(", ");
            json.append("\"ultimoMensaje\": \"").append(mensajeFinal).append("\", ");
            json.append("\"jugadores\": ").append(jsonJugadores);
            json.append("}");

            out.print(json.toString());

        } catch (Exception e) { 
            e.printStackTrace(); 
            // En caso de error, devolvemos JSON válido pero con error
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        } finally { try { if (con != null) con.close(); } catch (Exception e) {} }
    }
}