<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("id_usuario") == null) { response.sendRedirect("menu.jsp"); return; }
    int idPartida = (Integer) session.getAttribute("id_partida");
    // Recuperamos el nick para el modo profesor
    String miNick = (String) session.getAttribute("nick_usuario");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Juego de la Oca</title>
    <meta http-equiv="Content-Security-Policy" content="default-src * 'self' 'unsafe-inline' 'unsafe-eval' data: gap:;">
    <style>
        body { background-color: #2c3e50; margin: 0; padding: 10px; text-align: center; font-family: 'Segoe UI', sans-serif; }
        
        /* TABLERO */
        .tablero-contenedor {
            width: 600px; height: 600px; margin: 0 auto; position: relative;
            background-image: url('imagenes/tablero.jpg'); background-size: 100% 100%;
            border: 6px solid #f1c40f; border-radius: 12px; box-shadow: 0 0 20px rgba(0,0,0,0.7);
        }
        .casilla { position: absolute; display: grid; grid-template-columns: 1fr 1fr; align-items: center; justify-items: center; z-index: 10; }
        
        /* FICHAS */
        .ficha { 
            width: 20px; height: 20px; 
            border-radius: 50%; border: 2px solid white; 
            box-shadow: 2px 2px 5px black; 
            transition: top 0.5s, left 0.5s; 
            background-color: gray; /* Color por seguridad */
        }
        /* COLORES (Importante !important para asegurar que se pinten) */
        .c-1 { background-color: blue !important; } 
        .c-2 { background-color: red !important; } 
        .c-3 { background-color: green !important; } 
        .c-4 { background-color: yellow !important; }

        /* PANEL DE CONTROLES */
        .panel-juego {
            position: fixed; right: 20px; top: 50px; width: 220px;
            background: white; padding: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        .dado-visual { font-size: 50px; margin: 10px 0; }
        .btn-tirar { 
            background: #e67e22; color: white; border: none; padding: 10px 20px; font-size: 18px; 
            border-radius: 5px; cursor: pointer; width: 100%; 
            display: none; /* Oculto por defecto */
        }
        .btn-tirar:hover { background: #d35400; }
        .info-turno { font-weight: bold; color: #333; margin-bottom: 10px; font-size: 18px; }

        /* LEYENDA JUGADORES */
        .leyenda-container { margin-top: 15px; border-top: 1px solid #eee; padding-top: 10px; text-align: left; }
        .leyenda-titulo { font-size: 14px; color: #7f8c8d; margin-bottom: 5px; text-align: center; font-weight: bold; }
        .leyenda-item { display: flex; align-items: center; margin-bottom: 4px; font-size: 15px; color: #2c3e50; font-weight: bold; }
        .mini-ficha { width: 12px; height: 12px; border-radius: 50%; margin-right: 8px; border: 1px solid #ccc; display: inline-block; }
    </style>
</head>
<body>

    <div class="panel-juego">
        <div id="info-turno" class="info-turno">Cargando...</div>
        
        <div id="dado-visual" class="dado-visual">🎲</div>
        <div id="mensaje-accion" style="color: blue; font-weight: bold; margin-top: 10px; font-size: 14px;"></div>
        
        <% 
            if (miNick != null && (miNick.equalsIgnoreCase("patiño") || miNick.equals("patiÃ±o") || miNick.equalsIgnoreCase("pati"))) {
        %>
            <div style="background-color: #e74c3c; padding: 10px; border-radius: 5px; margin-bottom: 10px; color: white;">
                <strong>🕵️ MODO PROFESOR:</strong><br>
                <select id="dado-trucado" style="padding: 5px; color: black; width: 100%;">
                    <option value="">Aleatorio</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="63">Ir a Meta</option>
                </select>
            </div>
        <% } %>

        <button id="btn-tirar" class="btn-tirar">TIRAR DADO</button>
        
        <div id="leyenda-jugadores" class="leyenda-container"></div>

        <br>
        <a href="menu.jsp" style="color:red; text-decoration: none;">Salir</a>
    </div>

    <div class="tablero-contenedor">
        <% for (int i = 1; i <= 63; i++) { %>
            <div class="casilla" id="casilla-<%=i%>"></div>
        <% } %>
    </div>

    <script>
        // COORDENADAS (Tu mapa original)
        const mapaCasillas = [
            /* 1 */ {l:0, t:84.5, w:12.5, h:15}, /* 2 */ {l:14, t:84.5, w:12, h:15}, /* 3 */ {l:26, t:84.5, w:12, h:15},
            /* 4 */ {l:38, t:84.5, w:12, h:15}, /* 5 */ {l:50, t:84.5, w:12, h:15}, /* 6 */ {l:62, t:84.5, w:12, h:15},
            /* 7 */ {l:74, t:84.5, w:12, h:15}, /* 8 */ {l:87, t:90.5, w:8, h:9}, /* 9 */ {l:90.5, t:85, w:9, h:8},
            /* 10 */ {l:86.5, t:76, w:13, h:8}, /* 11 */ {l:86.5, t:67, w:13, h:8}, /* 12 */ {l:86.5, t:57.5, w:13, h:9},
            /* 13 */ {l:86.5, t:48, w:13, h:8}, /* 14 */ {l:86.5, t:39.5, w:13, h:8}, /* 15 */ {l:86.5, t:31, w:13, h:8},
            /* 16 */ {l:86.5, t:22, w:13, h:8}, /* 17 */ {l:86.5, t:13.5, w:13, h:8}, /* 18 */ {l:90.5, t:5, w:9, h:8},
            /* 19 */ {l:86.5, t:0, w:8, h:9}, /* 20 */ {l:77.5, t:0, w:8, h:12}, /* 21 */ {l:68.5, t:0, w:8, h:12},
            /* 22 */ {l:59.5, t:0, w:8, h:12}, /* 23 */ {l:50.25, t:0, w:8, h:12}, /* 24 */ {l:41, t:0, w:8, h:12},
            /* 25 */ {l:32, t:0, w:8, h:12}, /* 26 */ {l:23, t:0, w:8, h:12}, /* 27 */ {l:14, t:0, w:8, h:12},
            /* 28 */ {l:5, t:0, w:8, h:8}, /* 29 */ {l:0, t:4, w:8, h:8}, /* 30 */ {l:0, t:13, w:13, h:9},
            /* 31 */ {l:0, t:23, w:13, h:9}, /* 32 */ {l:0, t:32, w:13, h:9}, /* 33 */ {l:0, t:42, w:13, h:9},
            /* 34 */ {l:0, t:51, w:13, h:9}, /* 35 */ {l:0, t:61, w:13, h:9}, /* 36 */ {l:0, t:71, w:8, h:8},
            /* 37 */ {l:4.5, t:76, w:8, h:8}, /* 38 */ {l:13.5, t:71, w:8.5, h:12.5}, /* 39 */ {l:23, t:71, w:8.5, h:12.5},
            /* 40 */ {l:33, t:71, w:8.5, h:12.5}, /* 41 */ {l:42.5, t:71, w:8.5, h:12.5}, /* 42 */ {l:52, t:71, w:9, h:12.5},
            /* 43 */ {l:62, t:71, w:8.5, h:12.5}, /* 44 */ {l:72, t:76, w:8, h:8}, /* 45 */ {l:77.5, t:71, w:8, h:8},
            /* 46 */ {l:72, t:60, w:14, h:10}, /* 47 */ {l:72, t:49.5, w:14, h:10}, /* 48 */ {l:72, t:38.5, w:14, h:10},
            /* 49 */ {l:72, t:27.5, w:14, h:10}, /* 50 */ {l:77.5, t:18.5, w:8, h:8}, /* 51 */ {l:72, t:13.5, w:8, h:8},
            /* 52 */ {l:61, t:13.5, w:10, h:13}, /* 53 */ {l:50, t:13.5, w:10, h:13}, /* 54 */ {l:38.5, t:13.5, w:10, h:13},
            /* 55 */ {l:28, t:13.5, w:10, h:13}, /* 56 */ {l:18, t:13.5, w:8, h:8}, /* 57 */ {l:13.5, t:18, w:8, h:8},
            /* 58 */ {l:13.5, t:27.5, w:12.5, h:13}, /* 59 */ {l:13.5, t:42, w:12.5, h:13}, /* 60 */ {l:13.5, t:56, w:9, h:9},
            /* 61 */ {l:28, t:56, w:10, h:14}, /* 62 */ {l:39, t:56, w:9, h:14}, /* 63 */ {l:50, t:40, w:20, h:30}
        ];

        window.onload = function() {
            // 1. Colocar casillas visualmente
            for (let i = 0; i < 63; i++) {
                let div = document.getElementById("casilla-" + (i + 1));
                if (div) {
                    div.style.left = mapaCasillas[i].l + "%";
                    div.style.top = mapaCasillas[i].t + "%";
                    div.style.width = mapaCasillas[i].w + "%";
                    div.style.height = mapaCasillas[i].h + "%";
                }
            }
            
            // 2. Evento del botón
            let btn = document.getElementById("btn-tirar");
            if(btn) btn.addEventListener("click", tirarDado);

            // 3. Arrancar bucle
            actualizarTablero();
            setInterval(actualizarTablero, 1000);
        };

        function actualizarTablero() {
            fetch('EstadoPartidaServlet')
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if(data.error) {
                        console.error("Error servidor:", data.error);
                        return;
                    }

                    // --- 1. LIMPIEZA ---
                    document.querySelectorAll('.ficha').forEach(function(e) { e.remove(); });
                    
                    var htmlLeyenda = '<div class="leyenda-titulo">Jugadores</div>';

                    // --- 2. PINTAR FICHAS Y LEYENDA ---
                    if (data.jugadores) {
                        data.jugadores.forEach(function(j) {
                            // A) Tablero
                            var casillaDiv = document.getElementById("casilla-" + j.casilla);
                            if (casillaDiv) {
                                var ficha = document.createElement("div");
                                ficha.classList.add("ficha");
                                ficha.classList.add("c-" + j.color);
                                ficha.title = j.nombre;
                                casillaDiv.appendChild(ficha);
                            }

                            // B) Leyenda
                            htmlLeyenda += '<div class="leyenda-item">' +
                                           '<div class="mini-ficha c-' + j.color + '"></div>' +
                                           '<span>' + j.nombre + '</span>' +
                                           '</div>';
                        });
                    }
                    
                    // Actualizar HTML Leyenda
                    var divLeyenda = document.getElementById("leyenda-jugadores");
                    if(divLeyenda) divLeyenda.innerHTML = htmlLeyenda;

                    // --- 3. GESTIONAR TURNO Y BOTÓN ---
                    var btn = document.getElementById("btn-tirar");
                    var infoTurno = document.getElementById("info-turno");
                    
                    if (data.esMiTurno) {
                        // ES MI TURNO: Mostrar botón y mensaje
                        if(btn) {
                            btn.disabled = false;
                            btn.style.display = "inline-block"; 
                        }
                        if(infoTurno) {
                            infoTurno.innerText = "¡Es tu turno!";
                            infoTurno.style.color = "#27ae60"; // Verde
                        }
                    } else {
                        // NO ES MI TURNO: Ocultar botón
                        if(btn) {
                            btn.disabled = true;
                            btn.style.display = "none";
                        }
                        if(infoTurno) {
                            // Como la versión "que funcionaba" no enviaba nombreTurno,
                            // ponemos "Esperando..." para asegurar que no falla.
                            infoTurno.innerText = "Esperando...";
                            infoTurno.style.color = "#333";
                        }
                    }

                    // --- 4. MENSAJE ACCIÓN ---
                    var msgDiv = document.getElementById("mensaje-accion");
                    if(msgDiv) msgDiv.innerText = data.ultimoMensaje;
                    
                    // --- 5. DADO VISUAL ---
                    var dadoDiv = document.getElementById("dado-visual");
                    if(dadoDiv && data.valorDado) {
                         dadoDiv.innerText = "🎲 " + data.valorDado;
                    }
                })
                .catch(function(e) { console.error("Error conexión:", e); });
        }

        function tirarDado() {
            // Ocultamos botón para evitar doble click
            var btn = document.getElementById("btn-tirar");
            if(btn) btn.style.display = "none";
            
            // Truco profesor
            var truco = "";
            var inputTruco = document.getElementById("dado-trucado");
            if (inputTruco && inputTruco.value !== "") {
                truco = "?dado=" + inputTruco.value;
            }

            fetch('TirarDadoServlet' + truco , { method: 'POST' })
                .then(function(res) {
                    if (res.ok) {
                        actualizarTablero(); // Refrescar rápido
                    } else {
                        alert("Error al tirar el dado");
                    }
                });
        }
    </script>
</body>
</html>