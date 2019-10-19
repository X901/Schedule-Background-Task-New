////
//BackgroundTaskService.swift
//Schedule Background Task New
//
//Created by Basel Baragabah on 14/10/2019.
//Copyright © 2019 Basel Baragabah. All rights reserved.
//

import Foundation
import BackgroundTasks
import RealmSwift
import FirebaseStorage

// How to Make a background Task
//step 1 : click on your project >> Signing & Capabilities >> click on "+ Capability" and added Background fetch & Background processing

//step 2 : open Info.plist and add new key called Permitted background task scheduler identifiers and after that give a background Task identifier
// I need only one background task so I did add background Task identifier named com.basil.imagesuploud

class BackgroundTaskService {
static public let shared = BackgroundTaskService()
private init() {}
    
    func enterBackground() {
         print("Enter Background !!")
         
         //step 4: cancel all Background Task before start new one !
         cancelAllTaskRequests()
         
         //step 5: request The Background Task
         requestUplouadBackgroungTask()
    }

}

extension BackgroundTaskService {

    func cancelAllTaskRequests() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }

    //step 3 : you need to register the backround Task immediately when app launch
    func registerBackgroundTaks() {
        // notice that this identifier is the same on info.plist file
       BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.basil.imagesuploud", using: nil) { task in
        
        // step 4 : handle the background task and notice that we cast the task as a BGProcessingTask
        // this function you will do what every you want the background task to do on background
                   self.handleImageUploadingTask(task: task as! BGProcessingTask)
               }
    }

 
     func requestUplouadBackgroungTask() {
        
        // Here we must request the background task
        
        // notice that :-
        // There is 2 type on background :
        // - BGAppRefreshTask it only to refresh the content exactly it's that same as Backround fetch on old iOS versions that mean it must finish on only 30 sec !
        // - BGProcessingTask is for doing things that take minutes to finish and that what we need here

        //again when we want to request the background task wee need to write the identifier
        let request = BGProcessingTaskRequest(identifier: "com.basil.imagesuploud")
        
        //Notice we need internet that why we must make it true , so the system will do this task only if there is internet !
         request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
        
        // but we don't need power (device charging)
        //Apple recommend make it true if your will do task will take long time to complete
        //Like making a Backup for large user data
        //Tranning the ML module etc
        //remmber if you allow the ExternalPower you will remove the limit on CPU and GPU of the device
         request.requiresExternalPower = false
         
        //this also requird if you what a dely on making the task
        // for example you can make the task after 1 menute my multiply to 1
        // ypu can also Schedule the task to happend every week for example
        
        //Note: Apple said EarliestBeginDate should not be set to too far into the future.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 0 * 60)
         
         
         do {
            // don't forget to ssumbit the request
             try BGTaskScheduler.shared.submit(request)
         } catch {
             print("Could not schedule image : \(error)")
         }
         
     }
     

     func handleImageUploadingTask(task: BGProcessingTask) {
        requestUplouadBackgroungTask() // Recall
         
    
        // if for any reason the system choose to stop the task it will do any thing inside this
        // you need to stop anything your doing
                   task.expirationHandler = {
                     //This Block call by System
                     //Cancel your all taks & queues
                     self.cancelAllTaskRequests()
                    
                                                 }
       
         
         let realm = try! Realm()
         let realmOpject = realm.objects(ImageObject.self)
         
         if realmOpject.count > 0 {
         for object in realmOpject {
         
                         
                         if let imageName = object.imageName {
                             if let image = loadImageFromDocumentDirectory(imageName: imageName)  {
                                 
                                 if let imageData = image.jpegData(compressionQuality: 1.0) {
                                uploadProfileImageToFirebase(data: imageData, nameOfImage: imageName)
                                     
                                 }else {
                                     print("imageData error")
                                 }
                                 
                             }else {
                                 print("image or imageName error")
                             }

                         }else {
                             print("imagePath error")
                         }
   
         }
             task.setTaskCompleted(success: true)

         }else {
            task.setTaskCompleted(success: false)
        }

     }

       func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
                   let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                   let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                   let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                   if let dirPath = paths.first{
                       let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName+".jpg")
                    try? FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], ofItemAtPath: dirPath)

                       guard let image = UIImage(contentsOfFile: imageURL.path) else { return nil}
                       return image
                   }
                   return nil
               }
    
    func deleteImageFromDocumentDirectory(fileNameToDelete: String) {
                 var filePath = ""
                 
                 // Fine documents directory on device
                  let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
                 
                 if dirs.count > 0 {
                     let dir = dirs[0] //documents directory
                     filePath = dir.appendingFormat("/" + fileNameToDelete)
                     print("Local path = \(filePath)")
          
                 } else {
                     print("Could not find local directory to store file")
                     return
                 }
                 
                 
                 do {
                      let fileManager = FileManager.default
                     
                     // Check if file exists
                     if fileManager.fileExists(atPath: filePath) {
                         // Delete file
                         try fileManager.removeItem(atPath: filePath)
                     } else {
                         print("File does not exist")
                     }
          
                 }
                 catch let error as NSError {
                     print("An error took place: \(error)")
                 }

      }
        
        func uploadProfileImageToFirebase(data:Data , nameOfImage:String){
                   
            let storage = Storage.storage()

                   // Create a storage reference from our storage service
                   let storageRef = storage.reference()

          // Create a reference to the file you want to upload
          let imageRef = storageRef.child("images/\(nameOfImage).jpg")

          // Upload the file to the path "images/rivers.jpg"
           imageRef.putData(data, metadata: nil) { (metadata, error) in
 
                        let realm = try! Realm()
                        if let imageObject = realm.objects(ImageObject.self).filter("imageName = %@", nameOfImage).first {
                            
                        try! realm.write {
                                       realm.delete(imageObject)
                            self.deleteImageFromDocumentDirectory(fileNameToDelete: nameOfImage)
                        }
            }
     
               }

    }
}
