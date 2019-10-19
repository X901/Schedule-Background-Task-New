# Schedule-Background-Task-New

### This is an example of how to uploads images on Background in iOS 13 using a new Framework called BackgroundTasks


### About the Project:
I did add ten images with high quality (every image have a size between 1 MB to 3 MB) on Assets Folder
if you want to know where I got them is from https://unsplash.com/

When you open the application for the first time, it will save 10 images on Document Folder
and save the names of images on Realm local database

on the application, you will see the counter of images on Realm database

When the background task happened, it will upload image one by one to Firebase storage
and delete it from Realm and also delete the image from Document folder

You can check if it finishes uploaded by watching the counter on the main screen, it will become 0 if it uploaded every image 
also you can check the firebase storage to see if there is any image did upload 


### Prepare to use the Demo :
- The first thing you need to do is change the `Bundle ID` to unique id
- create new `Firebase` Project and use the `Bundle ID` you did create
- change the Firebase Storage Rule to

`service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write;
    }
  }
}`

because we need it for testing only, it's not a good idea to make it like this on the Production version!

- move `GoogleService-Info.plist` that you did download from `Firebase` website to the project
- you need to use `Cocoapods` if you don't already have it installed on you Mac install it from their website
- open Terminal
- Move the project folder above `Terminal` icon. This is the fastest way to go directly inside the project folder on `Terminal`
- then final step write `pod install` on Terminal to install Firebase Storage and Realm Libraries 

I did explain everything on the project check the `BackgroundTaskService.swift` and `AppDelegate.swift` and also `SceneDelegate.swift`

Maybe you will wonder what is SceneDelegate ?
this new on iOS 13 project the only thing you need to know NOW is you need to call `background task request` when the app moving to Background 
on `sceneDidEnterBackground` function inside `SceneDelegate.swift`

what if your project is old and you don't have SceneDelegate.swift ?
its ok, You need to open `AppDelegate` and add `applicationDidEnterBackground`
and inside it call `BackgroundTaskService.shared.enterBackground()`

### I did mention that maybe the background task won't happen immediately then how to debug it?
Apple said you can debug the Background task by doing these steps 
- Connect your device to your Mac
- open Xcode project and run the project
- now go to home screen this will let you enter to the Background
- return back to your project
- Click on `Puese` button (this button you will found it above debug logs)
- now enter this line 

`e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.basil.imagesuploud"]`

notice that my background task identifier is `com.basil.imagesuploud`
I did add it to `info.plist` the file. You need to change it depending on your Identifier. if you only test my Demo project, it will be the same Identifier

after writing that line and click enter
Xcode will say

2019-10-19 17:00:14.615646+0300 Schedule Background Task New[48148:1564536] Simulating launch for task with identifier com.basil.imagesuploud

now click on `Play` button (this button you will found it above debug logs)

Now the Background will start immediately. You will see if it work or not!

return to the application you will see it change to 0
and when you check the Firebase Storage, you will found all the images there 

### one last thing is to debug if the system kill/stop the background task
same steps as before but only change it to 
`e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.basil.imagesuploud"]`

The excellent example of debugging it, you can test it if you do the above code and after that do the below code on short time
you will notice the task stop before uploading all images that mean it is working fine!


### Resources 
- https://developer.apple.com/videos/play/wwdc2019/707/
- https://developer.apple.com/documentation/backgroundtasks
- https://medium.com/snowdog-labs/managing-background-tasks-with-new-task-scheduler-in-ios-13-aaabdac0d95b

