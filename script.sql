CREATE SEQUENCE clienti_index START WITH 1 INCREMENT BY 1 MINVALUE 0 NOCACHE;
CREATE SEQUENCE locatii_index START WITH 1 INCREMENT BY 1 MINVALUE 0 NOCACHE;
CREATE SEQUENCE produse_index START WITH 1 INCREMENT BY 1 MINVALUE 0 NOCACHE;
CREATE SEQUENCE meniuri_index START WITH 1 INCREMENT BY 1 MINVALUE 0 NOCACHE;
CREATE SEQUENCE recompense_index START WITH 1 INCREMENT BY 1 MINVALUE 0 NOCACHE;
CREATE SEQUENCE comenzi_index START WITH 1 INCREMENT BY 1 MINVALUE 0 NOCACHE;
CREATE SEQUENCE categorii_index START WITH 1 INCREMENT BY 1 MINVALUE 0 NOCACHE;

CREATE TABLE CLIENTI
(
    id_client INT DEFAULT clienti_index.nextval PRIMARY KEY,
    email VARCHAR2(50) NOT NULL UNIQUE,
    parola_criptata VARCHAR2(50) NOT NULL,
    nume VARCHAR2(30) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    nr_puncte INT,
    telefon VARCHAR2(15) NOT NULL UNIQUE,
    data_inregistrarii DATE DEFAULT SYSDATE
);

CREATE TABLE LOCATII
(
    id_locatie INT DEFAULT locatii_index.nextval PRIMARY KEY,
    denumire VARCHAR(50) NOT NULL UNIQUE,
    adresa VARCHAR(100) NOT NULL,
    ora_deschidere VARCHAR2(6),
    ora_inchidere VARCHAR2(6)
);

CREATE TABLE MENIURI
(
    id_meniu INT DEFAULT meniuri_index.nextval PRIMARY KEY,
    denumire VARCHAR(50) NOT NULL UNIQUE,
    pret NUMBER(7,2) NOT NULL,
    cantitate_totala INT DEFAULT 0
);


CREATE TABLE CATEGORII
(
    id_categorie INT DEFAULT categorii_index.nextval PRIMARY KEY,
    denumire VARCHAR(50) NOT NULL UNIQUE,
    descriere VARCHAR(150)
);

CREATE TABLE PRODUSE
(
    id_produs INT DEFAULT produse_index.nextval PRIMARY KEY,
    denumire VARCHAR(150) NOT NULL UNIQUE,
    cantitate INT NOT NULL,
    pret NUMBER(7,2) NOT NULL,
    id_categorie REFERENCES categorii(id_categorie) ON DELETE SET NULL
);

CREATE TABLE NUTRITIE
(
    id_produs REFERENCES produse(id_produs) ON DELETE CASCADE PRIMARY KEY,
    calorii NUMBER(6,2) DEFAULT 0,
    grasimi NUMBER(6,2) DEFAULT 0,
    carbohidrati NUMBER(6,2) DEFAULT 0,
    proteine NUMBER(6,2) DEFAULT 0,
    fibre NUMBER(6,2) DEFAULT 0
);

CREATE TABLE RECOMPENSE
(
    id_recompensa INT DEFAULT recompense_index.nextval PRIMARY KEY,
    id_meniu REFERENCES meniuri(id_meniu) ON DELETE CASCADE,
    denumire VARCHAR(50) NOT NULL UNIQUE,
    nr_puncte INT DEFAULT 0 NOT NULL
);

CREATE TABLE CUPOANE
(
    cod_cupon VARCHAR(20) PRIMARY KEY NOT NULL,
    id_categorie REFERENCES categorii(id_categorie) ON DELETE SET NULL,
    procent INT DEFAULT 0,
    data_inceput DATE DEFAULT SYSDATE,
    data_expirare DATE DEFAULT SYSDATE
);

CREATE TABLE COMENZI
(
    id_comanda INT DEFAULT comenzi_index.nextval PRIMARY KEY,
    id_client REFERENCES clienti(id_client) ON DELETE SET NULL,
    id_cupon REFERENCES cupoane(cod_cupon) ON DELETE SET NULL,
    id_locatie REFERENCES locatii(id_locatie) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'In Pregatire',
    pret_total NUMBER(7,2) DEFAULT 0,
    puncte_totale INT DEFAULT 0,
    data_plasarii DATE DEFAULT SYSDATE
);

CREATE TABLE COMENZI_CONTIN_PRODUSE
(
    id_comanda REFERENCES comenzi(id_comanda) ON DELETE CASCADE,
    id_produs REFERENCES produse(id_produs) ON DELETE CASCADE,
    nr_produse INT DEFAULT 0,
    CONSTRAINT pk_com_pro PRIMARY KEY (id_comanda,id_produs)
);

CREATE TABLE STOC_LOCATII
(
    id_locatie REFERENCES locatii(id_locatie) ON DELETE CASCADE,
    id_produs REFERENCES produse(id_produs) ON DELETE CASCADE,
    nr_produse INT DEFAULT 0,
    CONSTRAINT pk_loc_pro PRIMARY KEY (id_locatie,id_produs)
);

CREATE TABLE COMENZI_CONTIN_MENIURI
(
    id_comanda REFERENCES comenzi(id_comanda) ON DELETE CASCADE,
    id_meniu REFERENCES meniuri(id_meniu) ON DELETE CASCADE,
    cantitate INT DEFAULT 1,
    CONSTRAINT pk_com_men PRIMARY KEY (id_comanda,id_meniu)
);

CREATE TABLE LOCATII_OFERA_MENIURI
(
    id_locatie REFERENCES locatii(id_locatie) ON DELETE CASCADE,
    id_meniu REFERENCES meniuri(id_meniu) ON DELETE CASCADE,
    CONSTRAINT pk_loc_men PRIMARY KEY (id_locatie,id_meniu)
);


CREATE TABLE MENIURI_CONTIN_PRODUSE
(
    id_meniu REFERENCES meniuri(id_meniu) ON DELETE CASCADE,
    id_produs REFERENCES produse(id_produs) ON DELETE CASCADE,
    nr_produse INT default 1,
    CONSTRAINT pk_men_pro PRIMARY KEY (id_meniu,id_produs)
);

CREATE TABLE COMENZI_CONTIN_RECOMPENSE
(
    id_comanda REFERENCES comenzi(id_comanda) ON DELETE CASCADE UNIQUE,
    id_recompensa REFERENCES recompense(id_recompensa) ON DELETE CASCADE,
    CONSTRAINT pk_com_rec PRIMARY KEY (id_comanda,id_recompensa)
);

CREATE TABLE MENIURI_AU_CATEGORII
(
    id_meniu REFERENCES meniuri(id_meniu) ON DELETE CASCADE,
    id_categorie REFERENCES categorii(id_categorie) ON DELETE CASCADE,
    CONSTRAINT pk_men_cat PRIMARY KEY (id_meniu,id_categorie)
);

INSERT INTO CLIENTI(email, parola_criptata, nume, prenume, nr_puncte, telefon) VALUES ('ana.popescu@example.com', 'DFanu3248234N', 'Popescu', 'Ana', 150, '+40721164456');
INSERT INTO CLIENTI(email, parola_criptata, nume, prenume, nr_puncte, telefon) VALUES ('mihai.ionescu@example.com', 'C3284BY324BByb', 'Ionescu', 'Mihai', 200, '+40732167836');
INSERT INTO CLIENTI(email, parola_criptata, nume, prenume, nr_puncte, telefon) VALUES ('cristina.radu@example.com', 'bv3874BCIUacn', 'Radu', 'Cristina', 100, '+40743125382');
INSERT INTO CLIENTI(email, parola_criptata, nume, prenume, nr_puncte, telefon) VALUES ('andrei.stoica@example.com', 'fv34h8f3fhniN', 'Stoica', 'Andrei', 50, '+40754176342');
INSERT INTO CLIENTI(email, parola_criptata, nume, prenume, nr_puncte, telefon) VALUES ('laura.petre@example.com', '324BH8234Rz', 'Petre', 'Laura', 300, '+40765125775');

