//
//  PlacementIDTableViewCell.h
//  test-objc-fw-integration
//
//  Created by Clarke Bishop on 3/29/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlacementIDTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *placementLbl;
@property (nonatomic, weak) IBOutlet UIButton *selectBtn;
@property (nonatomic, weak) IBOutlet UILabel *adTypeLbl;
@end

NS_ASSUME_NONNULL_END
