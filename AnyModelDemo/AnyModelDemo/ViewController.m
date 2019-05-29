//
//  ViewController.m
//  AnyModelDemo
//
//  Created by appnest on 2019/5/29.
//  Copyright © 2019 shane chen. All rights reserved.
//

#import "ViewController.h"

#import "CXObjectModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CXObjectModel *obj = CXObjectModel.new;
    obj.name = @"马";
    obj.age = 3;
    obj.kind = @"骑乘动物";
    obj.speed = 31.5f;
    
    id<CXAnimalProtocol> animal = obj;
    id<CXTransportationProtocol> transportation = obj;
    NSLog(@"我的交通工具是%@%@，它%ld岁了，速度是%.1fkm/h",transportation.kind,animal.name,animal.age,transportation.speed);
    
}


@end