INSERT INTO CATEGORII(denumire,descriere) values('Boluri Poke','Poke este peste crud taiat cubulete, servit fie ca aperitiv, fie ca fel principal.');
INSERT INTO CATEGORII(denumire,descriere) values('Meniuri de copii','Meniuri sanatoase, ideale pentru toti copiii');
INSERT INTO CATEGORII(denumire,descriere) values('Bauturi','Selectia noastra de bauturi');
INSERT INTO CATEGORII(denumire,descriere) values('Aditii Extra','Alimente aditionale pentru produsele comandate');
INSERT INTO CATEGORII(denumire,descriere) values('Populare','Produse populare, selectate de noi');
INSERT INTO CATEGORII(denumire) values('Salate'); --descrierea poate sa nu existe
INSERT INTO CATEGORII(denumire,descriere) values('Platouri','Platouri selectate de noi pentru o nutritie corecta');
INSERT INTO CATEGORII(denumire,descriere) values('Pui','Produse care contin pui');
INSERT INTO CATEGORII(denumire,descriere) values('Peste','Produse care contin peste');
INSERT INTO CATEGORII(denumire,descriere) values('Vita','Produse care contin vita');
INSERT INTO CATEGORII(denumire,descriere) values('Orez','Produse care contin orez');

INSERT INTO CUPOANE(cod_cupon,id_categorie,procent,data_inceput,data_expirare) values('POKE10',1,10,'20-JAN-2024','20-FEB-2024');
INSERT INTO CUPOANE(cod_cupon,id_categorie,procent,data_expirare) values('POKE20',1,20,SYSDATE-5);
INSERT INTO CUPOANE(cod_cupon,id_categorie,procent,data_expirare) values('VEGAN5',4,5,'25-MAR-2024');
INSERT INTO CUPOANE(cod_cupon,id_categorie,procent,data_inceput,data_expirare) values('COPII25',2,25,'1-JAN-2024','1-APR-2024');
INSERT INTO CUPOANE(cod_cupon,id_categorie,procent,data_expirare) values('VEGAN20',4,20,'1-FEB-2024');

INSERT INTO LOCATII(denumire,adresa,ora_deschidere,ora_inchidere) values('Helti Bucuresti Mall','Calea Vitan 55-59, Bucuresti 031282','8:00','22:00');
INSERT INTO LOCATII(denumire,adresa,ora_deschidere,ora_inchidere) values('Helti Afi Ploiesti','Strada Calomfirescu 2, Ploiesti 100176','10:00','20:00');
INSERT INTO LOCATII(denumire,adresa,ora_deschidere,ora_inchidere) values('Helti Afi Bucuresti','Bulevardul General Paul Teodorescu 4, Bucuresti 061344','11:00','22:00');
INSERT INTO LOCATII(denumire,adresa,ora_deschidere,ora_inchidere) values('Helti Dambovita Mall','Bulevardul Regele Ferdinand nr. 6, Targoviste 130026','9:00','20:00');
INSERT INTO LOCATII(denumire,adresa,ora_deschidere,ora_inchidere) values('Helti Timisoara Mall','Calea Sagului 100, Timisoara 300516','8:00','22:00');

INSERT INTO MENIURI(denumire,pret) values('Satay de pui',10.9);
INSERT INTO MENIURI(denumire,pret) values('Bol Poke cu somon', 11.95);
INSERT INTO MENIURI(denumire,pret) values('Curry Dulce',8.95);
INSERT INTO MENIURI(denumire,pret) values('Bol Poke cu pui Wakadori',9.95);
INSERT INTO MENIURI(denumire,pret) values('Platou Pui 3 Culori',12);
INSERT INTO MENIURI(denumire,pret) values('Platou Pui Teriyaki',12.5);
INSERT INTO MENIURI(denumire,pret) values('Platou Pui Chili Iute',12);
INSERT INTO MENIURI(denumire,pret) values('Platou Peste Crocant',11.5);
INSERT INTO MENIURI(denumire,pret) values('Platou Vita Texas',12.5);
INSERT INTO MENIURI(denumire,pret) values('Platou Pui Quatro Formaggi',12);

INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(1,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(1,5);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(2,1);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(2,9);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(4,1);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(4,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(5,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(5,7);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(6,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(6,7);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(7,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(7,7);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(8,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(8,9);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(8,5);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(9,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(9,10);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(10,8);
INSERT INTO MENIURI_AU_CATEGORII(id_meniu,id_categorie) VALUES(10,7);

INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(1,1);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(1,2);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(1,4);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(1,5);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(1,8);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(1,9);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(2,1);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(2,2);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(2,3);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(2,4);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(2,5);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(2,6);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(2,7);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(3,10);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(3,7);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(3,9);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(3,8);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(4,1);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(4,2);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(4,3);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(4,4);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(4,6);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(5,1);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(5,10);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(5,7);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(5,8);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(5,9);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(5,6);
INSERT INTO LOCATII_OFERA_MENIURI(id_locatie,id_meniu) VALUES(5,5);

-- Satay de pui
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Piept de pui',60,4,8);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Sos Satay',42,1.5,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Orez alb gatit',90,4,11);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Ciuperci',30,0.6,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Zucchini',40,0.6,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Ardei gras',40,0.6,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Muguri de fasole',30,0.6,4);

INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(1,1);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(1,2);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(1,3);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(1,4);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(1,5);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(1,6);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(1,7);
--Bol Poke cu somon
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Orez de sushi',160,6,11);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Somon',50,4,9);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Avocado',30,0.6,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Wakame',30,0.6,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Edamame',20,0.5,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Varza rosie',20,0.5,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Castravete',30,0.6,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Condimente asiatice',1,0.5,4);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Sos cremos de susan prajit',25,1,4);

INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,8);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,9);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,10);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,11);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,12);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,13);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,14);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,15);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(2,16);

--Curry dulce > nu le gasesc informatiile alimentare

--Bol Poke cu pui Wakadori
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Pui Wakadori',50,4.5,8);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,8);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,17);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,10);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,11);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,12);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,13);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,14);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,15);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(4,16);

--Platou Pui 3 culori
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Pui 3 culori',200,9.5,8);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Salata',150,3,6);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Orez alb cu legume',200,7.5,11);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(5,18);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(5,19);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(5,20);

--Platou Pui Teriyaki
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Pui Teriyaki',200,10,8);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Orez negru cu dovlecel',200,8,11);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(6,21);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(6,19);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(6,22);

--Platou Pui Chili Iute
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Pui Chili Iute',200,9,8);
INSERT INTO PRODUSE(denumire,cantitate,pret) values('Piure',200,7);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(7,23);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(7,19);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(7,24);

--Platou Peste Crocant
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Peste Crocant',200,10,9);
INSERT INTO PRODUSE(denumire,cantitate,pret) values('Cartofi Wedges',200,8.5);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(8,25);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(8,19);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(8,26);

--Platou Vita Texas
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Vita Texas',200,10,10);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(9,27);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(9,19);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(9,20);

