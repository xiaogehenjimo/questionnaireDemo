//
//  questSubView.m
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "questSubView.h"
#import "optionView.h"

//间距
#define boardWidth 20
//题目的字体大小
#define questContentFont  17



#define iphoneWidth  [UIScreen mainScreen].bounds.size.width
#define iphoneHeight [UIScreen mainScreen].bounds.size.height

/*颜色相关*/
#define XQQColorAlpa(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define XQQColor(r,g,b)         XQQColorAlpa((r),(g),(b),255)
#define XQQRandomColor          XQQColor(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))
#define XQQGrayColor(r)  XQQColor((r),(r),(r))
#define XQQBGColor       XQQGrayColor(214)
#define XQQSingleColor(r)  XQQColor((r),(r),(r))


@interface questSubView ()<optionSelectBtnPressDelegate>

/** 题目label */
@property(nonatomic,strong) UILabel * questionContentLabel;

/** 存储选项答案选项View */
@property(nonatomic, strong)  NSMutableArray  *  optionArr;


@end


@implementation questSubView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //题目的label
        UILabel * questContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(boardWidth, boardWidth, iphoneWidth - 2 * boardWidth, 0)];
        questContentLabel.numberOfLines = 0;
        questContentLabel.font = [UIFont boldSystemFontOfSize:questContentFont];
        [self addSubview:questContentLabel];
        self.questionContentLabel = questContentLabel;
    }
    
    return self;
}


/** 恢复按钮为可以选中状态 */
- (void)renewSelectBtn{
    for (optionView * view in self.optionArr) {
        view.userInteractionEnabled = YES;
    }
}

#pragma mark - optionSelectBtnPressDelegate
/** 某个选项被点击了 */
- (void)optionSelectBtnDidPress:(optionModel*)optionModel
                        optView:(optionView *)optview{
    NSLog(@"选择了:%@",optionModel.optionNum);
    for (optionView * view in self.optionArr) {
        
        //修改当前选中的颜色为红色 其他的颜色为灰色
        view.selectBtn.backgroundColor = view == optview ? [UIColor redColor] : [UIColor grayColor];
    
        view.userInteractionEnabled = NO;
    }

    self.dataModel.answer = optionModel.optionNum;
    self.dataModel.isSelected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(subViewDidCompleteSelect:queSubView:)]) {
        [self.delegate subViewDidCompleteSelect:self.dataModel queSubView:self];
    }
}

- (void)setDataModel:(questModel *)dataModel{
    _dataModel = dataModel;
    
    //计算题目高度
    NSString * contentStr = [NSString stringWithFormat:@"%@. %@",dataModel.questionNum,dataModel.questionContent];
    self.questionContentLabel.text = contentStr;
    
    CGFloat maxW = iphoneWidth - 2 * boardWidth;
    CGSize  centerLabelSize = [self sizeWithText:contentStr AndFont:[UIFont boldSystemFontOfSize:questContentFont] MaxW:maxW];
    
    self.questionContentLabel.frame = CGRectMake(boardWidth, boardWidth, iphoneWidth - 2 * boardWidth, centerLabelSize.height);
    
    //创建选项
    NSArray * optionArr = dataModel.optionListArr;
    
    for (NSInteger i = 0 ; i < optionArr.count; i ++) {
        
        optionModel * model = optionArr[i];
        
        optionView * optView = [[optionView alloc]init];
        
        optView.delegate = self;
        
        //选项view的最大宽度
        CGFloat optMaxW = iphoneWidth - 3 * boardWidth;
        
        //计算出高度
        CGFloat optViewHeight = [optView calculateHeight:model];
    
        if (i == 0) {
            optView.frame = CGRectMake(boardWidth * 2, CGRectGetMaxY(self.questionContentLabel.frame) + boardWidth, optMaxW, optViewHeight);
        }else{
            optionView * opt = self.optionArr.lastObject;
            optView.frame = CGRectMake(boardWidth * 2, CGRectGetMaxY(opt.frame) + boardWidth, optMaxW, optViewHeight);
        }
        
        optView.dataModel = model;
        
        [self addSubview:optView];
        
        [self.optionArr addObject:optView];
        
    }
}

//计算文字
- (CGSize)sizeWithText:(NSString*)text AndFont:(UIFont*)font MaxW :(CGFloat)maxW{
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithText:(NSString*)text AndFont:(UIFont*)font {
    return [self sizeWithText:text AndFont:font MaxW:MAXFLOAT];
}


- (NSMutableArray *)optionArr{
    if (!_optionArr) {
        _optionArr = @[].mutableCopy;
    }
    return _optionArr;
}



@end
