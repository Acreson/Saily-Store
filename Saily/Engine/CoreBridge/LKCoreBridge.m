//
//  LKCoreBridge.m
//  Saily
//
//  Created by Lakr Aream on 2019/7/20.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import "LKCoreBridge.h"

#include <notify.h>

@implementation LKCBObject

- (void)call_to_daemon_with:(NSString *)string {
    NSLog(@"[*] 准备向远端发送数据 %@", string);
    UIPasteboard *sender = [UIPasteboard generalPasteboard];
    if ([sender string] != NULL) {
        NSString *priv = [[NSString alloc] initWithString: [sender string]];
        [sender setString:string];
        notify_post([@"com.Lakr233.Saily.MsgPas.UIPasteBoard.read" UTF8String]);
        usleep(233333);
        [sender setString:priv];
    } else {
        notify_post([@"com.Lakr233.Saily.MsgPas.UIPasteBoard.read" UTF8String]);
    }
}

// https://stackoverflow.com/questions/3184235/how-to-redirect-the-nslog-output-to-file-instead-of-console
- (void)redirectConsoleLogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"/console.txt"];
    freopen([logPath fileSystemRepresentation],"a+",stderr);
}

@end
