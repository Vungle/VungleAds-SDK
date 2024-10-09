//
//  LOInterScrollerViewController.h
//  IOS-SDK-Demo-App
//
//  Created by Manoj Budumuru on 10/8/24.
//

#import <UIKit/UIKit.h>
#import <VungleAdsSDK/VungleAdsSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOInterScrollerViewController : UIViewController
@property (nonatomic, strong) NSString *placementId;

@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;


@end

NS_ASSUME_NONNULL_END
