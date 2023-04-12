//
//  LOBannerViewController.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/29/23.
//

/**
 IMPORTANT: Please review and set the placementID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Banner is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 */

#import "LOBannerViewController.h"
#import <VungleAdsSDK/VungleAdsSDK.h>
#import "CallbackLog.h"
#import "AppUtil.h"
#import "CallbackLogTableViewCell.h"

@interface LOBannerViewController () <VungleBannerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VungleBanner *bannerAd;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *placementLbl;
@end

@implementation LOBannerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Liftoff Banner Ad";
  self.placementLbl.text = self.placementId;
  self.callbackLogs = [self generateCallbackLogs];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
}

#pragma mark - IBAction Methods

- (IBAction)btnPressed:(id)sender {
  if (sender == self.loadBtn && self.placementId != nil) {
    [self loadBannerAd];
  } else if (sender == self.playBtn && [self.bannerAd canPlayAd]) {
    [self playBannerAd];
  } else if (sender == self.closeBtn) {
    [self closeBannerAd];
  }
}

#pragma mark - Private Methods

- (void)loadBannerAd {
  // clean up before load
  if (self.bannerAd != nil) {
    self.bannerAd.delegate = nil;
    self.bannerAd = nil;
    [self resetCallbackLogs];
  }
  /**
   Banner Sizes:
      BannerSize.regular = 320x50
      BannerSize.short = 300x50
      BannerSize.leaderboard = 720x50
   */
  self.bannerAd = [[VungleBanner alloc] initWithPlacementId:self.placementId
                                                       size:BannerSizeRegular];
  self.bannerAd.delegate = self;
  [self.bannerAd load:nil];
}

- (void)playBannerAd {
  [self.bannerAd presentOn:self.bannerAdContainer];
}

- (void)closeBannerAd {
  for (id subview in self.bannerAdContainer.subviews) {
    [subview removeFromSuperview];
  }
}

- (NSArray *)generateCallbackLogs {
  return @[
    [[CallbackLog alloc] initWithTitle:@"bannerAdDidLoad" index:0],
    [[CallbackLog alloc] initWithTitle:@"bannerAdWillPresent" index:1],
    [[CallbackLog alloc] initWithTitle:@"bannerAdDidPresent" index:2],
    [[CallbackLog alloc] initWithTitle:@"bannerAdDidTrackImpression" index:3],
    [[CallbackLog alloc] initWithTitle:@"bannerAdDidClick" index:4],
    [[CallbackLog alloc] initWithTitle:@"bannerAdWillLeaveApplication" index:5],
    [[CallbackLog alloc] initWithTitle:@"bannerAdWillClose" index:6],
    [[CallbackLog alloc] initWithTitle:@"bannerAdDidClose" index:7],
    [[CallbackLog alloc] initWithTitle:@"bannerAdDidFailToLoad" index:8],
    [[CallbackLog alloc] initWithTitle:@"bannerAdDidFailToPresent" index:9]
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

#pragma mark - UITableView Delegate / Datasource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

#pragma mark - VungleBanner Delegate Methods

- (void)bannerAdDidLoad:(VungleBanner *)banner {
  NSLog(@"bannerAdDidLoad");
  [self updateCallbackLogsWithTitle:@"bannerAdDidLoad"];
}

- (void)bannerAdDidFailToLoad:(VungleBanner *)banner
                    withError:(NSError *)withError {
  NSLog(@"bannerAdDidFailToLoad");
  [self updateCallbackLogsWithTitle:@"bannerAdDidFailToLoad"];
}

- (void)bannerAdWillPresent:(VungleBanner *)banner {
  NSLog(@"bannerAdWillPresent");
  [self updateCallbackLogsWithTitle:@"bannerAdWillPresent"];
}

- (void)bannerAdDidPresent:(VungleBanner *)banner {
  NSLog(@"bannerAdDidPresent");
  [self updateCallbackLogsWithTitle:@"bannerAdDidPresent"];
}

- (void)bannerAdDidFailToPresent:(VungleBanner *)banner
                       withError:(NSError *)withError {
  NSLog(@"bannerAdDidFailToPresent");
  [self updateCallbackLogsWithTitle:@"bannerAdDidFailToPresent"];
}

- (void)bannerAdDidTrackImpression:(VungleBanner *)banner {
  NSLog(@"bannerAdDidTrackImpression");
  [self updateCallbackLogsWithTitle:@"bannerAdDidTrackImpression"];
}

- (void)bannerAdDidClick:(VungleBanner *)banner {
  NSLog(@"bannerAdDidClick");
  [self updateCallbackLogsWithTitle:@"bannerAdDidClick"];
}

- (void)bannerAdWillLeaveApplication:(VungleBanner *)banner {
  NSLog(@"bannerAdWillLeaveApplication");
  [self updateCallbackLogsWithTitle:@"bannerAdWillLeaveApplication"];
}

- (void)bannerAdWillClose:(VungleBanner *)banner {
  NSLog(@"bannerAdWillClose");
  [self updateCallbackLogsWithTitle:@"bannerAdWillClose"];
}

- (void)bannerAdDidClose:(VungleBanner *)banner {
  NSLog(@"bannerAdDidClose");
  [self updateCallbackLogsWithTitle:@"bannerAdDidClose"];
}

@end
