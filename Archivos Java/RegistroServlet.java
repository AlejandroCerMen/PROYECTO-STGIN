import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class RegistroServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        
        String nombreRecibido = request.getParameter("nick");
        String passRecibido = request.getParameter("password");
        String passHash = Seguridad.codificar(passRecibido);

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConexionDB.obtenerConexion();
            
            // --- CAMBIO PRINCIPAL: Insertar en 'Jugadores' ---
            String sql = "INSERT INTO Jugadores (Nombre, Password) VALUES (?, ?)";
            
            // Necesitamos RETURN_GENERATED_KEYS para saber qué ID le ha tocado
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, nombreRecibido);
            ps.setString(2, passHash);
            
            ps.executeUpdate(); // Ejecutamos el registro
            
            // Recuperamos el ID generado automáticamente
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int idNuevo = rs.getInt(1);

                // --- LOGIN AUTOMÁTICO ---
                HttpSession session = request.getSession();
                session.setAttribute("id_usuario", idNuevo);
                session.setAttribute("nick_usuario", nombreRecibido);

                // Vamos al menú
                response.sendRedirect("menu.jsp");
            }

        } catch (Exception e) {
            // Si entra aquí, suele ser porque el nombre ya existe (Duplicado)
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Error: Ese nombre ya está en uso. Elige otro.'); window.location='index.html';</script>");
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}