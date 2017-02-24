//
//  mainViewController.m
//  questionnaireDemo
//
//  Created by XQQ on 2017/2/24.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "mainViewController.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "questModel.h"
#import "questView.h"


#define iphoneWidth  [UIScreen mainScreen].bounds.size.width
#define iphoneHeight [UIScreen mainScreen].bounds.size.height


@interface mainViewController ()<questViewDelegate>
/** 滚动视图 */
@property(nonatomic,strong) UIScrollView * scrollView;
/** 题目的view */
@property(nonatomic, strong)  questView  *  questView;
/** 数据源 */
@property(nonatomic, strong)  NSMutableArray  *  dataArr;

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    
    [self loadData];
    
}

- (void)initUI{
    self.navigationItem.title = @"风险测评";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.questView = [[questView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, iphoneHeight - 64)];
    self.questView.delegate = self;
    [self.view addSubview:self.questView];
}

#pragma mark - questViewDelegate

/** 上传答案按钮点击会回调此方法 */
- (void)uploadRiskAnswer:(NSArray<questModel *> *)answer{
    NSMutableString * str = @"".mutableCopy;
    for (questModel * model in answer) {
        [str appendString:[NSString stringWithFormat:@"%@",model.answer]];
        [str appendString:@","];
    }
    NSLog(@"上传的答案是:%@",str);
}

/** 答案选择完毕会回调此方法 */
- (void)didGetRiskAnswer:(NSArray *)answer{
    NSMutableString * str = @"".mutableCopy;
    for (questModel * model in answer) {
        [str appendString:[NSString stringWithFormat:@"%@",model.answer]];
        [str appendString:@","];
    }
    NSLog(@"最终选择的答案是:%@",str);
}


/** 加载问卷回访试题 */
- (void)loadData{
    
    NSString * pathStr = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"plist"];
    
    //总的字典
    NSDictionary * riskBeanDict = [[NSDictionary alloc]initWithContentsOfFile:pathStr][@"RiskBean"];
    
    NSString * resultCode = [NSString stringWithFormat:@"%@",riskBeanDict[@"resultCode"]];
    
    if ([resultCode isEqualToString:@"200"]) {
        //题目列表
        NSArray * questArr = riskBeanDict[@"questionList"];
        
        for (NSDictionary * dict in questArr) {
            questModel * model = [[questModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArr addObject:model];
        }
        //这里设置UI
        self.questView.dataArr = self.dataArr;
        
    }
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}


@end
