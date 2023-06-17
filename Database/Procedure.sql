CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.CreazioneGalleriaPersonale() RETURNS TRIGGER AS $CreazioneGalleriaPersonale$
	BEGIN 
		INSERT INTO galleriafotograficacondivisa.galleriapersonale VALUES(NEW.CodGP,CONCAT('GALLERIA DI ',NEW.Nickname));
		RETURN NEW;
	END;
$CreazioneGalleriaPersonale$ LANGUAGE plpgsql;

CREATE TRIGGER CreazioneGalleriaPersonale BEFORE INSERT ON galleriafotograficacondivisa.Utente
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.CreazioneGalleriaPersonale();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaFoto() RETURNS TRIGGER AS $EliminaFoto$
	BEGIN
		IF (NOT EXISTS(SELECT F.CodFoto
					FROM galleriafotograficacondivisa.FOTO AS F JOIN galleriafotograficacondivisa.Contenimento AS C
					on F.CodFoto=C.CodFoto
					WHERE F.CodFoto=OLD.CodFoto)
			AND	NOT EXISTS(SELECT F.CodFoto
						 FROM galleriafotograficacondivisa.FOTO AS F JOIN galleriafotograficacondivisa.Condivisione AS C
						 on F.CodFoto=C.CodFoto
						 WHERE F.CodFoto=OLD.CodFoto))
		THEN 
			DELETE FROM galleriafotograficacondivisa.FOTO AS F WHERE F.CodFoto=OLD.CodFoto;
		END IF;
		RETURN NEW;
	END;
$EliminaFoto$ LANGUAGE plpgsql;

CREATE TRIGGER EliminaFoto AFTER DELETE ON galleriafotograficacondivisa.Contenimento
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaFoto();

CREATE TRIGGER EliminaFoto2 AFTER DELETE ON galleriafotograficacondivisa.Condivisione
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaFoto();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.RinominaGalleriaCondivisa() RETURNS TRIGGER AS $RinominaGalleriaCondivisa$
BEGIN
	NEW.NomeGC=CONCAT(NEW.NomeGC,' #',NEW.CodGC);
	RETURN NEW;
END
$RinominaGalleriaCondivisa$ LANGUAGE plpgsql;

CREATE TRIGGER RinominaGalleriaCondivisa BEFORE INSERT ON galleriafotograficacondivisa.galleriacondivisa
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.RinominaGalleriaCondivisa();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaLuogo() RETURNS TRIGGER AS $EliminaLuogo$
	BEGIN
		IF (NOT EXISTS(SELECT L.NomeLuogo
					FROM galleriafotograficacondivisa.Luogo AS L JOIN galleriafotograficacondivisa.Soggetto AS S
					ON L.NomeLuogo=S.NomeSoggetto
					WHERE L.NomeLuogo=OLD.NomeLuogo)
			AND	NOT EXISTS(SELECT F.NomeLuogo
						 FROM galleriafotograficacondivisa.FOTO AS F
						 WHERE F.NomeLuogo=OLD.NomeLuogo))
		THEN 
			DELETE FROM galleriafotograficacondivisa.Luogo WHERE NomeLuogo=OLD.NomeLuogo;
		END IF;
		RETURN NEW;
	END;
$EliminaLuogo$ LANGUAGE plpgsql;

CREATE TRIGGER EliminaLuogo AFTER DELETE ON galleriafotograficacondivisa.Foto
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaLuogo();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaSoggetto() RETURNS TRIGGER AS $EliminaSoggetto$
DECLARE 
	elencoSoggetti CURSOR FOR 	(SELECT codSoggetto 
								FROM galleriafotograficacondivisa.AFFERENZA AS A
								WHERE A.CodFoto=OLD.codFoto);
	soggettoCorrente INTEGER;
	BEGIN
		OPEN elencoSoggetti;
			LOOP
				FETCH elencoSoggetti INTO soggettoCorrente;
				IF (NOT FOUND) 
				THEN EXIT;
				END IF;
				DELETE FROM galleriafotograficacondivisa.Afferenza WHERE (codSoggetto=soggettoCorrente AND codFoto=OLD.codFoto);
				IF (NOT EXISTS(SELECT *
						       FROM galleriafotograficacondivisa.Soggetto NATURAL JOIN galleriafotograficacondivisa.Afferenza
						       WHERE codSoggetto=soggettoCorrente))

				THEN 
					DELETE FROM galleriafotograficacondivisa.Soggetto WHERE (codSoggetto=soggettoCorrente);
				END IF;
			END LOOP;
		CLOSE elencoSoggetti;
		RETURN OLD;
	END;
