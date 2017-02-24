//
//  optionView.m
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "optionView.h"

#define iphoneWidth  [UIScreen mainScreen].bounds.size.width
#define iphoneHeight [UIScreen mainScreen].bounds.size.height


#define cententWidth 20

#define selBtnWH 20 //左侧按钮的宽高

#define boardWidth 5 //间距

#define optionLabelFont 15 //字体大小

@interface optionView ()


/** 答案的label */
@property(nonatomic, strong)  UILabel  *  optionLabel;



@end

@implementation optionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor redColor];
        UIButton * button = [[UIButton alloc]init];
        button.layer.cornerRadius = 10.0;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor grayColor];
        [button addTarget:self action:@selector(selectBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(boardWidth, boardWidth, selBtnWH, selBtnWH);
        [self addSubview:button];
        self.selectBtn = button;
        //右侧选项label
        UILabel * rightOptionLabel = [[UILabel alloc]init];
        rightOptionLabel.numberOfLines = 0;
        rightOptionLabel.font = [UIFont systemFontOfSize:optionLabelFont];
        //rightOptionLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:rightOptionLabel];
        rightOptionLabel.userInteractionEnabled = YES;
        self.optionLabel = rightOptionLabel;
        //label的点击事件
        UITapGestureRecognizer * sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(optionLabelDidPress:)];
        [self.optionLabel addGestureRecognizer:sigleTap];
        
    }
    return self;
}


#pragma mark - activity

/** 选项的label点击 */
- (void)optionLabelDidPress:(UITapGestureRecognizer*)tap{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(optionSelectBtnDidPress:optView:)]) {
        [self.delegate optionSelectBtnDidPress:self.dataModel optView:self];
    }
    //修改按钮颜色
    self.selectBtn.backgroundColor = [UIColor redColor];
}

/** 左侧选择的按钮点击 */
- (void)selectBtnDidPress:(UIButton*)button{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(optionSelectBtnDidPress:optView:)]) {
        [self.delegate optionSelectBtnDidPress:self.dataModel optView:self];
    }
    //修改按钮颜色
    self.selectBtn.backgroundColor = [UIColor redColor];
}

- (void)setDataModel:(optionModel *)dataModel{
    _dataModel = dataModel;
    
    if (dataModel.isSel) {
        self.selectBtn.backgroundColor = [UIColor redColor];
    }else{
        self.selectBtn.backgroundColor = [UIColor grayColor];
    }
    //计算高度
    CGSize optionLabelSize = [self calculateOptionLabelHeight:dataModel.optionContent];
    self.optionLabel.frame = CGRectMake(CGRectGetMaxX(self.selectBtn.frame) + boardWidth, boardWidth, self.frame.size.width - 3*boardWidth - selBtnWH, optionLabelSize.height);
    
    self.optionLabel.text = dataModel.optionContent;
    
    //设置左侧按钮的frame

    self.selectBtn.frame = CGRectMake(boardWidth, ((optionLabelSize.height + boardWidth * 2) - selBtnWH) * .5, selBtnWH, selBtnWH);
    
}


/** 计算文本的高度 */
- (CGSize)calculateOptionLabelHeight:(NSString*)optionStr{
    
    CGFloat maxW = iphoneWidth - 3 * cententWidth - 3 * boardWidth - selBtnWH;
    return [self sizeWithText:optionStr AndFont:[UIFont systemFontOfSize:optionLabelFont] MaxW:maxW];
}

/** 计算选项的高度 */
- (CGFloat)calculateHeight:(optionModel*)model{
    
    return [self calculateOptionLabelHeight:model.optionContent].height + 2 * boardWidth;
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
@end
