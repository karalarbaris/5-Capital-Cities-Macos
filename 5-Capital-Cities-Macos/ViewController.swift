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
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

