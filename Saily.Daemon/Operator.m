//
//  Operator.m
//  Saily.Daemon
//
//  Created by Lakr Aream on 2019/7/21.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import "Operator.h"

NSString *LKRDIR = @"";
int daemon_status = 0;

int read_status() {
    return daemon_status;
}

NSString *readAppPath() {
    return LKRDIR;
}

void setAppPath(NSString *string) {
    LKRDIR = string;
    NSLog(@"[*] 将 daemon 初始化到应用程序路径: %@", string);
    redirectConsoleLogToDocumentFolder();
}

void outDaemonStatus() {
    if ([LKRDIR isEqualToString:@""]) {
        NSLog(@"[E] 路径顺序不合法");
        return;
    }
    NSString *status_str = @"unknown";
    switch (daemon_status) {
        case 0:
            status_str = @"ready";
            break;
        case 1:
            status_str = @"busy";
        default:
            break;
    }
    NSString *echo = [[NSString alloc] initWithFormat: @"echo %@ >> %@/daemon.call/status.txt", status_str, LKRDIR];
    run_cmd((char *)[echo UTF8String]);
    fix_permission();
}

extern char **environ;
void run_cmd(char *cmd) {
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL, NULL};
    int status;
    
    status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
}

void fix_permission() {
    NSString *com = [[NSString alloc] initWithFormat:@"chmod -R 0777 %@/daemon.call", LKRDIR];
    run_cmd((char *)[com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"chown -R 777:777 %@/daemon.call/*", LKRDIR];
    run_cmd((char *)[com UTF8String]);
}

void redirectConsoleLogToDocumentFolder() {
    if ([LKRDIR isEqualToString:@""]) {
        NSLog(@"[E] 路径顺序不合法");
        return;
    }
    NSString *logPath = [LKRDIR stringByAppendingPathComponent:@"/daemon.call/console.txt"];
    NSString *echo = [[NSString alloc] initWithFormat: @"echo init >> %@/daemon.call/console.txt", LKRDIR];
    run_cmd((char *)[echo UTF8String]);
    fix_permission();
    freopen([logPath fileSystemRepresentation], "a+", stderr);
    NSLog(@"[*] 重定向输出到文件： %@", logPath);
}
