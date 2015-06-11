//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Benjamin Tsai on 6/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

protocol PhotoMapViewControllerDelegate {
    func photoMapViewController(sender: UIViewController, didSelectLatitude: Double, longitude: Double)
}

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoMapViewControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
    }
    
    @IBAction func onCamera(sender: AnyObject) {
        NSLog("onCamera")
        
        var vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        var editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
        dismissViewControllerAnimated(true, completion: nil)
        
        performSegueWithIdentifier("mapToLocationSegue", sender: self)
    }
    
    func photoMapViewController(sender: UIViewController, didSelectLatitude: Double, longitude: Double) {
        dismissViewControllerAnimated(true, completion: nil)
        
        NSLog("Add annotation \(didSelectLatitude) - \(longitude)")
        
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: didSelectLatitude, longitude: longitude)
        point.title = "\(didSelectLatitude)"
        
        mapView.addAnnotation(point)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView.canShowCallout = true
            annotationView.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navVc = segue.destinationViewController as! UINavigationController
        let locationVc = navVc.topViewController as! LocationsViewController
        locationVc.photoViewDelegate = self
    }
}
