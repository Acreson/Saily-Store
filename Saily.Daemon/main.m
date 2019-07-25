//
//  main.m
//  Saily.Daemon
//
//  Created by Lakr Aream on 2019/7/20.
//  Copyright (c) 2019 Lakr Aream. All rights reserved.
//

#import <Foundation/Foundation.h>

void someChimeraSetup(void);

#import "Operator.h"
#import "Linstener.h"

#include <dlfcn.h>

int main (int argc, const char * argv[])
{

    NSLog(@"[i] 准备启动 Daemon, 版本代号 0.6-b552");
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: @"/Applications/Sileo.app"]) {
        NSLog(@"[*] 为 Chimera 的越狱执行额外的脚本");
        someChimeraSetup();
        NSLog(@"[*] 确认存活？");
    }
    
    @autoreleasepool
    {
        regLinstenersOnMsgPass();
        CFRunLoopRun(); // keep it running in background
        return 0;
    }
	return 0;
}

void someChimeraSetup() {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", 1);
    if (handle) {
        dlerror();
        typedef void (*fix_setuid_prt_t)(pid_t pid);
        fix_setuid_prt_t ptr_setuid = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");
        typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
        fix_entitle_prt_t ptr_entitle = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");
        if(!dlerror()) {
            ptr_setuid(getpid());
        }
        // Come and fuck me if you can.
        for (int i = 0; i < 233; i++) {
            setuid(0);
        }
        if(!dlerror()) {
            ptr_entitle(getpid(), 2LL);
        }
    }
}


