//
//  MapaViewController.swift
//  FireBase
//
//  Created by Mac11 on 03/06/22.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapaC: MKMapView!
    @IBOutlet weak var mapa: UITabBarItem!
    var latitud: CLLocationDegrees?
    var longitud: CLLocationDegrees?
    var altitud: CLLocationDegrees?
    var manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        mapaC.delegate = self
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        //mejorar la precision de la ubicacion
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //monitorear en todo momento la ubicacion
        manager.startUpdatingLocation()

      
    }
    

    @IBAction func trazar(_ sender: UIButton) {
        let direccion = "1290 6th Ave, New York, NY 10104, Estados Unidos"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(direccion) { (places: [CLPlacemark]?,error: Error?) in
                //creamos el destino
            guard let destinoRuta = places?.first?.location else {return}
            //ai encontro la direccion
            if error == nil{
                let lugar = places?.first
                let anotacion = MKPointAnnotation()
                anotacion.coordinate = (lugar?.location?.coordinate)!
                anotacion.title = "Marvel Studios"
                //nivel de zoom
                let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
                //agregar anotacion
                self.mapaC.setRegion(region, animated: true)
                self.mapaC.addAnnotation(anotacion)
                self.trazarRuta(coordenadasDestino: destinoRuta.coordinate)
                
            }//if error
            else{
                let alerta = UIAlertController(title: "Error", message: "No se encontro la ruta", preferredStyle: .alert)
                let accionOk = UIAlertAction(title: "ok", style: .default)
                alerta.addAction(accionOk)
                self.present(alerta, animated: true)
            }
        }
        
    }
    func trazarRuta(coordenadasDestino: CLLocationCoordinate2D) {
        //obtener origen
        guard let coordOrigen = manager.location?.coordinate else {return}
        //origen-destino
        let origenPlaceMark = MKPlacemark(coordinate: coordOrigen)
        let destinoPlaceMark = MKPlacemark(coordinate: coordenadasDestino)
        
        //objeto mapkit item
        let origenItem = MKMapItem(placemark: origenPlaceMark)
        let destinoItem = MKMapItem(placemark: destinoPlaceMark)
        
        //solicitar ruta
        let solicitudDestino = MKDirections.Request()
        solicitudDestino.source = origenItem
        solicitudDestino.destination = destinoItem
        //como se va a viajar
        solicitudDestino.transportType = .automobile
        //recalcular ruta
        solicitudDestino.requestsAlternateRoutes = true
        
        let direcciones = MKDirections(request: solicitudDestino)
        direcciones.calculate { (respuesta, error) in
            //respuesta segura
            guard let respuestaSegura = respuesta else {
                if let error = error {
                    let alerta = UIAlertController(title: "Error", message: "Error al calcular ruta", preferredStyle: .alert)
                    let accionOk = UIAlertAction(title: "ok", style: .default)
                    alerta.addAction(accionOk)
                    self.present(alerta, animated: true)
                }
                return
            }//respuesta segura
            if let ruta = respuestaSegura.routes.first{
                self.mapaC.addOverlay(ruta.polyline)
                self.mapaC.setVisibleMapRect(ruta.polyline.boundingMapRect, animated: true)
            }
            
            
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("numero de ubicaciones : \(locations.count)")
        //crear ubicacion
        guard let ubicacion = locations.first else {return}
        
        latitud = ubicacion.coordinate.latitude
        longitud = ubicacion.coordinate.longitude
        altitud = ubicacion.altitude
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error al obtener la unicacion: ")
        let alerta = UIAlertController(title: "Error", message: "Al obtener ubicacion", preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "ok", style: .default)
        alerta.addAction(accionOk)
        present(alerta, animated: true)

    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderizado = MKPolylineRenderer (overlay: overlay as! MKPolyline)
        renderizado.strokeColor = .brown
        return renderizado
        
    }
    
}
