//
//  LORewardedViewController.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/29/23.
//

/**
 IMPORTANT: Please review and set the placementID and appID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Interstitial is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 
 */

#import "LORewardedViewController.h"
#import <VungleAdsSDK/VungleAdsSDK.h>
#import "CallbackLog.h"
#import "AppUtil.h"
#import "CallbackLogTableViewCell.h"

@interface LORewardedViewController () <VungleRewardedDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VungleRewarded *rewardedAd;
@property (nonatomic, strong) NSArray *callbackLogs;

@property (nonatomic, weak) IBOutlet UILabel *placementLbl;
@property (nonatomic, weak) IBOutlet UIButton *loadBtn;
@property (nonatomic, weak) IBOutlet UIButton *playBtn;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LORewardedViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Liftoff Rewarded Ad";
  self.placementLbl.text = self.placementId;
  self.callbackLogs = [self generateCallbackLogs];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;  
}

#pragma mark - IBAction Methods

- (IBAction)btnPressed:(id)sender {
  if (sender == self.loadBtn && self.placementId != nil) {
    [self loadRewardedAd];
  } else if (sender == self.playBtn && [self.rewardedAd canPlayAd]) {
    [self playRewardedAd];
  }
}

#pragma mark - Private Methods

- (void)loadRewardedAd {
  // clean up before load
  if (self.rewardedAd != nil) {
    self.rewardedAd.delegate = nil;
    self.rewardedAd = nil;
    [self resetCallbackLogs];
  }
  
  if (self.placementId) {
    self.rewardedAd = [[VungleRewarded alloc] initWithPlacementId:self.placementId];
    self.rewardedAd.delegate = self;
    [self.rewardedAd load:nil];
    
    // Set incentivized rewarded text
    [self.rewardedAd setAlertTitleText:@"Close Ad"];
    [self.rewardedAd setAlertBodyText:@"Are you sure you want to close the ad? You will lose out on your reward"];
    [self.rewardedAd setAlertCloseButtonText:@"Close Ad"];
    [self.rewardedAd setAlertContinueButtonText:@"Resume Ad"];
  }
}

- (void)playRewardedAd {
  [self.rewardedAd presentWith:self];
}

- (NSArray *)generateCallbackLogs {
  return @[
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidLoad" index:0],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdWillPresent" index:1],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidPresent" index:2],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidTrackImpression" index:3],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidClick" index:4],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdWillLeaveApplication" index:5],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidRewardUser" index:6],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdWillClose" index:7],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidClose" index:8],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidFailToLoad" index:9],
    [[CallbackLog alloc] initWithTitle:@"rewardedAdDidFailToPresent" index:10]
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

#pragma mark - UITableView Datasource / Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.callbackLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CallbackLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallbackLogTableCell" forIndexPath:indexPath];
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

#pragma mark - VungleRewarded Delegate Methods

- (void)rewardedAdDidLoad:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdDidLoad");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidLoad"];
}

- (void)rewardedAdDidFailToLoad:(VungleRewarded *)rewarded
                      withError:(NSError *)withError {
  NSLog(@"rewardedAdDidFailToLoad");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidFailToLoad"];
}

- (void)rewardedAdWillPresent:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdWillPresent");
  [self updateCallbackLogsWithTitle:@"rewardedAdWillPresent"];
}

- (void)rewardedAdDidPresent:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdDidPresent");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidPresent"];
}

- (void)rewardedAdDidFailToPresent:(VungleRewarded *)rewarded
                         withError:(NSError *)withError {
  NSLog(@"rewardedAdDidFailToPresent");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidFailToPresent"];
}

- (void)rewardedAdDidTrackImpression:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdDidTrackImpression");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidTrackImpression"];
}

- (void)rewardedAdDidClick:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdDidClick");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidClick"];
}

- (void)rewardedAdWillLeaveApplication:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdWillLeaveApplication");
  [self updateCallbackLogsWithTitle:@"rewardedAdWillLeaveApplication"];
}

- (void)rewardedAdDidRewardUser:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdDidRewardUser");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidRewardUser"];
}

- (void)rewardedAdWillClose:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdWillClose");
  [self updateCallbackLogsWithTitle:@"rewardedAdWillClose"];
}

- (void)rewardedAdDidClose:(VungleRewarded *)rewarded {
  NSLog(@"rewardedAdDidClose");
  [self updateCallbackLogsWithTitle:@"rewardedAdDidClose"];
}

@end
