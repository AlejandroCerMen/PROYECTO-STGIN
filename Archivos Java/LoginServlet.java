import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class LoginServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Obtenemos los datos del formulario (el HTML input sigue llamándose "nick" y "password")
        String nombreRecibido = request.getParameter("nick");
        String passRecibido = request.getParameter("password");
        
        // Codificamos la contraseña
        String passHash = Seguridad.codificar(passRecibido);

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConexionDB.obtenerConexion();
            
            // --- CAMBIO PRINCIPAL: Nombres de tabla y columnas nuevos ---
            // Buscamos en 'Jugadores' usando 'Nombre' y 'Password'
            String sql = "SELECT IdJugador FROM Jugadores WHERE Nombre = ? AND Password = ?";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, nombreRecibido);
            ps.setString(2, passHash);
            
            rs = ps.executeQuery();

            if (rs.next()) {
                // --- LOGIN CORRECTO ---
                HttpSession session = request.getSession();
                
                // Recuperamos el ID con el nuevo nombre de columna "IdJugador"
                int idEncontrado = rs.getInt("IdJugador");

                // Guardamos en sesión (Mantenemos las llaves 'id_usuario' y 'nick_usuario' 
                // para que menu.jsp siga funcionando sin cambios)
                session.setAttribute("id_usuario", idEncontrado);
                session.setAttribute("nick_usuario", nombreRecibido);

                // Vamos al menú
                response.sendRedirect("menu.jsp");

            } else {
                // --- LOGIN FALLIDO ---
                response.setContentType("text/html;charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>alert('Usuario o contraseña incorrectos'); window.location='index.html';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.html");
        } finally {
            // Cerramos recursos para evitar problemas de memoria
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}