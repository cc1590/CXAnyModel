//
//  CXObjectModel.h
//  AnyModelDemo
//
//  Created by appnest on 2019/5/29.
//  Copyright © 2019 shane chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CXAnyModel/CXAnyModel.h>
#import <CXAnyModel/CXAnyModelEntrance.h>

#import "CXAnimalProtocol.h"
#import "CXTransportationProtocol.h"

@interface CXObjectModel : CXAnyModel<CXAnimalProtocol,CXTransportationProtocol>

@end
