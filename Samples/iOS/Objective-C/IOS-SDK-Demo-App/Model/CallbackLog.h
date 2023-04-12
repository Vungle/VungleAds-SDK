//
//  CallbackLog.h
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/30/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallbackLog : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) int index;

- (instancetype)initWithTitle:(NSString *)title index:(int)index;

@end

NS_ASSUME_NONNULL_END
