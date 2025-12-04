import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class OcaServlet extends HttpServlet {
    
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h1>Hola! Soy el Servlet del Juego de la Oca</h1>");
        out.println("<p>Si lees esto, Java funciona correctamente en el servidor.</p>");
        out.println("</body></html>");
    }
}