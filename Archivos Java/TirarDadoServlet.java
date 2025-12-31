import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.*;

@WebServlet(name = "TirarDadoServlet", urlPatterns = {"/TirarDadoServlet"})
public class TirarDadoServlet extends HttpServlet {
    
    private static final List<Integer> OCAS = Arrays.asList(5, 9, 14, 18, 23, 27, 32, 36, 41, 45, 50, 54, 59);

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("id_partida") == null) return;

        int idPartida = (Integer) session.getAttribute("id_partida");
        int miId = (Integer) session.getAttribute("id_usuario");

        Connection con = null;
        try {
            con = ConexionDB.obtenerConexion();

            // 1. INFO ACTUAL
            String sqlInfo = "SELECT CasillaActual, Orden FROM DetallesPartida WHERE IdPartida=? AND IdJugador=?";
            PreparedStatement psInfo = con.prepareStatement(sqlInfo);
            psInfo.setInt(1, idPartida);
            psInfo.setInt(2, miId);
            ResultSet rsInfo = psInfo.executeQuery();
            
            int casillaActual = 1;
            int miOrden = 0;
            if (rsInfo.next()) {
                casillaActual = rsInfo.getInt("CasillaActual");
                miOrden = rsInfo.getInt("Orden");
            }
            rsInfo.close(); psInfo.close();

            // 2. LÓGICA
            int dado = (int) (Math.random() * 6) + 1;
            int nuevaCasilla = casillaActual + dado;
            
            // AQUÍ ESTÁ EL CAMBIO: Usamos IDs en lugar de Strings
            int idMensaje = 1; // 1 = Normal ("Ha sacado un X")
            boolean repetirTurno = false;
            boolean juegoTerminado = false;

            if (nuevaCasilla >= 63) {
                nuevaCasilla = 63;
                idMensaje = 6; // VICTORIA
                juegoTerminado = true;
            } 
            else {
                if (OCAS.contains(nuevaCasilla)) {
                    int siguienteOca = 63;
                    for (int oca : OCAS) { if (oca > nuevaCasilla) { siguienteOca = oca; break; } }
                    nuevaCasilla = siguienteOca;
                    idMensaje = 2; // OCA
                    repetirTurno = true;
                }
                else if (nuevaCasilla == 6) {
                    nuevaCasilla = 12;
                    idMensaje = 3; // PUENTE A PUENTE
                    repetirTurno = true;
                }
                else if (nuevaCasilla == 12) {
                    nuevaCasilla = 6;
                    idMensaje = 4; // PUENTE ROTO
                    repetirTurno = true;
                }
                else if (nuevaCasilla == 58) {
                    nuevaCasilla = 1;
                    idMensaje = 5; // MUERTE
                }
            }

            // 3. ACTUALIZAR POSICIÓN
            String sqlUpdPos = "UPDATE DetallesPartida SET CasillaActual = ? WHERE IdPartida=? AND IdJugador=?";
            PreparedStatement psUp = con.prepareStatement(sqlUpdPos);
            psUp.setInt(1, nuevaCasilla);
            psUp.setInt(2, idPartida);
            psUp.setInt(3, miId);
            psUp.executeUpdate();
            psUp.close();

            // 4. GUARDAR ESTADO (Usando el IdMensaje)
            if (juegoTerminado) {
                String sqlFin = "UPDATE Partidas SET IdEstado=3, UltimoValorDado=?, IdUltimoMensaje=? WHERE IdPartida=?";
                PreparedStatement psFin = con.prepareStatement(sqlFin);
                psFin.setInt(1, dado);
                psFin.setInt(2, idMensaje); // Guardamos ID
                psFin.setInt(3, idPartida);
                psFin.executeUpdate();
                psFin.close();
            } else {
                int idSiguienteJugador = miId;
                if (!repetirTurno) {
                    // (Lógica de siguiente turno simplificada igual que antes)
                    String sqlCount = "SELECT COUNT(*) FROM DetallesPartida WHERE IdPartida=?";
                    PreparedStatement psCount = con.prepareStatement(sqlCount);
                    psCount.setInt(1, idPartida);
                    ResultSet rsC = psCount.executeQuery(); rsC.next(); int total = rsC.getInt(1);
                    
                    int siguienteOrden = miOrden + 1;
                    if (siguienteOrden > total) siguienteOrden = 1;
                    
                    String sqlNext = "SELECT IdJugador FROM DetallesPartida WHERE IdPartida=? AND Orden=?";
                    PreparedStatement psN = con.prepareStatement(sqlNext);
                    psN.setInt(1, idPartida);
                    psN.setInt(2, siguienteOrden);
                    ResultSet rsN = psN.executeQuery();
                    if (rsN.next()) idSiguienteJugador = rsN.getInt("IdJugador");
                }

                String sqlTurno = "UPDATE Partidas SET IdJugadorTurno=?, UltimoValorDado=?, IdUltimoMensaje=? WHERE IdPartida=?";
                PreparedStatement psT = con.prepareStatement(sqlTurno);
                psT.setInt(1, idSiguienteJugador);
                psT.setInt(2, dado);
                psT.setInt(3, idMensaje); // Guardamos ID
                psT.setInt(4, idPartida);
                psT.executeUpdate();
                psT.close();
            }
            response.setStatus(200);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        } finally { try { if (con != null) con.close(); } catch (Exception e) {} }
    }
}