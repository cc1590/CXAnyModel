//
//  CXAnyModelEntrance.h
//  CXAnyModel
//
//  Created by shane chen on 2019/5/20.
//  Copyright © 2019年 shane chen. All rights reserved.
//

#import "CXAnyModelEntrance.h"

#include <objc/runtime.h>
#include <objc/message.h>

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

NSString *AnyModelSetBindSerializationIMPKey = @"AnyModelSetBindSerializationIMPKey";
NSString *AnyModelGetBindSerializationIMPKey = @"AnyModelGetBindSerializationIMPKey";

NSString *AnyModelValueForKeyIMPKey = @"AnyModelValueForKeyIMPKey";
NSString *AnyModelMethodSignatureForSelectorIMPKey = @"AnyModelMethodSignatureForSelectorIMPKey";
NSString *AnyModelForwardInvocationIMPKey = @"AnyModelForwardInvocationIMPKey";

BOOL    anyModelInitialized = NO;

static  NSMutableSet<NSString *> *registedClasses;
static  NSMutableDictionary<NSString *,NSMutableDictionary<NSString *,NSValue *> *> *repleasedIMP;
static  NSMutableDictionary<NSString *,NSMutableDictionary<NSString *,NSValue *> *> *superIMP;

//insert
extern  NSSet<NSString *> *allBindSerializationPropertys(Class self,SEL _cmd);
extern  NSSet<NSString *> *allBindNormalPropertys(Class self,SEL _cmd);
extern  NSSet<NSString *> *allPropertysFromProtocolWithKey(Class self,SEL _cmd,Protocol *tagPro,NSString *key);
extern  void runSeterBlockToInvocation(id self,SEL _cmd,NSInvocation *anInvocation,NSString *name,NSString *type,NSString *containerKey);
extern  void runGeterBlockToInvocation(id self,SEL _cmd,NSInvocation *anInvocation,NSString *name,NSString *type,NSString *containerKey);

//set/get
extern  void setBindSerialization(id self,SEL _cmd,NSMutableDictionary *bindDictionary);
extern  NSMutableDictionary *bindSerialization(id self,SEL _cmd);

//replease or insert
extern  id valueForKey(id self,SEL _cmd,NSString *key);
extern  NSMethodSignature *methodSignatureForSelector(id self,SEL _cmd,SEL aSelector);
extern  void forwardInvocation(id self,SEL _cmd,NSInvocation *anInvocation);

//model action
extern void anyModel_readyAllSetter(void);
extern void anyModel_readyAllGetter(void);

void initializationAnyModel()
{
    anyModelInitialized = YES;
    registedClasses = NSMutableSet.set;
    repleasedIMP = NSMutableDictionary.dictionary;
    superIMP = NSMutableDictionary.dictionary;
    anyModel_readyAllSetter();
    anyModel_readyAllGetter();
    
    //支持一些基础结构体
    CXAnyModelExtendedStruct(CGRect);
    CXAnyModelExtendedStruct(CGPoint);
    CXAnyModelExtendedStruct(CGSize);
    CXAnyModelExtendedStruct(CGVector);
    CXAnyModelExtendedStruct(NSRange);
    CXAnyModelExtendedStruct(UIEdgeInsets);
    CXAnyModelExtendedStruct(CMTime);
    CXAnyModelExtendedStruct(CGAffineTransform);
}

void appendOrRepleaceMethod(Class class,SEL sel,NSMutableDictionary<NSString *,NSValue *> *container,NSMutableDictionary<NSString *,NSValue *> *superContainer,const NSString *verifiKey,IMP imp,char *methodType)
{
    if(!class_addMethod(class,sel,imp,methodType)){
        IMP thisIMP = class_getMethodImplementation(class, sel);
        NSValue *value = [NSValue valueWithPointer:thisIMP];
        [container setObject:value forKey:verifiKey];
        class_replaceMethod(class,sel,imp,methodType);
    }
    
    IMP superIMP = class_getMethodImplementation(class_getSuperclass(class), sel);
    if(superIMP){
        NSValue *superValue = [NSValue valueWithPointer:superIMP];
        [superContainer setObject:superValue forKey:verifiKey];
    }
}

BOOL isKindOfClass(Class parent, Class child) {
    for (Class cls = child; cls; cls = class_getSuperclass(cls)) {
        if (cls == parent) {
            return YES;
        }
    }
    return NO;
}

