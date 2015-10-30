//
//  UILabel+FitContent.m
//  test
//
//  Created by tom on 15/10/30.
//  Copyright © 2015年 tom. All rights reserved.
//

#import "UILabel+FitContent.h"

@implementation UILabel (FitContent)
- (CGSize)fitSizeWithMaxSize:(CGSize)maxSize
{
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self.text sizeWithFont:self.font
                                  constrainedToSize:maxSize
                                      lineBreakMode:self.lineBreakMode];
    }
    return expectedLabelSize;
}
- (void)fitContent
{
    CGSize expectedLabelSize = CGSizeZero;
    expectedLabelSize = [self fitSizeWithMaxSize:CGSizeMake(260, 999)];
    CGRect oldFrame = self.frame;
    oldFrame.size = expectedLabelSize;
    self.frame = oldFrame;
}
- (void)fitContentWithMaxSize:(CGSize)maxSize
{
    CGSize expectedLabelSize = CGSizeZero;
    expectedLabelSize = [self fitSizeWithMaxSize:maxSize];
    CGRect oldFrame = self.frame;
    oldFrame.size = expectedLabelSize;
    self.frame = oldFrame;
}
@end
