//
//  ViewController.swift
//  FireBase
//
//  Created by Mac11 on 23/05/22.
//

import UIKit
import CLTypingLabel
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var contrasenaUsuario: UITextField!
    @IBOutlet weak var correoUsuario: UITextField!
    @IBOutlet weak var mensajeBienvenida: CLTypingLabel!
    
    //var personajemanager = personajeManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //personajemanager.obtenerPersonaje()
        correoUsuario.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        contrasenaUsuario.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //validar la sesion
        let defaults = UserDefaults.standard
        
        //validamos si existe la sesion guardada
        
        if let email = defaults.value(forKey: "email") as? String{
            performSegue(withIdentifier: "loginMenu", sender: self)
        }
        /*
        mensajeBienvenida.charInterval = 0.09
        mensajeBienvenida.text = "Bienvenido al multiverso 😝"
        // Do any additional setup after loading the view.
        mensajeBienvenida.onTypingAnimationFinished = {
            self.mensajeBienvenida.textColor = .blue
        }*/
    }


    @IBAction func loginBtn(_ sender: UIButton) {
        if let email = correoUsuario.text, let password = contrasenaUsuario.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print("error al iniciar sesion: \(e.localizedDescription)")
                    //alerta para el inicio de sesion
                    let alerta = UIAlertController(title: "Error", message: "\(e.localizedDescription)", preferredStyle: .alert)
                    let accionOk = UIAlertAction(title: "ok", style: .default)
                    alerta.addAction(accionOk)
                    self.present(alerta, animated: true)
                    
                    
                    
                    
                }else{
                    self.performSegue(withIdentifier: "loginMenu", sender: self)
                }
            }
            
            
            
            
            
        }
        
        
       
        
    }
}

