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
    <title>Tablero de la Oca</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #2c3e50;
            text-align: center;
            color: white;
            margin: 0;
            padding: 20px;
        }

        .tablero-contenedor {
            /* TAMAÑO: Cuadrado perfecto de 800x800 */
            width: 800px; 
            height: 800px; 
            
            margin: 0 auto;
            position: relative; 
            background-color: white;
            border: 8px solid #f1c40f;
            box-shadow: 0 15px 30px rgba(0,0,0,0.6);

            /* IMAGEN DE FONDO */
            background-image: url('imagenes/tablero.jpg'); 
            background-size: 100% 100%;
            background-repeat: no-repeat;

            /* GRID DE 10x10 */
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            grid-template-rows: repeat(10, 1fr);
        }

        .casilla {
            display: flex;
            justify-content: center;
            align-items: center;
            
            color: rgba(0, 0, 0, 0.5); /* Número semitransparente */
            font-weight: 900;
            font-size: 20px;
            
            /* BORDE ROJO DE GUÍA (Bórralo cuando ajustes tu imagen) */
            border: 1px dashed red;
            
            z-index: 10;
        }

        /* La Meta (63) */
        #casilla-63 {
            background-color: rgba(0, 255, 0, 0.2);
            border: 2px solid green;
            color: darkgreen;
            font-size: 30px;
        }

        .btn-volver {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background-color: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <h1>Tablero de Juego</h1>
    <p>Jugador: <strong><%= session.getAttribute("nick_usuario") %></strong></p>

    <div class="tablero-contenedor">
        <% 
           for (int i = 1; i <= 63; i++) { 
        %>
            <div class="casilla" id="casilla-<%=i%>">
                <%= i %>
            </div>
        <% } %>
    </div>

    <br>
    <a href="menu.jsp" class="btn-volver">Volver al Menú</a>

    <script>
        function generarEspiral() {
            // Matriz para marcar qué casillas ya están ocupadas
            // 11x11 para que sobre espacio y no indexar fuera
            let visitado = Array(12).fill().map(() => Array(12).fill(false));

            // Coordenadas iniciales (Esquina inferior izquierda)
            // En CSS Grid: Columna 1, Fila 10
            let col = 1;
            let row = 10;

            // Dirección inicial: Derecha (deltaCol = 1, deltaRow = 0)
            let dCol = 1;
            let dRow = 0;

            // Límites del tablero (Grid 10x10)
            const MIN = 1;
            const MAX = 10;

            for (let i = 1; i <= 63; i++) {
                let celda = document.getElementById("casilla-" + i);
                
                // 1. Asignar posición actual
                celda.style.gridColumn = col;
                celda.style.gridRow = row;
                
                // Caso especial para la Meta (63) para que ocupe el centro
                if (i === 63) {
                    celda.style.gridColumn = col + " / span 2"; 
                    return; 
                }

                // Marcar como visitada
                visitado[row][col] = true;

                // 2. Calcular siguiente paso
                let nextCol = col + dCol;
                let nextRow = row + dRow;

                // 3. Comprobar si chocamos con pared o con casilla visitada
                if (nextCol > MAX || nextCol < MIN || 
                    nextRow > MAX || nextRow < MIN || 
                    visitado[nextRow][nextCol]) {
                    
                    // ¡CHOQUE! Giramos 90 grados a la izquierda (en sentido antihorario visualmente)
                    // Derecha (1,0) -> Arriba (0,-1) -> Izquierda (-1,0) -> Abajo (0,1)
                    
                    if (dCol === 1 && dRow === 0) { // Iba Derecha -> Ahora Arriba
                        dCol = 0; dRow = -1;
                    } 
                    else if (dCol === 0 && dRow === -1) { // Iba Arriba -> Ahora Izquierda
                        dCol = -1; dRow = 0;
                    } 
                    else if (dCol === -1 && dRow === 0) { // Iba Izquierda -> Ahora Abajo
                        dCol = 0; dRow = 1;
                    } 
                    else if (dCol === 0 && dRow === 1) { // Iba Abajo -> Ahora Derecha
                        dCol = 1; dRow = 0;
                    }
                }

                // 4. Avanzar
                col += dCol;
                row += dRow;
            }
        }

        window.onload = generarEspiral;
    </script>

</body>
</html>