--Platou Pui Quatro Formaggi
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Pui Quatro Formaggi',200,9,8);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(10,28);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(10,19);
INSERT INTO MENIURI_CONTIN_PRODUSE(id_meniu,id_produs) VALUES(10,20);

--Bauturi
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Fresh Portocale',380,3.5,3);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Coca Cola Zero',500,3.5,3);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Limonada',380,3.5,3);
INSERT INTO PRODUSE(denumire,cantitate,pret,id_categorie) values('Fuzetea Piersici si Hibiscus',500,3.5,3);

INSERT INTO NUTRITIE(id_produs,calorii, grasimi, carbohidrati, proteine, fibre) VALUES(1,99,1.5,0,21,0);
INSERT INTO NUTRITIE(id_produs,calorii, grasimi, carbohidrati, proteine, fibre) VALUES(2,312,17.5,30,7.5,2.5);
INSERT INTO NUTRITIE(id_produs,calorii, grasimi, carbohidrati, proteine, fibre) VALUES(3,131,0,28,3,1);
INSERT INTO NUTRITIE(id_produs,calorii, grasimi, carbohidrati, proteine, fibre) VALUES(4,16.6,0,0,3.3,3.3);
INSERT INTO NUTRITIE(id_produs,calorii, grasimi, carbohidrati, proteine, fibre) VALUES(5,30,0,5,2.5,0);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(6,2.5,32.5,5,0,0);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(7,0,2.7,3.3,3.3,0);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(8,0.62,146.2,31.2,3.1,0);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(9,0,220,0,20,16);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(10,3.3,200,3,3,20);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(11,0,126.6,16.6,3,6.6);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(12,5,105,5,10,5);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(13,5,25,5,0,0);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(14,0,17,3,0,0);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(15,0,600,50,0,25);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(16,0,160,28,0,4);
INSERT INTO NUTRITIE(id_produs,fibre, calorii, carbohidrati, proteine, grasimi) VALUES(17,0,170,14,14,6);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(18,182,18.3,1.25,10.55,0);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(21,236,20,6.9,4.5,2);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(23,223,18,12.4,6.1,1);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(25,173.9,6.52,14.5,9.9,0.65);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(27,210,22,6.8,9,1);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(28,294.5,26,1.4,21.2,0);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(19,23.86,1.06,3.4,1,1.8);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(26,157.26,5,19.1,8.28,1.9);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(24,189,4.2,36.5,2.75,0.35);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(22,113,2.46,19.87,3.12,1);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(20,331,3.5,32.1,23,1.37);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(29,47,0.8,13,0.3,1.8);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(31,47,1.1,9,0.3,2.8);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(30,0.2,0,0,0,0);
INSERT INTO NUTRITIE(id_produs, calorii, proteine, carbohidrati, grasimi,fibre) VALUES(32,19,0,4.4,0,0);

INSERT INTO RECOMPENSE(id_meniu,denumire,nr_puncte) VALUES(2,'Bol Poke cu somon',330);
INSERT INTO RECOMPENSE(id_meniu,denumire,nr_puncte) VALUES(7,'Platou Pui Chili Iute',400);
INSERT INTO RECOMPENSE(id_meniu,denumire,nr_puncte) VALUES(5,'Platou Pui 3 Culori',400);
INSERT INTO RECOMPENSE(denumire,nr_puncte) VALUES('Cana stilizata cu brandul Helti',500);
INSERT INTO RECOMPENSE(denumire,nr_puncte) VALUES('Hanorac stilizat cu brandul Helti',700);
INSERT INTO RECOMPENSE(denumire,nr_puncte) VALUES('Tricou stilizat cu brandul Helti',500);

INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE) VALUES(1,1); --DEFAULT: SYSDATE
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,ID_CUPON,DATA_PLASARII) VALUES(2,1,'POKE10',SYSDATE-5);
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,DATA_PLASARII) VALUES(3,3,SYSDATE-3);
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,DATA_PLASARII) VALUES(2,4,SYSDATE);
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,DATA_PLASARII) VALUES(3,1,'1-JAN-2024');
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,ID_CUPON,DATA_PLASARII) VALUES(5,2,'POKE20','21-DEC-2023');
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,DATA_PLASARII) VALUES(3,1,'19-NOV-2023');
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,DATA_PLASARII) VALUES(3,1,'7-FEB-2023');
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,DATA_PLASARII) VALUES(5,3,'12-AUG-2023');
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE) VALUES(1,2);
INSERT INTO COMENZI(ID_CLIENT,ID_LOCATIE,DATA_PLASARII) VALUES(2,2,SYSDATE-20);

INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU) VALUES(1,1); --DEFAULT: 1 pt cantitate
INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU,CANTITATE) VALUES(1,2,2); 
INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(1,1);

INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU,CANTITATE) VALUES(2,4,3);
INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(2,2);

INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(3,3);

INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(4,2);
INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU) VALUES(4,6);
INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU) VALUES(4,3);

INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU,CANTITATE) VALUES(5,3,4);
INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(5,2);

INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU,CANTITATE) VALUES(6,7,2);
INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU) VALUES(6,4);

INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU,CANTITATE) VALUES(7,3,2);
INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(7,5);

INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES (8,1);
INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU) VALUES(8,9);
INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU) VALUES(8,8);

INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU) VALUES(9,9);
INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(9,1);

INSERT INTO COMENZI_CONTIN_MENIURI(ID_COMANDA,ID_MENIU,CANTITATE) VALUES (10,7,4);
INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(10,6);

INSERT INTO COMENZI_CONTIN_RECOMPENSE(ID_COMANDA,ID_RECOMPENSA) VALUES(11,1);

INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs) values(1,14);
INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs,nr_produse) values(1,31,2);

INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs,nr_produse) values(3,29,2);

INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs) values(5,30);

INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs,nr_produse) values(8,32,3);
INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs) values(1,2);

INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs) values(4,29);
INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs) values(10,29);
INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs,nr_produse) values(10,30,3);

INSERT INTO COMENZI_CONTIN_PRODUSE(id_comanda,id_produs,nr_produse) values(9,31,2);


-- Stoc Locatia 1
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 1, 10);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 2, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 3, 15);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 4, 32);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 5, 20);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 6, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 7, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 8, 12);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 9, 28);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 10, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 11, 17);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 12, 23);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 13, 30);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 14, 8);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 15, 22);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 16, 19);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 17, 26);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 18, 11);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 19, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 20, 30);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 21, 24);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 22, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 23, 27);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 24, 9);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 25, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 26, 21);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 27, 13);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 28, 29);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 29, 15);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 30, 7);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 31, 26);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (1, 32, 23);


-- Stoc Locatia 2
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 1, 10);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 2, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 3, 15);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 4, 32);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 5, 20);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 6, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 7, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 8, 12);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 9, 28);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 10, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 11, 17);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 12, 23);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 13, 30);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 14, 8);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 15, 22);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 16, 19);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 17, 26);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 18, 11);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 19, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 20, 30);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 21, 24);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 22, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 23, 27);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 24, 9);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 25, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 26, 21);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 27, 13);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 28, 29);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 29, 15);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 30, 7);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 31, 26);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (2, 32, 23);


-- Stoc Locatia 3
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 1, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 2, 27);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 3, 20);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 4, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 5, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 6, 8);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 7, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 8, 32);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 9, 12);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 10, 23);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 11, 29);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 12, 15);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 13, 22);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 14, 10);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 15, 19);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 16, 26);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 17, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 18, 21);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 19, 7);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 20, 30);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 21, 17);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 22, 28);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 23, 11);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 24, 24);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 25, 9);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 26, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 27, 31);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 28, 13);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 29, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 30, 5);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 31, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (3, 32, 22);


