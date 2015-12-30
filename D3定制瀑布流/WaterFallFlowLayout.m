//
//  WaterFallFlowLayout.m
//  D3定制瀑布流
//
//  Created by rock on 15/11/18.
//  Copyright © 2015年 zyq. All rights reserved.
//

#import "WaterFallFlowLayout.h"

@interface WaterFallFlowLayout ()
{
    NSMutableArray * _coulumnHeights; //用于记录所有列的高度
    
    NSMutableArray * _itemAttribute; //该数据用于记录布局的所有item的属性信息

}


@end

@implementation WaterFallFlowLayout
-(void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    if (_minimumColumnSpacing !=minimumLineSpacing) {
        
        _minimumColumnSpacing = minimumLineSpacing;
        //让布局失效，会自动重新布局
        [self invalidateLayout];
    }
}
-(void)setMinimumColumnSpacing:(CGFloat)minimumColumnSpacing
{
    if (_minimumColumnSpacing !=minimumColumnSpacing) {
        _minimumColumnSpacing = minimumColumnSpacing;
        [self invalidateLayout];
    }

}
-(void)setNumberofColumns:(NSUInteger)numberofColumns
{
    if (_numberofColumns !=numberofColumns) {
        _numberofColumns = numberofColumns;
        [self invalidateLayout];
    }
}
-(void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset= sectionInset;
        [self invalidateLayout];
    }
}
//重写方法 1：准备布局
-(void)prepareLayout
{
    [super prepareLayout];
    
    if(_coulumnHeights){
        [_coulumnHeights removeAllObjects];
    }else{
        _coulumnHeights = [[NSMutableArray alloc]init];
    }
    
    if (_itemAttribute) {
        [_itemAttribute removeAllObjects];
    }else{
        _itemAttribute = [[NSMutableArray alloc]init];
    }
//    设置每列的开始布局高度 (上边界应该是开始布局第一个的高度)
    for (NSUInteger i = 0;i<self.numberofColumns ; i++) {
        [_coulumnHeights addObject:@(self.sectionInset.top)];
    }
    //真正开始布局
    //计算item的宽度
    CGFloat totalWidth = self.collectionView.frame.size.width;
    CGFloat validWidth =totalWidth-self.sectionInset.left -self.sectionInset.right-(self.numberofColumns-1)*self.minimumColumnSpacing;
    CGFloat itemWidth = validWidth/self.numberofColumns;
//获取itemde 个数
    CGFloat itemHeight = itemWidth;
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i<count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        if ([self.delegate respondsToSelector:@selector(waterFallFlowLayout:heightForItemAntIndexPath:)]) {
         //计算item的高度
                   //想代理对象索取item的高度
        itemHeight = [self.delegate waterFallFlowLayout:self heightForItemAntIndexPath:indexPath];
        }
        //计算原点坐标
        NSUInteger shortestt = [self indexOfshotestColumn];
        CGFloat originX =self.sectionInset.left +shortestt*(itemWidth +self.minimumColumnSpacing);
        CGFloat orighinY = [_coulumnHeights[shortestt]floatValue];
        //得出frame

        CGRect frame = CGRectMake(originX, orighinY, itemWidth, itemHeight);
        
        
        //创建属性对象，并保存 frame
        UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = frame;
        [_itemAttribute addObject:attr];
        
        //更新最短列的高度
        [_coulumnHeights replaceObjectAtIndex:shortestt withObject:@(orighinY+itemHeight+self.minimumLineSpacing)];
        
    }
   //重新加载
    [self.collectionView reloadData];
}

//重写方法2 ：返回与指定区域(rect)有交集的所有item的属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (UICollectionViewLayoutAttributes *attr in _itemAttribute) {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            //有交集就保存
            [array addObject:attr];
        }
    }
    return array;
}
//重写方法4：返回滚动视图内容尺寸
-(CGSize)collectionViewContentSize
{
    NSInteger longest = [self indexOflongestColumn];
    CGFloat height  =[_coulumnHeights[longest] floatValue]-self.minimumLineSpacing+self.sectionInset.bottom;
    CGFloat width = self.collectionView.frame.size.width;
    return CGSizeMake(width, height);
}
//重写方法3：返回指定item的属性信息
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemAttribute[indexPath.item];

}
//返回数组中长度最短的或最长的下标
-(NSUInteger )indexOfshotestColumn
{
    NSUInteger index = 0;
    for (NSInteger i = 1; i<self.numberofColumns; i++) {
        if ([_coulumnHeights[i ] floatValue]<[_coulumnHeights[index] floatValue]) {
            index = i;
        }
    }
    
    return index;
}
-(NSUInteger )indexOflongestColumn
{
    
    NSUInteger index = 0;
    for (NSInteger i = 1; i<self.numberofColumns; i++) {
        if ([_coulumnHeights[i ] floatValue]>[_coulumnHeights[index] floatValue]) {
            index = i;
        }
    }
    
    return index;
}

@end
