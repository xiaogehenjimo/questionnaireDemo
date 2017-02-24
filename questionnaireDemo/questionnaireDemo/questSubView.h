//
//  questSubView.h
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "questModel.h"

@class questSubView;
@protocol questSubViewDelegate <NSObject>

@optional
- (void)subViewDidCompleteSelect:(questModel*)quesModel
                      queSubView:(questSubView*)subView;

@end

@interface questSubView : UIView
/** 代理 */
@property(nonatomic, weak)  id<questSubViewDelegate>  delegate;
/** 数据model */
@property(nonatomic, strong)  questModel  *  dataModel;

/** 恢复按钮为可以选中状态 */
- (void)renewSelectBtn;

@end
