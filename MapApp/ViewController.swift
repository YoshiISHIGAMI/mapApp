//
//  ViewController.swift
//  MapApp
//
//  Created by Yoshi Ishigami on 2015/09/26.
//  Copyright © 2015年 Yoshi Ishigami. All rights reserved.
//

import UIKit
import Parse
import MapKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //マップへタップイベント追加
        let gesture = UILongPressGestureRecognizer(target: self, action: "tapMapView:")
        mapView.addGestureRecognizer(gesture)
        
        fetchLocationObject()
        
    }

    
    //既に保存されているピンを取得
    func fetchLocationObject(){
        
        let query = PFQuery(className: "Location")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            //Swift2.0からのnilチェック　「if let 〜」よりもスコープが広く、nilならreturnするパターンが書ける
            guard let objects = objects else{
                return
            }
            
            //現在のピンを削除
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for object in objects{
                
                if let geo = object["geo"] as? PFGeoPoint{
                    
                    let pin = Pin(geo: CLLocationCoordinate2D(latitude: geo.latitude,
                        longitude: geo.longitude))
                    pin.title = object["msg"] as? String
                    
                    self.mapView.addAnnotation(pin)
                    
                }
            }
            
        }
        
    }
    
    //マップをタップした際のイベント
    func tapMapView(gesture:UITapGestureRecognizer){
        
        let point = gesture.locationInView(view)
        let geo = mapView.convertPoint(point, toCoordinateFromView: mapView)
        
        
        let alert = UIAlertController(title: "スポット登録", message: "この場所に残すメッセージを入力してください。", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "登録", style: .Default, handler: { (action) -> Void in
            
            let pin = Pin(geo: geo)
            self.mapView.addAnnotation(pin)
            
            self.sendLocation(geo,msg: (alert.textFields?.first?.text)!)
            
            
        }))
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "メッセージ"
        }
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //ピン登録イベント
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        var annotationV = mapView.dequeueReusableAnnotationViewWithIdentifier("Annotation")
        if annotationV == nil{
            annotationV = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationV!.canShowCallout = true
            annotationV!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        annotationV!.annotation = annotation
        
        
        return annotationV
        
    }
    
    //コールアウトの詳細ボタンをタップした際
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print(view.annotation)
        
    }
    
    //Parse.comへロケーションを送る
    func sendLocation(location:CLLocationCoordinate2D, msg:String = ""){
        
        let obj = PFObject(className: "Location")
        let geo = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
        obj["geo"] = geo
        obj["msg"] = msg
        obj.saveInBackgroundWithBlock({ (success, error) -> Void in
            print("保存しました")
        })
        
    }

}

