//
//  SortSelectView.m
//  N-BOX
//
//  Created by iOS-JJ-MacBookAir on 16/5/27.
//  Copyright © 2016年 Novaiot. All rights reserved.
//



#import "SortSelectView.h"
#define SORTBTNTAG    100
#define SORTBTNHEIGHT 40
#define PERSPC        10

@interface ArrowView :UIView

@end


@implementation ArrowView

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{

    CGFloat point1x = 0.0;
    CGFloat point1y = 10.0;
    CGFloat point2x = 7.5;
    CGFloat point2y = 0;
    CGFloat point3x = 15;
    CGFloat point3y = 10;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetRGBStrokeColor(ctx, 188.0/255.0, 186.0/255.0, 193.0/255.0, 1.0);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, point1x, point1y);
    CGContextAddLineToPoint(ctx, point2x, point2y);
    CGContextAddLineToPoint(ctx, point3x, point3y);
    CGContextStrokePath(ctx);
}

@end

typedef void(^MenuListSelectedBlock)(NSUInteger idx);
@interface SortMenuView : UIView<UITableViewDataSource,UITableViewDelegate>
/**
 *  菜单数据源，这里需要将数据源按照和按钮相对应的顺序传入，否则有对应不上的问题
 */
@property(nonatomic ,strong)NSArray *menuList;
@property(nonatomic ,strong)UITableView *menuTV;
@property(nonatomic ,copy)MenuListSelectedBlock menuSelectedBlock;
//展开列表的时候给一个向下的箭头 提高体验
@property(nonatomic ,strong)ArrowView *arrowImgV;
//@property(nonatomic ,strong)UIImageView *arrowImgV;
@property(nonatomic ,strong)UIView *lineView;
//用于计算箭头的位置
@property(nonatomic ,assign)NSUInteger menuCount;
- (void)reloadTableViewWithMenuIdx:(NSUInteger)idx;
@end


@implementation SortMenuView

- (instancetype)initWithFrame:(CGRect)frame withCount:(NSUInteger)menuCount{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _menuCount = menuCount;
    }
    
    return self;
}


- (void)setMenuSelectedBlock:(MenuListSelectedBlock)menuSelectedBlock{
    
    _menuSelectedBlock = menuSelectedBlock;
    
}

/**
 *  刷新tv
 */
- (void)reloadTableViewWithMenuIdx:(NSUInteger)idx{
    
    
    [self resetArrayPosition:idx];
    [self.menuTV reloadData];
}


- (void)resetArrayPosition:(NSUInteger)idx{
    
    [self arrowImgV];
    [self lineView];
    [self bringSubviewToFront:self.arrowImgV];
    
    NSUInteger itemCount = _menuCount;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat perWidth = (width - (itemCount + 1)*PERSPC)/itemCount;
    CGFloat arrowImgVCenter = (idx + 1)*PERSPC + idx*perWidth + perWidth/2;
    
    self.arrowImgV.frame = CGRectMake(0, 0, 15, 10);
    self.arrowImgV.center = CGPointMake(arrowImgVCenter, -12/2.0);
    
}

#pragma marks
#pragma tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_menuList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_menuList objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_menuSelectedBlock) {
        
        _menuSelectedBlock(indexPath.row);
    }
    
}

#pragma marks
#pragma getter LineView

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc] init];
        _lineView.clipsToBounds = YES;
        _lineView.frame = CGRectMake(0, -1.5, CGRectGetWidth(self.frame), 0.5);
        _lineView.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:186.0/255.0 blue:193.0/255.0 alpha:1.0];
        [self addSubview:_lineView];
    }
    
    return _lineView;
}
#pragma marks
#pragma menuListArrow

- (UIView *)arrowImgV{
    
    if (!_arrowImgV) {
        
//        _arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuListArrow"]];
        _arrowImgV = [[ArrowView alloc] init];
        _arrowImgV.frame = CGRectMake(0, -12, 15, 10);
        _arrowImgV.backgroundColor = [UIColor whiteColor];
        _arrowImgV.clipsToBounds = YES;
        [self addSubview:_arrowImgV];
    }
    
    return _arrowImgV;
}
#pragma marks
#pragma getter tablveiew

- (UITableView *)menuTV{
    
    if (!_menuTV) {
        
        _menuTV = [[UITableView alloc] initWithFrame:self.bounds];
        _menuTV.delegate = self;
        _menuTV.dataSource = self;
        [self addSubview:_menuTV];
    }
    
    return _menuTV;
}


@end


#pragma marks==============
#pragma ===========================================




@interface SortSelectView ()

@property (nonatomic , strong)NSMutableArray *menuBtnArray;
@property (nonatomic , strong)SortMenuView *menuView;
@property (nonatomic , assign)NSUInteger lastBtnIdx;
@property (nonatomic , strong)UIButton *coverBtn;

@end
@implementation SortSelectView



- (instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _lastBtnIdx = -1;
        
    }
    
    return self;
}


/**
 *  设置数据源
 *
 *  @param sortMenuArray
 */
- (void)setSortMenuArray:(NSArray *)sortMenuArray{
    
    _sortMenuArray = sortMenuArray;
    
    [_sortMenuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [self sortBtnWithIdx:idx];
        [self addSubview:btn];
        
    }];
    
}

