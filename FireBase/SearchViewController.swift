//
//  SearchViewController.swift
//  FireBase
//
//  Created by Mac11 on 27/05/22.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate, personajeModeloDelegado,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPersonajes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerta = UIAlertController(title: "Guardar", message: "¿Deseas guardar este elemento?", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            print("acepte")
            print("correo guardar : \(self.correo)")
            //hacemos un nuevo tipo
            let nuevoPersonaje = PersonajeUsuario(context: self.contexto)
            nuevoPersonaje.email = self.correo
            nuevoPersonaje.nombre = self.listaPersonajes[indexPath.row].name
            nuevoPersonaje.descripcion = self.listaPersonajes[indexPath.row].description
            let urlImagenGuardar = self.listaPersonajes[indexPath.row].thumbnail?.path
            nuevoPersonaje.imagen = "\(urlImagenGuardar ?? "").jpg"
            self.guardar()
        }
        let denegar = UIAlertAction(title: "Denegar", style: .cancel)
        alerta.addAction(accion)
        alerta.addAction(denegar)
        self.present(alerta, animated: true)
        tablaPersonajes.deselectRow(at: indexPath, animated: true)
        print(indexPath)
    }
    func guardar() {
        
        do{
            try contexto.save()
            print("guardado")
        }catch{
            print("Error al guardar en core data: \(error.localizedDescription)")
        }
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaPersonajes.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaPersonaje
        celda.tituloCelda.text = listaPersonajes[indexPath.row].name
        celda.descripcionCelda.text = listaPersonajes[indexPath.row].description
        
        let urlImagen = "\(listaPersonajes[indexPath.row].thumbnail?.path ?? "").jpg"
        //agregamos la imagen
        
            if let imagenURL = URL(string: urlImagen){
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
        
        
        
        
        
        
        
        
        return celda
    }
    
    func actualizarPersonaje(objPersonaje: [Results]) {
        listaPersonajes = objPersonaje
        print("imprimo desde search \(listaPersonajes)")
        DispatchQueue.main.async {
            self.tablaPersonajes.reloadData()
        }
    }
    
    func huboError(error: Error) {
       
    }
    //contexto para core data
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tablaPersonajes: UITableView!
    var atributos = ["Personajes", "Personaje por serie"]
    var urlStringCoincidencia = "https://gateway.marvel.com/v1/public/characters?ts=1000&apikey=e26cfe1a7428a3244311a66e0d8e2c65&hash=a7659b297b7557d61c40537cec90fb3a&nameStartsWith="
    var urlStringSerie = "https://gateway.marvel.com/v1/public/characters?ts=1000&apikey=e26cfe1a7428a3244311a66e0d8e2c65&hash=a7659b297b7557d61c40537cec90fb3a&series="
    var seleccion = "Personajes"
    var personajemanager = personajeManager()
    var listaPersonajes:[Results]=[]
    var numero:Int = 0
    var correo = ""
    @IBOutlet weak var busqueda: UISearchBar!
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //validar la sesion
        let defaults = UserDefaults.standard
        
        //validamos si existe la sesion guardada
        
        if let email = defaults.value(forKey: "email") as? String{
            print(email)
            correo = email
        }
        
        
        
        
        tablaPersonajes.delegate=self
        tablaPersonajes.dataSource=self
        tablaPersonajes.register(UINib(nibName: "CeldaPersonaje", bundle: nil), forCellReuseIdentifier: "celda")
        personajemanager.delegado = self
        picker.delegate = self
        picker.delegate = self
        busqueda.delegate = self

        // Do any additional setup after loading the view.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("\(seleccion)")
        print("\(busqueda.text ?? "")")
        if(numero == 0){
            print("buscar por coincidencia")
            let urlMandar = "\(urlStringCoincidencia)\(busqueda.text ?? "")"
            print(urlMandar)
            personajemanager.obtenerPersonaje(urlApi: urlMandar)
        }else if (numero == 1){
            let urlPegada = "\(urlStringSerie)\(busqueda.text ?? "")"
            print(urlPegada)
            personajemanager.obtenerPersonaje(urlApi: urlPegada)
        }
    }
    


}
extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return atributos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return atributos[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(atributos[row])
        numero = row
        seleccion = atributos[row]
    }
}
