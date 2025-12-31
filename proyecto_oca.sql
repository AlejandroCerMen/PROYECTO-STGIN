-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.32-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Volcando datos para la tabla proyecto_oca.detallespartida: ~2 rows (aproximadamente)
INSERT INTO `detallespartida` (`IdPartida`, `IdJugador`, `Casilla`, `Orden`, `Bloqueo`, `CasillaActual`) VALUES
	(13, 1, 1, 1, 0, 24),
	(13, 2, 1, 2, 0, 22);

-- Volcando datos para la tabla proyecto_oca.jugadores: ~2 rows (aproximadamente)
INSERT INTO `jugadores` (`IdJugador`, `Nombre`, `Password`) VALUES
	(1, 'alejandro', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'),
	(2, 'aitana', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');

-- Volcando datos para la tabla proyecto_oca.mensajes: ~6 rows (aproximadamente)
INSERT INTO `mensajes` (`IdMensaje`, `TextoTemplate`) VALUES
	(1, 'Ha sacado un {0}'),
	(2, '¡De Oca a Oca! Salta a la casilla {0}'),
	(3, '¡De Puente a Puente! Salta a la casilla {0}'),
	(4, '¡El puente está roto! Vuelve a la casilla {0}'),
	(5, '¡LA MUERTE! Vuelve a empezar'),
	(6, '¡VICTORIA! Ha llegado a la meta');

-- Volcando datos para la tabla proyecto_oca.partidas: ~1 rows (aproximadamente)
INSERT INTO `partidas` (`IdPartida`, `Nombre`, `IdJugadorTurno`, `IdEstado`, `Password`, `UltimoValorDado`, `IdUltimoMensaje`) VALUES
	(13, 'Sala de alejandro', 2, 2, NULL, 4, 1);

-- Volcando datos para la tabla proyecto_oca.tablero: ~63 rows (aproximadamente)
INSERT INTO `tablero` (`Casilla`, `IdTipo`) VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 1),
	(5, 2),
	(6, 3),
	(7, 1),
	(8, 1),
	(9, 2),
	(10, 1),
	(11, 1),
	(12, 3),
	(13, 1),
	(14, 2),
	(15, 1),
	(16, 1),
	(17, 1),
	(18, 2),
	(19, 4),
	(20, 1),
	(21, 1),
	(22, 1),
	(23, 2),
	(24, 1),
	(25, 1),
	(26, 1),
	(27, 2),
	(28, 1),
	(29, 1),
	(30, 1),
	(31, 5),
	(32, 2),
	(33, 1),
	(34, 1),
	(35, 1),
	(36, 2),
	(37, 1),
	(38, 1),
	(39, 1),
	(40, 1),
	(41, 2),
	(42, 6),
	(43, 1),
	(44, 1),
	(45, 2),
	(46, 1),
	(47, 1),
	(48, 1),
	(49, 1),
	(50, 2),
	(51, 1),
	(52, 7),
	(53, 1),
	(54, 2),
	(55, 1),
	(56, 1),
	(57, 1),
	(58, 8),
	(59, 2),
	(60, 1),
	(61, 1),
	(62, 1),
	(63, 9);

-- Volcando datos para la tabla proyecto_oca.tipocasilla: ~9 rows (aproximadamente)
INSERT INTO `tipocasilla` (`IdTipo`, `Nombre`) VALUES
	(1, 'Normal'),
	(2, 'Oca'),
	(3, 'Puente'),
	(4, 'Posada'),
	(5, 'Pozo'),
	(6, 'Laberinto'),
	(7, 'Carcel'),
	(8, 'Calavera'),
	(9, 'Meta');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
