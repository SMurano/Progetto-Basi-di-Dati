CREATE DOMAIN galleriafotograficacondivisa.NomeAlfaNumerico AS VARCHAR(30)
	CHECK(VALUE ~ '^[a-zA-Z0-9_#/. ]*$');

CREATE DOMAIN galleriafotograficacondivisa.NomeCongnomeUtente AS VARCHAR(30)
	CHECK(VALUE ~ '^[a-zA-Z ]*$');

CREATE DOMAIN galleriafotograficacondivisa.VisibilitaFoto AS VARCHAR(10)
	CHECK(VALUE='pubblico' OR VALUE='privato');
	
CREATE DOMAIN galleriafotograficacondivisa.CategoriaSoggetto As VARCHAR(20)
	CHECK(VALUE IN('luogo','utente','foto di gruppo','fiera','altro'));