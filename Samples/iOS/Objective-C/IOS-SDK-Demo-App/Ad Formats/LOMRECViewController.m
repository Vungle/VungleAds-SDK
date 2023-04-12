//
//  LOMRECViewController.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/31/23.
//

/**
 IMPORTANT: Please review and set the placementID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that MREC is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 */

#import "LOMRECViewController.h"
#import <VungleAdsSDK/VungleAdsSDK.h>

@interface LOMRECViewController () <VungleBannerDelegate>
@property (nonatomic, strong) VungleBanner *mrecAd;
@end

@implementation LOMRECViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"Liftoff Medium Rectangle Ad";
}

#pragma mark - IBAction Methods

- (IBAction)btnPressed:(id)sender {
  if (sender == self.loadBtn && self.placementId != nil) {
    [self loadMrecAd];
  } else if (sender == self.playBtn && [self.mrecAd canPlayAd]) {
    [self playMrecAd];
  } else if (sender == self.closeBtn) {
    [self closeMrecAd];
  }
}

#pragma mark - Private Methods

- (void)loadMrecAd {
  // clean up before load
  if (self.mrecAd != nil) {
    self.mrecAd.delegate = nil;
    self.mrecAd = nil;
    [self resetCallbackLogs];
  }
  self.mrecAd = [[VungleBanner alloc] initWithPlacementId:self.placementId size:BannerSizeMrec];
  self.mrecAd.delegate = self;
  [self.mrecAd load:nil];
}

- (void)playMrecAd {
  [self.mrecAd presentOn:self.bannerAdContainer];
}

- (void)closeMrecAd {
  for (id subview in self.bannerAdContainer.subviews) {
    [subview removeFromSuperview];
  }
}

@end
