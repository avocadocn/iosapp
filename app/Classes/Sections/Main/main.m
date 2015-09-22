      //
//  main.m
//  etrst
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
// //

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [NBSAppAgent startWithAppID:@"a6711df5a236411dafac4c389353dd57"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
