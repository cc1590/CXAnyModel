//
//  CXAnyModelEntrance.h
//  CXAnyModel
//
//  Created by shane chen on 2019/5/20.
//  Copyright © 2019年 shane chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CXAnyModelExtendedStruct(struct) \
do\
{\
    NSString *structType = [NSString stringWithUTF8String:@encode(struct)];\
    if([structType hasPrefix:@"{"] && [structType hasSuffix:@"}"]){\
        id seter = ^(id _self,struct value,NSString *_key,NSString *_containerKey){\
            NSValue *v = [NSValue value:&value withObjCType:structType.UTF8String];\
            anyModel_setValueToContainer(_self,_key,v,_containerKey);\
        };\
        id geter = ^(id _self,NSString *_key,NSString *_containerKey){\
            NSValue *v = anyModel_getValueFromContainer(_self,_key,_containerKey);\
            struct structure;\
            [v getValue:&structure];\
            return structure;\
        };\
        extendedStructureProperty(structType,seter,geter);\
    }\
}\
while(0);

typedef NS_ENUM(NSUInteger, CXAnyModelErrorCode) {
    CXAnyModelRegisterError                                      = 100,
    CXAnyModelRegisterErrorClassAlreadyRegisted
};

extern BOOL registerAnyModelToClass(Class class,NSError **error);
extern BOOL isRegisterAnyModelToClass(Class class);

//do not use,plz use CXAnyModelExtendedStruct(struct)
extern void extendedStructureProperty(NSString *structType,id seter,id geter);
extern void anyModel_setValueToContainer(id target,NSString *key,id value,NSString *containerKey);
extern id anyModel_getValueFromContainer(id target,NSString *key,NSString *containerKey);

/**
 *  序列化属性协议
 */
@protocol CXAnyModelSerializationValue <NSObject> @end

/**
 *  非序列化属性协议
 */
@protocol CXAnyModelNormalValue <NSObject> @end

/**
 *  提供所有键值对
 */
@protocol CXAnyModelValues <NSObject>

/**
 *  绑定序列化数据的容器
 */
@property (nonatomic,strong) NSMutableDictionary * anyModel_BindSerialization;

/**
 *  绑定非序列化数据的容器
 */
@property (nonatomic,strong) NSMutableDictionary * anyModel_BindNormal;

@end
