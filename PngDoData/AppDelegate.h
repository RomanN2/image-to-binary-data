//
//  AppDelegate.h
//  PngDoData
//
//  Created by Roman Nazarkevych on 3/26/13.
//  Copyright (c) 2013 Roman Nazarkevych. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *statusTextView;

- (IBAction)selectFolder:(id)sender;

- (void) convertFile:(NSString*)filePath;

@end
