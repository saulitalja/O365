sudo apt install postgresql postgresql-contrib -y
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo -i -u postgres
psql -U sauli -d testdb -h localhost

export PGPASSWORD='salasana123'
psql -U sauli -d testdb -h localhost -c "SELECT * FROM kirja;"


CREATE TABLE Opiskelija (
opiskelijanro integer not null,
etunimi character varying(32) not null,
sukunimi character varying(60) not null,
osoite character varying(100),
puhnro character varying(15),
PRIMARY KEY("opiskelijanro"));

CREATE TABLE Kurssi (
kurssinro integer not null primary key,
nimi character varying(32) not null,
alkamispvm date);

CREATE TABLE Suoritus (
opiskelijanro integer not null,
kurssinro integer not null,
arvosana integer not null,
PRIMARY KEY("opiskelijanro", "kurssinro"),
FOREIGN KEY("opiskelijanro") REFERENCES "opiskelija"("opiskelijanro"),
FOREIGN KEY("kurssinro") REFERENCES "kurssi"("kurssinro"));

DROP TABLE Kurssi;

CREATE TABLE Kurssi (
kurssinro integer not null primary key,
nimi character varying(32) not null,
alkamispvm date,
vastuuhenkilo     character varying(32)
);

ALTER TABLE Kurssi DROP COLUMN vastuuhenkilo;

ALTER TABLE Kurssi add COLUMN vastuuhenkilo character varying(32) default 'ei vastuuhenkilöä';

alter table kurssi add column aktiivinen boolean;


INSERT INTO Opiskelija (opiskelijanro, etunimi, sukunimi, osoite, puhnro)
VALUES (1, 'Risto', 'Reipas', 'Lehmustie 10 E 4, 53850, Loviisa', NULL);

INSERT INTO kurssi (kurssinro,nimi,alkamispvm,aktiivinen) VALUES (1021, 'Tietokantojen perusteet',
'2008-01-15', True);

UPDATE kurssi SET vastuuhenkilo = 'Saarinen Risto', alkamispvm = '2008-01-16' WHERE kurssinro = 1021;

DELETE FROM kurssi WHERE kurssinro =1010;

CREATE TABLE Opiskelija (
opiskelijanro SERIAL,
etunimi character varying(32) not null,
sukunimi character varying(60) not null,
osoite character varying(100),
puhnro character varying(15));

INSERT INTO opiskelija (etunimi,sukunimi,osoite,puhnro) VALUES ('Maija', 'Mattila', 'Kirkkonummi', '050 123456');
INSERT INTO opiskelija (etunimi,sukunimi,osoite,puhnro) VALUES ('Matti', 'Mattila', 'Kirkkonummi', '050 123456');
INSERT INTO opiskelija (etunimi,sukunimi,osoite,puhnro) VALUES ('Kalle', 'Mattila', 'Kirkkonummi', '050 123456');

Select * from opiskelija;




CREATE TABLE kirja (
    kirjaid        INTEGER PRIMARY KEY,
    nimi           VARCHAR(32) NOT NULL,
    tekijaid       INTEGER,
    kustantajaid   INTEGER,
    sivuja         INTEGER,
    hinta          DOUBLE PRECISION,
    julkaisupvm    DATE,
    FOREIGN KEY (tekijaid) REFERENCES kirjailija (tekijaid),
    FOREIGN KEY (kustantajaid) REFERENCES kustantaja (kustantajaid)
);

CREATE TABLE kirjailija (
    tekijaid   INTEGER PRIMARY KEY,
    sukunimi   VARCHAR(32) NOT NULL,
    etunimi    VARCHAR(32) NOT NULL
);

CREATE TABLE kustantaja (
    kustantajaid  INTEGER PRIMARY KEY,
    nimi          VARCHAR(32) NOT NULL,
    osoite        VARCHAR(32),
    postinro      VARCHAR(32),
    toimipaikka   VARCHAR(32)
);

CREATE TABLE varasto (
    varastoid   INTEGER PRIMARY KEY,
    kirjaid     INTEGER,
    lukumaara   INTEGER NOT NULL,
    FOREIGN KEY (kirjaid) REFERENCES kirja (kirjaid)
);

INSERT INTO kustantaja (kustantajaid, nimi, osoite, postinro, toimipaikka) VALUES
(1, 'Otava', 'Uudenmaankatu 10', '00120', 'Helsinki'),
(2, 'WSOY', 'Bulevardi 12', '00120', 'Helsinki'),
(3, 'Tammi', 'Keskuskatu 5', '00100', 'Helsinki');

