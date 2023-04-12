//
//  AppUtil.h
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/30/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUtil : NSObject
+ (NSArray *)updateCallbackLogs:(NSArray *)callbacks title:(NSString *)title;
+ (NSArray *)resetCallbackLogs:(NSArray *)callbacks;
@end

NS_ASSUME_NONNULL_END
