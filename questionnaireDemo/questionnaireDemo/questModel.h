//
//  questModel.h
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "optionModel.h"
@interface questModel : NSObject

/** 题目id */
@property (nonatomic, copy)  NSString  *  ID;
/** 选项数组 */
@property (nonatomic, strong)  NSArray<optionModel*>  *  optionListArr;
/** 选项类型 */
@property (nonatomic, copy)  NSString  *  optionType;
/** 题目 */
@property (nonatomic, copy)  NSString  *  questionContent;
/** 问题组 */
@property (nonatomic, copy)  NSString  *  questionGroup;
/** 问题的第几个个数 */
@property (nonatomic, copy)  NSString  *  questionNum;

/** 答案 */
@property (nonatomic, copy)  NSString  *  answer;
/** 是否被选中 */
@property(nonatomic, assign)  BOOL   isSelected;

@end
