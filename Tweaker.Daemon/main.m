//
//  main.m
//  Tweaker.Daemon
//
//  Created by Lakr Aream on 2019/7/20.
//  Copyright (c) 2019 Lakr Aream. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Operator.h"
#import "Linstener.h"

int main (int argc, const char * argv[])
{

    @autoreleasepool
    {
        regLinsteners();
        CFRunLoopRun(); // keep it running in background
        return 0;
    }
	return 0;
}

