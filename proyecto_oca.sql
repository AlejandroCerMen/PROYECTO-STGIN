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
  `TurnosCastigos` int(11) DEFAULT 0,
  PRIMARY KEY (`IdPartida`,`IdJugador`),
  KEY `IdJugador` (`IdJugador`),
  CONSTRAINT `detallespartida_ibfk_1` FOREIGN KEY (`IdPartida`) REFERENCES `partidas` (`IdPartida`) ON DELETE CASCADE,
  CONSTRAINT `detallespartida_ibfk_2` FOREIGN KEY (`IdJugador`) REFERENCES `jugadores` (`IdJugador`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla proyecto_oca.detallespartida: ~35 rows (aproximadamente)
DELETE FROM `detallespartida`;
INSERT INTO `detallespartida` (`IdPartida`, `IdJugador`, `Casilla`, `Orden`, `Bloqueo`, `CasillaActual`, `TurnosCastigos`) VALUES
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
	(42, 9, 1, 1, 0, 1, 0),
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
	(53, 9, 1, 2, 0, 58, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
