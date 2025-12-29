// logica.js - Código limpio y separado

function actualizarSala() {
    fetch('EstadoSalaServlet')
        .then(response => response.json())
        .then(data => {
            // Redirigir si empezó
            if (data.estado === 2) {
                window.location.href = 'tablero.jsp';
                return;
            }

            // Pintar jugadores
            let html = "";
            let total = data.jugadores.length;
            
            data.jugadores.forEach(jugador => {
                html += '<div class="jugador-row">' +
                        '<span>' + jugador.nombre + '</span>' +
                        '<div class="bola c-' + jugador.color + '"></div>' +
                        '</div>';
            });
            
            let contenedor = document.getElementById("contenedor-jugadores");
            if(contenedor) contenedor.innerHTML = html;

            // Botón
            let btn = document.getElementById("btn-jugar");
            let msg = document.getElementById("mensaje-estado");
            
            if (btn && msg) {
                if (btn && msg) {
                // CASO 1: Soy el líder y hay gente suficiente -> MUESTRA BOTÓN
                if (data.soyLider && total >= 2) {
                    btn.style.display = "inline-block";
                    msg.style.display = "none";
                } 
                // CASO 2: Soy el líder pero estoy solo -> MUESTRA "ESPERANDO JUGADORES"
                else if (data.soyLider && total < 2) {
                    btn.style.display = "none";
                    msg.style.display = "block";
                    msg.innerText = "Esperando al menos 2 jugadores...";
                    msg.style.color = "#f1c40f"; // Amarillo
                }
                // CASO 3: NO soy el líder (soy invitado) -> MUESTRA "ESPERANDO AL ANFITRIÓN"
                else {
                    btn.style.display = "none";
                    msg.style.display = "block";
                    msg.innerText = "Esperando a que el anfitrión inicie...";
                    msg.style.color = "#bdc3c7"; // Gris
                }
            }
        })
        .catch(console.error);
}

function empezarPartida() {
    fetch('EmpezarJuegoServlet', { method: 'POST' });
}

// Iniciamos el ciclo de forma segura cuando el archivo carga
window.onload = function() {
    // Usamos setInterval pasando la función, NO texto.
    setInterval(actualizarSala, 1000);
    actualizarSala(); // Primera llamada inmediata
    
    // Asignar el botón manualmente para evitar 'onclick' en HTML
    let btn = document.getElementById("btn-jugar");
    if(btn) {
        btn.addEventListener("click", empezarPartida);
    }
};