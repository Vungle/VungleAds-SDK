//
//  LOInterScrollerViewController.m
//  IOS-SDK-Demo-App
//
//  Created by Manoj Budumuru on 10/8/24.
//

#import "LOInterScrollerViewController.h"

@interface LOInterScrollerViewController () <VungleBannerViewDelegate>
@property (nonatomic, strong) VungleBannerView *banner;
@end

@implementation LOInterScrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Liftoff InterScroller display";
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect rect = self.view.safeAreaLayoutGuide.layoutFrame;
    self.heightConstraint.constant = rect.size.height;
    [self.view layoutIfNeeded];
    self.banner = [[VungleBannerView alloc] initWithPlacementId:self.placementId
                                                                vungleAdSize:[VungleAdSize VungleAdSizeFromCGSize:rect.size]];
    self.banner.delegate = self;
    [self.banner load:nil];
    [self.adView addSubview:self.banner];
}

- (void)setAdLayoutConstraints {
    if (self.banner != nil) {
        self.banner.translatesAutoresizingMaskIntoConstraints = false;
        NSArray<NSLayoutConstraint *> *constraintArray = @[[self.banner.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                                           [self.banner.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                                           [self.banner.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                                           [self.banner.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
                                                           [self.banner.heightAnchor constraintEqualToConstant:self.view.safeAreaLayoutGuide.layoutFrame.size.height]];
        [NSLayoutConstraint activateConstraints:constraintArray];
    }
}

- (void)bannerAdDidLoad:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidLoad");
}

- (void)bannerAdWillPresent:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdWillPresent");
}

- (void)bannerAdDidPresent:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidPresent");
    [self setAdLayoutConstraints];
}

- (void)bannerAdDidFail:(VungleBannerView * _Nonnull)bannerView withError:(NSError * _Nonnull)withError {
    NSLog(@"bannerAdDidFail");
}

- (void)bannerAdWillClose:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdWillClose");
}

- (void)bannerAdDidClose:(VungleBannerView * _Nonnull)bannerView {
    NSLog(@"bannerAdDidClose");
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
