import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/EmpezarJuegoServlet")
public class EmpezarJuegoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer idPartida = (Integer) session.getAttribute("id_partida");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (idPartida != null) {
            Connection con = null;
            try {
                con = ConexionDB.obtenerConexion();
                
                // 1. VALIDACIÓN: ¿Hay colores repetidos?
                // Contamos jugadores totales y colores distintos. Deben ser iguales.
                String sqlValidar = "SELECT COUNT(*) AS total, COUNT(DISTINCT Color) AS colores_unicos FROM DetallesPartida WHERE IdPartida = ?";
                PreparedStatement psVal = con.prepareStatement(sqlValidar);
                psVal.setInt(1, idPartida);
                ResultSet rs = psVal.executeQuery();
                
                if (rs.next()) {
                    int total = rs.getInt("total");
                    int unicos = rs.getInt("colores_unicos");
                    
                    if (total < 2) {
                        out.print("{\"error\": \"Necesitas al menos 2 jugadores.\"}");
                        con.close();
                        return;
                    }
                    if (total != unicos) {
                        out.print("{\"error\": \"¡Hay colores repetidos! Cada jugador debe elegir uno distinto.\"}");
                        con.close();
                        return;
                    }
                }
                rs.close(); psVal.close();

                // 2. SI TODO ESTÁ BIEN: Empezamos la partida
                String sqlEmpezar = "UPDATE Partidas SET IdEstado = 2 WHERE IdPartida = ?";
                PreparedStatement psStart = con.prepareStatement(sqlEmpezar);
                psStart.setInt(1, idPartida);
                psStart.executeUpdate();
                
                out.print("{\"status\": \"ok\"}");
                con.close();

            } catch (Exception e) {
                e.printStackTrace();
                out.print("{\"error\": \"Error en base de datos\"}");
            }
        } else {
             out.print("{\"error\": \"No hay partida\"}");
        }
    }
}