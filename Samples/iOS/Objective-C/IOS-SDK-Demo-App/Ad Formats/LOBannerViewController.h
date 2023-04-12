//
//  LOBannerViewController.h
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/29/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOBannerViewController : UIViewController
@property (nonatomic, strong) NSString *placementId;
@property (nonatomic, strong) NSArray *callbackLogs;

@property (nonatomic, weak) IBOutlet UIView *bannerAdContainer;
@property (nonatomic, weak) IBOutlet UIButton *loadBtn;
@property (nonatomic, weak) IBOutlet UIButton *playBtn;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

- (void)resetCallbackLogs;

@end

NS_ASSUME_NONNULL_END
