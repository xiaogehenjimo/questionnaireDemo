//
//  questView.h
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "questModel.h"

@protocol questViewDelegate <NSObject>
/** 获取到答案 */
- (void)didGetRiskAnswer:(NSArray<questModel*>*)answer;
/** 上传答案按钮点击了 */
- (void)uploadRiskAnswer:(NSArray<questModel*>*)answer;;

@end

@interface questView : UIView
/** 代理 */
@property(nonatomic, weak)  id<questViewDelegate>  delegate;
/** 数据源 */
@property(nonatomic, strong)  NSArray<questModel*>  *  dataArr;


@end
