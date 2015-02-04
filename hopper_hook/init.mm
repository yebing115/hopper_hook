//
//  init.mm
//  hopper_hook
//
//  Created by bingMini on 12/16/14.
//  Copyright (c) 2014 bingMini. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <mach-o/fat.h>
#include <mach-o/loader.h>
#include "hopper_hook.h"

struct ProgramVars {
    struct mach_header* mh;
    int*    NXArgcPtr;
    const char***   NXArgvPtr;
    const char**    __prognamePtr;
};


__attribute__((constructor))
void dump_class(int argc, const char **argv, const char **envp, const char **apple, struct ProgramVars *pvars) {
    printf("dylib injected\n");
    [hopper_hook hook_check_register];
}
