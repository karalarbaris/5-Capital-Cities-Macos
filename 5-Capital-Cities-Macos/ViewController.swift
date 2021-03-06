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
    
    var cities = [Pin]()
    var currentCity: Pin?
    var score = 0 {
        didSet {
            scoreLabel.stringValue = "Score: \(score) (Lowest score wins)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(mapClicked))
        mapView.addGestureRecognizer(recognizer)
        
        startNewGame()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func addPin(at coord: CLLocationCoordinate2D) {
        // make sure we have a city that we're looking for
        guard let actual = currentCity else { return }
        
        // create a pin representing the player's guess, and add it to the map
        let guess = Pin(title: "Your guess", coordinate: coord, color: NSColor.red)
        mapView.addAnnotation(guess)
        
        // also add the correct answer
        mapView.addAnnotation(actual)
        
        //convert both coordiantes to map points
        let point1 = MKMapPoint(guess.coordinate)
        let point2 = MKMapPoint(actual.coordinate)
        
        // calculate how many kilometers they were off, then subtract that from 500
        let distance = Int(point1.distance(to:point2) / 1000)
        // add that to their score; this will trigger the property observer
        score += distance
        
        // add an annotation to the correct pin telling the player what they score
        actual.subtitle = "You scored \(distance)"

        // tell the map view to select the correct answer, making it zoom in and show its title and subtitle
        mapView.selectAnnotation(actual, animated: true)
        
    }
    
    @objc func mapClicked(recognizer: NSClickGestureRecognizer) {
        if mapView.annotations.count == 0 {
            let location = recognizer.location(in: mapView)
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
            addPin(at: coordinates)
        } else {
            mapView.removeAnnotations(mapView.annotations)
            nextCity()
        }
        
        
    }
    
    func startNewGame() {
        score = 0
        
        // create example cities
        cities.append(Pin(title: "London", coordinate:
                            CLLocationCoordinate2D(latitude: 51.507222, longitude:
                                                    -0.1275)))
        cities.append(Pin(title: "Oslo", coordinate:
                            CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)))
        cities.append(Pin(title: "Paris", coordinate:
                            CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)))
        cities.append(Pin(title: "Rome", coordinate:
                            CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)))
        cities.append(Pin(title: "Washington DC", coordinate:
                            CLLocationCoordinate2D(latitude: 38.895111, longitude:
                                                    -77.036667)))
        
        cities.shuffle()
        
        // start playing the game
        nextCity()
    }
    
    func nextCity() {
        
        if let city = cities.popLast() {
            // Make this the city to guess
            currentCity = city
            questionLabel.stringValue = "Where is \(city.title!)"
        } else {
            // no more cities
            currentCity = nil
            let alert = NSAlert()
            alert.messageText = "Final score is \(score)"
            alert.runModal()
            
            // start a new game
            startNewGame()
        }
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
