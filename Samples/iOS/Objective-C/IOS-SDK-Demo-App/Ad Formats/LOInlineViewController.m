//
//  LOInlineViewController.m
//  test-objc-fw-integration
//

#import "LOInlineViewController.h"
#import <VungleAdsSDK/VungleAdsSDK.h>

@interface LOInlineViewController () <VungleBannerViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) UITableViewCell *adCell;
@property (nonatomic, strong) VungleBannerView *adView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LOInlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adView = [[VungleBannerView alloc] initWithPlacementId:self.placementId 
                                                   vungleAdSize:[VungleAdSize VungleAdSizeFromCGSize:CGSizeMake(300, 300)]];
    self.adView.delegate = self;
    [self.adView load:nil];
    self.models = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 10; i++)
    {
        [self.models addObject: [InlineModel new]];
    }
    self.adCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"adCell"];
    self.navigationItem.title = @"Liftoff Inline Ad";
}

#pragma mark - UITableViewDelegate / UITableViewDatasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InlineModel *model = self.models[indexPath.row];
    if (model.isAd) {
        return self.adCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InlineCell"
                                                                     forIndexPath:indexPath];
    [cell.imageView setImage: [UIImage imageNamed:@"Liftoff-monetize-demo"]];
    cell.textLabel.text = @"Inline demo";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InlineModel *model = self.models[indexPath.row];
    return model.cellHeight;
}

#pragma mark - VungleInterstitial Delegate Methods
- (void)bannerAdDidLoad:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidLoad");
    InlineModel *model = [[InlineModel alloc] init];
    model.isAd = YES;
    model.cellHeight = 300;
    [self.adCell.contentView addSubview: bannerView];
    [self.models insertObject: model atIndex:2];
    [self.tableView reloadData];
}

- (void)bannerAdWillPresent:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdWillPresent");
}

- (void)bannerAdDidPresent:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidPresent");
}

- (void)bannerAdDidFail:(VungleBannerView * _Nonnull)bannerView withError:(NSError * _Nonnull)withError {
    NSLog(@"bannerAdDidFail, %@", [withError localizedDescription]);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Load Ad Error"
                                                                   message: [withError localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)bannerAdWillClose:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdWillClose");
}

- (void)bannerAdDidClose:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidClose");
    [self.models removeObjectAtIndex:2];
    [self.tableView reloadData];
}

- (void)bannerAdDidTrackImpression:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidTrackImpression");
}

- (void)bannerAdDidClick:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidClick");
}

- (void)bannerAdWillLeaveApplication:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdWillLeaveApplication");
}
@end


@implementation InlineModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAd = NO;
        self.cellHeight = 200;
    }
    return self;
}

@end
