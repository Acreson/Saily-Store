//
//  Linstener.m
//  Tweaker.Daemon
//
//  Created by Lakr Aream on 2019/7/21.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import "Linstener.h"

static void readPasteBoard() {
    
    UIPasteboard *some = [UIPasteboard generalPasteboard];
    NSString *read = [some string];
    NSLog(@"%@", read);
    
    if ([read hasPrefix:@"init:path:"]) {
        setAppPath([read substringFromIndex:10]);
    }
    
}

void regLinsteners() {
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    readPasteBoard,
                                    CFSTR("com.Lakr233.Tweaker.MsgPas.UIPasteBoard.read"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
}
