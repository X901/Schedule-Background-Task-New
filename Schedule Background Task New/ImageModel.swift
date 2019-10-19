////
//ImageModel.swift
//Schedule Background Task New
//
//Created by Basel Baragabah on 17/10/2019.
//Copyright © 2019 Basel Baragabah. All rights reserved.
//

import Foundation
import RealmSwift

class ImageObject:Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var imageName : String? = nil

    convenience init(imageName:String?){
        self.init()
        self.imageName = imageName
    }

    
    override static func primaryKey() -> String? {
           return "id"
       }
}
