//
//  MostrarViewController.swift
//  FireBase
//
//  Created by Mac11 on 02/06/22.
//

import UIKit
import CoreData

class MostrarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPersonajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaGuardado.dequeueReusableCell(withIdentifier: "celda1", for: indexPath) as! CeldaPersonaje
        if(correo == listaPersonajes[indexPath.row].email){
            celda.tituloCelda.text = listaPersonajes[indexPath.row].nombre
            celda.descripcionCelda.text = listaPersonajes[indexPath.row].descripcion
            print("\(listaPersonajes[indexPath.row].imagen)")
            if let urlString = listaPersonajes[indexPath.row].imagen{
                if let imagenURL = URL(string: urlString){
                    DispatchQueue.global().async {
                        guard let imagenData = try? Data(contentsOf: imagenURL) else{
                            return
                        }
                        let image=UIImage(data: imagenData)
                        DispatchQueue.main.async {
                            celda.imagenCenlda.image=image
                        }
                    }
                }
            }
            
        }else{
            print("no es el mismo correo")
        }

        return celda
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(correo == listaPersonajes[indexPath.row].email){
            let accionEliminar=UIContextualAction(style: .normal, title: "Borrar") { (_, _, _) in
                self.contexto.delete(self.listaPersonajes[indexPath.row])
                self.listaPersonajes.remove(at: indexPath.row)
                do{
                    try self.contexto.save()
                }catch{
                    print("Error al eliminar datos")
                }
                self.tablaGuardado.reloadData()
            }
            accionEliminar.image=UIImage(systemName: "trash")
            accionEliminar.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [accionEliminar])
        }else{
            return nil
        }

    }
    

    @IBOutlet weak var tablaGuardado: UITableView!
    var listaPersonajes = [PersonajeUsuario]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var correo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaGuardado.delegate=self
        tablaGuardado.dataSource=self
        tablaGuardado.register(UINib(nibName: "CeldaPersonaje", bundle: nil), forCellReuseIdentifier: "celda1")
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String{
            print(email)
            correo = email
        }
        leerPersonaje()

    }
    
    func leerPersonaje() {
        let solicitud: NSFetchRequest<PersonajeUsuario> = PersonajeUsuario.fetchRequest()
        
        do{
            listaPersonajes = try contexto.fetch(solicitud)
        }catch{
            print("error: \(error.localizedDescription)")
        }
        tablaGuardado.reloadData()
    }
    


}
