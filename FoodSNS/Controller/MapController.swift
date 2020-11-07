//
//  Map2Controller.swift
//  ChemistrySNS
//
//  Created by 白数叡司 on 2020/10/31.
//

import UIKit
import MapKit
import CoreLocation
 
class MapController: UIViewController ,MKMapViewDelegate,
                                    CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        self.view.backgroundColor = UIColor(red:0.7,green:0.7,blue:0.7,alpha:1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        
        var topPadding: CGFloat = 0
        var bottomPadding: CGFloat = 0
        var leftPadding: CGFloat = 0
        var rightPadding: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
            leftPadding = window!.safeAreaInsets.left
            rightPadding = window!.safeAreaInsets.right
        }
 
        CLLocationManager.locationServicesEnabled()
 

        let status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.notDetermined) {
            print("NotDetermined")
            locationManager.requestWhenInUseAuthorization()
        }
        else if(status == CLAuthorizationStatus.restricted){
            print("Restricted")
        }
        else if(status == CLAuthorizationStatus.authorizedWhenInUse){
            print("authorizedWhenInUse")
        }
        else if(status == CLAuthorizationStatus.authorizedAlways){
            print("authorizedAlways")
        }
        else{
            print("not allowed")
        }
 
        locationManager.startUpdatingLocation()

        let mapView = MKMapView()
        
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        let rect = CGRect(x: leftPadding,
                          y: topPadding,
                          width: screenWidth - leftPadding - rightPadding,
                          height: screenHeight - topPadding - bottomPadding )
        
        mapView.frame = rect
        mapView.delegate = self

        var region:MKCoordinateRegion = mapView.region
        region.center = mapView.userLocation.coordinate
        
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region,animated:true)

        self.view.addSubview(mapView)
        mapView.mapType = MKMapType.hybrid
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("region changed")
    }
    
}

