import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class RegistroServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        
        String nick = request.getParameter("nick");
        String pass = request.getParameter("password");
        String passHash = Seguridad.codificar(pass);

        try {
            Connection con = ConexionDB.obtenerConexion();
            
            // 1. Insertamos (RETURN_GENERATED_KEYS es vital para saber su nueva ID)
            String sql = "INSERT INTO usuarios (nick, password) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, nick);
            ps.setString(2, passHash);
            ps.executeUpdate();
            
            // 2. Recuperamos la ID que MySQL le ha dado
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int idNuevo = rs.getInt(1);

                // 3. ¡Login Automático! Creamos la sesión aquí mismo
                HttpSession session = request.getSession();
                session.setAttribute("id_usuario", idNuevo);
                session.setAttribute("nick_usuario", nick);

                // 4. Nos vamos al menú
                response.sendRedirect("menu.jsp");
            }
            con.close();

        } catch (Exception e) {
            // Si entra aquí, es probable que el Nick ya exista (por el UNIQUE de SQL)
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Error: Ese NICK ya está en uso. Prueba otro.'); window.location='index.html';</script>");
        }
    }
}