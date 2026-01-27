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
            con = ConexionDB.obtenerConexion(); // Asegúrate de que esto coincide con tu clase ConexionDB

            // 1. OBTENEMOS DATOS DE LA PARTIDA
            String sqlP = "SELECT p.IdJugadorTurno, p.UltimoValorDado, p.IdEstado, p.IdUltimoMensaje, " +
                          "m.TextoTemplate, j.Nombre AS QuienMovio, p.IdUltimoJugadorAccion " + 
                          "FROM Partidas p " +
                          "LEFT JOIN Mensajes m ON p.IdUltimoMensaje = m.IdMensaje " +
                          "LEFT JOIN Jugadores j ON p.IdUltimoJugadorAccion = j.IdJugador " + 
                          "WHERE p.IdPartida = ?";
            
            PreparedStatement ps = con.prepareStatement(sqlP);
            ps.setInt(1, idPartida);
            ResultSet rs = ps.executeQuery();
            
            int idTurnoActual = 0, valorDado = 0, estadoPartida = 0, idMensaje = 0, idUltimoJugadorAccion = 0;
            String nombreJugadorAccion = ""; 
            String textoTemplate = ""; 

            if (rs.next()) {
                idTurnoActual = rs.getInt("IdJugadorTurno");
                valorDado = rs.getInt("UltimoValorDado");
                estadoPartida = rs.getInt("IdEstado");
                idMensaje = rs.getInt("IdUltimoMensaje");
                idUltimoJugadorAccion = rs.getInt("IdUltimoJugadorAccion");
                
                // Si estamos al principio (IdUltimoMensaje es 0 o null)
                if (idMensaje <= 0) {
                    textoTemplate = "¡Bienvenidos! Es el turno de {1}";
                    // En el primer turno, "QuienMovio" será el que tiene el turno
                    String sqlPrimerNombre = "SELECT Nombre FROM Jugadores WHERE IdJugador = ?";
                    try (PreparedStatement psN = con.prepareStatement(sqlPrimerNombre)) {
                        psN.setInt(1, idTurnoActual);
                        ResultSet rsN = psN.executeQuery();
                        if (rsN.next()) nombreJugadorAccion = rsN.getString("Nombre");
                    }
                } else {
                    textoTemplate = rs.getString("TextoTemplate");
                    nombreJugadorAccion = rs.getString("QuienMovio");
                }
            }
            
            // Si después de todo sigue siendo null, ponemos un valor seguro
            if (nombreJugadorAccion == null) nombreJugadorAccion = "Jugador";
            if (textoTemplate == null) textoTemplate = "Iniciando partida...";
            
            rs.close(); ps.close();

            // 2. OBTENER JUGADORES + COLOR
            // MODIFICACIÓN: Añadimos 'd.Color' a la consulta
            String sqlJ = "SELECT j.IdJugador, j.Nombre, d.Orden, d.CasillaActual, d.Color " +
                          "FROM DetallesPartida d JOIN Jugadores j ON d.IdJugador = j.IdJugador " +
                          "WHERE d.IdPartida = ? ORDER BY d.Orden ASC";
            ps = con.prepareStatement(sqlJ);
            ps.setInt(1, idPartida);
            ResultSet rsJ = ps.executeQuery();

            StringBuilder jsonJugadores = new StringBuilder("[");
            int casillaJugadorAccion = 1; 
            boolean primero = true;
            while (rsJ.next()) {
                if (!primero) jsonJugadores.append(",");
                int idJ = rsJ.getInt("IdJugador");
                int casilla = rsJ.getInt("CasillaActual");
                
                // Leemos el color. Si es 0 o nulo, forzamos 1 (Azul) para evitar errores visuales
                int colorDB = rsJ.getInt("Color");
                if (colorDB == 0) colorDB = 1;

                if (idJ == idUltimoJugadorAccion) casillaJugadorAccion = casilla;

                // MODIFICACIÓN: Añadimos el campo "color" al JSON
                jsonJugadores.append("{\"nombre\": \"").append(rsJ.getString("Nombre"))
                             .append("\", \"orden\": ").append(rsJ.getInt("Orden"))
                             .append(", \"casilla\": ").append(casilla)
                             .append(", \"color\": ").append(colorDB) // <--- ESTO ES NUEVO
                             .append("}");
                primero = false;
            }
            jsonJugadores.append("]");
            rsJ.close(); ps.close();

            // 3. FORMATEAR MENSAJE
            // {1} es el Nombre, {0} es el valor del dado o la casilla de destino
            String valorReemplazo = "";
            int turnosRestantes = 0;
            if (idMensaje == 1) {
                valorReemplazo = String.valueOf(valorDado);
            }
            else if (idMensaje == 11){
                valorReemplazo = String.valueOf(casillaJugadorAccion);
            }
            else if (idMensaje == 9) {
                // El Laberinto según tu tabla usa {4} para los turnos.
                String sqlT = "SELECT TurnosCastigo FROM DetallesPartida WHERE IdPartida=? AND IdJugador=?";
                PreparedStatement psT = con.prepareStatement(sqlT);
                psT.setInt(1, idPartida);
                psT.setInt(2, idUltimoJugadorAccion);
                ResultSet rsT = psT.executeQuery();
                if(rsT.next()) turnosRestantes = rsT.getInt("TurnosCastigo");
                rsT.close(); psT.close();
            }
            else{
                valorReemplazo = String.valueOf(casillaJugadorAccion);
            }      
            String mensajeFinal = textoTemplate
                .replace("{1}", nombreJugadorAccion)
                .replace("{0}", valorReemplazo)
                .replace("{4}", String.valueOf(turnosRestantes));

            // 4. GENERAR JSON FINAL
            out.print("{" +
                "\"esMiTurno\": " + (idTurnoActual == miId) + ", " +
                "\"valorDado\": " + valorDado + ", " +
                "\"estadoPartida\": " + estadoPartida + ", " +
                "\"ultimoMensaje\": \"" + mensajeFinal + "\", " +
                "\"jugadores\": " + jsonJugadores.toString() +
                "}");

        } catch (Exception e) { 
            e.printStackTrace(); 
            out.print("{\"error\": \"Error: " + e.getMessage() + "\"}");
        } finally { 
            try { if (con != null) con.close(); } catch (Exception e) {} 
        }
    }
}