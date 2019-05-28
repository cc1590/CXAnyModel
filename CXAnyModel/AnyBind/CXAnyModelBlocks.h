//
//  CXAnyModelBlocks.h
//  CXAnyModel
//
//  Created by shane chen on 2019/5/20.
//  Copyright © 2019 shane chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CXAnyModelAction) {
    CXAnyModelActionSet                             = 0,
    CXAnyModelActionGet                             = 1
};

extern id anyModel_chooseBlock(CXAnyModelAction anyModelAction,NSString *propertyType);
