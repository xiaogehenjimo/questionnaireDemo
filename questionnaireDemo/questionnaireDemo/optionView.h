//
//  optionView.h
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "optionModel.h"


@class optionView;
@protocol optionSelectBtnPressDelegate <NSObject>

@optional;
- (void)optionSelectBtnDidPress:(optionModel*)optionModel
                     optView:(optionView*)optView;

@end


@interface optionView : UIView
/** 左侧选择的按钮 */
@property(nonatomic, strong)  UIButton *  selectBtn;
/** 代理 */
@property(nonatomic, weak)  id<optionSelectBtnPressDelegate>  delegate;
/** 数据模型 */
@property(nonatomic, strong)  optionModel  *  dataModel;

/** 计算每个选项的高度 */
- (CGFloat)calculateHeight:(optionModel*)model;


@end
