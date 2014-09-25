//
//  SaveToPhotoAlbum.m
//  SaveToPhotoAlbumPlugin
//
//  Created by Nadav Greenberg on 2/20/13.
//
//

#import "SaveToPhotoAlbum.h"

@implementation SaveToPhotoAlbum

- (void) saveToPhotoAlbum:(CDVInvokedUrlCommand*)command {
// - (void) saveToPhotoAlbum:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString* callbackId = command.callbackId;
    NSString* path = [command.arguments objectAtIndex:0];
    // UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];

    //Now it will do this for each photo in the array
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}



@end
