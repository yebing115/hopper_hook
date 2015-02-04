//
//  hopper_hook.m
//  hopper_hook
//
//  Created by bingMini on 12/16/14.
//  Copyright (c) 2014 bingMini. All rights reserved.
//

#import "hopper_hook.h"
#import <objc/objc-runtime.h>

static unsigned long p_control = 0;

@implementation hopper_hook
+(void)hook_check_register {
    IMP my_imp = nil;
    unsigned int my_inst_method_count = 0;
    Method *myMethods = class_copyMethodList([hopper_hook class], &my_inst_method_count);
    for (int i = 0; i < my_inst_method_count; i++) {
        Method *thisMethod = myMethods + i;
        const char *methodName = sel_getName(method_getName(*thisMethod));
        if (strcmp(methodName, "myCheckRegistrationLicense:") == 0) {
            my_imp = method_getImplementation(*thisMethod);
        }
    }
    
    free(myMethods);
    
    // HopperAppDelegate
    Class hopper = objc_getClass("HopperAppDelegate");

    NSLog(@"get hopper app delegate class: %lx\n", (unsigned long)hopper);

    unsigned int methodCount = 0;
    Method *methodArray = class_copyMethodList(hopper, &methodCount);
    NSLog(@"get hopper app delegate method count: %d\n", methodCount);

    for (int i = 0; i < methodCount; i++) {
        Method *thisMethod = methodArray + i;
        const char *methodName = sel_getName(method_getName(*thisMethod));
        if (strcmp(methodName, "checkRegistrationLicense:") == 0) {
            IMP imp = method_getImplementation(*thisMethod);
            NSLog(@"hopper app delegate method : %s, imp addr: %lx\n", methodName, (unsigned long)imp);
            if (my_imp && imp) {
                method_setImplementation(*thisMethod, my_imp);
                typedef void(*func)(int);
                unsigned long slide = (unsigned long)imp - 0x10000B0AE;
                
//                unsigned long xx = 0x100082120 + slide;
//                NSLog(@"xx addr: %lx slide: %lx", xx, slide);
//                ((func)xx)(0x1);
                *(int*)(0x10053496C + slide) = 0x1;
                p_control = 0x10053496C + slide;
                NSLog(@"method hooked!\n");
            }
            
        }
    }
    
    free(methodArray);
    
//    unsigned int class_method_count = 0;
//    Method *classMethods = class_copyMethodList(object_getClass(hopper), &class_method_count);
//    NSLog(@"HopperAppDelegate has %d class methods", class_method_count);
//    for (int j = 0; j < class_method_count; j++) {
//        Method *thisMethod = classMethods + j;
//        const char *methodName = sel_getName(method_getName(*thisMethod));
//        //NSLog(@"class method name: %s", methodName);
//        if (strcmp(methodName, "checkSavedRegistration") == 0) {
//            char* returnTypeStr = method_copyReturnType(*thisMethod);
//            NSLog(@"checkSavedRegistration return type is: %s", returnTypeStr);
//            free(returnTypeStr);
//        }
//    }
}

-(BOOL)myCheckRegistrationLicense:(NSData*)data {
//    NSArray * stack = [NSThread callStackSymbols];
//    NSLog(@"%@", stack);
    *(int*)(p_control) = 0x1;
    return true;
}
@end