--Stoc Locatia 4
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 1, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 2, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 3, 30);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 4, 19);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 5, 10);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 6, 22);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 7, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 8, 27);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 9, 12);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 10, 8);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 11, 21);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 12, 29);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 13, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 14, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 15, 26);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 16, 9);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 17, 32);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 18, 15);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 19, 23);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 20, 7);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 21, 20);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 22, 11);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 23, 28);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 24, 17);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 25, 13);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 26, 24);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 27, 6);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 28, 19);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 29, 31);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 30, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 31, 28);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (4, 32, 10);


-- Stoc Locatia 5
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 1, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 2, 26);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 3, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 4, 32);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 5, 20);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 6, 11);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 7, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 8, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 9, 29);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 10, 9);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 11, 22);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 12, 15);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 13, 27);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 14, 13);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 15, 21);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 16, 7);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 17, 24);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 18, 19);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 19, 12);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 20, 30);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 21, 16);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 22, 23);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 23, 10);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 24, 28);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 25, 8);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 26, 17);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 27, 31);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 28, 14);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 29, 25);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 30, 5);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 31, 18);
INSERT INTO STOC_LOCATII (id_locatie, id_produs, nr_produse) VALUES (5, 32, 22);

--6. INDEX-BY TABLES, NESTED TABLES, VARRAYS cu SUBPROGRAM STOCAT INDEPENDENT (functie/procedura)

CREATE OR REPLACE PROCEDURE afisare_meniuri
IS
type rec_meniuri is record(
        id_meniu meniuri.id_meniu%TYPE,
        denumire_meniu meniuri.denumire%TYPE,
        pret_meniu meniuri.pret%TYPE
    );
type rec_produse is record(
        id_produs produse.id_produs%TYPE,
        denumire_produs produse.denumire%TYPE,
        pret_produs produse.pret%TYPE
    );
    TYPE v_men IS VARRAY(50) OF rec_meniuri;
    TYPE v_prod IS TABLE OF rec_produse;
    TYPE v_prod_men IS TABLE OF v_prod INDEX BY PLS_INTEGER;
    
    v_meniu v_men;
    v_produse_ale_meniului v_prod_men;
    pret_total_produse produse.pret%TYPE;
BEGIN
    SELECT id_meniu,denumire,pret
    BULK COLLECT INTO v_meniu
    FROM meniuri;
    
    FOR i in 1..v_meniu.count LOOP
   
        SELECT produse.id_produs,produse.denumire,produse.pret
        BULK COLLECT INTO v_produse_ale_meniului(i)
        FROM produse
        JOIN meniuri_contin_produse on meniuri_contin_produse.id_produs=produse.id_produs
        WHERE id_meniu = v_meniu(i).id_meniu;
           
   END LOOP; 
   FOR i in 1..v_meniu.count LOOP
        DBMS_OUTPUT.PUT_LINE('Meniu: ' || v_meniu(i).denumire_meniu || ' | Pret: ' || v_meniu(i).pret_meniu);
        pret_total_produse:=0;
        IF V_PRODUSE_ALE_MENIULUI(I).count>0 THEN
        DBMS_OUTPUT.PUT_LINE('Produse care alcatuiesc meniul:');
        FOR j in 1..v_produse_ale_meniului(i).count loop
            pret_total_produse:=pret_total_produse+v_produse_ale_meniului(i)(j).pret_produs;
            DBMS_OUTPUT.PUT_LINE(v_produse_ale_meniului(i)(j).denumire_produs || ' | Pret produs: ' || v_produse_ale_meniului(i)(j).pret_produs);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Prin alegerea meniului, economisesti ' || (100-ROUND((v_meniu(i).pret_meniu/pret_total_produse)*100,2)) ||  ' % (' || (ROUND((pret_total_produse-v_meniu(i).pret_meniu),2)) || ' Euro) ') ;
        ELSE
        DBMS_OUTPUT.PUT_LINE('Meniul specificat nu are produse specificate in baza de date');
        END IF;
    DBMS_OUTPUT.PUT_LINE('============================');
    END LOOP;    
END afisare_meniuri;
/

    

--7. 2 CURSORI DIFERITI, primul implicit-> apare in LMD (UPDATE/INSERT/DELETE), al doilea explicit DIN CARE UNUL PARAMETRIZAT, DEPENDENT DE PRIMUL cu SUBPROGRAM STOCAT INDEPENDENT (functie/procedura)

CREATE OR REPLACE PROCEDURE actualizare_comanda IS

cursor c_comenzi IS 
select id_comanda,nume||' '||prenume,id_cupon,denumire,pret_total,puncte_totale,data_plasarii
from clienti 
join comenzi using (id_client) 
join locatii using (id_locatie)
order by id_comanda;

cid comenzi.id_comanda%TYPE;
nclient clienti.nume%TYPE;
ldenumire locatii.denumire%TYPE;
cpret comenzi.pret_total%TYPE;
cpuncte comenzi.puncte_totale%TYPE;
v_data comenzi.data_plasarii%TYPE;
suma NUMBER(10,2):=0;
suma_puncte NUMBER(10,2):=0;
cupon cupoane.cod_cupon%TYPE;
reducere cupoane.procent%TYPE;
nume_cat categorii.denumire%TYPE;
id_cat categorii.id_categorie%TYPE;
pid_cat categorii.id_Categorie%TYPE;
mid_cat categorii.id_Categorie%TYPE;
v_inc cupoane.data_inceput%TYPE;
v_exp cupoane.data_expirare%TYPE;
cursor c_puncte(cid comenzi.id_comanda%TYPE) IS 
SELECT denumire,nr_puncte
from recompense 
join comenzi_contin_recompense using (id_recompensa)
join comenzi using (id_comanda)
where id_comanda=cid;

cursor c_produse(cid comenzi.id_comanda%TYPE) IS
SELECT produse.denumire,pret,nr_produse,id_categorie
from categorii left join produse using (id_categorie)
join comenzi_contin_produse using (id_produs)
where id_Comanda=cid;

cursor c_meniuri(cid comenzi.id_comanda%TYPE) IS
SELECT meniuri.denumire,pret,cantitate
from meniuri 
join comenzi_contin_meniuri using (id_meniu)
where id_Comanda=cid;

