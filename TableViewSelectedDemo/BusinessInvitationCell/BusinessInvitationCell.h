//
//  BusinessInvitationCell.h
//  TestApp
//
//  Created by XWH on 2020/2/19.
//  Copyright © 2020 XWH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessInvitation.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessInvitationCell : UITableViewCell

@property (strong, nonatomic) BusinessInvitation *model;

+ (CGFloat)heightWithModel:(BusinessInvitation *)model;

@end

NS_ASSUME_NONNULL_END
