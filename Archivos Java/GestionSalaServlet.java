import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class GestionSalaServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        
        HttpSession session = request.getSession();
        int idJugador = (Integer) session.getAttribute("id_usuario");
        String nick = (String) session.getAttribute("nick_usuario");
        
        String accion = request.getParameter("accion"); // "crear" o "unirse"
        String password = request.getParameter("password");
        if(password != null && password.trim().isEmpty()) password = null; // Convertir vacío a null

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConexionDB.obtenerConexion();

            if ("crear".equals(accion)) {
                // --- LÓGICA DE CREAR ---
                // 1. Crear partida con Estado 1 (Esperando)
                String sql = "INSERT INTO Partidas (Nombre, IdJugadorTurno, IdEstado, Password) VALUES (?, ?, 1, ?)";
                ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, "Sala de " + nick);
                ps.setInt(2, idJugador);
                ps.setString(3, password);
                ps.executeUpdate();

                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int idPartida = rs.getInt(1);
                    session.setAttribute("id_partida", idPartida);
                    
                    // 2. Meter al creador en DetallesPartida (Color Rojo por defecto)
                    insertarJugador(con, idPartida, idJugador, 1); // 1 = Rojo
                    
                    response.sendRedirect("salaEspera.jsp");
                }

            } else if ("unirse".equals(accion)) {
                // --- LÓGICA DE UNIRSE ---
                String sqlBuscar;
                if (password == null) {
                    // Buscar cualquiera pública que esté esperando (Estado 1) y tenga hueco
                    // (Simplificado: buscamos la primera esperando sin pass)
                    sqlBuscar = "SELECT IdPartida FROM Partidas WHERE IdEstado = 1 AND Password IS NULL ORDER BY IdPartida DESC LIMIT 1";
                    ps = con.prepareStatement(sqlBuscar);
                } else {
                    // Buscar una concreta por password
                    sqlBuscar = "SELECT IdPartida FROM Partidas WHERE IdEstado = 1 AND Password = ?";
                    ps = con.prepareStatement(sqlBuscar);
                    ps.setString(1, password);
                }
                
                rs = ps.executeQuery();
                
                if (rs.next()) {
                    int idPartidaEncontrada = rs.getInt("IdPartida");
                    
                    // Verificar si ya estoy dentro (por si recarga)
                    if (!estaEnPartida(con, idPartidaEncontrada, idJugador)) {
                        // Calcular siguiente color disponible (simple: contar cuantos hay + 1)
                        int numJugadores = contarJugadores(con, idPartidaEncontrada);
                        if (numJugadores < 4) {
                            insertarJugador(con, idPartidaEncontrada, idJugador, numJugadores + 1);
                            session.setAttribute("id_partida", idPartidaEncontrada);
                            response.sendRedirect("salaEspera.jsp");
                        } else {
                            response.sendRedirect("seleccion.jsp?error=llena");
                        }
                    } else {
                        session.setAttribute("id_partida", idPartidaEncontrada);
                        response.sendRedirect("salaEspera.jsp");
                    }
                    
                } else {
                    // No se encontró partida
                    response.sendRedirect("seleccion.jsp?error=no_encontrada");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("menu.jsp");
        } finally {
             try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
    
    // Métodos auxiliares para no repetir código
    private void insertarJugador(Connection con, int idPartida, int idJugador, int orden) throws SQLException {
        String sql = "INSERT INTO DetallesPartida (IdPartida, IdJugador, Casilla, Orden, Bloqueo) VALUES (?, ?, 1, ?, 0)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idPartida);
        ps.setInt(2, idJugador);
        ps.setInt(3, orden);
        ps.executeUpdate();
        ps.close();
    }
    
    private boolean estaEnPartida(Connection con, int idPartida, int idJugador) throws SQLException {
        String sql = "SELECT * FROM DetallesPartida WHERE IdPartida=? AND IdJugador=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idPartida);
        ps.setInt(2, idJugador);
        ResultSet rs = ps.executeQuery();
        boolean esta = rs.next();
        rs.close(); ps.close();
        return esta;
    }

    private int contarJugadores(Connection con, int idPartida) throws SQLException {
        String sql = "SELECT COUNT(*) FROM DetallesPartida WHERE IdPartida=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, idPartida);
        ResultSet rs = ps.executeQuery();
        rs.next();
        int total = rs.getInt(1);
        rs.close(); ps.close();
        return total;
    }
}