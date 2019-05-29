//
//  CXAnyModelEntrance.h
//  CXAnyModel
//
//  Created by shane chen on 2019/5/20.
//  Copyright © 2019年 shane chen. All rights reserved.
//

#include <objc/runtime.h>
#include <objc/message.h>

#import "CXAnyModelEntrance.h"
#import "CXAnyModelBlocks.h"

char *const anyModel_rootContainer = "anyModel_rootContainer";

NSString *const anyModel_allBindSerializationValuePropertyAndAttributes = @"anyModel_allBindSerializationValuePropertyAndAttributes";
NSString *const anyModel_allBindNormalValuePropertyAndAttributes = @"anyModel_allBindNormalValuePropertyAndAttributes";

NSString *const anyModel_bindSerialization = @"anyModel_bindSerialization";
NSString *const anyModel_bindNormal = @"anyModel_bindNormal";

@protocol CXAnyModelPrivate <NSObject>

@optional

+ (NSSet<NSString *> *)allBindSerializationPropertys;
+ (NSSet<NSString *> *)allBindNormalPropertys;

+ (NSSet<NSString *> *)allPropertysFrom:(Protocol *)tagPro withKey:(NSString *)key;

- (void)runSeterBlockToInvocation:(NSInvocation *)anInvocation withSetName:(NSString *)name setType:(NSString *)type inContainerKey:(NSString *)containerKey;
- (void)runGeterBlockToInvocation:(NSInvocation *)anInvocation withGetName:(NSString *)name getType:(NSString *)type inContainerKey:(NSString *)containerKey;

@end

#pragma string actions

NSUInteger occurenceOfString(NSString *targetString , NSString *substring){
    if(!substring.length){
        return 0;
    }
    NSUInteger cnt = 0, length = [targetString length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [targetString rangeOfString:substring options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            cnt++;
        }
    }
    return cnt;
}

#pragma bind actions

