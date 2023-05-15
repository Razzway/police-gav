-- phpMyAdmin SQL Dump
-- version 4.6.6deb5ubuntu0.5
-- https://www.phpmyadmin.net/
--
-- Client :  localhost:3306
-- Généré le :  Sam 15 Avril 2023 à 15:17
-- Version du serveur :  10.11.2-MariaDB-1:10.11.2+maria~ubu1804
-- Version de PHP :  7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `sweety`
--

-- --------------------------------------------------------

--
-- Structure de la table `police_gav`
--

CREATE TABLE `police_gav` (
  `identifier` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `celluleid` int(11) NOT NULL,
  `agentName` varchar(255) DEFAULT NULL,
  `pName` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `police_gav`
--
ALTER TABLE `police_gav`
  ADD PRIMARY KEY (`identifier`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
