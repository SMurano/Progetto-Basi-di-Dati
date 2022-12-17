package Model;

import java.util.ArrayList;

public class Luogo {
    private double latitudine;
    private double longitudine;             // Attributi della classe luogo

    private String nome;

    public Luogo (double lat, double lon, Fotografia f) {      //Dichiarazione costruttore contenente la chiave primaria del luogo e il riferimento alle foto scattate
        latitudine=lat;
        longitudine=lon;
        fotografieLocalizzate.add(f);
        f.luogoScatto=this;
    }
    ArrayList<Fotografia> fotografieLocalizzate;            //lista di foto localizzate da quel luogo

}
