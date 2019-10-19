# Schedule-Background-Task-New

### This is a example on how to uplouds images on Background in iOS 13 using new Framework
### called BackgroundTasks

### About the Project:
I did added 10 imges with high quailiy (every image have size between 1 MB to 3 MB) on Assets Folder
if you want to know here I get them is from https://unsplash.com/

When you open the application for the frist time it will save the 10 imges on Decoment Folder
and save the name of the image on Realm local database

on the application you will see the counter f the images on Realm folder

When the background task happend it will uploud image one by one to Firebase storage
and delete it from Realm and also delete the image from Decount Folder

You can check if it finish uplouding by wathing the count on screen it will become 0 if it uplouded every images 
also you can check the firebase storage to see if there is any image did uplouded 

### Notice ! :
we can know how and when exactlly the background will happend sometime happend immediately sometime after a while
this depend on my testing

### Prepare to use the Demo :
- The frist thing you need to do is change the `Bundele ID` to unique id
- create new `Firebase` Project and use the `Bundele ID` you did create
- change the Firebase Rule to

`service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write;
    }
  }
}`

because we only need it for testing only , it's not good idea to make it like this on Production version !

- move `GoogleService-Info.plist` that you did downloaded from `Firebase` website to the project
- you need to use `Cocoapods` if you don't already have it installed on you Mac install it from they website
- open Terminal
- move the project folder above `Terminal` icon . This is the fastest way to go directly indisd the project folder on `Terminal`
- then final step write `pod install` on terminal to install Firebase Storage and Realm Libreies 

I did exmplain everything on the project check the `BackgroundTaskService.swift` and `AppDelegate.swift` and also `SceneDelegate.swift`

maybe you will wondering what is SceneDelegate ?
this new on iOS 13 project the only thing you need to know NOW is you need to call `background task request` when the app moving to Background 
on `sceneDidEnterBackground` function inside `SceneDelegate.swift`

what if your project is old and you don't have SceneDelegate.swift ?
its ok only you need to open `AppDelegate` and add `applicationDidEnterBackground`
and inside it call `BackgroundTaskService.shared.enterBackground()`

### I did mention that maybe the background task won't happend immediately then how to debug it ?
Apple said you can debug the Background task by doing this steps 
- Connect you device to your Mac
- open Xcode project and run the project
- now go to home screen this will let ypu enter to the background
- return back to your project
- click on `Puese` button (this button you will find it above debug logs)
- now enter this line 

`e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.basil.imagesuploud"]`

notice that my background task idntifier is `com.basil.imagesuploud`
I did added it on info.plist file you need to change it depend on your Identifier. if you will only test my Demo project it will be the same idntifier

after write that line and click enter
Xcode will said

2019-10-19 17:00:14.615646+0300 Schedule Background Task New[48148:1564536] Simulating launch for task with identifier com.basil.imagesuploud

now click on `Play` button (this button you will found it above debug logs)

now the background will start immediately. you will see if it work or not !
return back to the application you will see it chagne to 0
and when you check the Firebase Storage you will find all the images there 

### one last thing is to debug if the system kill/stop the background task
same steps as before but only change it to 
`e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.basil.imagesuploud"]`

The great example on debugging it , you can test it if you do the above code and after that do the bloew code on very shurt time
you will notice the task stop before uplouding all images that mean it working fine !


### Resourse 
- https://developer.apple.com/videos/play/wwdc2019/707/
- https://developer.apple.com/documentation/backgroundtasks
- https://medium.com/snowdog-labs/managing-background-tasks-with-new-task-scheduler-in-ios-13-aaabdac0d95b

