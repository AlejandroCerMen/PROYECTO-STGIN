<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // SEGURIDAD: Si no hay usuario logueado, lo mandamos fuera
    if (session.getAttribute("id_usuario") == null) {
        response.sendRedirect("index.html");
        return;
    }
    // Recuperamos el nombre para saludar
    String nombre = (String) session.getAttribute("nick_usuario");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Menú Principal - La Oca</title>
    <style>
        body { font-family: sans-serif; text-align: center; background-color: #f4f4f4; margin-top: 50px; }
        .panel { background-color: white; width: 400px; margin: 0 auto; padding: 20px; border-radius: 10px; border: 1px solid #ccc; box-shadow: 2px 2px 10px rgba(0,0,0,0.1); }
        .btn { display: block; width: 100%; padding: 15px; margin: 10px 0; color: white; border: none; cursor: pointer; font-size: 16px; border-radius: 5px; font-weight: bold; }
        .verde { background-color: #27ae60; }
        .naranja { background-color: #f39c12; }
        .azul { background-color: #2980b9; }
        .btn:hover { opacity: 0.9; }
        .cerrar { color: #c0392b; text-decoration: none; font-size: 14px; display: inline-block; margin-top: 15px; }
    </style>
</head>
<body>

    <div class="panel">
        <h1>🦆 Hola, <%= nombre %>!</h1>
        <p>¿Listo para jugar?</p>
        <hr>

        <button class="btn verde" onclick="alert('Funcionalidad pendiente: Jugar turno')">🎲 Partidas con turno</button>
        <button class="btn naranja" onclick="alert('Funcionalidad pendiente: Ver partidas')">⏳ Partidas en espera</button>
        <button class="btn azul" onclick="alert('Funcionalidad pendiente: Crear nueva')">➕ Partida Nueva</button>
        
        <br>
        <a href="LogoutServlet" class="cerrar">Cerrar Sesión</a>
    </div>

</body>
</html>