void anyModel_bindValueWithKey(id target,id value,id<NSCopying> key)
{
    if(value && key && [(id<NSObject>)key conformsToProtocol:@protocol(NSCopying)]){
        NSMutableDictionary *bindDictionary = objc_getAssociatedObject(target, anyModel_rootContainer);
        if (!bindDictionary) {
            bindDictionary = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(target,anyModel_rootContainer, bindDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [bindDictionary setObject:value forKey:key];
    }
}

void anyModel_removeBindValueForKey(id target,id<NSCopying> key)
{
    if(key && [(id<NSObject>)key conformsToProtocol:@protocol(NSCopying)]){
        NSMutableDictionary *bindDictionary = objc_getAssociatedObject(target,anyModel_rootContainer);
        if(bindDictionary){
            [bindDictionary removeObjectForKey:key];
        }
    }
}

BOOL anyModel_containsBindValueForKey(id target,id<NSCopying> key)
{
    if(key && [(id<NSObject>)key conformsToProtocol:@protocol(NSCopying)]){
        NSMutableDictionary *bindDictionary = objc_getAssociatedObject(target,anyModel_rootContainer);
        if(bindDictionary){
            return [bindDictionary.allKeys containsObject:key];
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

id anyModel_getBindValueForKey(id target,id<NSCopying> key)
{
    if(key && [(id<NSObject>)key conformsToProtocol:@protocol(NSCopying)]){
        NSMutableDictionary *bindDictionary = objc_getAssociatedObject(target,anyModel_rootContainer);
        if(bindDictionary){
            return [bindDictionary objectForKey:key];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

void anyModel_clearBindValues(id target)
{
    NSMutableDictionary *bindDictionary = objc_getAssociatedObject(target,anyModel_rootContainer);
    if(bindDictionary){
        [bindDictionary removeAllObjects];
    }
}

#pragma setter

void anyModel_setValueToContainer(id target,NSString *key,id value,NSString *containerKey){
    [target willChangeValueForKey:key];
    [target willChangeValueForKey:containerKey];
    
    NSMutableDictionary *container = anyModel_getBindValueForKey(target, containerKey);
    if(!container){
        container = NSMutableDictionary.new;
        anyModel_bindValueWithKey(target, container, containerKey);
    }
    
    if (value) {
        [container setObject:value forKey:key];
    }
    else
    {
        if ([container.allKeys containsObject:key]) {
            [container removeObjectForKey:key];
        }
    }
    
    [target didChangeValueForKey:key];
    [target didChangeValueForKey:containerKey];
};


#pragma getter

id anyModel_getValueFromContainer(id target,NSString *key,NSString *containerKey){
    NSMutableDictionary *container = anyModel_getBindValueForKey(target, containerKey);
    if(!container){
        container = NSMutableDictionary.new;
        anyModel_bindValueWithKey(target, container, containerKey);
    }
    return [container objectForKey:key];
};

#pragma mate functions

extern IMP getOrigIMPFromRegistedClass(Class class,SEL sel);

NSSet<NSString *> *allBindSerializationPropertys(Class<CXAnyModelPrivate> self,SEL _cmd)
{
    return [self allPropertysFrom:@protocol(CXAnyModelSerializationValue) withKey:anyModel_allBindSerializationValuePropertyAndAttributes];
}

NSSet<NSString *> *allBindNormalPropertys(Class<CXAnyModelPrivate> self,SEL _cmd)
{
    return [self allPropertysFrom:@protocol(CXAnyModelNormalValue) withKey:anyModel_allBindNormalValuePropertyAndAttributes];
}

NSSet<NSString *> *allPropertysFromProtocolWithKey(Class self,SEL _cmd,Protocol *tagPro,NSString *key)
{
    NSSet<NSString *> *allPropertys = anyModel_getBindValueForKey(self, key);
    return allPropertys?:({
        BOOL (^hasContainProtocol)(Protocol *,Protocol *) = ^(Protocol *a,Protocol *b){
            BOOL result = NO;
            unsigned int proCount;
            Protocol * __unsafe_unretained *list = protocol_copyProtocolList(a, &proCount);
            for (int i = 0; i < proCount; i++) {
                Protocol *pro = list[i];
                result = result || protocol_isEqual(pro, b);
            }
            free(list);
            return result;
        };
        
        NSSet *(^findPropertyFromProtocol)(Protocol *) = ^(Protocol *pro){
            NSMutableSet *all = [NSMutableSet set];
            if(hasContainProtocol(pro,tagPro)){
                unsigned int proCount;
                objc_property_t *properties = protocol_copyPropertyList(pro, &proCount);
                for (int j = 0; j < proCount ; j++) {
                    const char *propertyName = property_getName(properties[j]);
                    [all addObject:[NSString stringWithUTF8String:propertyName]];
                }
                free(properties);
            }
            return [NSSet setWithSet:all];
        };
        
        NSMutableSet<NSSet *(^)(Protocol *)> *blockSet = NSMutableSet.set;
        NSSet *(^block)(Protocol *) = ^(Protocol *pro){
            NSMutableSet *all = [NSMutableSet set];
            [all unionSet:findPropertyFromProtocol(pro)];
            unsigned int count;
            Protocol * __unsafe_unretained *list = protocol_copyProtocolList(pro, &count);
            for (int i = 0; i < count; i++) {
                Protocol *innerPro = list[i];
                [all unionSet:findPropertyFromProtocol(innerPro)];
                [all unionSet:blockSet.anyObject(innerPro)];
            }
            free(list);
            return [NSSet setWithSet:all];
        };
        [blockSet addObject:block];
        
        NSMutableSet<NSString *> *all = [NSMutableSet set];
        unsigned int count;
        Protocol * __unsafe_unretained *list = class_copyProtocolList(self, &count);
        for (int i = 0; i < count; i++) {
            Protocol *pro = list[i];
            NSSet *pNames = blockSet.anyObject(pro);
            NSMutableSet<NSString *> *checkSet = [NSMutableSet setWithSet:all];
            [checkSet intersectSet:pNames];
            if(checkSet.count){
                //有命名重复
                @throw [NSException exceptionWithName:@"CXAnyModel" reason:@"RegisterFailWithDuplicateProperty" userInfo:@{@"protocol":pro,@"property":checkSet}];
            }
            else{
                [all unionSet:blockSet.anyObject(pro)];
            }
        }
        free(list);
        [blockSet removeAllObjects];
        anyModel_bindValueWithKey(self, [NSSet setWithSet:all], key);
        anyModel_getBindValueForKey(self, key);
    });
}

id valueForKey(id self,SEL _cmd,NSString *key)
{
    NSString *theKey = nil;
    if([key hasPrefix:@"_"]){
        theKey = [key substringWithRange:NSMakeRange(1, key.length - 1)];
    }
    else{
        theKey = key;
    }
    
    Class<CXAnyModelPrivate> class = [self class];
    
    if([[class allBindSerializationPropertys] containsObject:theKey] || [[class allBindNormalPropertys] containsObject:theKey]){
        return nil;
    }
    else{
        IMP imp = getOrigIMPFromRegistedClass([self class],_cmd);
        
        id result;
        @autoreleasepool {
            result = ((id (*) (id , SEL , id))imp)(self,_cmd,key);
        }
        
        return result;
    }
}

#pragma instanse functions

void setBindSerialization(id self,SEL _cmd,NSMutableDictionary *bindDictionary)
{
    NSMutableDictionary *bindSerialization = anyModel_getBindValueForKey(self,anyModel_bindSerialization);
    if(!bindSerialization){
        bindSerialization = [NSMutableDictionary dictionary];
        anyModel_bindValueWithKey(self, bindSerialization,anyModel_bindSerialization);
    }
    
    [bindSerialization removeAllObjects];
    [bindSerialization addEntriesFromDictionary:bindDictionary];
}

NSMutableDictionary *bindSerialization(id self,SEL _cmd)
{
    NSMutableDictionary *bindSerialization = anyModel_getBindValueForKey(self,anyModel_bindSerialization);
    if(!bindSerialization){
        bindSerialization = [NSMutableDictionary dictionary];
        anyModel_bindValueWithKey(self, bindSerialization,anyModel_bindSerialization);
    }
    
    return bindSerialization;
}

void setBindNormal(id self,SEL _cmd,NSMutableDictionary *bindDictionary)
{
    NSMutableDictionary *bindSerialization = anyModel_getBindValueForKey(self,anyModel_bindNormal);
    if(!bindSerialization){
        bindSerialization = [NSMutableDictionary dictionary];
        anyModel_bindValueWithKey(self, bindSerialization,anyModel_bindNormal);
    }
    
    [bindSerialization removeAllObjects];
    [bindSerialization addEntriesFromDictionary:bindDictionary];
}

NSMutableDictionary *bindNormal(id self,SEL _cmd)
{
    NSMutableDictionary *bindSerialization = anyModel_getBindValueForKey(self,anyModel_bindNormal);
    if(!bindSerialization){
        bindSerialization = [NSMutableDictionary dictionary];
        anyModel_bindValueWithKey(self, bindSerialization,anyModel_bindNormal);
    }
    
    return bindSerialization;
}

#pragma method translate

NSMethodSignature *methodSignatureForSelector(id self,SEL _cmd,SEL aSelector)
{
    Class<CXAnyModelPrivate> class = [self class];
    
    IMP imp = getOrigIMPFromRegistedClass(class,_cmd);
    
    NSMethodSignature *methodSignature;
    @autoreleasepool {
        methodSignature = ((id (*) (id , SEL , SEL))imp)(self,_cmd,aSelector);
    }
    
    if( (!methodSignature || strcmp(methodSignature.methodReturnType, @encode(void)) == 0) && [NSStringFromSelector(aSelector) hasPrefix:@"set"] && occurenceOfString(NSStringFromSelector(aSelector),@":") == 1 ){
        NSString *property = [[NSStringFromSelector(aSelector) substringWithRange:NSMakeRange(3, NSStringFromSelector(aSelector).length - 3)] stringByReplacingOccurrencesOfString:@":" withString:@""];
        property = [NSString stringWithFormat:@"%@%@",[property substringToIndex:1].lowercaseString,[property substringWithRange:NSMakeRange(1, property.length - 1)]];

        if([[class allBindSerializationPropertys] containsObject:property] || [[class allBindNormalPropertys] containsObject:property]){
            methodSignature = [NSMethodSignature signatureWithObjCTypes:[NSString stringWithFormat:@"v@@%@@@",[NSString stringWithUTF8String:[methodSignature getArgumentTypeAtIndex:2]]].UTF8String];
            return methodSignature;
        }
    }
    else if( (!methodSignature || strcmp(methodSignature.methodReturnType, @encode(void)) != 0) && occurenceOfString(NSStringFromSelector(aSelector),@":") == 0 ){
        if([[class allBindSerializationPropertys] containsObject:NSStringFromSelector(aSelector)] || [[class allBindNormalPropertys] containsObject:NSStringFromSelector(aSelector)]){
            methodSignature = [NSMethodSignature signatureWithObjCTypes:[NSString stringWithFormat:@"%@@@@@@",[NSString stringWithUTF8String:methodSignature.methodReturnType]].UTF8String];
            return methodSignature;
        }
    }

    return methodSignature;
}

void forwardInvocation(id<CXAnyModelPrivate> self,SEL _cmd,NSInvocation *anInvocation)
{
    Class<CXAnyModelPrivate> class = [self class];
    
    NSMethodSignature *methodSignature = anInvocation.methodSignature;
    SEL aSelector = anInvocation.selector;

    if([NSStringFromSelector(aSelector) hasPrefix:@"set"] && strcmp([methodSignature getArgumentTypeAtIndex:1], @encode(SEL)) != 0){
        NSString *property = [[NSStringFromSelector(aSelector) substringWithRange:NSMakeRange(3, NSStringFromSelector(aSelector).length - 3)] stringByReplacingOccurrencesOfString:@":" withString:@""];
        property = [NSString stringWithFormat:@"%@%@",[property substringToIndex:1].lowercaseString,[property substringWithRange:NSMakeRange(1, property.length - 1)]];

        if([[class allBindSerializationPropertys] containsObject:property]){
            [self runSeterBlockToInvocation:anInvocation withSetName:property setType:[NSString stringWithUTF8String:[anInvocation.methodSignature getArgumentTypeAtIndex:2]] inContainerKey:anyModel_bindSerialization];
            return;
        }

        if([[class allBindNormalPropertys] containsObject:property]){
            [self runSeterBlockToInvocation:anInvocation withSetName:property setType:[NSString stringWithUTF8String:[anInvocation.methodSignature getArgumentTypeAtIndex:2]] inContainerKey:anyModel_bindNormal];
            return;
        }
        
        NSLog(@"model:%@ setBindValueFail:%@",self,aSelector);
    }
    else if(strcmp(methodSignature.methodReturnType, @encode(void)) != 0 && strcmp([methodSignature getArgumentTypeAtIndex:1], @encode(SEL)) != 0){
        NSString *property = NSStringFromSelector(aSelector);
        if([[class allBindSerializationPropertys] containsObject:property]){
            [self runGeterBlockToInvocation:anInvocation withGetName:property getType:[NSString stringWithUTF8String:[anInvocation.methodSignature methodReturnType]] inContainerKey:anyModel_bindSerialization];
            return;
        }

        if([[class allBindNormalPropertys] containsObject:property]){
            [self runGeterBlockToInvocation:anInvocation withGetName:property getType:[NSString stringWithUTF8String:[anInvocation.methodSignature methodReturnType]] inContainerKey:anyModel_bindNormal];
            return;
        }
        
        NSLog(@"model:%@ getBindValueFail:%@",self,aSelector);
    }
    else{
        IMP imp = getOrigIMPFromRegistedClass([self class],_cmd);
        
        @autoreleasepool {
            ((void (*) (id , SEL , id))imp)(self,_cmd,anInvocation);
        }
    }
}

void runSeterBlockToInvocation(id self,SEL _cmd,NSInvocation *anInvocation,NSString *name,NSString *type,NSString *containerKey)
{
    id seter;
    
    seter = anyModel_chooseBlock(CXAnyModelActionSet, [type hasPrefix:@"^{"]?@"^{":type);
    
    if(seter){
        anInvocation.target = nil;
        anInvocation.selector = nil;
        
        [anInvocation setArgument:&self atIndex:1];
        [anInvocation setArgument:&name atIndex:3];
        [anInvocation setArgument:&containerKey atIndex:4];
        [anInvocation invokeWithTarget:seter];
    }
}

void runGeterBlockToInvocation(id self,SEL _cmd,NSInvocation *anInvocation,NSString *name,NSString *type,NSString *containerKey)
{
    id geter;
    
    geter = anyModel_chooseBlock(CXAnyModelActionGet, [type hasPrefix:@"^{"]?@"^{":type);
    
    if(geter){
        anInvocation.target = nil;
        anInvocation.selector = nil;
        
        [anInvocation setArgument:&self atIndex:1];
        [anInvocation setArgument:&name atIndex:2];
        [anInvocation setArgument:&containerKey atIndex:3];
        [anInvocation invokeWithTarget:geter];
    }
}
