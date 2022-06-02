//
//  RegistroViewController.swift
//  FireBase
//
//  Created by Mac11 on 24/05/22.
//

import UIKit
import FirebaseAuth
import CLTypingLabel

class RegistroViewController: UIViewController {
    

    @IBOutlet weak var otroTexto: CLTypingLabel!
    @IBOutlet weak var textoBien: UILabel!
    @IBOutlet weak var contraRegister: UITextField!
    @IBOutlet weak var correoRegister: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        correoRegister.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        contraRegister.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        
        /*
        otroTexto.charInterval = 0.09
        otroTexto.text = "Bienvenido al multiverso 😝"
        // Do any additional setup after loading the view.
        otroTexto.onTypingAnimationFinished = {
            self.otroTexto.textColor = .blue
        }*/

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registrarBtn(_ sender: UIButton) {
        if let email = correoRegister.text, let password = contraRegister.text{
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (resultado, error) in
                //validar si hubo un error
                
                if let e = error {
                    print("Error al crear usuario: \(e.localizedDescription)")
                    let alerta = UIAlertController(title: "Error", message: "\(e.localizedDescription)", preferredStyle: .alert)
                    let accionOk = UIAlertAction(title: "ok", style: .default)
                    alerta.addAction(accionOk)
                    self.present(alerta, animated: true)
                }else{
                    //si se pudo crear el usuario
                    print("usuario creado")
                    self.performSegue(withIdentifier: "registroMenu", sender: self)
                }
                
            }
            
            
            
            
        }
        
        

    }
    

}
