import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Usamos la anotación para no tener que tocar el web.xml
@WebServlet(name = "SetPartidaServlet", urlPatterns = {"/SetPartidaServlet"})
public class SetPartidaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Recibimos la ID de la partida que el usuario eligió en la lista
        String idPartidaStr = request.getParameter("id");
        
        if (idPartidaStr != null) {
            try {
                int idPartida = Integer.parseInt(idPartidaStr);
                
                // 2. Guardamos esa ID en la sesión
                HttpSession session = request.getSession();
                session.setAttribute("id_partida", idPartida);
                
                // 3. Redirigimos al tablero
                response.sendRedirect("tablero.jsp");
            } catch (NumberFormatException e) {
                // Si la ID no es un número válido, volvemos al menú
                response.sendRedirect("menu.jsp");
            }
        } else {
            response.sendRedirect("menu.jsp");
        }
    }
}