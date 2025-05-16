import streamlit as st
import sqlite3
import pandas as pd

def get_db_connection():
    conn = sqlite3.connect('mabase_SQLite.db')
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn

def consulter_reservations():
    st.header("Liste des Réservations")
    conn = get_db_connection()
    df = pd.read_sql_query('''
        SELECT Id_Reservation, Date_arrivee, Date_depart, Id_Client
        FROM Reservation
    ''', conn)
    conn.close()
    st.dataframe(df)

def consulter_clients():
    st.header("Liste des Clients")
    conn = get_db_connection()
    df = pd.read_sql_query("SELECT * FROM Client", conn)
    conn.close()
    st.dataframe(df)

def consulter_chambres_disponibles():
    st.header("Chambres Disponibles")
    date_debut = st.date_input("Date de début")
    date_fin = st.date_input("Date de fin")

    if date_debut and date_fin:
        conn = get_db_connection()
        df = pd.read_sql_query('''
            SELECT ch.*, tc.Type, h.Ville
            FROM Chambre ch
            JOIN Type_Chambre tc ON ch.Id_Type = tc.Id_Type
            JOIN Hotel h ON ch.Id_Hotel = h.Id_Hotel
            WHERE NOT EXISTS (
                SELECT 1
                FROM Reservation r
                JOIN Concerner cn ON r.Id_Reservation = cn.Id_Reservation
                JOIN Chambre c ON cn.Id_Type = c.Id_Type -- Corrected join here
                WHERE c.Id_Chambre = ch.Id_Chambre
                AND r.Date_arrivee < ?
                AND r.Date_depart > ?
            )
        ''', conn, params=(date_fin, date_debut))
        st.dataframe(df)
        conn.close()

def ajouter_client():
    st.header("Ajouter un Client")
    with st.form("ajouter_client_form"):
        nom = st.text_input("Nom complet")
        adresse = st.text_input("Adresse")
        ville = st.text_input("Ville")
        cp = st.number_input("Code postal", step=1)
        email = st.text_input("Email")
        tel = st.text_input("Téléphone")

        if st.form_submit_button("Ajouter"):
            conn = get_db_connection()
            conn.execute('''
                INSERT INTO Client (Nom_complet, Adresse, Ville, Code_postal, Email, Numero_telephone)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (nom, adresse, ville, cp, email, tel))
            conn.commit()
            conn.close()
            st.success("Client ajouté !")

def ajouter_reservation():
    st.header("Ajouter une Réservation")
    conn = get_db_connection()

    clients = conn.execute("SELECT Id_Client, Nom_complet FROM Client").fetchall()
    types_chambre = conn.execute("SELECT Id_Type, Type FROM Type_Chambre").fetchall()

    with st.form("ajouter_reservation_form"):
        client_id = st.selectbox("Client", options=[c['Id_Client'] for c in clients],
                                    format_func=lambda x: next(c['Nom_complet'] for c in clients if c['Id_Client'] == x))
        type_id = st.selectbox("Type de chambre", options=[t['Id_Type'] for t in types_chambre],
                                format_func=lambda x: next(t['Type'] for t in types_chambre if t['Id_Type'] == x))
        date_arrivee = st.date_input("Date d'arrivée")
        date_depart = st.date_input("Date de départ")

        if st.form_submit_button("Valider"):
            cur = conn.cursor()
            cur.execute('''
                INSERT INTO Reservation (Id_Client, Date_arrivee, Date_depart)
                VALUES (?, ?, ?)
            ''', (client_id, date_arrivee, date_depart))

            reservation_id = cur.lastrowid
            cur.execute('''
                INSERT INTO Concerner (Id_Reservation, Id_Type)
                VALUES (?, ?)
            ''', (reservation_id, type_id))

            conn.commit()
            conn.close()
            st.success("Réservation ajoutée !")

def main():
    st.title("🏨 Gestion Hôtelière")
    menu = ["Consulter Réservations", "Consulter Clients", "Chambres Disponibles", "Ajouter Client", "Ajouter Réservation"]
    choix = st.sidebar.selectbox("Menu", menu)

    if choix == "Consulter Réservations": consulter_reservations()
    elif choix == "Consulter Clients": consulter_clients()
    elif choix == "Chambres Disponibles": consulter_chambres_disponibles()
    elif choix == "Ajouter Client": ajouter_client()
    elif choix == "Ajouter Réservation": ajouter_reservation()

if __name__ == "__main__":
    main()
