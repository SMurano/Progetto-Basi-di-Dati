package GUI;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Login {
    private static JFrame frame;
    private JTextField LoginNicknameTextBox;
    private JButton LoginConfirmButton;
    private JPanel SchermataLogin;
    private JLabel LoginLoginLable;
    private JLabel LoginNicknameLabel;
    private JLabel LoginPasswordLabel;
    private JPasswordField LoginPasswordTextBox;
    private JButton LoginRegistratiButton;

    public static void main(String[] args){
        JFrame frame = new JFrame("Login");
        frame.setContentPane(new Login().SchermataLogin);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
    }
    public Login(){

        LoginRegistratiButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                Registrazione registrazione = new Registrazione(Controller,frame);
                Registrazione.frame.setVisible(true);
                frame.setVisible(false);
            }
        });
    }

    private void createUIComponents() {
        // TODO: place custom component creation code here
    }
}
