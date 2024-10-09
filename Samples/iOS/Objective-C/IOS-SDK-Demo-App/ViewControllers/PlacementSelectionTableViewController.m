//
//  PlacementSelectionTableViewController.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/29/23.
//

/**
 To see how each ad format is integrated, navigate to Ad Formats to see how to integrate ad type into an app.
 */

#import "PlacementSelectionTableViewController.h"
#import <VungleAdsSDK/VungleAdsSDK.h>
#import "PlacementIDTableViewCell.h"

#import "LOInterstitialViewController.h"
#import "LONativeAdViewController.h"
#import "LOBannerViewController.h"
#import "LORewardedViewController.h"
#import "LOMRECViewController.h"
#import "LOInlineViewController.h"
#import "LOInterScrollerViewController.h"

@interface PlacementSelectionTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *placementArr;
@property (nonatomic, strong) NSArray *adTypesArr;

// View which contains the loading text and spinner
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

// Text shown while loading the table view
@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *sdkVersionLbl;

@end

@implementation PlacementSelectionTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.placementArr = [NSArray arrayWithArray:[[NSBundle mainBundle].infoDictionary[@"Liftoff PlacementID"] allValues]];
  self.adTypesArr = [NSArray arrayWithArray:[[NSBundle mainBundle].infoDictionary[@"Liftoff PlacementID"] allKeys]];
  
  self.sdkVersionLbl.text = [NSString stringWithFormat:@"SDK Version: %@", [VungleAds sdkVersion]];
  
  [self setLoadingScreen];
  [self initializeSdkAndSetUpTable];
}

#pragma mark - Private methods

- (void)setLoadingScreen {
  // sets the view which contains the loading text and spinner
  CGFloat width = 140;
  CGFloat height = 30;
  CGFloat x = (self.view.frame.size.width / 2) - (width / 2);
  CGFloat y = (self.view.frame.size.height / 2) - (height / 2);
  self.loadingView.frame = CGRectMake(x, y, width, height);
  
  // sets loading text
  self.loadingLabel.textColor = [UIColor grayColor];
  self.loadingLabel.textAlignment = NSTextAlignmentCenter;
  self.loadingLabel.text = @"Loading...";
  self.loadingLabel.frame = CGRectMake(0, 26, 140, 30);
  [self.loadingView addSubview:self.loadingLabel];
  [self.view addSubview:self.loadingView];
  
  self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  self.activityIndicator.center = self.view.center;
  self.activityIndicator.hidesWhenStopped = YES;
  [self.view addSubview:self.activityIndicator];
  [self.activityIndicator startAnimating];
}

- (void)initializeSdkAndSetUpTable {
  // Initialize the SDK if it is not initialized already
  if (![VungleAds isInitialized]) {
    [VungleAds initWithAppId:[self getAppID] completion:^(NSError *error) {
      if (error != nil) {
        NSLog(@"Error initializing the SDK");
        [self showSdkInitFailureAlert];
      } else {
        [self setUpTableView];
      }
    }];
  } else {
    [self setUpTableView];
  }
}

- (NSString *)getAppID {
  NSString *appID = [NSBundle mainBundle].infoDictionary[@"Liftoff Dashboard AppID"];
  return appID;
}

- (void)showSdkInitFailureAlert {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Error initializing the SDK"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
  });
}

- (void)setUpTableView {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.loadingLabel setHidden:YES];
    [self.activityIndicator stopAnimating];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
  });
}

#pragma mark Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toInterstitialSegue"]) {
        LOInterstitialViewController *vc = (LOInterstitialViewController *)segue.destinationViewController;
        vc.placementId = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"toNativeSegue"]) {
        LONativeAdViewController *vc = (LONativeAdViewController *)segue.destinationViewController;
        vc.placementId = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"toBannerSegue"]) {
        LOBannerViewController *vc = (LOBannerViewController *)segue.destinationViewController;
        vc.placementId = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"toRewardedSegue"]) {
        LORewardedViewController *vc = (LORewardedViewController *)segue.destinationViewController;
        vc.placementId = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"toMRECSegue"]) {
        LOMRECViewController *vc = (LOMRECViewController *)segue.destinationViewController;
        vc.placementId = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"toInlineSegue"]) {
        LOInlineViewController *vc = (LOInlineViewController *)segue.destinationViewController;
        vc.placementId = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"toInterSegue"]) {
        LOInterScrollerViewController *vc = (LOInterScrollerViewController *)segue.destinationViewController;
        vc.placementId = (NSString *)sender;
    }
}

#pragma mark UITableViewDelegate, UITableViewDatasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.placementArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlacementIDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placementIdCell" forIndexPath:indexPath];
  cell.adTypeLbl.text = self.adTypesArr[indexPath.row];
  cell.placementLbl.text = self.placementArr[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlacementIDTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        NSString *selectedAdType = self.adTypesArr[indexPath.row];
        NSString *segueIdentifier = nil;
        if ([selectedAdType isEqualToString:@"Interstitial"]) {
            segueIdentifier = @"toInterstitialSegue";
        } else if ([selectedAdType isEqualToString:@"Banner"]) {
            segueIdentifier = @"toBannerSegue";
        } else if ([selectedAdType isEqualToString:@"Native"]) {
            segueIdentifier = @"toNativeSegue";
        } else if ([selectedAdType isEqualToString:@"MREC"]) {
            segueIdentifier = @"toMRECSegue";
        } else if ([selectedAdType isEqualToString:@"Inline"]) {
            segueIdentifier = @"toInlineSegue";
        } else if ([selectedAdType isEqualToString:@"InterScroller"]) {
            segueIdentifier = @"toInterSegue";
        } else if ([selectedAdType isEqualToString:@"Rewarded"] || [selectedAdType isEqualToString:@"Rewarded Playable"]) {
            segueIdentifier = @"toRewardedSegue";
        }
        
        if (segueIdentifier != nil) {
            [self performSegueWithIdentifier:segueIdentifier sender:cell.placementLbl.text];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"The ad format is not yet supported by the Liftoff SDK" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

@end
