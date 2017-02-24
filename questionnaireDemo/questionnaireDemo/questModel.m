//
//  questModel.m
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "questModel.h"

@implementation questModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }else if ([key isEqualToString:@"optionList"]) {
        //转模型
        NSMutableArray * finallyArr = @[].mutableCopy;
        NSArray * optionArr = (NSArray*)value;
        for (NSDictionary*obj in optionArr) {
            optionModel * model = [[optionModel alloc]init];
            [model setValuesForKeysWithDictionary:obj];
            model.isSel = NO;
            [finallyArr addObject:model];
        }
        self.optionListArr = finallyArr;
    }
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end
