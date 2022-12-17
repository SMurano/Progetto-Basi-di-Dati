package Model;

import java.util.ArrayList;

public class Soggetto {
    private String idSoggetto;
    private String tipo;

    public Soggetto (String idSog, String t, Fotografia f){
        idSoggetto=idSog;
        tipo=t;
        fotografieRappresentanti.add(f);
        f.soggettiPartecipanti.add (this);
    }
    public Soggetto (String idSog, Utente t, Fotografia f){
        idSoggetto=idSog;
        tipoUtente=t;
        fotografieRappresentanti.add(f);
        f.soggettiPartecipanti.add (this);
    }
    public Utente tipoUtente;

    public Soggetto (String idSog, Luogo t, Fotografia f){
        idSoggetto=idSog;
        tipoLuogo=t;
        fotografieRappresentanti.add(f);
        f.soggettiPartecipanti.add (this);
    }
    public Luogo tipoLuogo;
    ArrayList<Fotografia> fotografieRappresentanti;


}