INSERT INTO kirjailija (tekijaid, sukunimi, etunimi) VALUES
(1, 'Linnankoski', 'Johannes'),
(2, 'Hotakainen', 'Kari'),
(3, 'Jansson', 'Tove');

INSERT INTO kirja (kirjaid, nimi, tekijaid, kustantajaid, sivuja, hinta, julkaisupvm) VALUES
(100, 'Työmiehen vaimo', 1, 1, 250, 24.90, '2020-05-01'),
(101, 'Ihmisen osa', 2, 2, 320, 29.90, '2015-09-10'),
(102, 'Muumipappa ja meri', 3, 3, 190, 19.90, '2008-03-15');


INSERT INTO varasto (varastoid, kirjaid, lukumaara) VALUES
(1, 100, 12),
(2, 101, 7),
(3, 102, 15);


CREATE TABLE AUTHOR (
    authorid INTEGER PRIMARY KEY NOT NULL,
    surname  VARCHAR(32) NOT NULL,
    forename VARCHAR(32) NOT NULL
);

CREATE TABLE BOOK (
    bookid       INTEGER PRIMARY KEY NOT NULL,
    title        VARCHAR(48) NOT NULL,
    authorid     INTEGER,
    publisherid  INTEGER,
    pages        INTEGER,
    price        DOUBLE PRECISION,
    published    DATE,
    FOREIGN KEY (authorid) REFERENCES AUTHOR(authorid),
    FOREIGN KEY (publisherid) REFERENCES PUBLISHER(publisherid)
);

CREATE TABLE PUBLISHER (
    publisherid INTEGER PRIMARY KEY NOT NULL,
    name        VARCHAR(32) NOT NULL,
    address     VARCHAR(32),
    postcode    VARCHAR(32),
    city        VARCHAR(32)
);

CREATE TABLE STOCK (
    stockid INTEGER PRIMARY KEY NOT NULL,
    bookid  INTEGER,
    instock INTEGER NOT NULL,
    FOREIGN KEY (bookid) REFERENCES BOOK(bookid)
);

INSERT INTO PUBLISHER (publisherid, name, address, postcode, city) VALUES
(301, 'Taylor & Wells', '17 Pine Road', 'SN11017', 'Little Town'),
(302, 'Black Wolf Publishing', '100 A Hillside Way', 'BF10071', 'Dullville'),
(303, 'Info Press', '2 High Street', 'CD05020', 'Forestwood'),
(304, 'Classics4you', '10 Old Road', 'YT98100', 'Creek-on-Trent');

INSERT INTO AUTHOR (authorid, surname, forename) VALUES
(201, 'Savielle', 'Ernesto'),
(202, 'Adams', 'Arthur'),
(203, 'Schmidt', 'Abigale'),
(204, 'Weinstein-Welle', 'Marie'),
(205, 'Nordqvist', 'Arvid'),
(206, 'van Holstein', 'Theodore'),
(207, 'Annett', 'Josephine');

INSERT INTO BOOK (bookid, title, authorid, publisherid, pages, price, published) VALUES
(101, 'Three Bearded Men and the Sea', 202, 304, 333, 21.8, '1983-12-04'),
(102, 'The Ghost of the Moor', 202, 301, 310, 23.1, '1980-12-01'),
(103, 'How Computers Work', 205, 303, 870, 16.8, '1999-03-14'),
(104, 'The Hound and other short stories', 204, 302, 475, 35.5, '2000-01-01'),
(105, 'Let''s Play Poker and Chess!', 201, 303, 125, 10.5, '2006-04-19'),
(106, 'My life as I see it', 204, 301, 782, 55.2, '1990-10-10'),
(107, 'Upside-down and other children''s stories', 204, 301, 245, 20.8, '1970-11-20'),
(108, 'The Winter Everlasting', 204, 301, 1156, 46.8, '1975-12-01'),
(109, 'There and Never Back Again', 206, 302, 370, 29.9, '1998-09-30'),
(110, 'The Crime that never was', 202, 304, 555, 16.4, '2004-03-10'),
(111, 'Learn to Knit', 207, 303, 75, 10.2, '1995-11-02');

INSERT INTO STOCK (stockid, bookid, instock) VALUES
(1001, 101, 175),
(1002, 102, 252),
(1003, 103, 15),
(1004, 104, 244),
(1005, 105, 53),
(1006, 106, 102),
(1007, 107, 10),
(1008, 109, 5),
(1009, 110, 0),
(1010, 111, 34);

