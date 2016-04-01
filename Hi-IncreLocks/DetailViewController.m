//
//  DetailViewController.m
//  Hi-IncreLocks
//
//  Created by tuanhi on 3/27/16.
//  Copyright © 2016 tuanhi. All rights reserved.
//

#import "DetailViewController.h"
#import "CommonUtils.h"
#import "Masonry.h"
#import "SIAlertView.h"
#import "Definitions.h"
#define kTAG_CellImage     100

typedef enum {
    state_WallPaper,
    state_Overlay,
    state_Done
} State;



//
#define kPreviewMarginTop      (IS_IPHONE_6_PLUS ? 60.0f : IS_IPHONE_4 ? 60.0f : 50.0f)
#define kPreviewMarginLeft     (IS_IPHONE_6_PLUS ? 60.0f : IS_IPHONE_4 ? 60.0f : 50.0f)



@interface DetailViewController ()<iCarouselDataSource,iCarouselDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,GADInterstitialDelegate>
@property (nonatomic ,strong)    UIImage *chosedWallPaper;
@property (nonatomic ,strong)    NSMutableArray *images;
@property (nonatomic ,strong)    NSMutableArray *images2;

@property (nonatomic ,strong)    NSMutableArray *imagesWallPaper;
@property (nonatomic ,strong)    NSMutableArray *imagesOverLay;
@property (nonatomic ,strong)    NSMutableArray *displayArray;

@property (nonatomic ,assign)    NSInteger indexWallPaper;
@property (nonatomic ,assign)    NSInteger indexOverlay;
@property (nonatomic ,assign)    State currentState;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAutolayOut];
    
    

    self.images = [[NSMutableArray alloc]init];
    self.images2 = [[NSMutableArray alloc]init];
    self.imagesOverLay = [[NSMutableArray alloc]init];
    self.imagesWallPaper = [[NSMutableArray alloc]init];
    self.displayArray = [[NSMutableArray alloc]init];
    

    _currentState = state_WallPaper;
    self.icarouselView.delegate = self;
    self.icarouselView.dataSource = self;
    [self configIcarouselView];
    [self checkModeAndLoadDataInput];
    
    self.icarouselView.type = iCarouselTypeLinear;
    [self.icarouselView reloadData];
    
    // import ADs

    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-5006509190725017/2190724289"];
    GADRequest *request = [GADRequest request];
    //load request

    [self.interstitial loadRequest:request];
    request.testDevices =  @[ kGADSimulatorID ];

    
    // push ADS
    
    [self pushADS];
    // Do any additional setup after loading the view.
}

