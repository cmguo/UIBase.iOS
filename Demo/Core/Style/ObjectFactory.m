//
//  ObjectFactory.m
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

#include <objc/runtime.h>
#import <Foundation/Foundation.h>
#include "ObjectFactory.h"

@implementation ObjectFactory

+ (id) create:(NSString*)className {
    return [[NSClassFromString(className) alloc] init];
}

@end
