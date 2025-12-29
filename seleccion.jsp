<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("id_usuario") == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Seleccionar Partida</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #2c3e50; color: white; text-align: center; padding: 50px; }
        .contenedor { display: flex; justify-content: center; gap: 50px; }
        .caja { background-color: white; color: #333; padding: 30px; border-radius: 10px; width: 300px; box-shadow: 0 0 20px rgba(0,0,0,0.5); }
        h2 { color: #f39c12; }
        input { width: 90%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; }
        button { width: 100%; padding: 10px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; color: white; font-size: 16px; margin-top: 10px;}
        .btn-crear { background-color: #27ae60; }
        .btn-unir { background-color: #2980b9; }
        .btn-volver { background-color: #e74c3c; width: 150px; margin-top: 50px; }
    </style>
</head>
<body>

    <h1>¿Qué quieres hacer?</h1>

    <div class="contenedor">
        <div class="caja">
            <h2>Crear Sala</h2>
            <p>Tú serás el anfitrión.</p>
            <form action="GestionSalaServlet" method="post">
                <input type="hidden" name="accion" value="crear">
                <label>Contraseña (Opcional):</label>
                <input type="password" name="password" placeholder="Déjalo vacío para pública">
                <button type="submit" class="btn-crear">🏠 Crear Partida</button>
            </form>
        </div>

        <div class="caja">
            <h2>Unirse a Sala</h2>
            <p>Busca una partida existente.</p>
            <form action="GestionSalaServlet" method="post">
                <input type="hidden" name="accion" value="unirse">
                <label>Contraseña de la sala:</label>
                <input type="password" name="password" placeholder="Vacío = Buscar aleatoria">
                <button type="submit" class="btn-unir">🔍 Buscar y Unirse</button>
            </form>
        </div>
    </div>

    <button onclick="window.location.href='menu.jsp'" class="btn-volver">Volver al Menú</button>

</body>
</html>