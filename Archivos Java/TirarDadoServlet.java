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
            
            // 2. LÓGICA DE CASTIGO (Si tiene turnos pendientes, no tira)
            if (castigo > 0) {
                // Reducir castigo
                String sqlReducir = "UPDATE DetallesPartida SET TurnosCastigo = TurnosCastigo - 1 WHERE IdPartida=? AND IdJugador=?";
                PreparedStatement psR = con.prepareStatement(sqlReducir);
                psR.setInt(1, idPartida);
                psR.setInt(2, miId);
                psR.executeUpdate();
                psR.close();

                // Cambiar el turno al siguiente jugador y salir
                int idSiguiente = obtenerSiguienteJugador(con, idPartida, miOrden);
                cambiarTurno(con, idPartida, idSiguiente, miId, 0, 9); 
                response.setStatus(200);
                return;
            }
            // 3. LÓGICA MOVIMIENTO
            int dado;
            String nickUsuario = (String) session.getAttribute("nick_usuario");
            String valorTrucado = request.getParameter("dado");
            
            // Si es Patiño y ha elegido un número en el selector
            if (nickUsuario != null && (nickUsuario.equalsIgnoreCase("patiño") || nickUsuario.equals("patiÃ±o")) 
                && valorTrucado != null && !valorTrucado.isEmpty()) {
                
                try {
                    dado = Integer.parseInt(valorTrucado);
                } catch (NumberFormatException e) {
                    dado = (int) (Math.random() * 6) + 1; // Si falla, aleatorio
                }
                System.out.println("🎲 TRUCO ACTIVADO por Patiño: Ha sacado un " + dado);
                
            } else {
                // Jugador normal o Patiño eligiendo "Aleatorio"
                dado = (int) (Math.random() * 6) + 1;
            }
            int nuevaCasilla = casillaActual + dado;
            
            // AQUÍ ESTÁ EL CAMBIO: Usamos IDs en lugar de Strings
            int idMensaje = 1; // 1 = Normal ("Ha sacado un X")
           boolean repetirTurno = false; 
           boolean juegoTerminado = false; 
           if (nuevaCasilla == 63) { 
               nuevaCasilla = 63; idMensaje = 6; 
               // VICTORIA 
               juegoTerminado = true; 
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
                    // OCA
                    repetirTurno = true; 
                }
                else if (nuevaCasilla > 63) {
                    // REBOTE (Torrarse): Si estoy en 61 y saco un 4: 61+4=65. 65-63=2. 63-2 = 61.
                    int exceso = nuevaCasilla - 63;
                    nuevaCasilla = 63 - exceso;
                    idMensaje = 11; // i{1} SE TORRÓ!
                } 
                else if (nuevaCasilla == 6) {
                    nuevaCasilla = 12;
                    idMensaje = 3; 
                    // PUENTE A PUENTE 
                    repetirTurno = true;
                } 
                else if (nuevaCasilla == 12) {
                    nuevaCasilla = 6;
                    idMensaje = 3;
                    // PUENTE ROTO 
                    repetirTurno = true;
                } 
                else if (nuevaCasilla == 58) {
                    nuevaCasilla = 1;
                    idMensaje = 8;
                    // MUERTE
                } 
                else if (nuevaCasilla == 19) {
                    // LA POSADA
                    idMensaje = 4;
                } 
                else if (nuevaCasilla == 31) {
                    // EL POZO
                    idMensaje = 5;
                    // Se queda hasta que otro jugador caiga o pasen N turnos
                } 
                else if (nuevaCasilla == 52) {
                    // LA CÁRCEL 
                    idMensaje = 7;
                } 
                else if (nuevaCasilla == 42) {
                    // EL LABERINTO 
                    idMensaje = 9; 
                    // 1. Aplicamos el castigo
                    String sqlC = "UPDATE DetallesPartida SET TurnosCastigo = 4 WHERE IdPartida=? AND IdJugador=?"; 
                    try (PreparedStatement psC = con.prepareStatement(sqlC)) {
                        psC.setInt(1, idPartida);
                        psC.setInt(2, miId);
                        psC.executeUpdate(); 
                    }
                    // 2. IMPORTANTE: Forzamos que NO repita turno para que pase al siguiente
                    repetirTurno = false;
                }
                else if (nuevaCasilla == 26 || nuevaCasilla == 53) {
                    // CASILLA DE DADOS 
                    idMensaje = 10; 
                    // {1} ha caido en los dados 
                    repetirTurno = true; 
                }
            }

            // 4. ACTUALIZAR POSICIÓN
            String sqlUpdPos = "UPDATE DetallesPartida SET CasillaActual = ? WHERE IdPartida=? AND IdJugador=?";
            PreparedStatement psUp = con.prepareStatement(sqlUpdPos);
            psUp.setInt(1, nuevaCasilla);
            psUp.setInt(2, idPartida);
            psUp.setInt(3, miId);
            psUp.executeUpdate();
            psUp.close();

            // 5. GESTIONAR FINAL O CAMBIO DE TURNO
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
                    // Lógica para calcular el siguiente ID de jugador
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

    // Método auxiliar para no repetir código de cambio de turno
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
}