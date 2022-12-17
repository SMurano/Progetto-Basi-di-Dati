package Model;

import java.util.ArrayList;

public class Utente {
    private String nickname;
    private String password;

    public Utente(String n, String p) {
        nickname=n;
        password=p;

    };

    GalleriaPersonale galleriaPersonale;
    ArrayList<GalleriaCondivisa> gallerieACuiPartecipa;

}
