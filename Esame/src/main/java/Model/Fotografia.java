package Model;

import java.util.ArrayList;

public class Fotografia {
    private String idfoto;
    private String dispositivo;     // Attributi della classe fotograifa
    private Boolean visibilita;


    public Fotografia (String idf, String d, Utente f, GalleriaPersonale g, Boolean v, Luogo l, Soggetto s) {        //Dichiarazione costruttore Fotografia con riferimento al luogo di scatto e all'utente autore dello scatto
        idfoto=idf;
        dispositivo=d;
        fotografo=f;

        f.galleriaPersonale=g;
        g.fotoUtente.add (this);

        visibilita=v;
        luogoScatto=l;

        soggettiPartecipanti.add(s);
        s.fotografieRappresentanti.add (this);
    }
    public Utente fotografo;
    public Luogo luogoScatto;

    ArrayList<Soggetto> soggettiPartecipanti;
    ArrayList<GalleriaCondivisa> gallerieInCuiEContenuta;
}
