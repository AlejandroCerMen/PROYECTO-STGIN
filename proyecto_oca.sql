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
  PRIMARY KEY (`IdPartida`,`IdJugador`),
  KEY `IdJugador` (`IdJugador`),
  CONSTRAINT `detallespartida_ibfk_1` FOREIGN KEY (`IdPartida`) REFERENCES `partidas` (`IdPartida`) ON DELETE CASCADE,
  CONSTRAINT `detallespartida_ibfk_2` FOREIGN KEY (`IdJugador`) REFERENCES `jugadores` (`IdJugador`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.detallespartida: ~23 rows (aproximadamente)
DELETE FROM `detallespartida`;
INSERT INTO `detallespartida` (`IdPartida`, `IdJugador`, `Casilla`, `Orden`, `Bloqueo`, `CasillaActual`) VALUES
	(13, 1, 1, 1, 0, 24),
	(13, 2, 1, 2, 0, 22),
	(14, 1, 1, 2, 0, 10),
	(14, 3, 1, 1, 0, 7),
	(15, 1, 1, 1, 0, 10),
	(15, 2, 1, 4, 0, 15),
	(15, 4, 1, 2, 0, 26),
	(15, 5, 1, 3, 0, 22),
	(40, 5, 1, 2, 0, 1),
	(40, 9, 1, 1, 0, 1),
	(41, 5, 1, 1, 0, 13),
	(41, 9, 1, 2, 0, 11),
	(42, 9, 1, 1, 0, 1),
	(43, 5, 1, 1, 0, 1),
	(43, 9, 1, 2, 0, 1),
	(44, 5, 1, 1, 0, 1),
	(44, 9, 1, 2, 0, 1),
	(45, 5, 1, 2, 0, 1),
	(45, 9, 1, 1, 0, 9),
	(46, 5, 1, 1, 0, 63),
	(46, 9, 1, 2, 0, 56),
	(47, 5, 1, 1, 0, 3),
	(47, 9, 1, 2, 0, 2);

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

-- Volcando datos para la tabla proyecto_oca.mensajes: ~6 rows (aproximadamente)
DELETE FROM `mensajes`;
INSERT INTO `mensajes` (`IdMensaje`, `TextoTemplate`) VALUES
	(1, '{1} ha sacado un {0}'),
	(2, '¡De Oca a Oca! {1} salta a la casilla {0}'),
	(3, '¡De Puente a Puente! {1} salta a la casilla {0}'),
	(4, '¡El puente está roto! {1} vuelve a la casilla {0}'),
	(5, '¡LA MUERTE! {1} vuelve a empezar'),
	(6, '¡FIN DEL JUEGO! {1} ha llegado a la meta');

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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.partidas: ~11 rows (aproximadamente)
DELETE FROM `partidas`;
INSERT INTO `partidas` (`IdPartida`, `Nombre`, `IdJugadorTurno`, `IdEstado`, `Password`, `UltimoValorDado`, `IdUltimoMensaje`, `IdUltimoJugadorAccion`) VALUES
	(13, 'Sala de alejandro', 2, 2, NULL, 4, 1, NULL),
	(14, 'Sala de G', 1, 2, NULL, 3, 1, NULL),
	(15, 'Sala de alejandro', 1, 2, NULL, 1, 1, NULL),
	(40, 'Sala de Paco', 9, 2, NULL, 0, 1, NULL),
	(41, 'Sala de pablofa', 5, 2, NULL, 2, 1, NULL),
	(42, 'Sala de Paco', 9, 1, NULL, 0, 1, NULL),
	(43, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(44, 'Sala de pablofa', 5, 2, NULL, 0, 1, NULL),
	(45, 'Sala de Paco', 9, 2, NULL, 4, 2, 9),
	(46, 'Sala de pablofa', 5, 3, NULL, 3, 6, 5),
	(47, 'Sala de pablofa', 5, 2, NULL, 1, 1, 9);

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

-- Volcando estructura para tabla proyecto_oca.tipocasilla
CREATE TABLE IF NOT EXISTS `tipocasilla` (
  `IdTipo` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IdTipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.tipocasilla: ~10 rows (aproximadamente)
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
	(9, 'Meta');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