$EliminaSoggetto$ LANGUAGE plpgsql;

CREATE TRIGGER EliminaSoggetto BEFORE DELETE ON galleriafotograficacondivisa.Foto
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaSoggetto();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.CreaElencoUtenti() RETURNS TRIGGER AS $CreaElencoUtenti$
DECLARE 
	elencoNickname CURSOR FOR 	(SELECT Nickname 
								FROM galleriafotograficacondivisa.GALLERIACONDIVISA
								NATURAL JOIN galleriafotograficacondivisa.PARTECIPAZIONE
								NATURAL JOIN galleriafotograficacondivisa.UTENTE
								WHERE CodGC=NEW.CodGC);
	utenteCorrente VARCHAR(30);
BEGIN
	NEW.ElencoUtenti='';
	OPEN elencoNickname;
		LOOP
			FETCH elencoNickname INTO utenteCorrente;
			IF (NOT FOUND) 
			THEN EXIT;
			END IF;
			NEW.ElencoUtenti= CONCAT(NEW.ElencoUtenti,utenteCorrente,', ');
		END LOOP;
	CLOSE elencoNickname;
RETURN NEW;
END;
$CreaElencoUtenti$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER CreaElencoUtenti BEFORE INSERT ON galleriafotograficacondivisa.Condivisione
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.CreaElencoUtenti();



CREATE OR REPLACE PROCEDURE galleriafotograficacondivisa.EliminaUtenteDaElenco(Utente VARCHAR(30), Foto Integer, GalleriaCondivisa Integer) 
LANGUAGE plpgsql 
AS $$
BEGIN
	UPDATE galleriafotograficacondivisa.CONDIVISIONE
	SET ElencoUtenti=REPLACE(ElencoUtenti,CONCAT(Utente,', '),'')
	WHERE (CodFoto = Foto AND CodGC = GalleriaCOndivisa);
	DELETE FROM galleriafotograficacondivisa.CONDIVISIONE
	WHERE ElencoUtenti='';
END;
$$;



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.FiltraFotoPerLuogo(Utente VARCHAR(30), Luogo VARCHAR(30)) RETURNS REFCURSOR AS $$

DECLARE 
	elencoFoto REFCURSOR;
BEGIN
	OPEN elencoFoto FOR    (SELECT F.codFoto, F.Dispositivo, F.DimAltezza, F.DimLarghezza, F.NomeFoto, F.Nfotografo, F.DataScatto,GC.NomeGC
						   FROM galleriafotograficacondivisa.FOTO AS F 
						   JOIN galleriafotograficacondivisa.CONDIVISIONE AS CO 
						   ON F.CodFoto=CO.CodFoto
						   JOIN galleriafotograficacondivisa.GALLERIACONDIVISA AS GC
						   ON CO.CodGC=GC.CodGC
						   JOIN galleriafotograficacondivisa.PARTECIPAZIONE AS P
						   ON GC.CODGC=P.CODGC
						   WHERE F.NomeLuogo=Luogo AND P.nickname=Utente

						   UNION					
						   	   
						   SELECT F.codFoto, F.Dispositivo, F.DimAltezza, F.DimLarghezza, F.NomeFoto, F.Nfotografo, F.DataScatto,GP.NomeGP
						   FROM galleriafotograficacondivisa.FOTO AS F 						   
						   JOIN galleriafotograficacondivisa.CONTENIMENTO AS C 
						   ON F.codFoto=C.codFoto 
						   JOIN galleriafotograficacondivisa.GALLERIAPERSONALE AS GP
						   ON C.CodGP=GP.CodGP
						   WHERE GP.NomeGP=CONCAT('GALLERIA DI ',Utente) AND F.NomeLuogo=Luogo);
	CLOSE elencoFoto;
	RETURN elencoFoto;
