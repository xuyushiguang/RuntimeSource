//
//  main.m
//  OCRuntime
//
//  Created by xingye yang on 2021/9/18.
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import <objc/message.h>
#import "ClassInfo.h"

@interface Person:NSObject
{
@public
    //定义一个私有属性,这个属性系统不会生成set/get方法
    int _age;
}
//定义一个property类型的属性,这个属性系统会帮我们生成set/get方法
@property(nonatomic,assign)int height;
-(void)run;
+(void)home;
@end

@implementation Person
-(void)run{
    NSLog(@"=======调用了 run 方法");
}

+(void)home{
}
@end

int main(int argc, const char * argv[]) {
    
    //问了验证runtime,需要把ARC关闭,换成MRC
    
    Person *p = [[Person alloc] init];
    /*
     Person对象有两个属性_age和height;都是int类型
     我们知道Person底层对呗转成一个结构体
     struct Person_IMPL {
         struct NSObject_IMPL NSObject_IVARS;
         int _age;
         int _height;
     };
     现在我们把p对象当成Person_IMPL结构体使用
     */
    //首先给p对象的两个属性设置值
    p->_age = 0xAABBCCDD;
    p.height = 0xEE1122FF;
    
    NSLog(@"==转换前==_age==%x",p->_age);
    NSLog(@"==转换前==height==%x",p.height);
    
    //转换p对象的指针类型
    int *Q = (int *)p;
    NSLog(@"==取值==_age=%x",*(Q+2));
    NSLog(@"==取值==height=%x",*(Q+3));
   
    //修改值
    *(Q+2) = 0x11223344;
    *(Q+3) = 0x55667788;
    NSLog(@"==修改值==_age=%x",*(Q+2));
    NSLog(@"==修改值==height=%x",*(Q+3));
    
    NSLog(@"==修改值==p->_age==%x",p->_age);
    NSLog(@"==修改值==p.height==%x",p.height);
    
    //p确实是一个指针,并且可以通过指针移动获取值
    
    /*
     我们在ClassInfo.m文件里定义了mj_objc_class结构体,
     这个结构体和系统底层的结构体相似,可以互相转换
     */
    
    /*
     首先我们把Person类对象进行转换
     */
    struct mj_objc_class *personClass = (__bridge struct mj_objc_class *)p.class;
    
    
    /*
     我们拿到class_rw_t结构体对象,
     这个结构体保存了Person类的所有数据结构体
     */
    struct  class_rw_t *personClassData = personClass->data();
    
    NSLog(@"===类名===%@",[[NSString alloc] initWithCString:personClassData->ro->name encoding:NSUTF8StringEncoding]);
    NSLog(@"===类起始内存===%u",personClassData->ro->instanceStart);
    NSLog(@"===类内存长度===%u",personClassData->ro->instanceSize);
    
    //获取属性变量的数量
    int count = personClassData->ro->ivars->count;
    
    NSLog(@"===属性变量===");
    
    for(int i = 0;i<count;i++){
        const ivar_t * iv_t = (const ivar_t *) &personClassData->ro->ivars->first;
        ivar_t iv = *(iv_t + i);
        NSLog(@"===name===%@",[[NSString alloc] initWithCString:iv.name encoding:NSUTF8StringEncoding]);
        NSLog(@"===offsett===%d",*iv.offset);
        NSLog(@"===alignment_raw==%d",iv.alignment_raw);
        NSLog(@"===size===%d",iv.size);
    }
    
    NSLog(@"===方法===");
    
    //获取方法数量
    count = personClassData->ro->baseMethodList->count;
    
    for(int i = 0;i<count;i++){
        const method_t * iv_t = (const method_t *) &personClassData->ro->baseMethodList->first;
        method_t iv = *(iv_t + i);
        NSLog(@"===types===%@",[[NSString alloc] initWithCString:iv.types encoding:NSUTF8StringEncoding]);
        NSLog(@"===sel name===%@",NSStringFromSelector(iv.name));
        NSLog(@"===imp===%p",iv.imp);
    }
    
    /*
     直接调用objc_msgSend函数
     */
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)p, sel_registerName("run"));
    /*
     把p对象转成Q指针后在调用objc_msgSend函数
     */
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)Q, sel_registerName("run"));
    
    
    return 0;
}
