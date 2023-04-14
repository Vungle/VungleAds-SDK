//
//  LONativeAdViewController.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/29/23.
//

/**
 IMPORTANT: Please review and set the placementID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Native is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 */

#import "LONativeAdViewController.h"
#import <VungleAdsSDK/VungleAdsSDK.h>
#import "CallbackLog.h"
#import "AppUtil.h"
#import "CallbackLogTableViewCell.h"

@interface LONativeAdViewController () <VungleNativeDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VungleNative *nativeAd;
@property (nonatomic, strong) NSArray *callbackLogs;
// Native Ad UI Components
@property (nonatomic, weak) IBOutlet UIView *nativeAdView;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet MediaView *mediaView;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *ratingLbl;
@property (nonatomic, weak) IBOutlet UILabel *sponsorLbl;
@property (nonatomic, weak) IBOutlet UILabel *adTextLbl;
@property (nonatomic, weak) IBOutlet UIButton *downloadBtn;

@property (nonatomic, weak) IBOutlet UILabel *placementLbl;
@property (nonatomic, weak) IBOutlet UIButton *loadBtn;
@property (nonatomic, weak) IBOutlet UIButton *playBtn;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (nonatomic, weak) IBOutlet UITableView *tableView;



@end

@implementation LONativeAdViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Liftoff Native Ad";
  self.placementLbl.text = self.placementId;
  
  self.callbackLogs = [self generateCallbackLogs];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

#pragma mark - IBAction Methods

- (IBAction)btnPressed:(id)sender {
  if (sender == self.loadBtn && self.placementId != nil) {
    [self loadNativeAd];
  } else if (sender == self.playBtn && [self.nativeAd canPlayAd]) {
    [self playNativeAd];
  } else if (sender == self.closeBtn) {
    [self closeNativeAd];
  }
}

#pragma mark - Private Methods

- (void)loadNativeAd {
  // clean up before load
  if (self.nativeAd != nil) {
    self.nativeAd.delegate = nil;
    self.nativeAd = nil;
    [self resetCallbackLogs];
  }
  
  self.nativeAd = [[VungleNative alloc] initWithPlacementId:self.placementId];
  self.nativeAd.delegate = self;
  [self.nativeAd load:nil];
}

- (void)playNativeAd {
  [self setUpNativeAdForDisplay];
  
  [self.nativeAd registerViewForInteractionWithView:self.nativeAdView
                                          mediaView:self.mediaView
                                      iconImageView:self.iconView
                                     viewController:self
                                     clickableViews:@[self.iconView,
                                                      self.downloadBtn,
                                                      self.nativeAdView]];
}

- (void)setUpNativeAdForDisplay {
  self.titleLbl.text = self.nativeAd.title;
  self.ratingLbl.text = [NSString stringWithFormat:@"Rating: %f", self.nativeAd.adStarRating > 0 ? self.nativeAd.adStarRating : 0];
  self.sponsorLbl.text = self.nativeAd.sponsoredText;
  self.adTextLbl.text = self.nativeAd.bodyText;
  [self.downloadBtn setTitle:self.nativeAd.callToAction forState:UIControlStateNormal];
  
  self.nativeAd.adOptionsPosition = NativeAdOptionsPositionTopRight;
}

- (void)closeNativeAd {
  [self.nativeAd unregisterView];
  
  // reset values inside the labels
  self.titleLbl.text = @"App Title";
  self.ratingLbl.text = @"App Rating";
  self.sponsorLbl.text = @"Sponsored by Text";
  self.adTextLbl.text = @"Body Text";
  [self.downloadBtn setTitle:@"CTA Text" forState:UIControlStateNormal];  
}

- (NSArray *)generateCallbackLogs {
 return @[
   [[CallbackLog alloc] initWithTitle:@"nativeAdDidLoad" index:0],
   [[CallbackLog alloc] initWithTitle:@"nativeAdDidTrackImpression" index:1],
   [[CallbackLog alloc] initWithTitle:@"nativeAdDidClick" index:2],
   [[CallbackLog alloc] initWithTitle:@"nativeAdDidFailToLoad" index:3],
   [[CallbackLog alloc] initWithTitle:@"nativeAdDidFailToPresent" index:4],
 ];
}

- (void)updateCallbackLogsWithTitle:(NSString *)title {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.callbackLogs = [AppUtil updateCallbackLogs:self.callbackLogs title:title];
    [self.tableView reloadData];
  });
}

- (void)resetCallbackLogs {
  self.callbackLogs = [AppUtil resetCallbackLogs:self.callbackLogs];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate / Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.callbackLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CallbackLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallbackLogTableCell" forIndexPath:indexPath];
  
  CallbackLog *log = self.callbackLogs[indexPath.row];
  if (log.isActive) {
    cell.callbackLbl.textColor = UIColor.labelColor;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.callbackLbl.textColor = UIColor.grayColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  cell.callbackLbl.text = log.title;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

#pragma mark - VungleNative Deleagate Methods

- (void)nativeAdDidLoad:(VungleNative *)native {
  NSLog(@"nativeAdDidLoad");
  [self updateCallbackLogsWithTitle:@"nativeAdDidLoad"];
}

- (void)nativeAdDidFailToLoad:(VungleNative *)native
                    withError:(NSError *)withError {
  NSLog(@"nativeAdDidFailToLoad");
  [self updateCallbackLogsWithTitle:@"nativeAdDidFailToLoad"];
}

- (void)nativeAdDidFailToPresent:(VungleNative *)native
                       withError:(NSError *)withError {
  NSLog(@"nativeAdDidFailToPresent");
  [self updateCallbackLogsWithTitle:@"nativeAdDidFailToPresent"];
}

- (void)nativeAdDidTrackImpression:(VungleNative *)native {
  NSLog(@"nativeAdDidTrackImpression");
  [self updateCallbackLogsWithTitle:@"nativeAdDidTrackImpression"];
}

- (void)nativeAdDidClick:(VungleNative *)native {
  NSLog(@"nativeAdDidClick");
  [self updateCallbackLogsWithTitle:@"nativeAdDidClick"];
}

@end
