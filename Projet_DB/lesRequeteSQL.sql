
USE gestion_hotel;

-- Requête a
-- Afficher la liste des réservations avec le nom du client et la ville de l’hôtel réservé.

SELECT
    R.Id_Réservation,
    C.Nom_complet AS "Nom du client",
    H.Ville AS "Ville de l'hôtel"
FROM
    Reservation R
    JOIN Client C
        ON R.Id_Client = C.Id_Client
    JOIN Concerner Con
        ON R.Id_Réservation = Con.Id_Réservation
    JOIN Type_Chambre TC
        ON Con.Id_Type = TC.Id_Type
    JOIN Chambre Ch
        ON TC.Id_Type = Ch.Id_Type
    JOIN Hotel H
        ON Ch.Id_Hotel = H.Id_Hotel
GROUP BY
    R.Id_Réservation,
    C.Nom_complet,
    H.Ville
ORDER BY
    R.Id_Réservation;


-- Requête b
-- Afficher les clients qui habitent à Paris.

SELECT * FROM Client WHERE Ville = 'Paris';

-- Requete c
-- Calculer le nombre de réservations faites par chaque client.

SELECT
    C.Nom_complet AS "Nom du client",
    COUNT(R.Id_Réservation) AS "Nombre de réservations"
FROM
    Client C
    LEFT JOIN Reservation R
        ON C.Id_Client = R.Id_Client
GROUP BY
    C.Id_Client,
    C.Nom_complet;


-- Requête d
-- Donner le nombre de chambres pour chaque type de chambre.

SELECT
    TC.Type AS "Type de chambre",
    COUNT(Ch.Id_Chambre) AS "Nombre de chambres"
FROM
    Type_Chambre TC
    LEFT JOIN Chambre Ch
        ON TC.Id_Type = Ch.Id_Type
GROUP BY
    TC.Id_Type,
    TC.Type;



-- Requête e
-- Afficher la liste des chambres qui ne sont pas réservées pour une période donnée (entre deux dates saisies par l’utilisateur).

SELECT
    Ch.Id_Chambre,
    Ch.Numero,
    H.Ville,
    TC.Type AS "Type de chambre"
FROM
    Chambre Ch
    JOIN Hotel H
        ON Ch.Id_Hotel = H.Id_Hotel
    JOIN Type_Chambre TC
        ON Ch.Id_Type = TC.Id_Type
WHERE
    TC.Id_Type NOT IN (
        SELECT DISTINCT Con.Id_Type
        FROM Concerner Con
        JOIN Reservation R
            ON Con.Id_Réservation = R.Id_Réservation
        WHERE
            R.Date_arrivée <= '2025-12-31'
            AND R.Date_départ >= '2025-12-01'
    )
ORDER BY
    H.Ville,
    Ch.Numero;