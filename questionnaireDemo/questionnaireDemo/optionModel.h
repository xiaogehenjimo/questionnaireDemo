//
//  optionModel.h
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface optionModel : NSObject

/** 选项 */
@property (nonatomic, copy)  NSString  *  optionContent;
/** 选项的序号 */
@property (nonatomic, copy)  NSString  *  optionNum;
/** 选项是否被选中 */
@property(nonatomic, assign)  BOOL   isSel;

@end