CREATE TABLE kirja (
    kirjaid        INTEGER PRIMARY KEY,
    nimi           VARCHAR(32) NOT NULL,
    tekijaid       INTEGER,
    kustantajaid   INTEGER,
    sivuja         INTEGER,
    hinta          DOUBLE PRECISION,
    julkaisupvm    DATE,
    FOREIGN KEY (tekijaid) REFERENCES kirjailija (tekijaid),
    FOREIGN KEY (kustantajaid) REFERENCES kustantaja (kustantajaid)
);

CREATE TABLE kirjailija (
    tekijaid   INTEGER PRIMARY KEY,
    sukunimi   VARCHAR(32) NOT NULL,
    etunimi    VARCHAR(32) NOT NULL
);

CREATE TABLE kustantaja (
    kustantajaid  INTEGER PRIMARY KEY,
    nimi          VARCHAR(32) NOT NULL,
    osoite        VARCHAR(32),
    postinro      VARCHAR(32),
    toimipaikka   VARCHAR(32)
);

CREATE TABLE varasto (
    varastoid   INTEGER PRIMARY KEY,
    kirjaid     INTEGER,
    lukumaara   INTEGER NOT NULL,
    FOREIGN KEY (kirjaid) REFERENCES kirja (kirjaid)
);

INSERT INTO kirjailija (tekijaid, sukunimi, etunimi) VALUES
(201, 'Helkala', 'Maarit'),
(202, 'Hilppala', 'Heikki'),
(203, 'Vilperi', 'Eero'),
(204, 'Turkunen', 'Heikki'),
(205, 'Nyströmberg', 'Kaisa'),
(206, 'Vilperi', 'Aatu');

INSERT INTO kustantaja (kustantajaid, nimi, osoite, postinro, toimipaikka) VALUES
(301, 'Musta Kottarainen', 'Kilpakuja 7', '35700', 'Vilppula'),
(302, 'Stadin teos', 'Päällystie 67 C', '00002', 'Helsinki'),
(303, 'Linnunrata', 'Syrjätie 34', '00210', 'Espoo'),
(304, 'Old Books', 'Vanhatie 21', '05800', 'Hyvinkää');

INSERT INTO kustantaja (kustantajaid, nimi, osoite, postinro, toimipaikka) VALUES (305, 'very Old Books', 'Vanhatie 21', '05800', 'Hyvinkää');



INSERT INTO kirja (kirjaid, nimi, tekijaid, kustantajaid, sivuja, hinta, julkaisupvm) VALUES
(101, 'Kolme vanhaa miestä', 202, 304, 333, 21.8, '2002-12-04'),
(102, 'Ilkka ja koira', 201, 301, 310, 23.1, '1999-12-31'),
(103, 'Poika ja huuhkaja', 201, 301, 232, 16.8, '1996-03-14'),
(104, 'Kevät', 203, 302, 143, 14.5, '2000-01-01'),
(105, 'Seitsemän pelikorttia', 204, 302, 290, 29.8, '1991-04-19'),
(106, 'Koko pakka', 205, 303, 520, 41.7, '1990-10-10'),
(107, 'Pikku-Antin seikkailut', 201, 301, 56, 10.4, '2001-11-20'),
(108, 'Pitkä talvi', 202, 304, 1156, 46.8, '1970-12-01'),
(109, 'Sinne ja tänne', 203, 303, 814, 41.2, '1978-09-30');

INSERT INTO varasto (varastoid, kirjaid, lukumaara) VALUES
(1001, 101, 3324),
(1002, 102, 123),
(1003, 103, 311),
(1004, 104, 244),
(1005, 105, 53),
(1006, 106, 0),
(1007, 107, 30),
(1008, 108, 5),
(1009, 109, 1);

INSERT INTO kustantaja (kustantajaid, nimi, osoite, postinro, toimipaikka) VALUES (305, 'very Old Books', 'Vanhatie 21', '05800', 'Hyvinkää');


SELECT Kirja.nimi AS Kirja, kustantajaid FROM Kirja;
Select Kustantaja.nimi AS Kustantaja, kustantajaid from kustantaja;

SELECT Kirja.nimi AS Kirja, Kustantaja.nimi AS Kustantaja
FROM Kirja
INNER JOIN Kustantaja ON Kirja.kustantajaid = Kustantaja.kustantajaid
ORDER BY Kirja.nimi;



