//
//  questView.m
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "questView.h"
#import "questSubView.h"

#define iphoneWidth  [UIScreen mainScreen].bounds.size.width
#define iphoneHeight [UIScreen mainScreen].bounds.size.height

/*颜色相关*/
#define XQQColorAlpa(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define XQQColor(r,g,b)         XQQColorAlpa((r),(g),(b),255)
#define XQQRandomColor          XQQColor(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))
#define XQQGrayColor(r)  XQQColor((r),(r),(r))
#define XQQBGColor       XQQGrayColor(214)
#define XQQSingleColor(r)  XQQColor((r),(r),(r))



@interface questView ()<questSubViewDelegate>
/** 选中的题目的数组 */
@property(nonatomic, strong)  NSMutableArray  *  selectAnswerArr;
/** 题目的滚动视图 */
@property(nonatomic, strong)  UIScrollView  *  questScrollView;
/** 添加的视图 */
@property(nonatomic, strong)  NSMutableArray  *  questSubViews;


/** 上一题按钮 */
@property(nonatomic, strong)  UIButton  *  previousBtn;
/** 进度label */
@property(nonatomic, strong)  UILabel  *  progressLabel;


/** 记录当前显示的页面序号 */
@property(nonatomic, assign)  NSInteger   currentIndex;
/** 上一个页面的序号 */
@property(nonatomic, assign)  NSInteger   previousIndex;


/** 上传答案按钮 */
@property(nonatomic, strong)  UIButton  *  uploadBtn;


@end

@implementation questView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.currentIndex = 1;
        
        UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroll.scrollEnabled = NO;
        scroll.pagingEnabled = YES;
        
        [self addSubview:scroll];
        //241  229  198
        scroll.backgroundColor = XQQColor(241, 229, 198);
        
        self.questScrollView = scroll;
        
        //上一题按钮
        UIButton * preBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, frame.size.height - 20 - 40, 80, 40)];
        [preBtn addTarget:self action:@selector(preBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [preBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [preBtn setTitle:@"上一题" forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        preBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        preBtn.hidden = YES;
        [self addSubview:preBtn];
        self.previousBtn = preBtn;
        //进度label
        
        UILabel * progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(iphoneWidth - 20 - 140, preBtn.frame.origin.y, 140, 40)];
        
        progressLabel.textAlignment = NSTextAlignmentCenter;
        
        progressLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:progressLabel];
        
        self.progressLabel = progressLabel;
        
        UIButton * upBtn = [[UIButton alloc]initWithFrame:CGRectMake((iphoneWidth - 80)*.5, progressLabel.frame.origin.y - 5 - 30, 80, 30)];
        upBtn.backgroundColor = XQQSingleColor(243);
        upBtn.layer.cornerRadius = 8.0;
        upBtn.layer.masksToBounds = YES;
        
        [upBtn setTitle:@"保存答案" forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [upBtn addTarget:self action:@selector(uploadBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:upBtn];
        upBtn.hidden = YES;
        self.uploadBtn = upBtn;
        
    }
    return self;
}

/** 上传答案按钮点击了 */
- (void)uploadBtnDidPress:(UIButton*)button{

    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadRiskAnswer:)]) {
        [self.delegate uploadRiskAnswer:self.selectAnswerArr];
    }
}

/** 上一步按钮点击 */
- (void)preBtnDidPress:(UIButton*)button{
    //切换到上一题
    [self.questScrollView setContentOffset:CGPointMake((self.previousIndex  - 1) * iphoneWidth, 0) animated:YES];
    
    self.previousBtn.hidden = self.previousIndex == 1 ? YES : NO;
    //取出上一题的View
    questSubView * previousView = self.questSubViews[self.previousIndex  - 1];
    [previousView renewSelectBtn];
    self.previousIndex --;
}


#pragma mark - questSubViewDelegate

/** 按照题号从小到大进行排序 */
- (void)sortArr{
    for (NSInteger i = 0; i < self.selectAnswerArr.count; i ++) {
        for (NSInteger j = 0; j < self.selectAnswerArr.count - 1; j ++) {
            if ([[self.selectAnswerArr[j] questionNum] integerValue] > [[self.selectAnswerArr[j+1] questionNum] integerValue]) {
                [self.selectAnswerArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}

/** 选项选择完成 处理跳转 及保存答案 */
- (void)subViewDidCompleteSelect:(questModel *)quesModel
                      queSubView:(questSubView *)subView{
    
    if ([self.selectAnswerArr containsObject:quesModel]) {
        [self.selectAnswerArr removeObject:quesModel];
    }
    [self.selectAnswerArr addObject:quesModel];
    //数组进行排序
    
    [self sortArr];
    
    if (self.selectAnswerArr.count == self.questSubViews.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didGetRiskAnswer:)]) {
            [self.delegate didGetRiskAnswer:self.selectAnswerArr];
            self.uploadBtn.hidden = NO;
        }
    }
    
    NSInteger index = [quesModel.questionNum integerValue];
    
    if (index == 20) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //修改偏移量
        
        //选中的最后一个数组
        questModel * lastModel = [self.selectAnswerArr lastObject];
        
        NSInteger lastIndex = [lastModel.questionNum integerValue];
        
        if (lastIndex + 1 == index + 1) {
            [self.questScrollView setContentOffset:CGPointMake(index * iphoneWidth, 0) animated:YES];
            self.currentIndex = index + 1;
            
            self.previousIndex = index;
        }else{
            if (lastIndex == 20) {
                questSubView * lastView = self.questSubViews.lastObject;
                [lastView renewSelectBtn];
                
                [self.questScrollView setContentOffset:CGPointMake((lastIndex - 1) * iphoneWidth, 0) animated:NO];
                self.currentIndex = lastIndex;
                self.previousIndex = lastIndex -1;
            }else{
                [self.questScrollView setContentOffset:CGPointMake(lastIndex * iphoneWidth, 0) animated:NO];
                self.currentIndex = lastIndex + 1;
                self.previousIndex = lastIndex;
            }
        }
        
        self.previousBtn.hidden = NO;
    
        self.progressLabel.text = [NSString stringWithFormat:@"答题进度:%ld/%ld",lastIndex == 20 ? lastIndex : lastIndex + 1,self.questSubViews.count];
    });
}


- (void)setDataArr:(NSArray<questModel *> *)dataArr{
    _dataArr = dataArr;

    if (self.questScrollView.subviews.count > 0) {
        [self.questScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //在这里给滚动视图添加View
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        questModel * model = dataArr[i];
        questSubView * subView = [[questSubView alloc]initWithFrame:CGRectMake(i * iphoneWidth, 0, iphoneWidth, self.questScrollView.frame.size.height)];
        subView.dataModel = model;
        subView.delegate = self;
        [self.questScrollView addSubview:subView];
        [self.questSubViews addObject:subView];
    }
    
    //设置contentSize
    questSubView * lastSubView = self.questSubViews.lastObject;
    
    self.questScrollView.contentSize = CGSizeMake(lastSubView.frame.origin.x + iphoneWidth, self.questScrollView.frame.size.height);
    //设置答题进度
    self.progressLabel.text = [NSString stringWithFormat:@"答题进度:1/%ld",self.questSubViews.count];
}


- (NSMutableArray *)selectAnswerArr{
    if (!_selectAnswerArr) {
        _selectAnswerArr = @[].mutableCopy;
    }
    return _selectAnswerArr;
}

- (NSMutableArray *)questSubViews{
    if (!_questSubViews) {
        _questSubViews = @[].mutableCopy;
    }
    return _questSubViews;
}

@end
