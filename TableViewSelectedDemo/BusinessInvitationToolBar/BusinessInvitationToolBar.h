//
//  BusinessInvitationToolBar.h
//  huinongwang
//
//  Created by HN on 2020/2/5.
//  Copyright © 2020 cnhnb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BusinessInvitationToolBar;

@protocol BusinessInvitationToolBarDelegate <NSObject>

- (void)businessInvitationToolBar:(BusinessInvitationToolBar *)contentView
                        didSelect:(UIButton *)sender;
- (void)businessInvitationToolBar:(BusinessInvitationToolBar *)contentView
                        didDelete:(UIButton *)sender;

@end

@interface BusinessInvitationToolBar : UIView

@property (nonatomic, weak) id<BusinessInvitationToolBarDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, assign) NSInteger number;

+ (instancetype)contentViewWithDelegate:(id<BusinessInvitationToolBarDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
