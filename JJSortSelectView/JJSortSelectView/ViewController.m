//
//  ViewController.m
//  JJSortSelectView
//
//  Created by iOS-JJ-MacBookAir on 16/5/30.
//  Copyright © 2016年 Nova. All rights reserved.
//

#import "ViewController.h"
#import "SortSelectView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic ,strong)UITableView *tv;
@property (strong,nonatomic)SortSelectView *sortView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self tv];
    
    
    NSDictionary *titleDic1 = @{@"title":@"品牌"};
    NSDictionary *titleDic2 = @{@"title":@"区域"};
    NSDictionary *titleDic3 = @{@"title":@"排序"};
    
    NSArray *array = @[@"奥迪",@"宝马",@"兰博基尼",@"比亚迪",@"东风标致",@"奇瑞",@"雪佛兰"];
    NSArray *array1 = @[@"aobama",@"宝马",@"兰博基尼",@"比亚迪",@"东风标致",@"奇瑞",@"雪佛兰"];
    NSArray *array2 = @[@"🐻毛",@"宝马",@"兰博基尼",@"比亚迪",@"东风标致",@"奇瑞",@"雪佛兰"];
    NSArray *menuArray = @[array,array1,array2];
    
    _sortView = [[SortSelectView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 50)];
    _sortView.sortMenuArray = @[titleDic1,titleDic2,titleDic3];
    _sortView.sortListArray = menuArray;
    
    //这个可以不传，不传的话将用keyWindow展示，如果传的在计算菜单位置的时候，将计算sortselectView 和 它的相对位置关系，所以如果传请保证有足够的高度默认菜单展开200高度


    _sortView.menuContainerView = self.view;
    _sortView.menuBlock = ^(NSUInteger tyepIdx,NSUInteger itemIdx){
        
        NSLog(@"the type is %lu the item is %lu",(unsigned long)tyepIdx,(unsigned long)itemIdx);
        
    };
    
    [self.view addSubview:_sortView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks
#pragma getter

- (UITableView *)tv{
    
    if (!_tv) {
        
        _tv = [[UITableView alloc] init];
        _tv.frame = CGRectMake(0, 70, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 70);
        _tv.delegate = self;
        _tv.dataSource = self;
        [self.view addSubview:_tv];
    }
    
    return _tv;
}

#pragma marks
#pragma tabelview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"index of %ld",(long)indexPath.row];
    
    return cell;
}

@end
