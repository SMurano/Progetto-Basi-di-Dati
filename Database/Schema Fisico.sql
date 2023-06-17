CREATE TABLE galleriafotograficacondivisa.GALLERIAPERSONALE
(CodGP    SERIAL     NOT NULL,
NomeGP    galleriafotograficacondivisa.NomeAlfaNumerico NOT NULL,
PRIMARY KEY (CodGP));

CREATE TABLE galleriafotograficacondivisa.GALLERIACONDIVISA
(CodGC    SERIAL     NOT NULL,
NomeGC    galleriafotograficacondivisa.NomeAlfaNumerico NOT NULL,
PRIMARY KEY (CodGC));

CREATE TABLE galleriafotograficacondivisa.UTENTE    
(Nome    galleriafotograficacondivisa.NomeCongnomeUtente,
Cognome  galleriafotograficacondivisa.NomeCongnomeUtente,  
Nickname galleriafotograficacondivisa.NomeAlfaNumerico  NOT NULL,
Pass     galleriafotograficacondivisa.NomeAlfaNumerico  NOT NULL,
CodGP    SERIAL      NOT NULL,
PRIMARY KEY (Nickname),
FOREIGN KEY (CodGP) REFERENCES galleriafotograficacondivisa.GALLERIAPERSONALE(CodGP));

CREATE TABLE galleriafotograficacondivisa.LUOGO
(Latitudine	 DECIMAL(9,6),
Longitudine	 DECIMAL(9,6),
NomeLuogo    galleriafotograficacondivisa.NomeAlfaNumerico,
PRIMARY KEY (NomeLuogo));

CREATE TABLE galleriafotograficacondivisa.FOTO
(CodFoto	 SERIAL      NOT NULL,
Dispositivo	 VARCHAR(30)  NOT NULL,
DimAltezza   DECIMAL(6,2),
DimLarghezza DECIMAL(6,2),
NomeFoto     galleriafotograficacondivisa.NomeAlfaNumerico  NOT NULL,
Nfotografo   VARCHAR(30)  NOT NULL,
NomeLuogo    galleriafotograficacondivisa.NomeAlfaNumerico,
TipoFoto     galleriafotograficacondivisa.VisibilitaFoto  NOT NULL,
DataScatto   DATE,
PRIMARY KEY (CodFoto),
FOREIGN KEY (Nfotografo) REFERENCES galleriafotograficacondivisa.UTENTE(Nickname),
FOREIGN KEY(NomeLuogo) REFERENCES galleriafotograficacondivisa.LUOGO(NomeLuogo));

CREATE TABLE galleriafotograficacondivisa.SOGGETTO
(CodSoggetto	 SERIAL      NOT NULL,
Tipo	         galleriafotograficacondivisa.CategoriaSoggetto  NOT NULL,
NickSoggetto     galleriafotograficacondivisa.NomeAlfaNumerico,
NomeSoggetto     galleriafotograficacondivisa.NomeAlfaNumerico,
PRIMARY KEY (CodSoggetto),
FOREIGN KEY (NickSoggetto) REFERENCES galleriafotograficacondivisa.UTENTE(Nickname),
FOREIGN KEY(NomeSoggetto) REFERENCES galleriafotograficacondivisa.LUOGO(NomeLuogo));

CREATE TABLE galleriafotograficacondivisa.CONTENIMENTO
(CodFoto	INTEGER			NOT NULL,
CodGP		INTEGER			NOT NULL,
PRIMARY KEY (CodFoto, CodGP),
FOREIGN KEY (CodFoto) REFERENCES galleriafotograficacondivisa.FOTO(CodFoto),
FOREIGN KEY (CodGP) REFERENCES galleriafotograficacondivisa.GALLERIAPERSONALE(CodGP));

CREATE TABLE galleriafotograficacondivisa.AFFERENZA          
(CodFoto	 INTEGER   NOT NULL,
CodSoggetto	 INTEGER   NOT NULL,
PRIMARY KEY (CodFoto,CodSoggetto),
FOREIGN KEY (CodFoto) REFERENCES galleriafotograficacondivisa.FOTO(CodFoto),
FOREIGN KEY (CodSoggetto) REFERENCES galleriafotograficacondivisa.SOGGETTO(CodSoggetto));

CREATE TABLE galleriafotograficacondivisa.PARTECIPAZIONE
(Nickname   VARCHAR(30)   NOT NULL,
CodGC       INTEGER       NOT NULL, 
PRIMARY KEY (Nickname, CodGC),
FOREIGN KEY (Nickname) REFERENCES galleriafotograficacondivisa.UTENTE(Nickname),
FOREIGN KEY (CodGC) REFERENCES galleriafotograficacondivisa.GALLERIACONDIVISA(CodGC));

CREATE TABLE galleriafotograficacondivisa.CONDIVISIONE
(CodFoto	 INTEGER    NOT NULL,
CodGC        INTEGER    NOT NULL, 
ElencoUtenti VARCHAR(255),
PRIMARY KEY (CodFoto, CodGC),
FOREIGN KEY (CodFoto) REFERENCES galleriafotograficacondivisa.FOTO(CodFoto),
FOREIGN KEY (CodGC) REFERENCES galleriafotograficacondivisa.GALLERIACONDIVISA(CodGC));

ALTER TABLE galleriafotograficacondivisa.luogo
 	ADD CONSTRAINT CoordinateLuogo UNIQUE (Latitudine, Longitudine);

ALTER TABLE galleriafotograficacondivisa.soggetto
 	ADD CONSTRAINT soggettoUnico UNIQUE (Tipo, NickSoggetto);

ALTER TABLE galleriafotograficacondivisa.soggetto
 	ADD CONSTRAINT soggettoUnico2 UNIQUE (Tipo, NomeSoggetto);