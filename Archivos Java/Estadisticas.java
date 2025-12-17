import java.sql.*;

public class Estadisticas {

    // Devuelve un array de 3 enteros: { PartidasJugadas, PartidasGanadas, Porcentaje }
    public static int[] obtenerDatos(int idJugador) {
        int jugadas = 0;
        int ganadas = 0;
        int porcentaje = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConexionDB.obtenerConexion();

            // 1. CALCULAR PARTIDAS JUGADAS (TERMINADAS)
            // Lógica: Buscamos partidas donde participe NUESTRO jugador (d1)
            // Y donde ALGUIEN (d2) haya llegado a la casilla 63 (Meta).
            String sqlJugadas = "SELECT COUNT(DISTINCT d1.IdPartida) " +
                                "FROM DetallesPartida d1 " +
                                "JOIN DetallesPartida d2 ON d1.IdPartida = d2.IdPartida " +
                                "WHERE d1.IdJugador = ? AND d2.Casilla = 63";
            
            ps = con.prepareStatement(sqlJugadas);
            ps.setInt(1, idJugador);
            rs = ps.executeQuery();
            if (rs.next()) {
                jugadas = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // 2. CALCULAR PARTIDAS GANADAS
            // Lógica: Partidas donde YO estoy en la casilla 63.
            String sqlGanadas = "SELECT COUNT(*) FROM DetallesPartida WHERE IdJugador = ? AND Casilla = 63";
            ps = con.prepareStatement(sqlGanadas);
            ps.setInt(1, idJugador);
            rs = ps.executeQuery();
            if (rs.next()) {
                ganadas = rs.getInt(1);
            }

            // 3. CALCULAR PORCENTAJE (Evitando división por cero)
            if (jugadas > 0) {
                // Multiplicamos por 100 antes de dividir para no perder decimales en la división entera
                porcentaje = (ganadas * 100) / jugadas;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return new int[] { jugadas, ganadas, porcentaje };
    }
}