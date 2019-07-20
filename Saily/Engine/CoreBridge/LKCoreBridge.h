//
//  LKCoreBridge.h
//  Saily
//
//  Created by Lakr Aream on 2019/7/20.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LKCBObject : NSObject

- (void)call_to_daemon_with:(NSString *)string;
- (void)redirectConsoleLogToDocumentFolder;

@end

