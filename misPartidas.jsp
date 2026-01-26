<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 1. SEGURIDAD: Si no está logueado, lo mandamos al login
    if (session.getAttribute("id_usuario") == null) {
        response.sendRedirect("index.html");
        return;
    }

    int idUsuario = (Integer) session.getAttribute("id_usuario");
    String tipo = request.getParameter("tipo"); // Recibe "turno" o "espera"
    
    String titulo = "";
    String colorHeader = "";
    
    // 2. CONFIGURACIÓN VISUAL: Título y color según el botón que pulsó
    if ("turno".equals(tipo)) {
        titulo = "🎲 Partidas donde es tu turno";
        colorHeader = "#27ae60"; // Verde
    } else {
        titulo = "⏳ Partidas esperando turno";
        colorHeader = "#f39c12"; // Naranja
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Mis Partidas</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #2c3e50; color: white; text-align: center; padding: 40px; }
        .container { width: 80%; margin: 0 auto; background: white; color: #333; border-radius: 10px; padding: 20px; box-shadow: 0 0 20px rgba(0,0,0,0.5); }
        h1 { color: <%= colorHeader %>; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: <%= colorHeader %>; color: white; padding: 12px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f1f1f1; }
        .btn-entrar { 
            background-color: #2980b9; color: white; padding: 8px 15px; text-decoration: none; 
            border-radius: 5px; font-weight: bold; font-size: 14px; 
        }
        .btn-entrar:hover { background-color: #1abc9c; }
        .volver { display: inline-block; margin-top: 20px; color: #ecf0f1; text-decoration: none; border: 1px solid white; padding: 10px 20px; border-radius: 5px; }
        .mensaje-vacio { padding: 20px; color: #777; font-style: italic; }
    </style>
</head>
<body>

<div class="container">
    <h1><%= titulo %></h1>

    <table>
        <thead>
            <tr>
                <th>ID Sala</th>
                <th>Nombre de Sala</th>
                <th>Turno Actual de...</th>
                <th>Acción</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    // 3. CONEXIÓN A BASE DE DATOS
                    try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { Class.forName("com.mysql.jdbc.Driver"); }
                    String url = "jdbc:mysql://localhost:3306/proyecto_oca?useSSL=false&serverTimezone=UTC";
                    con = DriverManager.getConnection(url, "root", "");

                    // 4. CONSULTA 
                    // Busca partidas activas (Estado=2) donde TÚ estés jugando (JOIN DetallesPartida)
                    String sql = "SELECT p.IdPartida, p.Nombre, p.IdJugadorTurno, j.Nombre as NombreTurno " +
                                 "FROM Partidas p " +
                                 "JOIN DetallesPartida dp ON p.IdPartida = dp.IdPartida " +
                                 "JOIN Jugadores j ON p.IdJugadorTurno = j.IdJugador " +
                                 "WHERE dp.IdJugador = ? AND p.IdEstado = 2 ";

                    // Filtra si es tu turno o no
                    if ("turno".equals(tipo)) {
                        sql += "AND p.IdJugadorTurno = ?"; 
                    } else {
                        sql += "AND p.IdJugadorTurno != ?"; 
                    }
                    
                    sql += " ORDER BY p.IdPartida DESC";

                    ps = con.prepareStatement(sql);
                    ps.setInt(1, idUsuario);
                    ps.setInt(2, idUsuario);
                    
                    rs = ps.executeQuery();
                    boolean hayPartidas = false;

                    while (rs.next()) {
                        hayPartidas = true;
                        int idP = rs.getInt("IdPartida");
                        String nomP = rs.getString("Nombre");
                        String quienJuega = rs.getString("NombreTurno");
            %>
                        <tr>
                            <td>#<%= idP %></td>
                            <td><%= nomP %></td>
                            <td><%= quienJuega %></td>
                            <td>
                                <a href="SetPartidaServlet?id=<%= idP %>" class="btn-entrar">
                                    <%= ("turno".equals(tipo)) ? "🎲 JUGAR" : "👀 VER" %>
                                </a>
                            </td>
                        </tr>
            <%
                    }
                    if (!hayPartidas) {
            %>
                        <tr>
                            <td colspan="4" class="mensaje-vacio">
                                No tienes partidas en esta categoría ahora mismo.
                            </td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            %>
        </tbody>
    </table>
</div>

<a href="menu.jsp" class="volver">⬅ Volver al Menú</a>

</body>
</html>