BEGIN
OPEN C_COMENZI;
LOOP
    suma:=0;
    suma_puncte:=0;
    cupon:=null;
    reducere:=0;
     pid_cat:=null;
     mid_cat:=0;
    FETCH C_COMENZI INTO cid,nclient,cupon,ldenumire,cpret,cpuncte,v_data;
    EXIT WHEN C_COMENZI%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('Comanda ' || cid || ' realizata de ' || nclient || ' la locatia ' || ldenumire);
    
    IF CUPON IS NOT NULL THEN 
        SELECT procent, denumire,id_categorie,data_inceput,data_expirare
        into reducere, nume_cat,id_cat,v_inc,v_exp
        from cupoane join categorii using (id_categorie)
        where cod_cupon=cupon;
    if v_inc<=v_data AND v_data<=v_exp THEN
        DBMS_OUTPUT.PUT_LINE('Cuponul '|| cupon || ' este expirat!');
        reducere:=0;
    else
        DBMS_OUTPUT.PUT_LINE('Comanda contine cuponul ' || cupon || ' care ofera ' || reducere || '% reducere la produsele si meniurile din categoria ' || nume_cat);
    end if;
    END IF;
    
    if cpret=0 THEN 
    DBMS_OUTPUT.PUT_LINE('Comanda nu are pretul initializat, il initializam, daca e cazul!');
    FOR i IN c_produse(cid) LOOP
        DBMS_OUTPUT.PUT_LINE('Produsul ' || i.denumire || ' cu pretul ' || i.pret || ' a fost adaugat in costul comenzii!');
        if id_cat=i.id_categorie and id_cat is not null then
        DBMS_OUTPUT.PUT_LINE('Cuponul ' || cupon || ' a fost folosit cu success pentru produsul ' || i.denumire || '!');
            suma:=suma+i.pret*i.nr_produse*(100-reducere)/100;
        else
            suma:=suma+i.pret*i.nr_produse;
        end if;
    end loop;
    FOR j IN c_meniuri(cid) LOOP
   
        if id_cat is not null THEN
            select count(id_categorie) into mid_cat from meniuri join meniuri_au_categorii using (id_meniu) join categorii using (id_categorie) where id_categorie=id_cat and meniuri.denumire=j.denumire;
            end if;
        if mid_cat>0 THEN
            DBMS_OUTPUT.PUT_LINE('Cuponul ' || cupon || ' a fost folosit cu success pentru meniul ' || j.denumire || '!');
            suma:=suma+j.pret*j.cantitate*(100-reducere)/100;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Meniul ' || j.denumire || ' cu pretul ' || j.pret || ' a fost adaugat in costul comenzii!');
            suma:=suma+j.pret;
        end if;
    END LOOP;
    END IF;
    if cpuncte=0 THEN
    DBMS_OUTPUT.PUT_LINE('Comanda nu are punctele initializate, le initializam, daca e cazul!');
    FOR k IN c_puncte(cid) LOOP
        DBMS_OUTPUT.PUT_LINE('Recompensa ' || k.denumire || ' de ' || k.nr_puncte || ' puncte a fost adaugat in punctele folosite in efectuarea comenzii!');
        suma_puncte:=suma_puncte+k.nr_puncte;
    end loop;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Comenzii i-au fost adaugati ' || suma || ' euro si ' || suma_puncte || ' puncte');
    DBMS_OUTPUT.PUT_LINE('==================================================================');
    update comenzi set pret_total=suma,puncte_totale=suma_puncte where id_comanda=cid;
END LOOP;
END;
/

--8. in o singura comanda SQL folosim 3 tabele (probabil joinuri) cu minim 2 exceptii definite cu functie

CREATE OR REPLACE FUNCTION cantitate_meniu(id_m meniuri.id_meniu%TYPE) 
RETURN meniuri.cantitate_totala%TYPE
IS
cant meniuri.cantitate_totala%TYPE;
begin
select sum(cantitate) 
into cant
from meniuri_contin_produse join produse using (id_produs)
join nutritie using (id_produs)
where id_meniu=id_m;
return cant;
end;
/

create or replace procedure update_meniuri as
cursor c is select id_meniu from meniuri;
id_m meniuri.id_meniu%TYPE;
begin
    open c;
    loop
        fetch c into id_m;
        exit when c%NOTFOUND;
        update meniuri
        set cantitate_totala=cantitate_meniu(id_m) where id_meniu=id_m;
    end loop;
end;
/

--9. in o singura comanda SQL folosim 5 tabele (probabil joinuri) cu toate exceptiile default inclusiv no_data_found si too_many_rows cu procedura

CREATE OR REPLACE PROCEDURE top_meniu(id_c clienti.id_client%TYPE)
IS
nume_c VARCHAR(100);
email_c clienti.email%TYPE;
nume_locatie locatii.denumire%TYPE;
id_loc locatii.id_locatie%TYPE;
v_id_men meniuri.id_meniu%TYPE;
v_den_men meniuri.denumire%TYPE;
v_nr_men INT;
v_calorii NUMBER(10,2);
cursor c_locatii is select denumire,id_locatie from locatii;
exceptie_nutritie EXCEPTION;
BEGIN
    select nume||' '||prenume,email
    into nume_c,email_c
    from clienti
    where id_client=id_c;
    OPEN C_LOCATII;
    --EXTRAGE INFORMATIILE USERULUI
    LOOP
        --EXTRAGE INFORMATIILE LOCATIEI, A TREBUIT DECLARAT UN BLOC NOU PT CA EXCEPTIILE APAR INAINTE DE END
        BEGIN
        fetch c_locatii into nume_locatie,id_loc;
        exit when c_locatii%NOTFOUND;
        
        --PENTRU FIECARE CLIENT SI LOCATIE, LUAM MENIUL CEL MAI COMANDAT DUPA CANTITATE SI RETINEM PT ACESTA DENUMIREA, CANTITATEA, CALORIILE
        --DACA NU ARE PARTEA DE NUTRITIE SAU PRODUSE DECLARATE IN MENIUL RESPECTIV, ENTRY-URILE PENTRU PRODUSE VOR FI NULL PENTRU FIECARE COMANDA CARE LE CONTINE
        --DECI COUNT VA FI 0, FOLOSIM REPLACE PENTRU A FUNCTIONA IMPARTIREA
        
        select id_meniu, m.denumire, sum(cm.cantitate)/replace(count(id_produs),0,1),sum(n.calorii/100*p.cantitate)
        into v_id_men,v_den_men,v_nr_men,v_calorii
        FROM COMENZI CO
        JOIN COMENZI_CONTIN_MENIURI CM USING (ID_COMANDA)
        JOIN MENIURI M USING (ID_MENIU)
        LEFT JOIN MENIURI_CONTIN_PRODUSE MP USING (ID_MENIU)
        LEFT JOIN PRODUSE P USING (ID_PRODUS) 
        LEFT JOIN NUTRITIE N USING (ID_PRODUS)
        WHERE ID_CLIENT=ID_C AND ID_LOCATIE=ID_LOC
        HAVING SUM(CM.CANTITATE)/replace(count(id_produs),0,1)>=ALL
        (SELECT SUM(CM2.CANTITATE)
        FROM COMENZI_CONTIN_MENIURI CM2,COMENZI CO2
        WHERE CM2.ID_COMANDA=CO2.ID_COMANDA AND CO2.ID_CLIENT=co.id_client AND CO2.ID_LOCATIE=co.id_locatie
        GROUP BY CO2.ID_CLIENT,co2.id_locatie,CM2.ID_MENIU)
        group by co.id_client,co.id_locatie,id_meniu,m.denumire
        order by co.id_client,co.id_locatie;

        
        --EXCEPTIE CUSTOM
        if v_calorii is NULL THEN 
            RAISE exceptie_nutritie;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Clientul '||nume_c||' cu adresa de email '||email_c||' a comandat de '|| v_nr_men || ' ori meniul ' || v_den_men || ' la locatia ' || nume_locatie || ' consumand in total ' || (v_calorii*v_nr_men) || 'kcal!');
         
         --EXCEPTIILE   
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('/!\ Clientul '||nume_c||' cu adresa de email '||email_c||' nu a comandat nimic la locatia '||nume_locatie);
                CONTINUE;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('/!\ Clientul '||nume_c||' cu adresa de email '||email_c||' are mai multe meniuri cu numarul maxim de comenzi la locatia '||nume_locatie);
                CONTINUE;
            WHEN exceptie_nutritie THEN
                DBMS_OUTPUT.PUT_LINE('/!\ Clientul '||nume_c||' cu adresa de email '||email_c||' a comandat de '|| v_nr_men || ' ori meniul ' || v_den_men || ' la locatia ' || nume_locatie || ' care NU are informatii nutritionale!');
                CONTINUE;
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20020,'/!\ Alta eroare s-a intamplat!');
        END;
    END LOOP;
    
