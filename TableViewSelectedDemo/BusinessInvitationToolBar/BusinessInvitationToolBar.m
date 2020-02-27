//
//  BusinessInvitationToolBar.m
//  huinongwang
//
//  Created by HN on 2020/2/5.
//  Copyright © 2020 cnhnb. All rights reserved.
//

#import "BusinessInvitationToolBar.h"

@interface BusinessInvitationToolBar ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation BusinessInvitationToolBar

+ (instancetype)contentViewWithDelegate:(id<BusinessInvitationToolBarDelegate>)delegate
{
    BusinessInvitationToolBar *contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil][0];
    return contentView;
}

- (void)setNumber:(NSInteger)number
{
    _number = number;
    self.numberLabel.text = [NSString stringWithFormat:@"(已选%ld)",number > 0? number : 0];
    self.deleteButton.enabled = number > 0 ? YES : NO;
    self.deleteButton.backgroundColor = number > 0 ? UIColor.redColor : UIColor.darkTextColor;
}

- (IBAction)onActionSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(businessInvitationToolBar:didSelect:)]) {
        [self.delegate businessInvitationToolBar:self didSelect:sender];
    }
}

- (IBAction)onActionDelete:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(businessInvitationToolBar:didDelete:)]) {
        [self.delegate businessInvitationToolBar:self didDelete:sender];
    }
}

@end
