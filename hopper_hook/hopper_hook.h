//
//  hopper_hook.h
//  hopper_hook
//
//  Created by bingMini on 12/16/14.
//  Copyright (c) 2014 bingMini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hopper_hook : NSObject
+(void)hook_check_register;
//+(BOOL)my_check_register;
-(BOOL)myCheckRegistrationLicense:(NSData*)data;
@end
