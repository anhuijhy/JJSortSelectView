//
//  SortSelectView.h
//  N-BOX
//
//  Created by iOS-JJ-MacBookAir on 16/5/27.
//  Copyright © 2016年 Novaiot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuSelectedBlock)(NSUInteger typeIdx ,NSUInteger itemIdx);


@interface SortSelectView : UIView
@property(nonatomic ,strong)NSArray  *sortMenuArray;
/**
 *  菜单数据源，这里需要将数据源按照和按钮相对应的顺序传入，否则有对应不上的问题
 */
@property(nonatomic ,strong)NSArray  *sortListArray;
/**
 *  菜单显示在哪个view上面，如果没有的话 就是keywindow
 */
@property(nonatomic ,assign)UIView *menuContainerView;
@property (nonatomic , copy)MenuSelectedBlock menuBlock;
/**
 *  取消ListView
 */
- (void)removeMenu;
@end
