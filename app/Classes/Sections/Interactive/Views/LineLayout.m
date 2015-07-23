//
//  LineLayout.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "LineLayout.h"
#import "RankItemLayoutAttr.h"
#define ITEM_SIZE 150
#define ACTIVE_DISTANCE 300
#define ZOOM_FACTOR 0.8


@interface LineLayout()
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) CGFloat gapLength;

@end
@implementation LineLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       self.sectionInset = UIEdgeInsetsMake((DLScreenHeight - ITEM_SIZE) / 2 - 64 ,100,(DLScreenHeight -ITEM_SIZE) / 2,20);
        self.minimumLineSpacing = -50.0;
        self.gapLength = ITEM_SIZE + self.minimumLineSpacing;
        // self.sectionInset = UIEdgeInsetsMake(100, 100, 100, 100);
        self.currentIndex = 0;
        
   
        

    }
    return self;
}


// 覆盖其中的layoutAttrClass
+(Class)layoutAttributesClass{
    
    return [RankItemLayoutAttr class];
}

- (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat verticalCenter = proposedContentOffset.y + (CGRectGetHeight(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    // NSInteger currentIndex = 0;
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (RankItemLayoutAttr* layoutAttributes in array) {
        // NSLog(@"%@",layoutAttributes);
        // NSLog(@"count:%zd",array.count);
        // NSLog(@"%@",NSStringFromCGPoint(layoutAttributes.center));
        CGFloat itemVerticalCenterCenter = layoutAttributes.center.y;
        if (ABS(itemVerticalCenterCenter - verticalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemVerticalCenterCenter - verticalCenter;
            // currentIndex = layoutAttributes.indexPath.item;
            // NSLog(@"%zd",layoutAttributes.indexPath.item);
        }
        // NSLog(@"%zd",currentIndex);
        
    }
    return CGPointMake(proposedContentOffset.x  , proposedContentOffset.y + offsetAdjustment);
}



-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    
    visibleRect.size = self.collectionView.bounds.size;
   
   
    
    for (RankItemLayoutAttr* attributes in array) {
    
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidY(visibleRect) - attributes.center.y;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                if (ABS(distance) < self.gapLength / 2) {
                    self.currentIndex = attributes.indexPath.item;
                    
                }
               
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
               
                attributes.zIndex = array.count - ABS(attributes.indexPath.item - self.currentIndex);
                attributes.equivocation =  ABS(normalizedDistance);
                [[NSNotificationCenter defaultCenter] postNotificationName:kLineLayoutAttrChange object:attributes];
                
            }
            if (ABS(distance) > 150) {
                attributes.hidden = YES;
            }
        }
    }
    return array;
}



-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
   // NSLog(@"%@",NSStringFromCGRect(newBounds));
    return YES;
}

@end
