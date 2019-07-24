//
//  Operator.h
//  Saily
//
//  Created by Lakr Aream on 2019/7/21.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#ifndef Operator_h
#define Operator_h

#import <Foundation/Foundation.h>
#include <spawn.h>
#include <mach/mach.h>

void setAppPath(NSString *string);
void run_cmd(char *cmd);
NSString *readAppPath(void);
void redirectConsoleLogToDocumentFolder(void);
int read_status(void);
void outDaemonStatus(void);
void fix_permission(void);
void executeScriptFromApplication(void);
void executeRespring(void);
#endif /* Operator_h */
