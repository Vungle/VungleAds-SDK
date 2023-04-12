//
//  LOInterstitialViewController.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/29/23.
//

/**
 IMPORTANT: Please review and set the placementID and appID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Interstitial is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 
 */

#import "LOInterstitialViewController.h"
#import <VungleAdsSDK/VungleAdsSDK.h>
#import "CallbackLog.h"
#import "AppUtil.h"
#import "CallbackLogTableViewCell.h"

@interface LOInterstitialViewController () <VungleInterstitialDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VungleInterstitial *interstitialAd;
@property (nonatomic, strong) NSArray *callbackLogs;

@property (nonatomic, weak) IBOutlet UILabel *placementLbl;
@property (nonatomic, weak) IBOutlet UIButton *loadBtn;
@property (nonatomic, weak) IBOutlet UIButton *playBtn;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LOInterstitialViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // view setup
  self.navigationItem.title = @"Liftoff Interstitial Ad";
  self.placementLbl.text = self.placementId;
  self.callbackLogs = [self generateCallbackLogs];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

#pragma mark - IBAction methods

- (IBAction)btnPressed:(id)sender {
  if (sender == self.loadBtn && self.placementId != nil) {
    [self loadInterstitialAd];
  } else if (sender == self.playBtn && [self.interstitialAd canPlayAd]) {
    [self playInterstitialAd];
  }
}

#pragma mark - Private methods

- (void)loadInterstitialAd {
  // clean up before load
  if (self.interstitialAd != nil) {
    self.interstitialAd.delegate = nil;
    self.interstitialAd = nil;
    [self resetCallbackLogs];
  }
  // Create the interstitial ad instance
  self.interstitialAd = [[VungleInterstitial alloc] initWithPlacementId:self.placementId];
  self.interstitialAd.delegate = self;
  // Load the interstitial ad instance (in this example, WITHOUT a bid payload)
  [self.interstitialAd load:nil];
}

- (void)playInterstitialAd {
  [self.interstitialAd presentWith:self];
}

- (NSArray *)generateCallbackLogs {
  return @[
    [[CallbackLog alloc] initWithTitle:@"interstitialAdDidLoad" index:0],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdWillPresent" index:1],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdDidPresent" index:2],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdDidTrackImpression" index:3],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdDidClick" index:4],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdWillLeaveApplication" index:5],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdWillClose" index:6],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdDidClose" index:7],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdDidFailToLoad" index:8],
    [[CallbackLog alloc] initWithTitle:@"interstitialAdDidFailToPresent" index:9]
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

#pragma mark - UITableViewDelegate / UITableViewDatasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.callbackLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CallbackLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallbackLogTableCell"
                                                                   forIndexPath:indexPath];
  
  CallbackLog *log = self.callbackLogs[indexPath.row];
  if (log.isActive) {
    [cell.callbackLbl setTextColor:[UIColor labelColor]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    [cell.callbackLbl setTextColor:[UIColor grayColor]];
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

#pragma mark - VungleInterstitial Delegate Methods

- (void)interstitialAdDidLoad:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdDidLoad");
  [self updateCallbackLogsWithTitle:@"interstitialAdDidLoad"];
}

- (void)interstitialAdDidFailToLoad:(VungleInterstitial *)interstitial
                          withError:(NSError *)withError {
  NSLog(@"interstitialAdDidFailToLoad");
  [self updateCallbackLogsWithTitle:@"interstitialAdDidFailToLoad"];
}

- (void)interstitialAdWillPresent:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdWillPresent");
  [self updateCallbackLogsWithTitle:@"interstitialAdWillPresent"];
}

- (void)interstitialAdDidPresent:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdDidPresent");
  [self updateCallbackLogsWithTitle:@"interstitialAdDidPresent"];
}

- (void)interstitialAdDidFailToPresent:(VungleInterstitial *)interstitial
                             withError:(NSError *)withError {
  NSLog(@"interstitialAdDidFailToPresent");
  [self updateCallbackLogsWithTitle:@"interstitialAdDidFailToPresent"];
}

- (void)interstitialAdDidTrackImpression:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdDidTrackImpression");
  [self updateCallbackLogsWithTitle:@"interstitialAdDidTrackImpression"];
}

- (void)interstitialAdDidClick:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdDidClick");
  [self updateCallbackLogsWithTitle:@"interstitialAdDidClick"];
}

- (void)interstitialAdWillLeaveApplication:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdWillLeaveApplication");
  [self updateCallbackLogsWithTitle:@"interstitialAdWillLeaveApplication"];
}

- (void)interstitialAdWillClose:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdWillClose");
  [self updateCallbackLogsWithTitle:@"interstitialAdWillClose"];
}

- (void)interstitialAdDidClose:(VungleInterstitial *)interstitial {
  NSLog(@"interstitialAdDidClose");
  [self updateCallbackLogsWithTitle:@"interstitialAdDidClose"];
}

@end
