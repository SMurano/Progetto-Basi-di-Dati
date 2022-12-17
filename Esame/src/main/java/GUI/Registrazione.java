package GUI;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Registrazione {
    private JLabel RegisterRegisterLabel;
    private JPanel SchermataRegistrazione;
    private JTextField RegisterNameTextBox;
    private JTextField RegisterLnameTextBox;
    private JTextField RegisterNicknameTextBox;
    private JLabel RegisterNameLabel;
    private JLabel RegisterLnameLable;
    private JLabel RegisterNicknameLabel;
    private JLabel RegisterPasswordLabel;
    private JPasswordField RegisterPasswordTextBox;
    private JLabel RegisterConfirmPasswordLabel;
    private JPasswordField RegisterConfirmPasswordTextBox;
    private JButton RegisterConfirmButton;

    public Registrazione() {

        RegisterConfirmButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                // crea il collegamento con il database
                // inserisci nel database una tupla costituita da: RegisterNameTextBox.text, RegisterLastNameTextBox.text, RegisterNicknameTextBox.text, RegisterPasswordTextBox.text"

                SchermataRegistrazione.setVisible(false);
                SchermataLogin.setVisible(true);
            }
        });
    }
}
