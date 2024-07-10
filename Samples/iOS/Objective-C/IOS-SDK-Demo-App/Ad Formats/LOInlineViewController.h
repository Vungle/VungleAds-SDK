//
//  LOInlineViewController.h
//  test-objc-fw-integration
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LOInlineViewController: UIViewController
@property (nonatomic, strong) NSString *placementId;
@end


@interface InlineModel : NSObject
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isAd;
@end

NS_ASSUME_NONNULL_END
