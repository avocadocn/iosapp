//
//  PublishedInteractionsMapViewController.h
//  app
//
//  Created by burring on 15/9/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@protocol PublishedDelegate<NSObject>

-(void)passAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end



@interface PublishedInteractionsMapViewController : UIViewController

@property (nonatomic, assign)id<PublishedDelegate>delegate;

@end
