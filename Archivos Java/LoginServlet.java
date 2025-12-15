import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class LoginServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Obtenemos datos del formulario
        String nick = request.getParameter("nick");
        String pass = request.getParameter("password");
        
        // Convertimos contraseña a código MD5
        String passHash = Seguridad.codificar(pass);

        try {
            Connection con = ConexionDB.obtenerConexion();
            // Buscamos si existe
            String sql = "SELECT id FROM usuarios WHERE nick = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nick);
            ps.setString(2, passHash);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // --- ¡ÉXITO! ---
                HttpSession session = request.getSession();
                session.setAttribute("id_usuario", rs.getInt("id"));
                session.setAttribute("nick_usuario", nick);

                // Nos vamos al menú
                response.sendRedirect("menu.jsp");
            } else {
                // --- FALLO ---
                response.setContentType("text/html;charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>alert('Usuario o contraseña incorrectos'); window.location='index.html';</script>");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}