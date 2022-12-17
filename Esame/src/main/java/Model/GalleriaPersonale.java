package Model;

import java.util.ArrayList;

public class GalleriaPersonale extends Galleria {

    public GalleriaPersonale (String g, Utente u, Fotografia f){

        super(g);
        utente=u;
        fotoUtente.add(f);


    }
    ArrayList<Fotografia> fotoUtente;
    Utente utente;
}
