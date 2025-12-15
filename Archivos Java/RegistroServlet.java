import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class RegistroServlet extends HttpServlet {

    // Usamos doPost porque el formulario HTML envía los datos con method="POST"
    public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // 1. Recibir datos del formulario
        String nick = request.getParameter("nick");
        String passPlana = request.getParameter("password"); // Contraseña legible (1234)
        
        // PASO NUEVO: Codificar la contraseña
        String passHash = Seguridad.codificar(passPlana); // Contraseña segura (a665a45920...)
        
        out.println("<html><body style='text-align:center; font-family:sans-serif;'>");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // 2. Conectar a la BD (Usando la clase que creamos antes)
            con = ConexionDB.obtenerConexion();
            
            if (con != null) {
                // 3. Preparar la inserción (SQL)
                // Usamos ? para evitar que nos hackeen con SQL Injection
                String sql = "INSERT INTO usuarios (nick, password) VALUES (?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, nick);
                ps.setString(2, passHash);

                // 4. Ejecutar
                int filasAfectadas = ps.executeUpdate();

                if (filasAfectadas > 0) {
                    out.println("<h2 style='color:green'>¡Registro Exitoso!</h2>");
                    out.println("<p>Bienvenido, " + nick + ".</p>");
                    out.println("<a href='index.html'>Volver al Inicio para entrar</a>");
                }
            } else {
                out.println("<h3>Error: No se pudo conectar a la base de datos.</h3>");
            }

        } catch (SQLException e) {
            // REQUISITO: Evitar dos usuarios con el mismo nick 
            // El código de error 1062 en MySQL significa "Duplicate entry"
            if (e.getErrorCode() == 1062) {
                out.println("<h3 style='color:red'>Error: El Nick '" + nick + "' ya existe.</h3>");
                out.println("<p>Por favor, elige otro.</p>");
                out.println("<a href='index.html'>Intentarlo de nuevo</a>");
            } else {
                out.println("<h3>Error de Base de Datos: " + e.getMessage() + "</h3>");
            }
        } finally {
            // 5. Cerrar conexiones para no bloquear el servidor
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        out.println("</body></html>");
    }
}