END;
/

--10. trigger LMD la nivel de comanda

CREATE OR REPLACE TRIGGER creaza_stoc
AFTER INSERT ON produse
DECLARE
id_max produse.id_produs%TYPE;
cursor c_locatii is select id_locatie from locatii;
id_loc_curenta locatii.id_locatie%TYPE;
BEGIN
SELECT MAX(ID_PRODUS)
into id_max
from produse;
open c_locatii;
LOOP
    FETCH C_LOCATII INTO ID_LOC_CURENTA;
    exit when c_locatii%NOTFOUND;
    insert into stoc_locatii(id_locatie, id_produs, nr_produse) values(id_loc_curenta,id_max,0);
END LOOP;
dbms_output.put_line('Inserat stoc cu success!');
END;
/

--11. trigger LMD la nivel de linie


CREATE OR REPLACE PROCEDURE
modifica_stoc_si_pret_comanda(v_id_m meniuri.id_meniu%TYPE,v_id_c comenzi.id_comanda%TYPE, v_cant comenzi_contin_meniuri.cantitate%TYPE)
IS
pret_meniu meniuri.pret%TYPE;
v_id_loc locatii.id_locatie%TYPE;
v_nr_p stoc_locatii.nr_produse%TYPE;
produs_curent produse.id_produs%TYPE;
v_cupon cupoane.cod_cupon%TYPE;
v_procent cupoane.procent%TYPE;
v_inc cupoane.data_inceput%TYPE;
v_exp cupoane.data_inceput%TYPE;
v_data comenzi.data_plasarii%TYPE;
vandut INT;
cursor cursor_meniu is
select id_produs
from meniuri_contin_produse
where id_meniu=v_id_m;
BEGIN
    --RETINEM LOCATIA SI CUPONUL FOLOSIT PENTRU COMANDA (pentru eventuala modificare a costului produselor)
    select id_locatie,id_cupon,data_plasarii into v_id_loc,v_cupon,v_data
    from comenzi
    where id_comanda=v_id_c;
    --VERIFICA DACA MENIUL ESTE VANDUT DE MAGAZIN
    select count(*) into vandut
    from locatii_ofera_meniuri
    where id_locatie=v_id_loc and id_meniu=v_id_m;
    if vandut=0 THEN
        RAISE_APPLICATION_ERROR(-20000,'Nu puteti comanda un articol care nu este vandut de locatie');
    end if;
    OPEN cursor_meniu;
    --LOOP PENTRU VERIFICARE STOC
    LOOP
        FETCH cursor_meniu into produs_curent;
        EXIT WHEN cursor_meniu%notfound;
        select nr_produse into v_nr_p
        from stoc_locatii
        where id_locatie=v_id_loc and id_produs=produs_curent;
        IF v_nr_p+v_cant<0 THEN
            RAISE_APPLICATION_ERROR(-20000,'Nu puteti adauga mai multe produse in comanda decat sunt in stoc in locatie');
        END IF;
    END LOOP;
    CLOSE cursor_meniu;
    --LOOP PENTRU ADAUGARE STOC, DACA NU DA EROARE
    OPEN cursor_meniu;
    LOOP
        FETCH cursor_meniu into produs_curent;
        EXIT WHEN cursor_meniu%notfound;
        UPDATE STOC_LOCATII
        SET NR_PRODUSE=nr_produse+v_cant
        where id_locatie=v_id_loc and id_produs=produs_curent;
    END LOOP;
    CLOSE cursor_meniu;
    -- ACTUALIZAM PRETUL COMENZII
    SELECT pret into pret_meniu
    FROM MENIURI
    WHERE id_meniu=v_id_m;
    --VERIFICAM DACA COMANDA AVEA CUPON VALID DIN SELECTUL ANTERIOR
END;
/

CREATE OR REPLACE TRIGGER MENIURI_IN_COMENZI
BEFORE INSERT OR UPDATE OR DELETE ON COMENZI_CONTIN_MENIURI
FOR EACH ROW
BEGIN
    IF DELETING THEN
        modifica_stoc_si_pret_comanda(:OLD.id_meniu,:OLD.id_comanda,:OLD.CANTITATE);
    ELSIF UPDATING THEN
        IF :NEW.ID_MENIU<>:OLD.ID_MENIU OR :NEW.ID_COMANDA<>:OLD.ID_COMANDA THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nu puteti modifica decat cantitatea produsului!');
        ELSE modifica_stoc_si_pret_comanda(:NEW.id_meniu,:NEW.id_comanda,:NEW.CANTITATE-:OLD.CANTITATE);
        END IF;
    ELSE modifica_stoc_si_pret_comanda(:NEW.id_meniu,:NEW.id_comanda,-:NEW.CANTITATE);
    END IF;
END;
/

--12. trigger LDD
--inspirat din curs
CREATE TABLE audit_utilizator
(
    user_logat VARCHAR2(30), 
    eveniment VARCHAR2(20), 
    tip_obiect_referit VARCHAR2(30), 
    nume_obiect_referit VARCHAR2(30), 
    data_actiunii TIMESTAMP(3),
    permis VARCHAR2(6)
); 
 
CREATE OR REPLACE TRIGGER audit_schema 
AFTER CREATE OR DROP OR ALTER ON SCHEMA
DECLARE
permis VARCHAR2(6):='TRUE';
BEGIN 
    IF TO_NUMBER(TO_CHAR(SYSDATE, 'D')) IN (1,7) OR TO_NUMBER(TO_CHAR(SYSDATE, 'hh24')) NOT BETWEEN 8 AND 18 THEN
    permis:='FALSE';
    IF UPPER(SYS.LOGIN_USER)<>'PROIECT_NOU' THEN
        RAISE_APPLICATION_ERROR(-20005,'Nu ai voie sa modifici baza de date in afara programului de munca!');
    END IF;
    END IF;
END; 
/ 

CREATE OR REPLACE PACKAGE pachet_ex13 IS 
   PROCEDURE afisare_meniuri;
PROCEDURE actualizare_comanda;
procedure update_meniuri;
PROCEDURE top_meniu(id_c clienti.id_client%TYPE);
PROCEDURE modifica_stoc_si_pret_comanda(v_id_m meniuri.id_meniu%TYPE,v_id_c comenzi.id_comanda%TYPE, v_cant comenzi_contin_meniuri.cantitate%TYPE);
FUNCTION cantitate_meniu(id_m meniuri.id_meniu%TYPE) RETURN meniuri.cantitate_totala%TYPE;
END; 
/

CREATE OR REPLACE PACKAGE BODY pachet_ex13 IS 
PROCEDURE afisare_meniuri
IS
type rec_meniuri is record(
        id_meniu meniuri.id_meniu%TYPE,
        denumire_meniu meniuri.denumire%TYPE,
        pret_meniu meniuri.pret%TYPE
    );
type rec_produse is record(
        id_produs produse.id_produs%TYPE,
        denumire_produs produse.denumire%TYPE,
        pret_produs produse.pret%TYPE
    );
    TYPE v_men IS VARRAY(50) OF rec_meniuri;
    TYPE v_prod IS TABLE OF rec_produse;
    TYPE v_prod_men IS TABLE OF v_prod INDEX BY PLS_INTEGER;

    v_meniu v_men;
    v_produse_ale_meniului v_prod_men;
    pret_total_produse produse.pret%TYPE;
