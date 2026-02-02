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
            
            // 0. VERIFICAR SI LA PARTIDA YA TERMINÓ
            String sqlEstado = "SELECT IdEstado FROM Partidas WHERE IdPartida = ?";
            try (PreparedStatement psEst = con.prepareStatement(sqlEstado)) {
                 psEst.setInt(1, idPartida);
                ResultSet rsEst = psEst.executeQuery();
                if (rsEst.next()) {
                     int estado = rsEst.getInt("IdEstado");
                     if (estado == 3) { // 3 = Finalizada/Victoria
                          response.sendError(HttpServletResponse.SC_FORBIDDEN, "La partida ya ha terminado.");
                          return;
                      }
                 }
            }

            // 1. INFO ACTUAL
            String sqlInfo = "SELECT CasillaActual, Orden, TurnosCastigo FROM DetallesPartida WHERE IdPartida=? AND IdJugador=?";
            PreparedStatement psInfo = con.prepareStatement(sqlInfo);
            psInfo.setInt(1, idPartida);
            psInfo.setInt(2, miId);
            ResultSet rsInfo = psInfo.executeQuery();
            
            int casillaActual = 1;
            int miOrden = 0;
            int castigo = 0;
            if (rsInfo.next()) {
                casillaActual = rsInfo.getInt("CasillaActual");
                miOrden = rsInfo.getInt("Orden");
                castigo = rsInfo.getInt("TurnosCastigo");
            }
            rsInfo.close(); psInfo.close();
            
            // 2. LÓGICA DE CASTIGO
            if (castigo > 0) {
                int idSiguiente = obtenerSiguienteJugador(con, idPartida, miOrden);

                if (castigo >= 90) { 
                    // Castigo infinito (Pozo/Cárcel/Posada)
                    cambiarTurno(con, idPartida, idSiguiente, miId, 0, 14); 
                } 
                else {
                    // Reducir castigo normal
                    String sqlReducir = "UPDATE DetallesPartida SET TurnosCastigo = TurnosCastigo - 1 WHERE IdPartida=? AND IdJugador=?";
                    try (PreparedStatement psR = con.prepareStatement(sqlReducir)) {
                        psR.setInt(1, idPartida);
                        psR.setInt(2, miId);
                        psR.executeUpdate();
                    }

                    if (castigo > 1) {
                        cambiarTurno(con, idPartida, idSiguiente, miId, 0, 12);
                    } else {
                        cambiarTurno(con, idPartida, idSiguiente, miId, 0, 13);
                    }
                }
                
                response.setStatus(200);
                return;
            }

            // 3. LÓGICA MOVIMIENTO
            int dado;
            String nickUsuario = (String) session.getAttribute("nick_usuario");
            String valorTrucado = request.getParameter("dado");
            
            // Si es Patiño (o variantes) y ha elegido un número
            if (nickUsuario != null && (nickUsuario.equalsIgnoreCase("patiño") || nickUsuario.equals("patiÃ±o") || nickUsuario.equalsIgnoreCase("pati")) 
                && valorTrucado != null && !valorTrucado.isEmpty()) {
                
                try {
                    dado = Integer.parseInt(valorTrucado);
                } catch (NumberFormatException e) {
                    dado = (int) (Math.random() * 6) + 1;
                }
                // Debug (opcional)
                System.out.println("🎲 TRUCO ACTIVADO: " + dado);
                
            } else {
                dado = (int) (Math.random() * 6) + 1;
            }

            // ==========================================
            // CORRECCIÓN PARA LA META (TRUCO 63)
            // ==========================================
            int nuevaCasilla;
            
            if (dado == 63) {
                // Si el truco es 63, vamos directos a la meta (Casilla 63) SIN SUMAR
                nuevaCasilla = 63;
                
                // Ajustamos el valor del dado solo para que en el historial no salga "Has sacado un 63"
                if (casillaActual < 63) {
                    dado = 63 - casillaActual;
                }
            } else {
                // Cálculo normal para cualquier otro caso (sumar dado a la casilla actual)
                nuevaCasilla = casillaActual + dado;
            }
            // ==========================================
            
            int idMensaje = 1; 
            boolean repetirTurno = false; 
            boolean juegoTerminado = false; 
            
            // REBOTE (Si se pasa de 63, pero SOLO si no hemos forzado el 63 antes)
            if (nuevaCasilla > 63) {
                int exceso = nuevaCasilla - 63;
                nuevaCasilla = 63 - exceso;
                idMensaje = 11; // {1} se torró y vuelve a {0}
            }
            
            // COMPROBACIONES DE CASILLAS
            if (nuevaCasilla == 63) { 
               nuevaCasilla = 63; idMensaje = 6; 
               juegoTerminado = true; // VICTORIA
            } 
            else { 
                if (OCAS.contains(nuevaCasilla)) { 
                    int siguienteOca = 63; 
                    for (int oca : OCAS) {
                        if (oca > nuevaCasilla) { 
                            siguienteOca = oca; break;
                        } 
                    } 
                    nuevaCasilla = siguienteOca; idMensaje = 2; 
                    repetirTurno = true; 
                } 
                else if (nuevaCasilla == 6) { nuevaCasilla = 12; idMensaje = 3; repetirTurno = true; } 
                else if (nuevaCasilla == 12) { nuevaCasilla = 6; idMensaje = 3; repetirTurno = true; } 
                else if (nuevaCasilla == 58) { nuevaCasilla = 1; idMensaje = 8; } 
                else if (nuevaCasilla == 19) { 
                    idMensaje = 4; 
                    liberarAtrapados(con, idPartida, nuevaCasilla);
                    setCastigoInfinito(con, idPartida, miId);
                    repetirTurno = false;
                } 
                else if (nuevaCasilla == 31) { 
                    idMensaje = 5; 
                    liberarAtrapados(con, idPartida, nuevaCasilla);
                    setCastigoInfinito(con, idPartida, miId);
                    repetirTurno = false;
                } 
                else if (nuevaCasilla == 52) { 
                    idMensaje = 7; 
                    liberarAtrapados(con, idPartida, nuevaCasilla);
                    setCastigoInfinito(con, idPartida, miId);
                    repetirTurno = false;
                } 
                else if (nuevaCasilla == 42) { 
                    idMensaje = 9; 
                    String sqlC = "UPDATE DetallesPartida SET TurnosCastigo = 4 WHERE IdPartida=? AND IdJugador=?"; 
                    try (PreparedStatement psC = con.prepareStatement(sqlC)) {
                        psC.setInt(1, idPartida);
                        psC.setInt(2, miId);
                        psC.executeUpdate(); 
                    }
                    repetirTurno = false; 
                }
                else if (nuevaCasilla == 26 || nuevaCasilla == 53) { idMensaje = 10; repetirTurno = true; }
            }

            // 4. ACTUALIZAR POSICIÓN EN BD
            String sqlUpdPos = "UPDATE DetallesPartida SET CasillaActual = ? WHERE IdPartida=? AND IdJugador=?";
            PreparedStatement psUp = con.prepareStatement(sqlUpdPos);
            psUp.setInt(1, nuevaCasilla);
            psUp.setInt(2, idPartida);
            psUp.setInt(3, miId);
            psUp.executeUpdate();
            psUp.close();

            // 5. FINALIZAR O CAMBIAR TURNO
            if (juegoTerminado) {
                String sqlFin = "UPDATE Partidas SET IdEstado=3, UltimoValorDado=?, IdUltimoMensaje=?, IdUltimoJugadorAccion=? WHERE IdPartida=?";
                PreparedStatement psFin = con.prepareStatement(sqlFin);
                psFin.setInt(1, dado);
                psFin.setInt(2, idMensaje); 
                psFin.setInt(3, miId);
                psFin.setInt(4, idPartida);
                psFin.executeUpdate();
                psFin.close();
            } else {
                int idSiguiente = miId;
                if (!repetirTurno) {
                    idSiguiente = obtenerSiguienteJugador(con, idPartida, miOrden);
                }
                cambiarTurno(con, idPartida, idSiguiente, miId, dado, idMensaje);
            }
            
            response.setStatus(200);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        } finally { try { if (con != null) con.close(); } catch (Exception e) {} }
    }

    private void cambiarTurno(Connection con, int idPartida, int idSiguiente, int miId, int dado, int idMensaje) throws SQLException {
        String sqlTurno = "UPDATE Partidas SET IdJugadorTurno=?, UltimoValorDado=?, IdUltimoMensaje=?, IdUltimoJugadorAccion=? WHERE IdPartida=?";
        PreparedStatement psT = con.prepareStatement(sqlTurno);
        psT.setInt(1, idSiguiente);
        psT.setInt(2, dado);
        psT.setInt(3, idMensaje);
        psT.setInt(4, miId);
        psT.setInt(5, idPartida);
        psT.executeUpdate();
        psT.close();
    }

    private int obtenerSiguienteJugador(Connection con, int idPartida, int miOrden) throws SQLException {
        String sqlCount = "SELECT COUNT(*) FROM DetallesPartida WHERE IdPartida=?";
        PreparedStatement psCount = con.prepareStatement(sqlCount);
        psCount.setInt(1, idPartida);
        ResultSet rsC = psCount.executeQuery(); rsC.next(); 
        int total = rsC.getInt(1);
        rsC.close(); psCount.close();

        int siguienteOrden = (miOrden % total) + 1;

        String sqlNext = "SELECT IdJugador FROM DetallesPartida WHERE IdPartida=? AND Orden=?";
        PreparedStatement psN = con.prepareStatement(sqlNext);
        psN.setInt(1, idPartida);
        psN.setInt(2, siguienteOrden);
        ResultSet rsN = psN.executeQuery();
        int idSiguiente = 0;
        if (rsN.next()) idSiguiente = rsN.getInt("IdJugador");
        rsN.close(); psN.close();
        return idSiguiente;
    }
    
    private void liberarAtrapados(Connection con, int idPartida, int casilla) throws SQLException {
        String sql = "UPDATE DetallesPartida SET TurnosCastigo = 0 " +
                     "WHERE IdPartida = ? AND CasillaActual = ? AND TurnosCastigo >= 90";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPartida);
            ps.setInt(2, casilla);
            ps.executeUpdate();
        }
    }

    private void setCastigoInfinito(Connection con, int idPartida, int idJugador) throws SQLException {
        String sql = "UPDATE DetallesPartida SET TurnosCastigo = 99 WHERE IdPartida = ? AND IdJugador = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPartida);
            ps.setInt(2, idJugador);
            ps.executeUpdate();
        }
    }
}