//
//  AppDelegate.m
//  PngDoData
//
//  Created by Roman Nazarkevych on 3/26/13.
//  Copyright (c) 2013 Roman Nazarkevych. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize statusTextView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction)selectFolder:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseDirectories:NO];
    [openDlg setCanChooseFiles:YES];
    openDlg.allowsMultipleSelection = YES;
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.]
        NSArray* files = [openDlg filenames];
        
        // Loop through all the files and process them.
        for( int i = 0; i < [files count]; i++ )
        {
            NSString* fileName = [files objectAtIndex:i];
            [self convertFile:fileName];
        }
    }
}

- (void) convertFile:(NSString*)filePath
{
    // Update Text View
    NSString *fileName = [[filePath stringByDeletingPathExtension] lastPathComponent];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"@" withString:@"_"];
    fileName = [fileName uppercaseString];
    [statusTextView insertText:[NSString stringWithFormat:@"%@\n", fileName]];
    
    // Read and prepare data
    NSData *imageData = [[[NSImage alloc] initWithContentsOfFile:filePath] TIFFRepresentation];
    NSUInteger len = [imageData length];
    Byte *byteArray = (Byte *)[imageData bytes];

    // Open result file
    NSString *resultPath = [[filePath stringByDeletingPathExtension] stringByDeletingLastPathComponent];
    resultPath = [resultPath stringByAppendingPathComponent:@"Resources.h"];
    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:resultPath];
    if ( !fh ) {
        [[NSFileManager defaultManager] createFileAtPath:resultPath contents:nil attributes:nil];
        fh = [NSFileHandle fileHandleForWritingAtPath:resultPath];
    }
    [fh seekToEndOfFile];

    // Write beginning of the file
    NSString *variableName = [NSString stringWithFormat:@"const char %@[] = {", [fileName uppercaseString]];
    [fh writeData:[variableName dataUsingEncoding:NSUTF8StringEncoding]];
    // Write image data to the result file
    NSString * comma = @", ";
    NSData *commaData = [comma dataUsingEncoding:NSUTF8StringEncoding];
    for (int i=0; i<len; i++) {
        Byte byte = byteArray[i];
        NSString *str = [NSString stringWithFormat:@"%d", byte];
        [fh writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];

        if (i != len-1) {
            [fh writeData:commaData];
        }
    }
    
    NSString *closingBracket = @"};\n";
    [fh writeData:[closingBracket dataUsingEncoding:NSUTF8StringEncoding]];
    [fh closeFile];
}

@end
