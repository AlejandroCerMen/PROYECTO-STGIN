<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("id_usuario") == null || session.getAttribute("id_partida") == null) {
        response.sendRedirect("menu.jsp");
        return;
    }
    int idPartida = (Integer) session.getAttribute("id_partida");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Sala de Espera</title>
    <meta http-equiv="Content-Security-Policy" content="default-src * 'self' 'unsafe-inline' 'unsafe-eval' data: gap:;">
    
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #34495e; color: white; text-align: center; padding-top: 50px; }
        .lista-jugadores { background-color: #ffffff; width: 400px; margin: 20px auto; padding: 20px; border-radius: 10px; min-height: 100px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        .jugador-row { display: flex; justify-content: space-between; padding: 10px; border-bottom: 1px solid #eee; align-items: center; }
        
        /* Texto negro obligatorio */
        .jugador-row span, .lista-jugadores p { color: #000000 !important; font-weight: bold; font-size: 18px; }
        
        .bola { width: 20px; height: 20px; border-radius: 50%; display: inline-block; border: 1px solid #333; }
        .c-1 { background-color: blue; } .c-2 { background-color: red; } .c-3 { background-color: green; } .c-4 { background-color: yellow; }
        
        /* Botón verde */
        .btn-empezar { background-color: #27ae60; color: white; padding: 15px 30px; font-size: 20px; border: none; border-radius: 5px; cursor: pointer; margin-top: 20px; display: none; }
        .btn-empezar:hover { background-color: #2ecc71; }
        .esperando { color: #f1c40f; font-style: italic; font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>

    <h1>Sala de Espera</h1>
    <p>ID Partida: <strong><%= idPartida %></strong></p>

    <div class="lista-jugadores" id="contenedor-jugadores">
        <p>Conectando...</p>
    </div>

    <button id="btn-jugar" class="btn-empezar">🚀 JUGAR PARTIDA</button>
    
    <p id="mensaje-estado" class="esperando">Cargando estado...</p>

    <br><a href="menu.jsp" style="color: #bbb;">Salir</a>

    <script>
        // 1. DEFINIMOS LAS FUNCIONES (Aún no se ejecutan)
        
        function actualizarSala() {
            fetch('EstadoSalaServlet')
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    // Si hay error en el JSON, lo ignoramos para no romper todo
                    if(data.error) return;

                    // Si empezó, nos vamos
                    if (data.estado === 2) {
                        window.location.href = 'tablero.jsp';
                        return;
                    }

                    // Pintar jugadores
                    var html = "";
                    var total = 0;
                    if (data.jugadores) {
                        total = data.jugadores.length;
                        data.jugadores.forEach(function(j) {
                            html += '<div class="jugador-row">' +
                                    '<span>' + j.nombre + '</span>' +
                                    '<div class="bola c-' + j.color + '"></div>' +
                                    '</div>';
                        });
                    }
                    document.getElementById("contenedor-jugadores").innerHTML = html;

                    // Lógica del Botón
                    var btn = document.getElementById("btn-jugar");
                    var msg = document.getElementById("mensaje-estado");
                    
                    if (data.soyLider && total >= 2) {
                        btn.style.display = "inline-block";
                        msg.style.display = "none";
                    } else if (data.soyLider && total < 2) {
                        btn.style.display = "none";
                        msg.style.display = "block";
                        msg.innerText = "Esperando al menos 2 jugadores...";
                        msg.style.color = "#f1c40f";
                    } else {
                        btn.style.display = "none";
                        msg.style.display = "block";
                        msg.innerText = "Esperando al anfitrión...";
                        msg.style.color = "#bdc3c7";
                    }
                })
                .catch(function(e) { console.error("Error conexión:", e); });
        }

        function empezarPartida() {
            fetch('EmpezarJuegoServlet', { method: 'POST' });
        }

        // 2. EJECUTAMOS TODO AL CARGAR LA PÁGINA
        // Esto evita que busquemos elementos HTML antes de que existan
        window.onload = function() {
            
            // Asignamos el evento CLICK de forma segura (EventListener)
            var btn = document.getElementById("btn-jugar");
            if (btn) {
                btn.addEventListener("click", empezarPartida);
            }

            // Iniciamos el bucle de forma segura (SIN comillas en la función)
            setInterval(actualizarSala, 1000);
            
            // Primera ejecución inmediata
            actualizarSala();
        };
    </script>
</body>
</html>