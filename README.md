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
- create new `Firebase` Project and use the `Bundele ID` you did created
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
