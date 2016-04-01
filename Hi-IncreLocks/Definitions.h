//
//  Definitions.h
//  Hi-IncreLocks
//
//  Created by tuanhi on 3/27/16.
//  Copyright © 2016 tuanhi. All rights reserved.
//

#ifndef Definitions_h
#define Definitions_h


#define kLinkAppstore                               @"http://linkappstorehere.com"
#define kAppstoreID                                 @"552035781"


///Register google admob account at https://www.google.com/admob/ and create a new AdUnit ID for Interstitial (fullscreen ad). - NOT BANNER -
#define kGoogleAdmobInterstitialAdUnitID            @"ca-app-pub-4878057881792520/7515645491"
//@"Admob AdUnit ID here" ////


#define kRandomKeyShowAdmob                         -1


//////==== RATE APP REMINDER ====///////
//// More examples see here: https://github.com/arashpayan/appirater#production

#define kRateAppReminder_DaysUntilRemind            1
#define kRateAppReminder_AppLaunchUntilRemind       2
#define kRateAppReminder_DaysBeforeRemindAgain      2

//////==== END RATE APP REMINDER ====///////




#define kTotalWallpaperCount                        8
#define kTemplateWallpaperFile                      @"wallpaper_%d.png"


/////Overlay HomeScreen: Grid Icon
#define kTotalOverlayHomescreenCount_IPHONE6PLUS    8
#define kTotalOverlayHomescreenCount_IPHONE6        8
#define kTotalOverlayHomescreenCount_IPHONE5        8
#define kTotalOverlayHomescreenCount_IPHONE4        8

#define kTemplateOverlayHomescreen                  @"%@frame_%d.png"



/////Overlay Lockscreen: Slide to unlock + Clock
#define kTotalOverlayLockscreenCount_IPHONE6PLUS    8
#define kTotalOverlayLockscreenCount_IPHONE6        8
#define kTotalOverlayLockscreenCount_IPHONE5        8
#define kTotalOverlayLockscreenCount_IPHONE4        8


#define kTemplateOverlayLockscreen                  @"%@lockscreen_%d.png"


#define kButtonTitle_No             @"No"
#define kButtonTitle_Yes            @"Yes"
#define kButtonTitle_OK             @"OK"


////alert message
#define kAlertTitle_SaveImage       @"Save Image?"
#define kAlertMessage_SaveImage     @"Do you want to save Image?"


#define kAlertTitle_SaveImageDone       @"Image Saved."
#define kAlertMessage_SaveImageDone     @"In order to this app to work correctly you must disable parallax effect.\nSimply head over to Settings -> General -> Accessibility -> Reduce Motion and turn in ON"
///DO NOT CHANGE THIS
#define kTotalOverlayHomescreenCount                (IS_IPHONE_6_PLUS ? kTotalOverlayHomescreenCount_IPHONE6PLUS : IS_IPHONE_6 ? kTotalOverlayHomescreenCount_IPHONE6 : IS_IPHONE_5 ? kTotalOverlayHomescreenCount_IPHONE5 : IS_IPHONE_4 ? kTotalOverlayHomescreenCount_IPHONE4 : kTotalOverlayHomescreenCount_IPHONE4 )



///DO NOT CHANGE THIS
#define kTotalOverlayLockscreenCount                (IS_IPHONE_6_PLUS ? kTotalOverlayLockscreenCount_IPHONE6PLUS : IS_IPHONE_6 ? kTotalOverlayLockscreenCount_IPHONE6 : IS_IPHONE_5 ? kTotalOverlayLockscreenCount_IPHONE5 : IS_IPHONE_4 ? kTotalOverlayLockscreenCount_IPHONE4 : kTotalOverlayLockscreenCount_IPHONE4 )



//
//
// #define kTAG_CellImage     100














@interface Definitions : NSObject

@end

#endif /* Definitions_h */
