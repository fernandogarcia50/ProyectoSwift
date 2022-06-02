//
//  personajeManager.swift
//  FireBase
//
//  Created by Mac11 on 30/05/22.
//

import Foundation
protocol personajeModeloDelegado {
    
    func actualizarPersonaje(objPersonaje: [Results])
    func huboError(error:Error)
}

struct personajeManager {
    var delegado: personajeModeloDelegado?
    let personajeURL = "https://gateway.marvel.com/v1/public/characters?ts=1000&apikey=e26cfe1a7428a3244311a66e0d8e2c65&hash=a7659b297b7557d61c40537cec90fb3a"
    func obtenerPersonaje(urlApi: String) {
        realizarSolicitud(url: urlApi)
    }
    
    func realizarSolicitud(url:String) {
        if let url = URL(string: url){
            
            //creamos la url sesion
            
            let session = URLSession(configuration: .default)
            
            
            //asignamos la tarea a la sesion
            
            let tarea = session.dataTask(with: url) { (datos, respuesta, error) in
                if error != nil {
                    print("error: \(error?.localizedDescription)")
                    delegado?.huboError(error: error!)
                    return
                }
                if let datosSeguros = datos{
                    print(datosSeguros)
                    if let listaPersonajes = self.parsearJSON(datosPersonajes: datosSeguros){
                        //print(listaPersonajes)
                        delegado?.actualizarPersonaje(objPersonaje: listaPersonajes)
                    }
                }
            }
            tarea.resume()
        }
    }
    
    func parsearJSON(datosPersonajes: Data) -> [Results]? {
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados = try decodificador.decode(PersonajeModelo.self, from: datosPersonajes)
            let listaPersonajes = datosDecodificados.data?.results
            //print(listaPersonajes)
           
            /*
            let nombre = datosDecodificados.name ?? ""
            let descrpcion = datosDecodificados.description ?? ""
            
            var objPersonaje = personajeDatos(name: nombre, description: descrpcion)*/
            //let personajes: [PersonajeModelo] = datosDecodificados
            //print(personajes)
            return listaPersonajes
            
        } catch  {
            print(error.localizedDescription)
            delegado?.huboError(error: error)
            return nil
        }
    }
        
    
}