END;
$$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.FiltraFotoPerSoggetto(Utente VARCHAR(30), NomeSoggetto VARCHAR(30), TipoSoggetto VARCHAR(30)) RETURNS REFCURSOR AS $$

DECLARE 
	elencoFoto REFCURSOR;
BEGIN
	OPEN elencoFoto FOR    (SELECT F.codFoto, F.Dispositivo, F.DimAltezza, F.DimLarghezza, F.NomeFoto, F.Nfotografo, F.DataScatto,GC.NomeGC
						   FROM galleriafotograficacondivisa.FOTO AS F 
						   JOIN galleriafotograficacondivisa.CONDIVISIONE AS CO 
						   ON F.CodFoto=CO.CodFoto
						   JOIN galleriafotograficacondivisa.GALLERIACONDIVISA AS GC
						   ON CO.CodGC=GC.CodGC
						   JOIN galleriafotograficacondivisa.PARTECIPAZIONE AS P
						   ON GC.CODGC=P.CODGC
						   JOIN galleriafotograficacondivisa.AFFERENZA AS A
						   ON F.CodFoto=A.CodFoto
						   JOIN galleriafotograficacondivisa.SOGGETTO AS S
						   ON A.CodSoggetto=S.CodSoggetto
						   WHERE (P.nickname=Utente) AND (S.Tipo=TipoSoggetto) AND (S.NomeSoggetto=NomeSoggetto OR S.NickSoggetto=NomeSoggetto OR (S.NomeSoggetto IS NULL AND S.NickSoggetto IS NULL))) 

						   UNION					
						   	   
						   SELECT F.codFoto, F.Dispositivo, F.DimAltezza, F.DimLarghezza, F.NomeFoto, F.Nfotografo, F.DataScatto,GP.NomeGP
						   FROM galleriafotograficacondivisa.FOTO AS F 						   
						   JOIN galleriafotograficacondivisa.CONTENIMENTO AS C 
						   ON F.codFoto=C.codFoto 
						   JOIN galleriafotograficacondivisa.GALLERIAPERSONALE AS GP
						   ON C.CodGP=GP.CodGP
						   JOIN galleriafotograficacondivisa.AFFERENZA AS A
						   ON F.CodFoto=A.CodFoto
						   JOIN galleriafotograficacondivisa.SOGGETTO AS S
						   ON A.CodSoggetto=S.CodSoggetto
						   WHERE GP.NomeGP=CONCAT('GALLERIA DI ',Utente) AND (S.Tipo=TipoSoggetto) AND (S.NomeSoggetto=NomeSoggetto OR S.NickSoggetto=NomeSoggetto OR (S.NomeSoggetto IS NULL AND S.NickSoggetto IS NULL));
	CLOSE elencoFoto;
	RETURN elencoFoto;
END;
$$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.Top3LuoghiPiuImmortalati()  RETURNS TRIGGER AS $AggiornaTop3LuoghiPiuImmortalati$

DECLARE
BEGIN
	CREATE OR REPLACE VIEW galleriafotograficacondivisa.Top3Luoghi AS
	SELECT NomeSoggetto,COUNT (DISTINCT(CodFoto))
						   FROM galleriafotograficacondivisa.SOGGETTO
						   NATURAL JOIN galleriafotograficacondivisa.AFFERENZA
						   NATURAL JOIN galleriafotograficacondivisa.foto
						   WHERE Tipo='luogo'
						   GROUP BY(NomeSoggetto)
						   ORDER BY (COUNT (CodFoto)) DESC
						   LIMIT 3;
	RETURN NEW;			   
END;
$AggiornaTop3LuoghiPiuImmortalati$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER AggiornaTop3LuoghiPiuImmortalati AFTER INSERT ON galleriafotograficacondivisa.SOGGETTO
FOR EACH ROW 
WHEN (NEW.Tipo='luogo')
EXECUTE PROCEDURE galleriafotograficacondivisa.Top3LuoghiPiuImmortalati();



CREATE OR REPLACE PROCEDURE galleriafotograficacondivisa.VisualizzaTop3LuoghiPiuImmortalati() AS $$
BEGIN
	SELECT * FROM galleriafotograficacondivisa.Top3Luoghi; 
