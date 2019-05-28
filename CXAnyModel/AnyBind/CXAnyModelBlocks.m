//
//  CXAnyModelBlocks.m
//  CXAnyModel
//
//  Created by shane chen on 2019/5/20.
//  Copyright © 2019 shane chen. All rights reserved.
//

#import "CXAnyModelBlocks.h"

extern void anyModel_setValueToContainer(id target,NSString *key,id value,NSString *containerKey);
extern id anyModel_getValueFromContainer(id target,NSString *key,NSString *containerKey);

static NSMutableDictionary<NSString *,id> *anyModel_allSetter;
static NSMutableDictionary<NSString *,id> *anyModel_allGetter;

#pragma set actions

id anyModel_chooseBlock(CXAnyModelAction anyModelAction,NSString *propertyType)
{
    id block;
    switch (anyModelAction) {
        case CXAnyModelActionSet:
            block = [anyModel_allSetter objectForKey:propertyType];
            break;
        case CXAnyModelActionGet:
            block = [anyModel_allGetter objectForKey:propertyType];
            break;
        default:
            block = nil;
            break;
    }
    return block;
}

void anyModel_readyAllSetter(void)
{
    if(!anyModel_allSetter){
        anyModel_allSetter = NSMutableDictionary.dictionary;
    }
    
    if(anyModel_allSetter.count == 0){
        [anyModel_allSetter setObject:({
            ^(id _self,char value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(char)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,int value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(int)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,short value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(short)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,long value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(long)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,long long value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(long long)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,unsigned char value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned char)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,unsigned int value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned int)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,unsigned short value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned short)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,unsigned long value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned long)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,unsigned long long value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned long long)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,float value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(float)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,double value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(double)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,BOOL value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(BOOL)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,char value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,@(value),_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(char)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,IMP value,NSString *_key,NSString *_containerKey){
                NSValue *v = [NSValue value:value withObjCType:@encode(IMP)];
                anyModel_setValueToContainer(_self,_key,v,_containerKey);
            };
        }) forKey:[NSString stringWithUTF8String:@encode(IMP)]];
        
        [anyModel_allSetter setObject:({
            ^(id _self,void *value,NSString *_key,NSString *_containerKey){
                NSValue *v = [NSValue value:&value withObjCType:@encode(void *)];
                anyModel_setValueToContainer(_self,_key,v,_containerKey);
            };
        }) forKey:@"^{"];
        
        [anyModel_allSetter setObject:({
            ^(id _self,id value,NSString *_key,NSString *_containerKey){
                anyModel_setValueToContainer(_self,_key,value,_containerKey);
            };
        }) forKey:@"@"];
        [anyModel_allSetter setObject:[anyModel_allSetter objectForKey:@"@"] forKey:@"@?"];
        [anyModel_allSetter setObject:[anyModel_allSetter objectForKey:@"@"] forKey:@"#"];
        [anyModel_allSetter setObject:[anyModel_allSetter objectForKey:@"@"] forKey:@"^"];
    }
}

void anyModel_readyAllGetter(void)
{
    if(!anyModel_allGetter){
        anyModel_allGetter = NSMutableDictionary.dictionary;
    }
    
    if(anyModel_allGetter.count == 0){
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.charValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(char)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.intValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(int)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.shortValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(short)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.longValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(char)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.longLongValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(long long)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.unsignedCharValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned char)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.unsignedIntValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned int)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.unsignedShortValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned short)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.unsignedLongValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned long)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.unsignedLongLongValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(unsigned long long)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.floatValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(float)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.doubleValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(double)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.boolValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(BOOL)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSNumber *num = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return num.charValue;
            };
        }) forKey:[NSString stringWithUTF8String:@encode(char)]];
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSValue *v = anyModel_getValueFromContainer(_self,_key,_containerKey);
                if(v && [v isKindOfClass:NSValue.class]){
                    IMP imp;
                    [v getValue:&imp];
                    return imp;
                }
                else{
                    return (IMP)((void *)0);
                }
            };
        }) forKey:[NSString stringWithUTF8String:@encode(IMP)]];//函数指针
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                NSValue *v = anyModel_getValueFromContainer(_self,_key,_containerKey);
                if(v && [v isKindOfClass:NSValue.class]){
                    void **structPP = malloc(sizeof(void *));
                    [v getValue:structPP size:sizeof(void *)];
                    void *structP = *structPP;
                    free(structPP);
                    return structP;
                }
                else{
                    return (void *)0;
                }
            };
        }) forKey:@"^{"];//结构体指针
        
        [anyModel_allGetter setObject:({
            ^(id _self,NSString *_key,NSString *_containerKey){
                id v = anyModel_getValueFromContainer(_self,_key,_containerKey);
                return  v;
            };
        }) forKey:@"@"];//oc对象
        [anyModel_allGetter setObject:[anyModel_allGetter objectForKey:@"@"] forKey:@"@?"];//函数块oc对象
        [anyModel_allGetter setObject:[anyModel_allGetter objectForKey:@"@"] forKey:@"#"];//class
        [anyModel_allGetter setObject:[anyModel_allGetter objectForKey:@"@"] forKey:@"^"];//指针
    }
}

void extendedStructureProperty(NSString *structTypes,id seter,id geter)
{
    if(![anyModel_allSetter.allKeys containsObject:structTypes]){
        [anyModel_allSetter setObject:seter forKey:structTypes];
    }
    if(![anyModel_allGetter.allKeys containsObject:structTypes]){
        [anyModel_allGetter setObject:geter forKey:structTypes];
    }
}
