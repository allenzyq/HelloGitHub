//
//  RootViewController.m
//  D3定制瀑布流
//
//  Created by rock on 15/11/18.
//  Copyright © 2015年 zyq. All rights reserved.
//

#import "RootViewController.h"
#import "WaterFallFlowLayout.h"
#define VIEW_HEIGHT    self.view.frame.size.height
#define RANDOM    arc4random()%256/255.0
#define VIEW_WIDTH   self.view.frame.size.width
@interface RootViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterFallFlowLayoutDelegate>
//UICollectionViewDelegateFlowLayout 里面包含  UICollectionViewDelegate
{
UICollectionView * _collectionView;

}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建集合视图
    [self createCollectionView];
}
-(void)createCollectionView
{
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, VIEW_WIDTH, VIEW_HEIGHT) collectionViewLayout:[self createLayout]];
    _collectionView.backgroundColor = [UIColor redColor];
    _collectionView.dataSource = self;
    
    _collectionView.delegate = self;
    //注册cell 类型
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}
-(CGFloat)waterFallFlowLayout:(WaterFallFlowLayout*)layout heightForItemAntIndexPath:(NSIndexPath *)indexPath
{
    return arc4random()%200+50;

}
-(void)setLineSpacingFor:(WaterFallFlowLayout *)layout
{

    layout.minimumColumnSpacing = 30;
}
-(UICollectionViewLayout *)createLayout
{
#if 1
    WaterFallFlowLayout * layout = [[WaterFallFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10;
    layout.minimumColumnSpacing = 20;
    layout.numberofColumns = 3;
    layout.delegate = self;
    [self performSelector:@selector(setLineSpacingFor:) withObject:layout  afterDelay:5];
    
#else
 
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(150, 100);
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
#endif
    return layout;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  100;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UILabel * label = nil;
        NSArray * array = cell.contentView.subviews;
    if (array.count!=0) {
        label = array[0];
    }else
    {
        label = [[UILabel alloc]init];
       
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:50];
        }
    CGSize size = cell.frame.size;
        label.frame = CGRectMake(0, 0, size.width, size.height);
    label.text = [NSString stringWithFormat:@"%2ld",indexPath.item];
    [cell.contentView addSubview:label];
    cell.backgroundColor = [UIColor colorWithRed:RANDOM green:RANDOM blue:RANDOM alpha:1];

    return cell;
}
#pragma mark -UICollectionViewDelegateFlowLayout

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(150, arc4random()%200+50);
//}

@end