END;
$$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaSoggettoLibero() RETURNS TRIGGER AS $EliminaSoggettoLibero$
DECLARE 
	elencoSoggetti CURSOR FOR (SELECT S.CodSoggetto 
							  FROM galleriafotograficacondivisa.Soggetto AS S
							  WHERE S.codSoggetto NOT IN(SELECT CodSoggetto
														FROM galleriafotograficacondivisa.AFFERENZA)

							  UNION

							  SELECT S.CodSoggetto 
							  FROM galleriafotograficacondivisa.Soggetto AS S
							  WHERE (S.NickSoggetto<>NULL AND S.NomeSoggetto<>NULL) 
							  OR (S.Tipo='utente' AND (NickSoggetto=NULL OR S.NomeSoggetto<>NULL))
							  OR (S.Tipo='luogo' AND (NickSoggetto<>NULL OR S.NomeSoggetto=NULL)));
	soggettoCorrente INTEGER;
BEGIN
	OPEN elencoSoggetti;
		LOOP
			FETCH elencoSoggetti INTO soggettoCorrente;
			IF (NOT FOUND) 
			THEN EXIT;
			END IF;
				DELETE FROM galleriafotograficacondivisa.Soggetto WHERE (codSoggetto=soggettoCorrente);
		END LOOP;
	CLOSE elencoSoggetti;
	RETURN NEW;
END;
$EliminaSoggettoLibero$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER EliminaSoggettoLibero BEFORE INSERT ON galleriafotograficacondivisa.Soggetto
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaSoggettoLibero();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaLuogoLibero() RETURNS TRIGGER AS $EliminaLuogoLibero$
DECLARE 
	elencoLuoghi CURSOR FOR (SELECT L.NomeLuogo 
							FROM galleriafotograficacondivisa.Luogo AS L
							WHERE L.NomeLuogo NOT IN(SELECT NomeLuogo
													 FROM galleriafotograficacondivisa.Foto)
							AND L.NomeLuogo NOT IN(SELECT NomeSoggetto
													 FROM galleriafotograficacondivisa.Soggetto));
	luogoCorrente VARCHAR(30);
BEGIN
	OPEN elencoLuoghi;
		LOOP
			FETCH elencoLuoghi INTO luogoCorrente;
			IF (NOT FOUND) 
			THEN EXIT;
			END IF;
				DELETE FROM galleriafotograficacondivisa.Luogo WHERE (NomeLuogo=luogoCorrente);
		END LOOP;
	CLOSE elencoLuoghi;
	DELETE FROM galleriafotograficacondivisa.Luogo WHERE (Latitudine IS NULL AND Longitudine IS NOT NULL) OR (Latitudine IS NOT NULL AND Longitudine IS NULL);
	RETURN NEW;
END;
$EliminaLuogoLibero$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER EliminaLuogoLibero BEFORE INSERT ON galleriafotograficacondivisa.Luogo
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaLuogoLibero();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaFotoLibera() RETURNS TRIGGER AS $EliminaFotoLibera$
DECLARE 
	elencoFoto CURSOR FOR (SELECT F.CodFoto 
						  FROM galleriafotograficacondivisa.Foto AS F
						  WHERE F.CodFoto NOT IN(SELECT CodFoto
												 FROM galleriafotograficacondivisa.Contenimento)
						  AND F.CodFoto NOT IN(SELECT CodFoto
											   FROM galleriafotograficacondivisa.Condivisione));
	
	elencoFoto2 CURSOR FOR (SELECT F.CodFoto 
						   FROM galleriafotograficacondivisa.Foto AS F
						   WHERE F.CodFoto NOT IN(SELECT CodFoto
												  FROM galleriafotograficacondivisa.Afferenza)
												  
						   UNION

						   SELECT F.CodFoto 
						   FROM galleriafotograficacondivisa.Foto AS F
						   WHERE (F.DimAltezza IS NULL AND F.DimLarghezza IS NOT NULL) OR (F.DimAltezza IS NOT NULL AND F.DimLarghezza IS NULL));
	fotoCorrente INTEGER;
