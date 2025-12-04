PASOS INICIALES
1. Clonación del proyecto.  
Abriremos el cmd y escriviremos el siguiente comando `cd C:\xampp\tomcat\webapps` (si vustra ruta es diferente habra que cambiarlo).
A continucacion pegaremos el siguiente comando `git clone https://github.com/AlejandroCerMen/PROYECTO-STGIN.git` Os deberia de haber creado la carpeta PROYECTO-STGIN.

2. Entendimiento de las carpetas.  
En la carpeta 'Archivos Java' debemos de copiar los '.java' desde nuestra carpeta de BlueJ, al igual que los '.class' en la carpeta 'classes' de 'WEB-INF'.
 Esto lo vamos a hacer ya que el '.class' no se puede modificar así que si alguno quisiera modificar Java tiene que modificar el '.java' y compilarlo para crear el '.class' y si esta hecho por otro no tiene forma de hacerlo.
 (Si teneis dudas preguntar que no se como explicarlo).  
Las demas carpetas son las típicas de la práctica 4.

3. Comprobación inicial.
Iniciar Tomcat en Xampp, una vez arrancado en el buscados poner `localhost:8080/PROYECTO-STGIN` esto deberia de habrir una pagina que al darle al boton azul ejecuta el '.class'


RECORDATORIO COMANDOS TRABAJO  

Siempre que abramos el cmd tenemos que trabajr en el directorio, para ello al abrir cmd ponemo `cd C:\xampp\tomcat\webapps\PROYECTO-STGIN`.  
Despues tendremos que actualizarlo con lo último, para ello se usa el comando `git pull origin main`.
Cuando hayamos realizado los cambios pertinentes deberemos de hacer 3 comandos. Priemro `git add .` Segundo `git commit -m "Poned aquí qué habéis cambiado"` Tercero `git push origin main`.  
Si al hacer el push os da error (texto rojo), significa que alguien subió cosas antes que tú. Haced primero git pull origin main y luego volved a intentar el push.
