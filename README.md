# CXAnyModel
这是一个类型无关的model方案，适合作为组件化架构中各模块互通所用的model。


# 快速上手
以下指南将帮助你在本地机器上安装和运行该项目(你也可以直接copy代码)，进行开发和测试。


## 安装要求
1.安装cocoapods

2.支持iOS8.0及以上

## 安装步骤
项目目前只加到了我自己的仓库，在podfile中指定源
source 'https://github.com/cc1590/CXSpecs.git'
即可使用此项目


## 示例

### 类绑定
anymodel中可以绑定任一类使其和其子类拥有model功能


```
extern BOOL registerAnyModelToClass(Class class,NSError **error);
```

项目中默认绑定了CXAnymodel类作为原始model类，可以直接使用

### 属性声明
anymodel中的property都是声明在protocol中，
支持property声明的protocol是CXAnyModelSerializationValue和CXAnyModelNormalValue，
目前这两个protocol使用中没有区别，
你需要定义一个新的protocol接入以上两种protocol中的任一个，在新的protocol中进行property声明，
然后你的model类接入此新的protocol即可拥有property。


```
@protocol CXAnimalProtocol <CXAnyModelNormalValue>

@property NSString *name;
@property NSInteger age;

@end

@protocol CXTransportationProtocol <CXAnyModelNormalValue>

@property NSString *kind;
@property CGFloat speed;

@end

@interface CXObjectModel : CXAnyModel<CXAnimalProtocol,CXTransportationProtocol>

@end
```

以上就完成的property的声明，CXObjectModel即是CXAnimalProtocol表示是一个动物，也是CXTransportationProtocol表示是一个交通工具

### model的使用

CXObjectModel可以随意使用它的4个property，也可以作为CXAnimalProtocol，CXTransportationProtocol 分别使用。

```
CXObjectModel *obj = CXObjectModel.new;
obj.name = @"马";
obj.age = 3;
obj.kind = @"骑乘动物";
obj.speed = 31.5f;

id<CXAnimalProtocol> animal = obj;
id<CXTransportationProtocol> transportation = obj;

NSLog(@"我的交通工具是%@%@，它%ld岁了，速度是%.1fkm/h",transportation.kind,animal.name,animal.age,transportation.speed);

我的交通工具是骑乘动物马，它3岁了，速度是31.5km/h
```


### 支持的property
anymodel目前支持的property类型有

所有数字类型

BOOL

OC对象

class

block

char指针

函数指针

结构体指针

结构体


对于结构体默认支持以下几种
CGRect，CGPoint，CGSize，CGVector，NSRange，UIEdgeInsets，CMTime，CGAffineTransform
如果有需要支持其他类型的结构体或者有自定义的结构体类型需要支持可以使用以下宏添加支持
```
CXAnyModelExtendedStruct(struct)
```
struct填入结构体类型

所有property现在都是默认nonatomic的