BEGIN
	OPEN elencoFoto2;
		LOOP
			FETCH elencoFoto2 INTO fotoCorrente;
			IF (NOT FOUND) 
			THEN EXIT;
			END IF;
				DELETE FROM galleriafotograficacondivisa.Contenimento WHERE (CodFoto=fotoCorrente);
				DELETE FROM galleriafotograficacondivisa.Condivisione WHERE (CodFoto=fotoCorrente);
		END LOOP;
	CLOSE elencoFoto2;
	OPEN elencoFoto;
		LOOP
			FETCH elencoFoto INTO fotoCorrente;
			IF (NOT FOUND) 
			THEN EXIT;
			END IF;
				DELETE FROM galleriafotograficacondivisa.Foto WHERE (CodFoto=fotoCorrente);
		END LOOP;
	CLOSE elencoFoto;
	RETURN NEW;
	END;
$EliminaFotoLibera$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER EliminaFotoLibera BEFORE INSERT ON galleriafotograficacondivisa.Foto
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaFotoLibera();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaFotoPrivataGC() RETURNS TRIGGER AS $EliminaFotoPrivataGC$
DECLARE 
	elencoFoto CURSOR FOR (SELECT CodFoto 
						  FROM galleriafotograficacondivisa.Foto 
						  NATURAL JOIN galleriafotograficacondivisa.Condivisione 
						  WHERE TipoFoto='privato');					  
	fotoCorrente INTEGER;
BEGIN
	OPEN elencoFoto;
		LOOP
			FETCH elencoFoto INTO fotoCorrente;
			IF (NOT FOUND) 
			THEN EXIT;
			END IF;
				DELETE FROM galleriafotograficacondivisa.Condivisione WHERE (CodFoto=fotoCorrente);
		END LOOP;
	CLOSE elencoFoto;
	RETURN NEW;
END;
$EliminaFotoPrivataGC$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER EliminaFotoPrivataGC AFTER INSERT ON galleriafotograficacondivisa.Condivisione
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaFotoPrivataGC();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.EliminaGalleriaVuota() RETURNS TRIGGER AS $EliminaGalleriaVuota$
DECLARE 
	elencoGallerie CURSOR FOR (SELECT CodGC 
						  FROM galleriafotograficacondivisa.GalleriaCondivisa 
						  NATURAL JOIN galleriafotograficacondivisa.Partecipazione 
						  GROUP BY (CodGC)
						  HAVING COUNT(Nickname)<2
						  UNION 
						  SELECT CodGC 
						  FROM galleriafotograficacondivisa.GalleriaCondivisa 
						  WHERE CodGC NOT IN(SELECT CodGC 
						  					FROM galleriafotograficacondivisa.GalleriaCondivisa 
						  					NATURAL JOIN galleriafotograficacondivisa.Partecipazione));					  
	galleriaCorrente INTEGER;
BEGIN
	OPEN elencoGallerie;
		LOOP
			FETCH elencoGallerie INTO galleriaCorrente;
			IF (NOT FOUND) 
			THEN EXIT;
			END IF;
				DELETE FROM galleriafotograficacondivisa.Condivisione WHERE (CodGC=galleriaCorrente);
				DELETE FROM galleriafotograficacondivisa.Partecipazione WHERE (CodGC=galleriaCorrente);
				DELETE FROM galleriafotograficacondivisa.GalleriaCondivisa WHERE (CodGC=galleriaCorrente);
		END LOOP;
	CLOSE elencoGallerie;
	RETURN NEW;
END;
$EliminaGalleriaVuota$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER EliminaGalleriaVuota AFTER DELETE ON galleriafotograficacondivisa.Partecipazione
FOR EACH ROW EXECUTE FUNCTION galleriafotograficacondivisa.EliminaGalleriaVuota();



CREATE OR REPLACE FUNCTION galleriafotograficacondivisa.PrivatizzaFoto() RETURNS TRIGGER AS $PrivatizzaFoto$
BEGIN	
	DELETE FROM galleriafotograficacondivisa.Condivisione WHERE (CodFoto=NEW.CodFoto);
	RETURN NEW;
END;
$PrivatizzaFoto$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER PrivatizzaFoto AFTER UPDATE ON galleriafotograficacondivisa.Foto
FOR EACH ROW
WHEN (OLD.TipoFoto='pubblico' AND NEW.TipoFoto='privato')
EXECUTE FUNCTION galleriafotograficacondivisa.PrivatizzaFoto();