/**
 *  带箭头的按钮
 *
 *  @param idx idx
 *
 *  @return uibutton
 */

- (UIButton *)sortBtnWithIdx:(NSUInteger)idx {
    
    NSUInteger itemCount = _sortMenuArray.count;
    NSDictionary *dic = [_sortMenuArray objectAtIndex:idx];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat perWidth = (width - (itemCount + 1)*PERSPC)/itemCount;
    CGRect rect =  CGRectMake(PERSPC + (PERSPC + perWidth)*idx, 0, perWidth, SORTBTNHEIGHT);
    NSString *title = dic[@"title"];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    btn.contentMode = UIViewContentModeCenter;
    [btn setImage:[UIImage imageNamed:@"menuArrow"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, perWidth - (perWidth - titleSize.width)/2, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(perWidth - titleSize.width)/2, 0, 0)];
    [btn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = SORTBTNTAG + idx;
    btn.frame = rect;
    [self.menuBtnArray addObject:btn];
    return btn;
    
}

/**
 *  选中其中的一个按钮
 *
 *  @param btn
 */
- (void)sortAction:(UIButton *)btn{

    __unsafe_unretained typeof(self) weakself = self;
    
    btn.selected = !btn.selected;
    __block NSUInteger selectedTag = btn.tag;
    
    //set cover
    if (btn.selected) {
        
        [self setupCover];
        
        _lastBtnIdx = selectedTag;
        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        self.menuView.menuList = [self.sortListArray objectAtIndex:btn.tag - SORTBTNTAG];
        self.menuView.menuSelectedBlock = ^(NSUInteger idx){
            
            [weakself menuItemSelected:idx];
            
        };
        [self.menuView reloadTableViewWithMenuIdx:btn.tag - SORTBTNTAG];
        [self addMenuToKeyFrame];
        
    }else{
        
        btn.imageView.transform = CGAffineTransformMakeRotation(0);
        
        //dis cover
        [self coverClick];
    }


    
    [self.menuBtnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = (UIButton *)obj;
        if(btn.tag != _lastBtnIdx){
            
            btn.imageView.transform = CGAffineTransformMakeRotation(0);
            btn.selected = NO;
            
        }
        
    }];
}


//当点击一个菜单下的一行的时候，通过block 返回所选菜单及具体行
- (void)menuItemSelected:(NSUInteger)idx{
    
    //选择的是第几个类别 第几个具体Item
    
    if (_menuBlock) {
        
        _menuBlock(_lastBtnIdx - SORTBTNTAG,idx);
    }
    
}


/**
 *  添加菜单列表
 */
- (void)addMenuToKeyFrame{
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    [[self containerView] addSubview:self.menuView];
    
    
}




/**
 *  移除菜单相关
 */
- (void)coverClick{
    
    [self removeMenu];
    
}

/**
 *  菜单消失
 */
- (void)removeMenu
{
    _lastBtnIdx = -1;
    
    [self.menuBtnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = (UIButton *)obj;
        btn.imageView.transform = CGAffineTransformIdentity;
        btn.selected = NO;
        
    }];
    
    [self.menuView removeFromSuperview];
    self.menuView = nil;
    [self.coverBtn removeFromSuperview];
    self.coverBtn = nil;
    
}


/**
 *  获取相对于window 的位置
 *
 *  @return 相对位置
 */

- (CGRect)menuViewOriY{
    
    CGRect  rect = [self convertRect:self.bounds toView:[self containerView]];
//    DBLog(@"menu rect covert is orix = %f oriy =%f width =%f height = %f ",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
//    return rect.origin.y + rect.size.height;
    return rect;
    
}

#pragma marks
#pragma getter btnArray

- (NSMutableArray *)menuBtnArray{
    
    if (!_menuBtnArray) {
        
        _menuBtnArray = [NSMutableArray array];
    }

    return _menuBtnArray;
}


#pragma marks
#pragma menuView

- (SortMenuView *)menuView{
    
    if (!_menuView) {
        
        //这个东西是加在keywindow上的，frame 随便写的
        _menuView = [[SortMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 250) withCount:[self.sortMenuArray count]];
        _menuView.backgroundColor = [UIColor whiteColor];
    }
    
    /**
     *  下面的处理方式  是为了防止小屏手机高度不够 确保tv 可以滑动到最底部
     */
    CGRect rect = [self menuViewOriY];
    CGFloat oriy = rect.origin.y + rect.size.height;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - oriy;
    if(height > 200)height = 200;
    _menuView.frame = CGRectMake(0, rect.origin.y + rect.size.height, CGRectGetWidth(self.frame), height);
    return _menuView;
}

/**
 *  添加遮盖
 */
- (void)setupCover
{
    // 添加一个遮盖按钮
    
    if (self.coverBtn) {
        //已经有cover了 无需添加更多
        return;
    }
    CGRect rect = [self menuViewOriY];
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = CGRectMake(0, rect.origin.y +rect.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    self.coverBtn = cover;
    [[self containerView] addSubview:cover];
    
}


-  (UIView *)containerView{
    
    if (_menuContainerView) {
        
        return _menuContainerView;
    }else{
        
        return  [UIApplication sharedApplication].keyWindow;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
