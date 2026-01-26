proyecto_oca-- --------------------------------------------------------
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


-- Volcando estructura de base de datos para proyecto_oca
CREATE DATABASE IF NOT EXISTS `proyecto_oca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `proyecto_oca`;

-- Volcando estructura para tabla proyecto_oca.detallespartida
CREATE TABLE IF NOT EXISTS `detallespartida` (
  `IdPartida` int(11) NOT NULL,
  `IdJugador` int(11) NOT NULL,
  `Casilla` int(11) DEFAULT 1,
  `Orden` int(11) DEFAULT NULL,
  `Bloqueo` int(11) DEFAULT 0,
  `CasillaActual` int(11) DEFAULT 1,
  `TurnosCastigo` int(11) DEFAULT 0,
  PRIMARY KEY (`IdPartida`,`IdJugador`),
  KEY `IdJugador` (`IdJugador`),
  CONSTRAINT `detallespartida_ibfk_1` FOREIGN KEY (`IdPartida`) REFERENCES `partidas` (`IdPartida`) ON DELETE CASCADE,
  CONSTRAINT `detallespartida_ibfk_2` FOREIGN KEY (`IdJugador`) REFERENCES `jugadores` (`IdJugador`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.detallespartida: ~68 rows (aproximadamente)
DELETE FROM `detallespartida`;
INSERT INTO `detallespartida` (`IdPartida`, `IdJugador`, `Casilla`, `Orden`, `Bloqueo`, `CasillaActual`, `TurnosCastigo`) VALUES
	(13, 1, 1, 1, 0, 24, 0),
	(13, 2, 1, 2, 0, 22, 0),
	(14, 1, 1, 2, 0, 10, 0),
	(14, 3, 1, 1, 0, 7, 0),
	(15, 1, 1, 1, 0, 10, 0),
	(15, 2, 1, 4, 0, 15, 0),
	(15, 4, 1, 2, 0, 26, 0),
	(15, 5, 1, 3, 0, 22, 0),
	(40, 5, 1, 2, 0, 1, 0),
	(40, 9, 1, 1, 0, 1, 0),
	(41, 5, 1, 1, 0, 13, 0),
	(41, 9, 1, 2, 0, 11, 0),
	(42, 5, 1, 2, 0, 57, 0),
	(42, 9, 1, 1, 0, 63, 0),
	(43, 5, 1, 1, 0, 1, 0),
	(43, 9, 1, 2, 0, 1, 0),
	(44, 5, 1, 1, 0, 1, 0),
	(44, 9, 1, 2, 0, 1, 0),
	(45, 5, 1, 2, 0, 1, 0),
	(45, 9, 1, 1, 0, 9, 0),
	(46, 5, 1, 1, 0, 63, 0),
	(46, 9, 1, 2, 0, 56, 0),
	(47, 5, 1, 1, 0, 4, 0),
	(47, 9, 1, 2, 0, 2, 0),
	(48, 5, 1, 1, 0, 2, 0),
	(48, 9, 1, 2, 0, 1, 0),
	(49, 5, 1, 1, 0, 63, 0),
	(49, 9, 1, 2, 0, 51, 0),
	(50, 5, 1, 1, 0, 26, 0),
	(50, 9, 1, 2, 0, 85, 0),
	(51, 5, 1, 1, 0, 57, 0),
	(51, 9, 1, 2, 0, 57, 0),
	(52, 5, 1, 1, 0, 1, 0),
	(52, 9, 1, 2, 0, 1, 0),
	(53, 5, 1, 1, 0, 58, 0),
	(53, 9, 1, 2, 0, 58, 0),
	(54, 5, 1, 1, 0, 1, 0),
	(54, 9, 1, 2, 0, 1, 0),
	(55, 5, 1, 1, 0, 1, 0),
	(55, 9, 1, 2, 0, 1, 0),
	(56, 5, 1, 1, 0, 1, 0),
	(56, 9, 1, 2, 0, 1, 0),
	(57, 5, 1, 1, 0, 2, 0),
	(57, 9, 1, 2, 0, 1, 0),
	(58, 5, 1, 1, 0, 16, 0),
	(58, 9, 1, 2, 0, 1, 0),
	(59, 5, 1, 1, 0, 4, 0),
	(59, 9, 1, 2, 0, 1, 0),
	(60, 5, 1, 1, 0, 4, 0),
	(60, 9, 1, 2, 0, 1, 0),
	(61, 5, 1, 1, 0, 58, 0),
	(61, 9, 1, 2, 0, 1, 0),
	(62, 5, 1, 1, 0, 9, 0),
	(62, 9, 1, 2, 0, 1, 0),
	(63, 5, 1, 1, 0, 8, 0),
	(63, 9, 1, 2, 0, 17, 0),
	(64, 5, 1, 1, 0, 50, 0),
	(64, 9, 1, 2, 0, 43, 0),
	(65, 5, 1, 1, 0, 20, 0),
	(65, 9, 1, 2, 0, 28, 0),
	(66, 5, 1, 1, 0, 16, 0),
	(66, 9, 1, 2, 0, 27, 0),
	(67, 5, 1, 2, 0, 62, 0),
	(67, 9, 1, 1, 0, 55, 0),
	(68, 5, 1, 1, 0, 62, 0),
	(68, 9, 1, 2, 0, 59, 0),
	(69, 5, 1, 1, 0, 51, 0),
	(69, 9, 1, 2, 0, 60, 0);

-- Volcando estructura para tabla proyecto_oca.jugadores
CREATE TABLE IF NOT EXISTS `jugadores` (
  `IdJugador` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  PRIMARY KEY (`IdJugador`),
  UNIQUE KEY `Nombre` (`Nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.jugadores: ~6 rows (aproximadamente)
