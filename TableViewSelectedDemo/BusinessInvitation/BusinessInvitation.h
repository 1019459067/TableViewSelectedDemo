//
//  BusinessInvitation.h
//  TableViewSelectedDemo
//
//  Created by HN on 2020/2/27.
//  Copyright © 2020 HN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessInvitation : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL bSelected;  ///< cell的选中状态
@property (nonatomic, assign) BOOL bManaged;    ///< cell的编辑状态

@end

NS_ASSUME_NONNULL_END
