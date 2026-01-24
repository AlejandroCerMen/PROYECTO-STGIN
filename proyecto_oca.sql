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

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
