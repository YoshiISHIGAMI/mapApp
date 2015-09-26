//
//  pin.swift
//  MapApp
//
//  Created by Yoshi Ishigami on 2015/09/26.
//  Copyright © 2015年 Yoshi Ishigami. All rights reserved.
//

import MapKit

//アノテーションクラス
class Pin :NSObject, MKAnnotation{
    
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title:String?
    
    init(geo:CLLocationCoordinate2D){
        coordinate = geo
    }
    
}