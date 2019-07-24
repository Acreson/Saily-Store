//
//  Operator.m
//  Saily.Daemon
//
//  Created by Lakr Aream on 2019/7/21.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import "Operator.h"

BOOL IN_FORCE_ROOT_APP = false;

NSString *LKRDIR = @"";
int daemon_status = 0;

int read_status() {
    return daemon_status;
}

NSString *readAppPath() {
    return LKRDIR;
}

void setAppPath(NSString *string) {
    
    if ([string containsString:@"/var/mobile/Containers/Data/Application/"] && IN_FORCE_ROOT_APP) {
        NSLog(@"[*] 不允许沙箱内 App 启用此版本 daemon: %@", string);
        exit(9);
    }
    
    LKRDIR = string;
    NSLog(@"[*] 将 daemon 初始化到应用程序路径: %@", string);
//    redirectConsoleLogToDocumentFolder();
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

void executeScriptFromApplication() {
    NSLog(@"[*] 准备执行用户脚本");
    
    if ([LKRDIR  isEqual: @""]) {
        NSLog(@"[*] 不允许未初始化的实例执行脚本");
        return;
    }
    
    NSString *test = [[NSString alloc] initWithFormat: @"%@/daemon.call/requsetScript.txt", LKRDIR];
    if (![[NSFileManager defaultManager] fileExistsAtPath: test]) {
        NSLog(@"[*] 脚本文件不存在，拒绝执行");
        return;
    }
    
    NSString *mkdir = @"mkdir -p /var/root/Saily.Daemon";
    NSString *cp = [[NSString alloc] initWithFormat: @"cp %@/daemon.call/requsetScript.txt /var/root/Saily.Daemon/requsetScript.txt", LKRDIR];
    NSString *chmod = [[NSString alloc] initWithFormat: @"chmod +x /var/root/Saily.Daemon/requsetScript.txt"];
    NSString *bash = [[NSString alloc] initWithFormat: @"bash /var/root/Saily.Daemon/requsetScript.txt"];
    run_cmd((char *)[mkdir UTF8String]);
    run_cmd((char *)[cp UTF8String]);
    run_cmd((char *)[chmod UTF8String]);
    run_cmd((char *)[bash UTF8String]);
    NSLog(@"[*] 执行完成 ✅");
    fix_permission();
}

void executeRespring() {
    NSString *cmd = @"killall backboardd";
    run_cmd((char *)[cmd UTF8String]);
    NSLog(@"[*] 注销完成");
    exit(0);
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
