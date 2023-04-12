//
//  CallbackLog.m
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/30/23.
//

/**
 To see how each ad format is integrated, navigate to Ad Formats to see how to integrate ad type into an app.
 */

#import "CallbackLog.h"

@implementation CallbackLog

- (instancetype)initWithTitle:(NSString *)title index:(int)index {
  self = [super init];
  if (self) {
    self.title = title;
    self.index = index;
  }
  return self;
}

@end
