//
//  ViewController.swift
//  5-Capital-Cities-Macos
//
//  Created by Baris Karalar on 30.12.2021.
//

import Cocoa
import MapKit
class ViewController: NSViewController {

    @IBOutlet var questionLabel: NSTextField!
    @IBOutlet var scoreLabel: NSTextField!
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(mapClicked))
        mapView.addGestureRecognizer(recognizer)

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addPin(at coord: CLLocationCoordinate2D) {
        let guess = Pin(title: "Your guess", coordinate: coord, color: NSColor.red)
        mapView.addAnnotation(guess)
    }

    @objc func mapClicked(recognizer: NSClickGestureRecognizer) {
        let location = recognizer.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        addPin(at: coordinates)
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1: Convert the annotation to a pin so we can read its color
        guard let pin = annotation as? Pin else { return nil}
        
        // 2: Create an identifier string that will be used to share map pins
        let identifier = "Guess"
        
        // 3: Attempt to dequeue a pin from the reuse queue
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            // 4: There was no pin to reuse, create new one
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            // 5: We have a pin to reuse, update its annotation to the new annotation
            annotationView?.annotation = annotation
        }
        
        // 6: Customise the call out and color
        annotationView?.canShowCallout = true
        annotationView?.markerTintColor = pin.color
        
        
        return annotationView
    }
}
