//
//  HomeViewController.h
//  Hi-IncreLocks
//
//  Created by tuanhi on 3/27/16.
//  Copyright © 2016 tuanhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnLockScreen;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnRateApp;


#pragma method of button

- (IBAction)btnLockScreenDidTap:(id)sender;
- (IBAction)btnHomeDidTap:(id)sender;
- (IBAction)btnRateAppDidTap:(id)sender;

@end
