//
//  BusinessInvitationCell.m
//  TestApp
//
//  Created by XWH on 2020/2/19.
//  Copyright © 2020 XWH. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "BusinessInvitationCell.h"

@interface BusinessInvitationCell ()
@property (weak, nonatomic) IBOutlet UIView *buttonBgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *ratioButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBgViewConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraintH;

@end

@implementation BusinessInvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

+ (instancetype)shared
{
    static BusinessInvitationCell *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BusinessInvitationCell alloc] init];
    });
    return instance;
}

- (void)setModel:(BusinessInvitation *)model
{
    _model = model;
    self.contentLabel.text = model.title.length ? model.title : @"";
    
    // 管理编辑状态
    self.buttonBgView.hidden = model.bManaged ? NO :YES;
    self.buttonBgViewConstraintW.constant = model.bManaged ? 40 : 0;

    // 按钮状态
    self.ratioButton.selected = model.bSelected;
    self.contentLabelConstraintH.constant = [self textHeightWithModel:model];
}

#pragma mark - Public
+ (CGFloat)heightWithModel:(BusinessInvitation *)model;
{
    return [[BusinessInvitationCell shared] parseModel:model];
}

- (CGFloat)parseModel:(BusinessInvitation *)model
{
    CGFloat fHeight = [self textHeightWithModel:model];
    return 15+fHeight+15;
}

- (CGFloat)textHeightWithModel:(BusinessInvitation *)model
{
    NSString *text = model.title.length ? model.title : @"";
    CGFloat textW = model.bManaged ? SCREEN_WIDTH-15*2-40:SCREEN_WIDTH-15*2;
    CGSize size = [text boundingRectWithSize:CGSizeMake(textW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    return size.height+5;
}

@end
