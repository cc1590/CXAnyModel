//
//  CXAnimalProtocol.h
//  AnyModelDemo
//
//  Created by appnest on 2019/5/29.
//  Copyright © 2019 shane chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CXAnyModel/CXAnyModelEntrance.h>

@protocol CXAnimalProtocol <CXAnyModelNormalValue>

@property NSString *name;
@property NSInteger age;

@end
