//
//  ObjectFactory.h
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

#ifndef ObjectFactory_h
#define ObjectFactory_h

@interface ObjectFactory : NSObject

+ (id) create: (NSString*)className;

+ (NSArray*) valuesForStyle: (id) clsStyles style: (NSString*)name;

+ (NSArray*) descsForStyle: (id) clsStyles style: (NSString*)name;

@end

#endif /* ObjectFactory_h */
