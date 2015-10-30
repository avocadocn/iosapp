//
//  UILabel+FitContent.m
//  test
//
//  Created by tom on 15/10/30.
//  Copyright © 2015年 tom. All rights reserved.
//

#import "UILabel+FitContent.h"

@implementation UILabel (FitContent)

- (void)fitContent
{
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self.text boundingRectWithSize:CGSizeMake(260, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self.text sizeWithFont:self.font
                                  constrainedToSize:CGSizeMake(260, 999)
                                      lineBreakMode:self.lineBreakMode];
    }
    
    CGRect oldFrame = self.frame;
    oldFrame.size = expectedLabelSize;
    self.frame = oldFrame;
}
@end