BEGIN
    SELECT id_meniu,denumire,pret
    BULK COLLECT INTO v_meniu
    FROM meniuri;

    FOR i in 1..v_meniu.count LOOP

        SELECT produse.id_produs,produse.denumire,produse.pret
        BULK COLLECT INTO v_produse_ale_meniului(i)
        FROM produse
        JOIN meniuri_contin_produse on meniuri_contin_produse.id_produs=produse.id_produs
        WHERE id_meniu = v_meniu(i).id_meniu;

   END LOOP; 
   FOR i in 1..v_meniu.count LOOP
        DBMS_OUTPUT.PUT_LINE('Meniu: ' || v_meniu(i).denumire_meniu || ' | Pret: ' || v_meniu(i).pret_meniu);
        pret_total_produse:=0;
        IF V_PRODUSE_ALE_MENIULUI(I).count>0 THEN
        DBMS_OUTPUT.PUT_LINE('Produse care alcatuiesc meniul:');
        FOR j in 1..v_produse_ale_meniului(i).count loop
            pret_total_produse:=pret_total_produse+v_produse_ale_meniului(i)(j).pret_produs;
            DBMS_OUTPUT.PUT_LINE(v_produse_ale_meniului(i)(j).denumire_produs || ' | Pret produs: ' || v_produse_ale_meniului(i)(j).pret_produs);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Prin alegerea meniului, economisesti ' || (100-ROUND((v_meniu(i).pret_meniu/pret_total_produse)*100,2)) ||  ' % (' || (ROUND((pret_total_produse-v_meniu(i).pret_meniu),2)) || ' Euro) ') ;
        ELSE
        DBMS_OUTPUT.PUT_LINE('Meniul specificat nu are produse specificate in baza de date');
        END IF;
    DBMS_OUTPUT.PUT_LINE('============================');
    END LOOP;    
END afisare_meniuri;


PROCEDURE actualizare_comanda IS

cursor c_comenzi IS 
select id_comanda,nume||' '||prenume,id_cupon,denumire,pret_total,puncte_totale,data_plasarii
from clienti 
join comenzi using (id_client) 
join locatii using (id_locatie)
order by id_comanda;

cid comenzi.id_comanda%TYPE;
nclient clienti.nume%TYPE;
ldenumire locatii.denumire%TYPE;
cpret comenzi.pret_total%TYPE;
cpuncte comenzi.puncte_totale%TYPE;
v_data comenzi.data_plasarii%TYPE;
suma NUMBER(10,2):=0;
suma_puncte NUMBER(10,2):=0;
cupon cupoane.cod_cupon%TYPE;
reducere cupoane.procent%TYPE;
nume_cat categorii.denumire%TYPE;
id_cat categorii.id_categorie%TYPE;
pid_cat categorii.id_Categorie%TYPE;
mid_cat categorii.id_Categorie%TYPE;
v_inc cupoane.data_inceput%TYPE;
v_exp cupoane.data_expirare%TYPE;
cursor c_puncte(cid comenzi.id_comanda%TYPE) IS 
SELECT denumire,nr_puncte
from recompense 
join comenzi_contin_recompense using (id_recompensa)
join comenzi using (id_comanda)
where id_comanda=cid;

cursor c_produse(cid comenzi.id_comanda%TYPE) IS
SELECT produse.denumire,pret,nr_produse,id_categorie
from categorii left join produse using (id_categorie)
join comenzi_contin_produse using (id_produs)
where id_Comanda=cid;

cursor c_meniuri(cid comenzi.id_comanda%TYPE) IS
SELECT meniuri.denumire,pret,cantitate
from meniuri 
join comenzi_contin_meniuri using (id_meniu)
where id_Comanda=cid;

BEGIN
OPEN C_COMENZI;
LOOP
    suma:=0;
    suma_puncte:=0;
    cupon:=null;
    reducere:=0;
     pid_cat:=null;
     mid_cat:=0;
    FETCH C_COMENZI INTO cid,nclient,cupon,ldenumire,cpret,cpuncte,v_data;
    EXIT WHEN C_COMENZI%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Comanda ' || cid || ' realizata de ' || nclient || ' la locatia ' || ldenumire);

    IF CUPON IS NOT NULL THEN 
        SELECT procent, denumire,id_categorie,data_inceput,data_expirare
        into reducere, nume_cat,id_cat,v_inc,v_exp
        from cupoane join categorii using (id_categorie)
        where cod_cupon=cupon;
    if v_inc<=v_data AND v_data<=v_exp THEN
        DBMS_OUTPUT.PUT_LINE('Cuponul '|| cupon || ' este expirat!');
        reducere:=0;
    else
        DBMS_OUTPUT.PUT_LINE('Comanda contine cuponul ' || cupon || ' care ofera ' || reducere || '% reducere la produsele si meniurile din categoria ' || nume_cat);
    end if;
    END IF;

    if cpret=0 THEN 
    DBMS_OUTPUT.PUT_LINE('Comanda nu are pretul initializat, il initializam, daca e cazul!');
    FOR i IN c_produse(cid) LOOP
        DBMS_OUTPUT.PUT_LINE('Produsul ' || i.denumire || ' cu pretul ' || i.pret || ' a fost adaugat in costul comenzii!');
        if id_cat=i.id_categorie and id_cat is not null then
        DBMS_OUTPUT.PUT_LINE('Cuponul ' || cupon || ' a fost folosit cu success pentru produsul ' || i.denumire || '!');
            suma:=suma+i.pret*i.nr_produse*(100-reducere)/100;
        else
            suma:=suma+i.pret*i.nr_produse;
        end if;
    end loop;
    FOR j IN c_meniuri(cid) LOOP

        if id_cat is not null THEN
            select count(id_categorie) into mid_cat from meniuri join meniuri_au_categorii using (id_meniu) join categorii using (id_categorie) where id_categorie=id_cat and meniuri.denumire=j.denumire;
            end if;
        if mid_cat>0 THEN
            DBMS_OUTPUT.PUT_LINE('Cuponul ' || cupon || ' a fost folosit cu success pentru meniul ' || j.denumire || '!');
            suma:=suma+j.pret*j.cantitate*(100-reducere)/100;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Meniul ' || j.denumire || ' cu pretul ' || j.pret || ' a fost adaugat in costul comenzii!');
            suma:=suma+j.pret;
        end if;
    END LOOP;
    END IF;
    if cpuncte=0 THEN
    DBMS_OUTPUT.PUT_LINE('Comanda nu are punctele initializate, le initializam, daca e cazul!');
    FOR k IN c_puncte(cid) LOOP
        DBMS_OUTPUT.PUT_LINE('Recompensa ' || k.denumire || ' de ' || k.nr_puncte || ' puncte a fost adaugat in punctele folosite in efectuarea comenzii!');
        suma_puncte:=suma_puncte+k.nr_puncte;
    end loop;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Comenzii i-au fost adaugati ' || suma || ' euro si ' || suma_puncte || ' puncte');
    DBMS_OUTPUT.PUT_LINE('==================================================================');
    update comenzi set pret_total=suma,puncte_totale=suma_puncte where id_comanda=cid;
END LOOP;
END actualizare_comanda;


procedure update_meniuri as
cursor c is select id_meniu from meniuri;
id_m meniuri.id_meniu%TYPE;
begin
    open c;
    loop
        fetch c into id_m;
        exit when c%NOTFOUND;
        update meniuri
        set cantitate_totala=cantitate_meniu(id_m) where id_meniu=id_m;
    end loop;
end update_meniuri;