IMP getOrigIMPFromRegistedClass(Class class,SEL sel)
{
    NSString *className;
    
    if([registedClasses containsObject:NSStringFromClass(class)]){
        className = NSStringFromClass(class);
    }
    else{
        for (NSString *parentName in registedClasses) {
            if(isKindOfClass(NSClassFromString(parentName), class)){
                className = parentName;
                break;
            }
        }
    }
    
    if(!className){
        return (void *)0;
    }
    
    IMP resultIMP;
    
    if(sel_isEqual(sel, @selector(setAnyModel_BindSerialization:))){
        NSValue *superValue = [[repleasedIMP objectForKey:className] objectForKey:AnyModelSetBindSerializationIMPKey];
        if(!superValue){
            superValue = [[superIMP objectForKey:className] objectForKey:AnyModelSetBindSerializationIMPKey];
        }
        
        [superValue getValue:&resultIMP];
    }
    else if(sel_isEqual(sel, @selector(anyModel_BindSerialization))){
        NSValue *superValue = [[repleasedIMP objectForKey:className] objectForKey:AnyModelGetBindSerializationIMPKey];
        if(!superValue){
            superValue = [[superIMP objectForKey:className] objectForKey:AnyModelGetBindSerializationIMPKey];
        }
        [superValue getValue:&resultIMP];
    }
    else if(sel_isEqual(sel, @selector(valueForKey:))){
        NSValue *superValue = [[repleasedIMP objectForKey:className] objectForKey:AnyModelValueForKeyIMPKey];
        if(!superValue){
            superValue = [[superIMP objectForKey:className] objectForKey:AnyModelValueForKeyIMPKey];
        }
        [superValue getValue:&resultIMP];
    }
    else if(sel_isEqual(sel, @selector(methodSignatureForSelector:))){
        NSValue *superValue = [[repleasedIMP objectForKey:className] objectForKey:AnyModelMethodSignatureForSelectorIMPKey];
        if(!superValue){
            superValue = [[superIMP objectForKey:className] objectForKey:AnyModelMethodSignatureForSelectorIMPKey];
        }
        [superValue getValue:&resultIMP];
    }
    else if(sel_isEqual(sel, @selector(forwardInvocation:))){
        NSValue *superValue = [[repleasedIMP objectForKey:className] objectForKey:AnyModelForwardInvocationIMPKey];
        if(!superValue){
            superValue = [[superIMP objectForKey:className] objectForKey:AnyModelForwardInvocationIMPKey];
        }
        [superValue getValue:&resultIMP];
    }
    else{
        resultIMP = (void *)0;
    }
    
    return resultIMP;
}

//线程安全待考虑
BOOL isRegisterAnyModelToClass(Class class)
{
    if(!anyModelInitialized){
        initializationAnyModel();
    }
    
    if([registedClasses containsObject:NSStringFromClass(class)]){
        return YES;
    }
    else{
        for(NSString *className in registedClasses){
            if(isKindOfClass(NSClassFromString(className), class) || isKindOfClass(class, NSClassFromString(className))){
                return YES;
            }
        }
        
        return NO;
    }
}

//线程安全待考虑
BOOL registerAnyModelToClass(Class class,NSError **error)
{
    if(!anyModelInitialized){
        initializationAnyModel();
    }
    
    if(isRegisterAnyModelToClass(class)){
        if(error){
            *error = [NSError errorWithDomain:@"class(parent class | child class) already registed" code:CXAnyModelRegisterErrorClassAlreadyRegisted userInfo:nil];
        }
        return NO;
    }
    else{
        [registedClasses addObject:NSStringFromClass(class)];
        [repleasedIMP setObject:NSMutableDictionary.dictionary forKey:NSStringFromClass(class)];
        [superIMP setObject:NSMutableDictionary.dictionary forKey:NSStringFromClass(class)];
        
        NSMutableSet<NSString *> *all = [NSMutableSet set];
        unsigned int count;
        Protocol * __unsafe_unretained *list = class_copyProtocolList(class, &count);
        for (int i = 0; i < count; i++) {
            Protocol *pro = list[i];
            [all addObject:NSStringFromProtocol(pro)];
        }
        free(list);
        
        class_addMethod(object_getClass(class), @selector(allBindSerializationPropertys), (IMP)allBindSerializationPropertys,"@@:");
        class_addMethod(object_getClass(class), @selector(allBindNormalPropertys), (IMP)allBindNormalPropertys,"@@:");
        class_addMethod(object_getClass(class), @selector(allPropertysFrom:withKey:), (IMP)allPropertysFromProtocolWithKey,"@@:@@");
        class_addMethod(class, @selector(runSeterBlockToInvocation:withSetName:setType:inContainerKey:), (IMP)runSeterBlockToInvocation,"@@:@@@@");
        class_addMethod(class, @selector(runGeterBlockToInvocation:withGetName:getType:inContainerKey:), (IMP)runGeterBlockToInvocation,"@@:@@@@");
        
        NSMutableDictionary<NSString *,NSValue *> *container = [repleasedIMP objectForKey:NSStringFromClass(class)];
        NSMutableDictionary<NSString *,NSValue *> *superContainer = [superIMP objectForKey:NSStringFromClass(class)];
        
        appendOrRepleaceMethod(class, @selector(setAnyModel_BindSerialization:),container,superContainer,AnyModelSetBindSerializationIMPKey,(IMP)setBindSerialization,"v@:@");
        appendOrRepleaceMethod(class, @selector(anyModel_BindSerialization),container,superContainer,AnyModelGetBindSerializationIMPKey,(IMP)bindSerialization,"@@:");
        appendOrRepleaceMethod(class, @selector(valueForKey:),container,superContainer,AnyModelValueForKeyIMPKey,(IMP)valueForKey,"@@:");
        appendOrRepleaceMethod(class, @selector(methodSignatureForSelector:),container,superContainer,AnyModelMethodSignatureForSelectorIMPKey,(IMP)methodSignatureForSelector,"@@::");
        appendOrRepleaceMethod(class, @selector(forwardInvocation:),container,superContainer,AnyModelForwardInvocationIMPKey,(IMP)forwardInvocation,"v@:@");
        
        return YES;
    }
}

////线程安全待考虑
//BOOL unRegisterAnyModelToClass(Class class,NSError **error)
//{
//    if(!anyModelInitialized){
//        initializationAnyModel();
//    }
//
//    if(!isRegisterAnyModelToClass(class)){
//        *error = [NSError errorWithDomain:@"class not registered yet" code:CXAnyModelUnregisterErrorNotRegisteredYet userInfo:nil];
//        return NO;
//    }
//    else{
//        //todo 注销
//
//        [registedClasses removeObject:NSStringFromClass(class)];
//        [repleasedIMP removeObjectForKey:NSStringFromClass(class)];
//        [superIMP removeObjectForKey:NSStringFromClass(class)];
//        return YES;
//    }
//}
