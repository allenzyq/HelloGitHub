//
//  WaterFallFlowLayout.h
//  D3定制瀑布流
//
//  Created by rock on 15/11/18.
//  Copyright © 2015年 zyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFallFlowLayout;

//创建代理方法
@protocol WaterFallFlowLayoutDelegate <NSObject>

-(CGFloat)waterFallFlowLayout:(WaterFallFlowLayout*)layout heightForItemAntIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFallFlowLayout : UICollectionViewLayout
@property (nonatomic,assign)id<WaterFallFlowLayoutDelegate>delegate;

//@protocol UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>
@property (nonatomic,assign) CGFloat minimumLineSpacing;

@property (nonatomic,assign) CGFloat minimumColumnSpacing;

@property (nonatomic,assign) UIEdgeInsets sectionInset;

@property(nonatomic,assign)NSUInteger numberofColumns; //列数

@end

