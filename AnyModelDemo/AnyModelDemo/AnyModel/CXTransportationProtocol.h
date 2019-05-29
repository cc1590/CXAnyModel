//
//  CXTransportationProtocol.h
//  AnyModelDemo
//
//  Created by appnest on 2019/5/29.
//  Copyright © 2019 shane chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CXAnyModel/CXAnyModelEntrance.h>

@protocol CXTransportationProtocol <CXAnyModelNormalValue>

@property NSString *kind;
@property CGFloat speed;

@end
