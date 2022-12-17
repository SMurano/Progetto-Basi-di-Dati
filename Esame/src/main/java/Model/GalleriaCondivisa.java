package Model;

import java.util.ArrayList;

public class GalleriaCondivisa extends Galleria {
    public GalleriaCondivisa (String g, Utente u1, Utente u2, Fotografia f) {

        super(g);

        utentiPartecipanti.add(u1);
        u1.gallerieACuiPartecipa.add (this);

        utentiPartecipanti.add(u2);
        u2.gallerieACuiPartecipa.add (this);

        fotografieCondivise.add(f);
        f.gallerieInCuiEContenuta.add (this);
    }
    ArrayList<Utente> utentiPartecipanti;
    ArrayList<Fotografia> fotografieCondivise;
}