// ads
- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-5006509190725017/2190724289"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}
-(void)pushADS
{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkModeAndLoadDataInput
{
  
    NSString *deviceName;
    deviceName = [CommonUtils returnStringWithDevice];
    for (int i = 0; i < kTotalWallpaperCount; i++) {
        NSString *fileName = [NSString stringWithFormat:kTemplateWallpaperFile, i+1];
        [_imagesWallPaper addObject:fileName];
    }
    
    if (_currentMode == mode_Lock) {
        for (int i = 0; i < kTotalOverlayLockscreenCount; i++) {
            NSString *fileName = [NSString stringWithFormat:kTemplateOverlayLockscreen,deviceName, i+1];
            [_imagesOverLay addObject:fileName];
            NSLog(@"file name %@",fileName);
        }
        NSString *imgOverlayName = [NSString stringWithFormat:@"%@clock_preview.png",deviceName];
        UIImage *imgOverlay = [UIImage imageNamed:imgOverlayName];
        _imvOverlay.image = imgOverlay;
    }

    
    if (_currentMode == mode_Home) {
        
        for (int i = 0; i < kTotalOverlayHomescreenCount; i++) {
            NSString *fileName = [NSString stringWithFormat:kTemplateOverlayHomescreen,deviceName, i+1];
            [_imagesOverLay addObject:fileName];
        }
         NSString *imgOverlayName = [NSString stringWithFormat:@"%@icon_preview.png",deviceName];
        UIImage *imgOverlay = [UIImage imageNamed:imgOverlayName];
        _imvOverlay.image = imgOverlay;

    }
    _displayArray = _imagesWallPaper;
    _chosedWallPaper = [UIImage imageNamed:[_displayArray objectAtIndex:_indexWallPaper]];
    [_icarouselView reloadData];
    
}

-(void)configAlert
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Save Image?" andMessage:@"Do you want to save Image?"];
    
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button NO Clicked");
                          }];
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button YES Clicked");
                              
                              [self exportImage];
                          }];

    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {

    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {

    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {

    };
    
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    
    [alertView show];
}

#pragma AutoLayOut

-(void)configAutolayOut
{
    
    CGSize applicationSize = [UIScreen mainScreen].bounds.size;
    CGFloat previewWidth = applicationSize.width - kPreviewMarginLeft * 2.0;
    CGFloat previewHeight = previewWidth * applicationSize.height / applicationSize.width;

    [self.view addSubview:self.icarouselView];
    [self.view addSubview:self.imvOverlay];
    [self.view addSubview:self.imvWallpaper];
    [self.view addSubview:self.imvSilder];
    
    [self.view insertSubview:_imvSilder aboveSubview:_imvWallpaper];
    [self.view insertSubview:_icarouselView aboveSubview:_imvSilder];
    [self.view insertSubview:_imvOverlay aboveSubview:_icarouselView];
    
    
    float paddingBottom = applicationSize.height - previewHeight - kPreviewMarginTop;
    UIEdgeInsets paddingOtherView = UIEdgeInsetsMake(kPreviewMarginTop, kPreviewMarginLeft,paddingBottom, kPreviewMarginLeft);
    UIEdgeInsets paddingIcarousel = UIEdgeInsetsMake(kPreviewMarginTop, 0,paddingBottom, 0);
    [self makeConstraintsfor:self.imvWallpaper withPadding:paddingOtherView withSuperView:self.self.view];
    [self makeConstraintsfor:self.imvSilder withPadding:paddingOtherView withSuperView:self.self.view];
    [self makeConstraintsfor:self.imvOverlay withPadding:paddingOtherView withSuperView:self.view];
    [self makeConstraintsfor:self.icarouselView withPadding:paddingIcarousel withSuperView:self.view];

    

    
    [_icarouselView reloadData];
    
    _imvWallpaper.clipsToBounds = YES;
    _imvOverlay.clipsToBounds = YES;
    _imvSilder.clipsToBounds = YES;
    _icarouselView.clipsToBounds = YES;
    


    NSLog(@"%f %f %f",kPreviewMarginTop,kPreviewMarginTop,paddingBottom);
}
-(void)makeConstraintsfor:(UIView*)view withPadding:(UIEdgeInsets)padding withSuperView:(UIView*)superView
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(superView.mas_left).with.offset(padding.left);
        make.bottom.equalTo(superView.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(superView.mas_right).with.offset(-padding.right);
    }];
}


-(void)makeContrainsfor:(UIView*)view EqualTo:(UIView*)view2
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view2);
    }];
}



-(void)moveToState:(State)state
{
    _currentState = state;
    
    switch (_currentState) {
        case state_WallPaper:
            btnAlbum.hidden = NO;
            btnCamera.hidden = NO;
            _imvWallpaper.image = nil;
            _imvSilder.image = nil;
            _icarouselView.hidden = NO;
            _imvSilder.hidden = YES;
            break;
        case state_Overlay:
            btnAlbum.hidden = YES;
            btnCamera.hidden = YES;
            _imvSilder.hidden = YES;
            self.imvWallpaper.image = _chosedWallPaper;
            _displayArray = _imagesOverLay;
            [_icarouselView reloadData];
            [_icarouselView setCurrentItemIndex:0];
            
            break;
        case state_Done:
            _icarouselView.hidden =YES;
            btnAlbum.hidden = YES;
            btnCamera.hidden = YES;
            _imvWallpaper.hidden = NO;
            _imvSilder.hidden = NO;
            [self configAlert];
            
        default:
            break;
    }
    
    
}

// Export Image

