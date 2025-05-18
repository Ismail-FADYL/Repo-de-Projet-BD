--  La création de la base de données

CREATE DATABASE IF NOT EXISTS gestion_hotel;

USE gestion_hotel;


--  La création des tables

CREATE TABLE IF NOT EXISTS Hotel (
    Id_Hotel INT PRIMARY KEY AUTO_INCREMENT,
    Ville VARCHAR(255),
    Pays VARCHAR(255),
    Code_postal INT
);

CREATE TABLE IF NOT EXISTS Client (
    Id_Client INT PRIMARY KEY AUTO_INCREMENT,
    Adresse VARCHAR(255),
    Ville VARCHAR(255),
    Code_postal INT,
    Email VARCHAR(255),
    Numero_telephone VARCHAR(20),
    Nom_complet VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Type_Chambre (
    Id_Type INT PRIMARY KEY AUTO_INCREMENT,
    Type VARCHAR(255),
    Tarif DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS Chambre (
    Id_Chambre INT PRIMARY KEY AUTO_INCREMENT,
    Numero INT,
    Etage INT,
    Fumeurs BOOLEAN,
    Id_Hotel INT,
    Id_Type INT,
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel(Id_Hotel),
    FOREIGN KEY (Id_Type) REFERENCES Type_Chambre(Id_Type)
);

CREATE TABLE IF NOT EXISTS Reservation (
    Id_Réservation INT PRIMARY KEY AUTO_INCREMENT,
    Date_arrivée DATE,
    Date_départ DATE,
    Id_Client INT,
    Id_Chambre INT,
    FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client),
    FOREIGN KEY (Id_Chambre) REFERENCES Chambre(Id_Chambre)
);

CREATE TABLE IF NOT EXISTS Prestation (
    Id_Prestation INT PRIMARY KEY AUTO_INCREMENT,
    Prix DECIMAL(10, 2),
    Type VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Evaluation (
    Id_Evaluation INT PRIMARY KEY AUTO_INCREMENT,
    Date_arrivee DATE,
    Note INT,
    Texte_descriptif TEXT,
    Id_Client INT,
    FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client)
);

CREATE TABLE IF NOT EXISTS Offre (
    Id_Hotel INT,
    Id_Prestation INT,
    PRIMARY KEY (Id_Hotel, Id_Prestation),
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel(Id_Hotel),
    FOREIGN KEY (Id_Prestation) REFERENCES Prestation(Id_Prestation)
);

CREATE TABLE IF NOT EXISTS Concerner (
    Id_Réservation INT,
    Id_Type INT,
    PRIMARY KEY (Id_Réservation, Id_Type),
    FOREIGN KEY (Id_Réservation) REFERENCES Reservation(Id_Réservation),
    FOREIGN KEY (Id_Type) REFERENCES Type_Chambre(Id_Type)
);