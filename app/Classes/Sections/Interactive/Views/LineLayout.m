//
//  LineLayout.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "LineLayout.h"
#define ITEM_SIZE 200
#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3
@implementation LineLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       self.sectionInset = UIEdgeInsetsMake(100, DLScreenWidth / 2 - ITEM_SIZE / 2, 100, DLScreenWidth / 2 - ITEM_SIZE / 2);
        self.minimumLineSpacing = -150;
         // self.sectionInset = UIEdgeInsetsMake(100, 100, 100, 100);
        

    }
    return self;
}


- (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        //NSLog(@"%@",layoutAttributes);
        
        // NSLog(@"%@",NSStringFromCGPoint(layoutAttributes.center));
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
        
        
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment , proposedContentOffset.y);
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
   // NSLog(@"--");
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    NSInteger zIndex = 1;
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = -(++zIndex);
                // NSLog(@"%zd",zIndex);
                NSLog(@"%f--%f",attributes.center.x,DLScreenWidth / 2);
            }
        }
       
    }
    return array;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