PROCEDURE top_meniu(id_c clienti.id_client%TYPE)
IS
nume_c VARCHAR(100);
email_c clienti.email%TYPE;
nume_locatie locatii.denumire%TYPE;
id_loc locatii.id_locatie%TYPE;
v_id_men meniuri.id_meniu%TYPE;
v_den_men meniuri.denumire%TYPE;
v_nr_men INT;
v_calorii NUMBER(10,2);
cursor c_locatii is select denumire,id_locatie from locatii;
exceptie_nutritie EXCEPTION;
BEGIN
    select nume||' '||prenume,email
    into nume_c,email_c
    from clienti
    where id_client=id_c;
    OPEN C_LOCATII;
    --EXTRAGE INFORMATIILE USERULUI
    LOOP
        --EXTRAGE INFORMATIILE LOCATIEI, A TREBUIT DECLARAT UN BLOC NOU PT CA EXCEPTIILE APAR INAINTE DE END
        BEGIN
        fetch c_locatii into nume_locatie,id_loc;
        exit when c_locatii%NOTFOUND;

        --PENTRU FIECARE CLIENT SI LOCATIE, LUAM MENIUL CEL MAI COMANDAT DUPA CANTITATE SI RETINEM PT ACESTA DENUMIREA, CANTITATEA, CALORIILE
        --DACA NU ARE PARTEA DE NUTRITIE SAU PRODUSE DECLARATE IN MENIUL RESPECTIV, ENTRY-URILE PENTRU PRODUSE VOR FI NULL PENTRU FIECARE COMANDA CARE LE CONTINE
        --DECI COUNT VA FI 0, FOLOSIM REPLACE PENTRU A FUNCTIONA IMPARTIREA

        select id_meniu, m.denumire, sum(cm.cantitate)/replace(count(id_produs),0,1),sum(n.calorii/100*p.cantitate)
        into v_id_men,v_den_men,v_nr_men,v_calorii
        FROM COMENZI CO
        JOIN COMENZI_CONTIN_MENIURI CM USING (ID_COMANDA)
        JOIN MENIURI M USING (ID_MENIU)
        LEFT JOIN MENIURI_CONTIN_PRODUSE MP USING (ID_MENIU)
        LEFT JOIN PRODUSE P USING (ID_PRODUS) 
        LEFT JOIN NUTRITIE N USING (ID_PRODUS)
        WHERE ID_CLIENT=ID_C AND ID_LOCATIE=ID_LOC
        HAVING SUM(CM.CANTITATE)/replace(count(id_produs),0,1)>=ALL
        (SELECT SUM(CM2.CANTITATE)
        FROM COMENZI_CONTIN_MENIURI CM2,COMENZI CO2
        WHERE CM2.ID_COMANDA=CO2.ID_COMANDA AND CO2.ID_CLIENT=co.id_client AND CO2.ID_LOCATIE=co.id_locatie
        GROUP BY CO2.ID_CLIENT,co2.id_locatie,CM2.ID_MENIU)
        group by co.id_client,co.id_locatie,id_meniu,m.denumire
        order by co.id_client,co.id_locatie;


        --EXCEPTIE CUSTOM
        if v_calorii is NULL THEN 
            RAISE exceptie_nutritie;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Clientul '||nume_c||' cu adresa de email '||email_c||' a comandat de '|| v_nr_men || ' ori meniul ' || v_den_men || ' la locatia ' || nume_locatie || ' consumand in total ' || (v_calorii*v_nr_men) || 'kcal!');

         --EXCEPTIILE   
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('/!\ Clientul '||nume_c||' cu adresa de email '||email_c||' nu a comandat nimic la locatia '||nume_locatie);
                CONTINUE;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('/!\ Clientul '||nume_c||' cu adresa de email '||email_c||' are mai multe meniuri cu numarul maxim de comenzi la locatia '||nume_locatie);
                CONTINUE;
            WHEN exceptie_nutritie THEN
                DBMS_OUTPUT.PUT_LINE('/!\ Clientul '||nume_c||' cu adresa de email '||email_c||' a comandat de '|| v_nr_men || ' ori meniul ' || v_den_men || ' la locatia ' || nume_locatie || ' care NU are informatii nutritionale!');
                CONTINUE;
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20020,'/!\ Alta eroare s-a intamplat!');
        END;
    END LOOP;

END top_meniu;


PROCEDURE
modifica_stoc_si_pret_comanda(v_id_m meniuri.id_meniu%TYPE,v_id_c comenzi.id_comanda%TYPE, v_cant comenzi_contin_meniuri.cantitate%TYPE)
IS
pret_meniu meniuri.pret%TYPE;
v_id_loc locatii.id_locatie%TYPE;
v_nr_p stoc_locatii.nr_produse%TYPE;
produs_curent produse.id_produs%TYPE;
v_cupon cupoane.cod_cupon%TYPE;
v_procent cupoane.procent%TYPE;
v_inc cupoane.data_inceput%TYPE;
v_exp cupoane.data_inceput%TYPE;
v_data comenzi.data_plasarii%TYPE;
vandut INT;
cursor cursor_meniu is
select id_produs
from meniuri_contin_produse
where id_meniu=v_id_m;
BEGIN
    --RETINEM LOCATIA SI CUPONUL FOLOSIT PENTRU COMANDA (pentru eventuala modificare a costului produselor)
    select id_locatie,id_cupon,data_plasarii into v_id_loc,v_cupon,v_data
    from comenzi
    where id_comanda=v_id_c;
    --VERIFICA DACA MENIUL ESTE VANDUT DE MAGAZIN
    select count(*) into vandut
    from locatii_ofera_meniuri
    where id_locatie=v_id_loc and id_meniu=v_id_m;
    if vandut=0 THEN
        RAISE_APPLICATION_ERROR(-20000,'Nu puteti comanda un articol care nu este vandut de locatie');
    end if;
    OPEN cursor_meniu;
    --LOOP PENTRU VERIFICARE STOC
    LOOP
        FETCH cursor_meniu into produs_curent;
        EXIT WHEN cursor_meniu%notfound;
        select nr_produse into v_nr_p
        from stoc_locatii
        where id_locatie=v_id_loc and id_produs=produs_curent;
        IF v_nr_p+v_cant<0 THEN
            RAISE_APPLICATION_ERROR(-20000,'Nu puteti adauga mai multe produse in comanda decat sunt in stoc in locatie');
        END IF;
    END LOOP;
    CLOSE cursor_meniu;
    --LOOP PENTRU ADAUGARE STOC, DACA NU DA EROARE
    OPEN cursor_meniu;
    LOOP
        FETCH cursor_meniu into produs_curent;
        EXIT WHEN cursor_meniu%notfound;
        UPDATE STOC_LOCATII
        SET NR_PRODUSE=nr_produse+v_cant
        where id_locatie=v_id_loc and id_produs=produs_curent;
    END LOOP;
    CLOSE cursor_meniu;
    -- ACTUALIZAM PRETUL COMENZII
    SELECT pret into pret_meniu
    FROM MENIURI
    WHERE id_meniu=v_id_m;
    --VERIFICAM DACA COMANDA AVEA CUPON VALID DIN SELECTUL ANTERIOR
END modifica_stoc_si_pret_comanda;

FUNCTION cantitate_meniu(id_m meniuri.id_meniu%TYPE) 
RETURN meniuri.cantitate_totala%TYPE
IS
cant meniuri.cantitate_totala%TYPE;
begin
select sum(cantitate) 
into cant
from meniuri_contin_produse join produse using (id_produs)
join nutritie using (id_produs)
where id_meniu=id_m;
return cant;
end cantitate_meniu;

END;
/

execute pachet_ex13.top_meniu(1);