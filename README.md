# Schedule-Background-Task-New

### This is an example on how to upload images in Background on iOS 13 using a framework called BackgroundTasks

### About the Project:
I added ten high quailiy images (every image have size between 1 MB to 3 MB) in the Assets Folder,
You can find these images at https://unsplash.com/

When you open the application for the frist time it will save ten images in the documents folder along with the names of the images locally on Realm

When the background task finishes it will upload each to the Firebase storage and then delete it from Realm and the documents folder.

You can check if it finishes uploaded by watching the counter on the main screen, it will become 0 if it uploaded every image 
also you can check the firebase storage to see if there is any image did upload 

### Using the Demo project:
- First change the `Bundle ID` to unique id
- Create a new `Firebase` Project and use the `Bundle ID` you created in the first step
- Change the Firebase Storage Rule to the following:

`service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write;
    }
  }
}`

#### NOTE: This is for testing purposes only and this rule should not be used in production!

- Download and move `GoogleService-Info.plist` to the project, this file can be found on `Firebase`
- You need to have `Cocoapods` installed before continuing
- Open Terminal
- Drill down to the project on terminal. One easy way to do this is by typing cd and then dragging the folder to terminal
- Once you have drilled down to your project then type and enter`pod install`, this will install the libraries Firebase Storage and Realm  


For more explanation check the following files `BackgroundTaskService.swift` and `AppDelegate.swift` and `SceneDelegate.swift`

You are probably wondering what is SceneDelegate?
This is new on iOS 13. The only thing you need to know now is that you need to call `background task request` when the app moves to Background in the function `sceneDidEnterBackground` inside the file `SceneDelegate.swift`


What should you do if your project doesn't have SceneDelegate.swift ?
You need to open `AppDelegate` and add `applicationDidEnterBackground`
and inside it call `BackgroundTaskService.shared.enterBackground()`

### Here are steps for debugging, if the background task doesn't trigger immediately.
Apple said you can debug the Background task by doing this steps 
- Connect you device to your Mac
- open Xcode project and run the project
- now go to the home screen this will let you enter into background mode
- go back to your project
- click on the `Pause` button (this button you will found it above debug logs)

- now enter this line 

`e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.basil.imagesuploud"]`

notice that my background task identifier is `com.basil.imagesuploud`
You need to change the identifier in the `info.plist` file for your project to match the bundle id. For my demo project you don't need to change anything

After you write that line and click enter

Xcode will say

2019-10-19 17:00:14.615646+0300 Schedule Background Task New[48148:1564536] Simulating launch for task with identifier com.basil.imagesuploud

Now click on the `Play` button (this button you will found it above debug logs)

Now the background will start immediately. You will see if it works or not

Go back to the application and you will see it change to 0
and when you check the Firebase Storage you will find all the images there 

### One last thing is to debug if the system kills or stops the background task
same steps as above but only change the command to 
`e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.basil.imagesuploud"]`

The excellent example of debugging it, you can test it if you do the above code and after that do the below code on short time
you will notice the task stop before uploading all images that mean it is working fine!


### Resources 
- https://developer.apple.com/videos/play/wwdc2019/707/
- https://developer.apple.com/documentation/backgroundtasks
- https://medium.com/snowdog-labs/managing-background-tasks-with-new-task-scheduler-in-ios-13-aaabdac0d95b

