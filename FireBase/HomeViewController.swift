//
//  HomeViewController.swift
//  FireBase
//
//  Created by Mac11 on 24/05/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //ocultar boton de retroceder
        navigationItem.hidesBackButton = true
        //guardar la sesion del usuario
        
        if let email = Auth.auth().currentUser?.email{
            let defaults = UserDefaults.standard
            defaults.set(email, forKey: "email")
            defaults.synchronize()
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cerrarSesionBtn(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            print("se ha cerrado la sesion :)")
            //borrar la sesion guardada
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "email")
            defaults.synchronize()
            
            //navegar a la pantalla de inicio
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print("Error al cerrar sesion: \(error.localizedDescription)")
        }
    }
    
}
