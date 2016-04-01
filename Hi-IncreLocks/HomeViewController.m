//
//  HomeViewController.m
//  Hi-IncreLocks
//
//  Created by tuanhi on 3/27/16.
//  Copyright © 2016 tuanhi. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "CommonUtils.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnLockScreenDidTap:(id)sender {
    
    
    
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    detailVC.currentMode = mode_Lock;

    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (IBAction)btnHomeDidTap:(id)sender;
{
    
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailVC.currentMode = mode_Home;

    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

- (IBAction)btnRateAppDidTap:(id)sender {
    
    [CommonUtils openURLExternalHandlerForLink:@"http://linkappstorehere.com"];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
