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
    <title>Juego de la Oca</title>
    <style>
        body {          
            background-color: #2c3e50;
            margin: 0;
            padding: 10px;
            text-align: center;
            overflow-y: auto; 
        }

        h1 {
            color: white; 
            font-size: 24px;
            margin: 10px 0;
        }

        .tablero-contenedor {
            width: 600px;
            height: 600px;
            
            margin: 0 auto;
            position: relative;
            
            /* IMAGEN DE FONDO */
            background-image: url('imagenes/tablero.jpg');
            background-size: 100% 100%;
            
            border: 6px solid #f1c40f;
            border-radius: 12px;
        }

        .casilla {
            position: absolute;     
            display: flex;
            justify-content: center;
            align-items: center;
            
            /* --- BORDE ROJO PARA PROBAR (BÓRRALO LUEGO) --- */
            border: 1px dashed red; 
            
            /* Texto semitransparente para que no moleste */
            color: rgba(0,0,0,0.4); 
            font-weight: 900;
            font-size: 14px; 
            
            z-index: 10;
        }
        
        /* La meta tiene un estilo propio en el CSS, pero la posición la da el JS */
        #casilla-63 {
            color: green;
            background-color: rgba(0, 255, 0, 0.1);
            border: 2px solid green;
        }

        /* HE ELIMINADO LA CLASE .ficha QUE HABÍA AQUÍ */

        .btn-volver {
            display: inline-block;
            margin-top: 15px;
            padding: 8px 16px;
            background-color: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <h1>Partida de <%= session.getAttribute("nick_usuario") %></h1>

    <div class="tablero-contenedor">
        <% 
           // Generamos los 63 DIVs (Sin la lógica de la ficha)
           for (int i = 1; i <= 63; i++) { 
        %>
            <div class="casilla" id="casilla-<%=i%>">
                <%= i %>
            </div>
        <% } %>
    </div>

    <a href="menu.jsp" class="btn-volver">Volver al Menú</a>

    <script>
        // Mapa con la posición (left, top) y tamaño (width, height) en PORCENTAJES
        const mapaCasillas = [
            /* 1 */ {l:0, t:84.5, w:12.5, h:15},
            /* 2 */ {l:14, t:84.5, w:12, h:15},
            /* 3 */ {l:26, t:84.5, w:12, h:15},
            /* 4 */ {l:38, t:84.5, w:12, h:15},
            /* 5 */ {l:50, t:84.5, w:12, h:15},
            /* 6 */ {l:62, t:84.5, w:12, h:15},
            /* 7 */ {l:74, t:84.5, w:12, h:15},
            /* 8 */ {l:87, t:90.5, w:8, h:9},
            /* 9 */ {l:90.5, t:85, w:9, h:8},
            /* 10 */ {l:86.5, t:76, w:13, h:8},
            /* 11 */ {l:86.5, t:67, w:13, h:8},
            /* 12 */ {l:86.5, t:57.5, w:13, h:9},
            /* 13 */ {l:86.5, t:48, w:13, h:8},
            /* 14 */ {l:86.5, t:39.5, w:13, h:8},
            /* 15 */ {l:86.5, t:31, w:13, h:8},
            /* 16 */ {l:86.5, t:22, w:13, h:8},
            /* 17 */ {l:86.5, t:13.5, w:13, h:8},
            /* 18 */ {l:90.5, t:5, w:9, h:8},
            /* 19 */ {l:86.5, t:0, w:8, h:9},
            /* 20 */ {l:77.5, t:0, w:8, h:12},
            /* 21 */ {l:68.5, t:0, w:8, h:12},
            /* 22 */ {l:59.5, t:0, w:8, h:12},
            /* 23 */ {l:50.25, t:0, w:8, h:12},
            /* 24 */ {l:41, t:0, w:8, h:12},
            /* 25 */ {l:32, t:0, w:8, h:12},
            /* 26 */ {l:23, t:0, w:8, h:12},
            /* 27 */ {l:14, t:0, w:8, h:12},
            /* 28 */ {l:5, t:0, w:8, h:8},
            /* 29 */ {l:0, t:4, w:8, h:8},
            /* 30 */ {l:0, t:13, w:13, h:9},
            /* 31 */ {l:0, t:23, w:13, h:9},
            /* 32 */ {l:0, t:32, w:13, h:9},
            /* 33 */ {l:0, t:42, w:13, h:9},
            /* 34 */ {l:0, t:51, w:13, h:9},
            /* 35 */ {l:0, t:61, w:13, h:9},
            /* 36 */ {l:0, t:71, w:8, h:8},
            /* 37 */ {l:4.5, t:76, w:8, h:8},
            /* 38 */ {l:13.5, t:71, w:8.5, h:12.5},
            /* 39 */ {l:23, t:71, w:8.5, h:12.5},
            /* 40 */ {l:33, t:71, w:8.5, h:12.5},
            /* 41 */ {l:42.5, t:71, w:8.5, h:12.5},
            /* 42 */ {l:52, t:71, w:9, h:12.5},
            /* 43 */ {l:62, t:71, w:8.5, h:12.5},
            /* 44 */ {l:72, t:76, w:8, h:8},
            /* 45 */ {l:77.5, t:71, w:8, h:8},
            /* 46 */ {l:72, t:60, w:14, h:10},
            /* 47 */ {l:72, t:49.5, w:14, h:10},
            /* 48 */ {l:72, t:38.5, w:14, h:10},
            /* 49 */ {l:72, t:27.5, w:14, h:10},
            /* 50 */ {l:77.5, t:18.5, w:8, h:8},
            /* 51 */ {l:72, t:13.5, w:8, h:8},
            /* 52 */ {l:61, t:13.5, w:10, h:13},
            /* 53 */ {l:50, t:13.5, w:10, h:13},
            /* 54 */ {l:38.5, t:13.5, w:10, h:13},
            /* 55 */ {l:28, t:13.5, w:10, h:13},
            /* 56 */ {l:18, t:13.5, w:8, h:8},
            /* 57 */ {l:13.5, t:18, w:8, h:8},
            /* 58 */ {l:13.5, t:27.5, w:12.5, h:13},
            /* 59 */ {l:13.5, t:42, w:12.5, h:13},
            /* 60 */ {l:13.5, t:56, w:9, h:9},
            /* 61 */ {l:28, t:56, w:10, h:14},
            /* 62 */ {l:39, t:56, w:9, h:14},
            /* 63 */ {l:50, t:40, w:20, h:30}
        ];

        function posicionarCasillas() {
            for (let i = 0; i < 63; i++) {
                // El array empieza en 0, pero las casillas en 1
                let numCasilla = i + 1;
                let datos = mapaCasillas[i];
                let celda = document.getElementById("casilla-" + numCasilla);
                
                if (celda) {
                    celda.style.left = datos.l + "%";
                    celda.style.top = datos.t + "%";
                    celda.style.width = datos.w + "%";
                    celda.style.height = datos.h + "%";
                }
            }
        }

        window.onload = posicionarCasillas;
    </script>

</body>
</html>