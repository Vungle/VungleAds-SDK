//
//  AppUtil.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/30/23.
//

/**
 To see how each ad format is integrated, navigate to Ad Formats to see how to integrate ad type into an app.
 */

#import "AppUtil.h"
#import <UIKit/UIKit.h>
#import "CallbackLog.h"

@implementation AppUtil

+ (NSArray *)updateCallbackLogs:(NSArray *)callbacks
                          title:(NSString *)title {
  NSMutableArray *updatedLogs = [NSMutableArray arrayWithCapacity:callbacks.count];
  for (CallbackLog *log in callbacks) {
    if ([log.title isEqualToString:title]) {
      log.isActive = YES;
    }
    [updatedLogs addObject:log];
  }
  return updatedLogs;
  
}

+ (NSArray *)resetCallbackLogs:(NSArray *)callbacks {
  NSMutableArray *updatedLogs = [NSMutableArray arrayWithCapacity:callbacks.count];
  for (CallbackLog *log in callbacks) {
    log.isActive = NO;
    log.subtitle = @"";
    [updatedLogs addObject:log];
  }
  return updatedLogs;
}

@end
