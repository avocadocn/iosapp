//
//  ProfileButton.m
//  app
//
//  Created by 张加胜 on 15/8/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ProfileButton.h"

@implementation ProfileButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ProfileButton" owner:self options:nil];
        self = [nibs objectAtIndex:0];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)awakeFromNib{
    [self.icon.layer setCornerRadius:self.icon.width / 2];
    [self.icon.layer setMasksToBounds:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"_-------");
    [[NSNotificationCenter defaultCenter] postNotificationName:kProfileButtonClicked object:self];
}


@end
