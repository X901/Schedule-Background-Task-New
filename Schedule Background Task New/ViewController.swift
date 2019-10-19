////
//ViewController.swift
//Schedule Background Task
//
//Created by Basel Baragabah on 11/10/2019.
//Copyright © 2019 Basel Baragabah. All rights reserved.
//

import UIKit
import FirebaseStorage
import RealmSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var realmItemCountLabel: UILabel!

    
    let defaults = UserDefaults.standard
    let imageAddedBeforeKey = "imageAddedBefore"

    override func viewDidLoad() {
        super.viewDidLoad()
        
       saveImagesToRealm()
        
      displayHowManyItemsOnRealm()
        
    }
    
    func saveImagesToRealm(){
        let imageAddedBefore = defaults.bool(forKey: imageAddedBeforeKey)

               if !imageAddedBefore {
                   
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-1")!, imageName: "image-1")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-2")!, imageName: "image-2")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-3")!, imageName: "image-3")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-4")!, imageName: "image-4")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-5")!, imageName: "image-5")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-6")!, imageName: "image-6")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-7")!, imageName: "image-7")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-8")!, imageName: "image-8")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-9")!, imageName: "image-9")
                   saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage(named: "image-10")!, imageName: "image-10")

                      defaults.set(true, forKey: imageAddedBeforeKey)
                   
                   print("images did add to Realm !!")
               }else {
                   print("no need to add images to Realm")
               }
    }
    
    func displayHowManyItemsOnRealm(){
          do {
        
          let realm = try Realm()
        
         let realmOpject = realm.objects(ImageObject.self)

            if realmOpject.count > 0 {
                realmItemCountLabel.text = "\(realmOpject.count)"
            }else {
                realmItemCountLabel.text = "0"
            }

                    } catch {
                        print("error Realm items count", error)
                    }

        
    }
    
    
    

    private func saveImageToDecumentFolderAndSaveTheReferenceToRealmFile(image: UIImage , imageName: String) {
        
        var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }

        let fileURL = documentsUrl.appendingPathComponent(imageName + ".jpg")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
           try? imageData.write(to: fileURL, options: .atomic)
            
              do {
            
                            let realm = try Realm()
            
                           var myImageObject = ImageObject()
            
                            myImageObject = ImageObject(imageName: imageName)
            
                            try! realm.write {
                                realm.add(myImageObject)
                            }
            
                        } catch {
                            print("error saving", error)
                        }

        }
    }




}

