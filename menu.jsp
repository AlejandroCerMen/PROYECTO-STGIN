<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // ---------------------------------------------------------
    // 1. SEGURIDAD
    // ---------------------------------------------------------
    if (session.getAttribute("id_usuario") == null) {
        response.sendRedirect("index.html");
        return;
    }

    // ---------------------------------------------------------
    // 2. CÁLCULO DE ESTADÍSTICAS
    // ---------------------------------------------------------
    int idUsuario = (Integer) session.getAttribute("id_usuario");
    String nombre = (String) session.getAttribute("nick_usuario");
    
    int jugadas = 0;
    int ganadas = 0;
    int porcentaje = 0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // 1. Cargamos el driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            Class.forName("com.mysql.jdbc.Driver");
        }

        // 2. Datos de conexión 
        String url = "jdbc:mysql://localhost:3306/proyecto_oca?useSSL=false&serverTimezone=UTC"; 
        String usuarioDB = "root";
        String passwordDB = "";
        con = DriverManager.getConnection(url, usuarioDB, passwordDB);
        // ------------------------------------------------------

        // A. CALCULAR JUGADAS
        String sqlJugadas = "SELECT COUNT(DISTINCT d1.IdPartida) FROM DetallesPartida d1 JOIN DetallesPartida d2 ON d1.IdPartida = d2.IdPartida WHERE d1.IdJugador = ? AND d2.CasillaActual = 63";
                            
        ps = con.prepareStatement(sqlJugadas);
        ps.setInt(1, idUsuario);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            jugadas = rs.getInt(1);
        }
        rs.close(); 
        ps.close();

        // B. CALCULAR GANADAS
        String sqlGanadas = "SELECT COUNT(*) FROM DetallesPartida WHERE IdJugador = ? AND CasillaActual = 63";
        ps = con.prepareStatement(sqlGanadas);
        ps.setInt(1, idUsuario);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            ganadas = rs.getInt(1);
        }

        // C. CALCULAR PORCENTAJE
        if (jugadas > 0) {
            porcentaje = (ganadas * 100) / jugadas;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Menú Principal - La Oca</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; text-align: center; background-color: #f4f4f4; margin-top: 30px; }
        .panel { background-color: white; width: 450px; margin: 0 auto; padding: 25px; border-radius: 10px; border: 1px solid #ccc; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h1 { color: #333; margin-bottom: 5px; }
        
        .stats-box { background-color: #ecf0f1; border-radius: 8px; padding: 15px; margin: 20px 0; border: 1px solid #bdc3c7; }
        .stats-titulo { font-weight: bold; color: #7f8c8d; text-transform: uppercase; font-size: 12px; letter-spacing: 1px; margin-bottom: 10px; display: block; }
        .stats-grid { display: flex; justify-content: space-around; }
        .stat-item { text-align: center; }
        .stat-valor { font-size: 24px; font-weight: bold; color: #2c3e50; display: block; }
        .stat-label { font-size: 12px; color: #7f8c8d; }
        
        .bueno { color: #27ae60; } .regular { color: #f39c12; } .malo { color: #c0392b; }
        hr { border: 0; border-top: 1px solid #eee; margin: 20px 0; }
        .btn { display: block; width: 100%; padding: 15px; margin: 10px 0; color: white; border: none; cursor: pointer; font-size: 16px; border-radius: 5px; font-weight: bold; transition: opacity 0.2s; }
        .verde { background-color: #27ae60; } .naranja { background-color: #f39c12; } .azul { background-color: #2980b9; }
        .btn:hover { opacity: 0.9; }
        .cerrar { color: #c0392b; text-decoration: none; font-size: 14px; display: inline-block; margin-top: 10px; }
    </style>
</head>
<body>

    <div class="panel">
        <h1>🦆 Hola, <%= nombre %>!</h1>
        
        <div class="stats-box">
            <span class="stats-titulo">Tus Estadísticas</span>
            <div class="stats-grid">
                
                <div class="stat-item">
                    <span class="stat-valor"><%= jugadas %></span>
                    <span class="stat-label">Jugadas</span>
                </div>
                
                <div class="stat-item">
                    <span class="stat-valor"><%= ganadas %></span>
                    <span class="stat-label">Ganadas</span>
                </div>
                
                <div class="stat-item">
                    <% 
                       String colorClass = "malo";
                       if(porcentaje >= 50) colorClass = "bueno";
                       else if(porcentaje >= 25) colorClass = "regular";
                    %>
                    <span class="stat-valor <%= colorClass %>"><%= porcentaje %>%</span>
                    <span class="stat-label">Victorias</span>
                </div>

            </div>
        </div>

        <hr>

        <button class="btn verde" onclick="alert('Funcionalidad pendiente: Jugar partidas')'">🎲 Partida con turno</button>
        <button class="btn naranja" onclick="alert('Funcionalidad pendiente: Ver partidas')">⏳ Partida sin turno</button>
        <button class="btn azul" onclick="window.location.href='seleccion.jsp'">➕ Partida Nueva</button>
	<button class="btn" onclick="window.location.href='tablero.jsp'">Ir al Tablero (Pruebas)</button>
        
        <br>
        <a href="LogoutServlet" class="cerrar">Cerrar Sesión</a>
    </div>

</body>
</html>