DELETE FROM `jugadores`;
INSERT INTO `jugadores` (`IdJugador`, `Nombre`, `Password`) VALUES
	(1, 'alejandro', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'),
	(2, 'aitana', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'),
	(3, 'G', '333e0a1e27815d0ceee55c473fe3dc93d56c63e3bee2b3b4aee8eed6d70191a3'),
	(4, 'pablito', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'),
	(5, 'pablofa', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5'),
	(9, 'Paco', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3');

-- Volcando estructura para tabla proyecto_oca.mensajes
CREATE TABLE IF NOT EXISTS `mensajes` (
  `IdMensaje` int(11) NOT NULL,
  `TextoTemplate` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`IdMensaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.mensajes: ~12 rows (aproximadamente)
DELETE FROM `mensajes`;
INSERT INTO `mensajes` (`IdMensaje`, `TextoTemplate`) VALUES
	(0, '¡{1} EMPIEZA EL JUEGO! '),
	(1, '{1} ha sacado un {0}'),
	(2, '¡De Oca a Oca! {1} salta a la casilla {0}'),
	(3, '¡De Puente a Puente! y {1} tira por la corriente'),
	(4, '¡Posada! {1} se quedará a descansar hasta que pase alguien'),
	(5, '¡POZO! {1} se quedará hasta que alguien le ayude'),
	(6, '¡FIN DEL JUEGO! {1} ha llegado a la meta'),
	(7, '¡{1} A LA CARCEL POR SINVERGÜENZA! hasta que lo rescaten'),
	(8, '¡LA MUERTE! {1} vuelve a empezar'),
	(9, '¡LABERINTO! {1} se ha perdido durante {4} turnos'),
	(10, '{1} ha caido en los dados'),
	(11, '¡{1} SE TORRÓ! retrocede a la casilla {0} ');

-- Volcando estructura para tabla proyecto_oca.partidas
CREATE TABLE IF NOT EXISTS `partidas` (
  `IdPartida` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) DEFAULT NULL,
  `IdJugadorTurno` int(11) DEFAULT NULL,
  `IdEstado` int(11) DEFAULT 1,
  `Password` varchar(50) DEFAULT NULL,
  `UltimoValorDado` int(11) DEFAULT 0,
  `IdUltimoMensaje` int(11) DEFAULT 1,
  `IdUltimoJugadorAccion` int(11) DEFAULT NULL,
  PRIMARY KEY (`IdPartida`),
  KEY `IdJugadorTurno` (`IdJugadorTurno`),
  KEY `fk_mensaje` (`IdUltimoMensaje`),
  CONSTRAINT `fk_mensaje` FOREIGN KEY (`IdUltimoMensaje`) REFERENCES `mensajes` (`IdMensaje`),
  CONSTRAINT `partidas_ibfk_1` FOREIGN KEY (`IdJugadorTurno`) REFERENCES `jugadores` (`IdJugador`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.partidas: ~33 rows (aproximadamente)
DELETE FROM `partidas`;
INSERT INTO `partidas` (`IdPartida`, `Nombre`, `IdJugadorTurno`, `IdEstado`, `Password`, `UltimoValorDado`, `IdUltimoMensaje`, `IdUltimoJugadorAccion`) VALUES
	(13, 'Sala de alejandro', 2, 2, NULL, 4, 1, NULL),
	(14, 'Sala de G', 1, 2, NULL, 3, 1, NULL),
	(15, 'Sala de alejandro', 1, 2, NULL, 1, 1, NULL),
	(40, 'Sala de Paco', 9, 2, NULL, 0, 1, NULL),
	(41, 'Sala de pablofa', 5, 2, NULL, 2, 1, NULL),
	(42, 'Sala de Paco', 9, 3, NULL, 5, 6, NULL),
	(43, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(44, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(45, 'Sala de Paco', 9, 2, NULL, 4, 2, 9),
	(46, 'Sala de pablofa', 5, 3, NULL, 3, 6, 5),
	(47, 'Sala de pablofa', 9, 2, NULL, 1, 1, 5),
	(48, 'Sala de pablofa', 9, 2, NULL, 1, 1, 5),
	(49, 'Sala de pablofa', 5, 3, NULL, 5, 6, 5),
	(50, 'Sala de pablofa', 5, 3, NULL, 6, 11, 9),
	(51, 'Sala de pablofa', 5, 3, NULL, 6, 11, 9),
	(52, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(53, 'Sala de pablofa', 9, 3, NULL, 5, 11, 5),
	(54, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(55, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(56, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(57, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(58, 'Sala de pablofa', 5, 2, NULL, 4, 2, 5),
	(59, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(60, 'Sala de pablofa', 5, 2, NULL, 3, 2, 5),
	(61, 'Sala de pablofa', 5, 3, NULL, 3, 6, 5),
	(62, 'Sala de pablofa', 5, 2, NULL, 1, 2, 5),
	(63, 'Sala de pablofa', 5, 2, NULL, 3, 1, NULL),
	(64, 'Sala de pablofa', 5, 2, NULL, 5, 2, NULL),
	(65, 'Sala de pablofa', 9, 2, NULL, 2, 1, 5),
	(66, 'Sala de pablofa', 9, 2, NULL, 6, 2, 9),
	(67, 'Sala de Paco', 5, 3, NULL, 3, 1, 9),
	(68, 'Sala de pablofa', 9, 3, NULL, 3, 1, 5),
	(69, 'Sala de pablofa', 9, 2, NULL, 1, 1, 5);

-- Volcando estructura para tabla proyecto_oca.tablero
CREATE TABLE IF NOT EXISTS `tablero` (
  `Casilla` int(11) NOT NULL,
  `IdTipo` int(11) DEFAULT NULL,
  PRIMARY KEY (`Casilla`),
  KEY `IdTipo` (`IdTipo`),
  CONSTRAINT `tablero_ibfk_1` FOREIGN KEY (`IdTipo`) REFERENCES `tipocasilla` (`IdTipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.tablero: ~63 rows (aproximadamente)
DELETE FROM `tablero`;
INSERT INTO `tablero` (`Casilla`, `IdTipo`) VALUES
	(1, 0),
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
	(26, 10),
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
	(53, 10),
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

-- Volcando estructura para tabla proyecto_oca.tipocasilla
CREATE TABLE IF NOT EXISTS `tipocasilla` (
  `IdTipo` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IdTipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.tipocasilla: ~11 rows (aproximadamente)
DELETE FROM `tipocasilla`;
INSERT INTO `tipocasilla` (`IdTipo`, `Nombre`) VALUES
	(0, 'Inicio'),
	(1, 'Normal'),
	(2, 'Oca'),
	(3, 'Puente'),
	(4, 'Posada'),
	(5, 'Pozo'),
	(6, 'Laberinto'),
	(7, 'Carcel'),
	(8, 'Calavera'),
	(9, 'Meta'),
	(10, 'Dados');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