-(void)exportImage
{
    UIView *viewExport = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *imvExportImage1 = [[UIImageView alloc]initWithFrame:viewExport.bounds];
    imvExportImage1.image = _imvWallpaper.image;
    imvExportImage1.contentMode = UIViewContentModeScaleAspectFill;
    [viewExport addSubview:imvExportImage1];
    
    UIImageView *imvExportImage2 = [[UIImageView alloc]initWithFrame:viewExport.bounds];
    imvExportImage2.image = _imvSilder.image;
    imvExportImage2.contentMode = UIViewContentModeScaleAspectFill;
    [viewExport addSubview:imvExportImage2];
    
    //export this view to image
    UIImage *imgExport = [UIImage captureImageFromView:viewExport inFrame:viewExport.bounds];
    
    //save to gallery
    UIImageJPEGRepresentation(imgExport, 1.0);
    
    UIImageWriteToSavedPhotosAlbum(imgExport, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        //save OK
        NSLog(@"Export Image DONE");
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:kAlertTitle_SaveImageDone
                                                         andMessage:kAlertMessage_SaveImageDone];
        
        [alertView addButtonWithTitle:LOCALIZE(kButtonTitle_OK)
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {

                              }];
        
        
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
        
        [alertView show];
        
    } else {
        //inform error
        NSLog(@"Export Image Error: %@", [error localizedDescription]);
    }
    
}
#pragma mark iCarousel


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;
{
    
    [self.icarouselView reloadData];
    
    if (_currentState == state_WallPaper)
    {
        _chosedWallPaper = [UIImage imageNamed:[_displayArray objectAtIndex:_indexWallPaper]];
        [self moveToState:state_Overlay];
    }
    else if (_currentState == state_Overlay)
    {
        _imvSilder.image =[UIImage imageNamed:[_displayArray objectAtIndex:_indexOverlay]];
        [self moveToState:state_Done];
    }
}


- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.icarouselView.currentItemIndex));
    
    if (_currentState == state_WallPaper) {
        _indexWallPaper = self.icarouselView.currentItemIndex;
    }
    if (_currentState == state_Overlay) {
        _indexOverlay  = self.icarouselView.currentItemIndex;
    }

}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSInteger count = (_currentState == state_WallPaper ? _imagesWallPaper.count : _imagesOverLay.count);
    
    return count;
}




- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    
    UIImageView *itemView;
    
    if (view == nil)
    {
         view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _imvOverlay.frame.size.width, _imvOverlay.frame.size.height)];
        
        
         itemView = [[UIImageView alloc]initWithFrame:_imvOverlay.frame];
         itemView.contentMode = UIViewContentModeScaleToFill;
         itemView.contentMode = UIViewContentModeScaleAspectFill;
        itemView.tag = kTAG_CellImage;
        
        [view addSubview:itemView];
        view.clipsToBounds = YES;
    }
    else
    {
        itemView = (UIImageView*) [view viewWithTag:kTAG_CellImage];
    }
 
    itemView.image = [UIImage imageNamed:[_displayArray objectAtIndex:index]];
 


    return itemView;
    
}
-(void)configIcarouselView
{
    _icarouselView.ignorePerpendicularSwipes = YES;
    _icarouselView.centerItemWhenSelected = YES;
    _icarouselView.decelerationRate = 0.5f;
}

#pragma mark Icaroues DataSource

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50.0f];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.icarouselView.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.icarouselView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        {
            return 0.0f;
        }
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
            //        {
            //            return 0.0f;
            //        }
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}



- (IBAction)btnBackDidTap:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    _icarouselView.hidden = YES;
}

#pragma mark camera and album

- (IBAction)btnCameraDidTap:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
                                                    [myAlertView show];
        
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
   _chosedWallPaper = chosenImage;
    _imvWallpaper.contentMode = UIViewContentModeScaleAspectFill;
    [self moveToState:state_Overlay];
    [_icarouselView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma -
#pragma mark Btn Tap Action METHOD

- (IBAction)btnAlbumDidTap:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)btnWallpaperDidTap:(id)sender {
    
//    [self pushADS];
    
    if (_currentState == state_WallPaper)
    {
        return;
    }
    else
    {
        [self moveToState:state_WallPaper];
        [_icarouselView reloadData];
        _displayArray = _imagesWallPaper;
        _icarouselView.hidden = NO;
        [_icarouselView setCurrentItemIndex:0];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//end

- (IBAction)btnOverlayDidTap:(id)sender {
    
    if (_currentState == state_Overlay) {
        return;
    }
    else{
        
        
        [self moveToState:state_Overlay];
        _imvWallpaper.image = _chosedWallPaper;
        _icarouselView.hidden = NO;
        _displayArray = _imagesOverLay;
        [_icarouselView reloadData];
        [_icarouselView setCurrentItemIndex:0];
    }
}

- (IBAction)btnDoneDidTap:(id)sender {
    
    if (_currentState == state_WallPaper) {
        _imvWallpaper.image = _chosedWallPaper;
        _icarouselView.hidden = YES;
        [self moveToState:state_Done];
    }else if(_currentState == state_Overlay)
    {
        _imvSilder.image = [UIImage imageNamed:[_imagesOverLay objectAtIndex:_indexOverlay]];
        _icarouselView.hidden = YES;
        [self moveToState:state_Done];
    }else if (_currentState == state_Done)
    {
        [self moveToState:state_Done];
        
    }
    

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
