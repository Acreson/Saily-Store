//
//  Operator.m
//  Saily.Daemon
//
//  Created by Lakr Aream on 2019/7/21.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import "Operator.h"

NSString *LKRDIR = @"";

NSString *readAppPath() {
    return LKRDIR;
}

void setAppPath(NSString *string) {
    LKRDIR = string;
    NSLog(@"[*] 将 daemon 初始化到应用程序路径: %@", string);
}

extern char **environ;
void run_cmd(char *cmd)
{
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

static void fix_permission()
{
    NSString *com = [[NSString alloc] initWithFormat:@"chmod -R 0777 %@/daemon.call", LKRDIR];
    run_cmd((char *)[com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"chown -R 501:501 %@/daemon.call", LKRDIR];
    run_cmd((char *)[com UTF8String]);
}
