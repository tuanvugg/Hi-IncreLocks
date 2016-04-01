//
//  DetailViewController.h
//  Hi-IncreLocks
//
//  Created by tuanhi on 3/27/16.
//  Copyright © 2016 tuanhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@import GoogleMobileAds;

typedef enum {
    mode_Lock,
    mode_Home,
} Mode;

@interface DetailViewController : UIViewController
{
    
    IBOutlet UIButton *btnAlbum;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnCamera;
    IBOutlet UIButton *btnWallpaper;
    IBOutlet UIButton *btnOverlay;
    IBOutlet UIButton *btnDone;
}



@property (nonatomic ,assign) Mode currentMode;
@property(nonatomic, strong) GADInterstitial *interstitial;

@property (weak, nonatomic) IBOutlet UIImageView *imvWallpaper;
@property (weak, nonatomic) IBOutlet  iCarousel *icarouselView;
@property (weak, nonatomic) IBOutlet UIImageView *imvSilder;
@property (weak, nonatomic) IBOutlet UIImageView *imvOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *imvBackground;


- (IBAction)btnBackDidTap:(id)sender;
- (IBAction)btnCameraDidTap:(id)sender;
- (IBAction)btnAlbumDidTap:(id)sender;
- (IBAction)btnWallpaperDidTap:(id)sender;
- (IBAction)btnOverlayDidTap:(id)sender;
- (IBAction)btnDoneDidTap:(id)sender;

@end
