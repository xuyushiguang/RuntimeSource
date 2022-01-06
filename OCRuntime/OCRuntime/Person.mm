////
////  Person.m
////  Interview001-OC对象的本质
////
////  Created by xingye yang on 2021/9/18.
////  Copyright © 2021 YangYu. All rights reserved.
////
//
//#import "Person.h"
//#import <objc/runtime.h>
//#import <malloc/malloc.h>
//
///*
// 用来计算结构体的属性在内存中的偏移量
// */
//#define __OFFSETOFIVAR__(TYPE, MEMBER) ((long long) &((TYPE *)0)->MEMBER)
//
//
//@interface Person()
//{
//@public
//    //定义一个私有属性,这个属性系统不会生成set/get方法
//    int _age;
//}
////定义一个property类型的属性,这个属性系统会帮我们生成set/get方法
//@property(nonatomic,assign)int height;
//-(void)run;
//+(void)home;
//@end
//
//@implementation Person
//-(void)run{
//}
//
//+(void)home{
//}
//@end
//
//#pragma mark ########### 以下是把.m文件转成.cpp后的样子,在这里我把关键的部分取出来,写在这里;#####
//#pragma mark###################################  Person start  ##################################################
//#pragma mark##################### 以下是把.m文件转成.cpp后的样子,在这里我把关键的部分取出来,写在这里;#####################
//#pragma mark####################################  Person start  ################################################
//
//
///*
// Object-C中所有继承NSObject的类 底层就是一个结构体,所以我们把OC类转成.cpp文件后,看到的就是一个结构体
// */
//
///*
// 这个结构体是NSObject类底层的样子,说明NSObject类只有一个isa属性,isa是一个指针类型占8个字节,说明NSObject的一个对象实际内存是8字节;
// 但是系统分配内存的时候却分配了16个字节,在下面这个函数中我们可以看到原因,当内存字节小于16字节时返回16字节的长度;
// size_t instanceSize(size_t extraBytes) {
//     size_t size = alignedInstanceSize() + extraBytes;
//     // CF requires all objects be at least 16 bytes.
//     if (size < 16) size = 16;
//     return size;
// }
// 综上所述:一个NSObject对象的占内存长度是16个字节
// */
//struct NSObject_IMPL {
//    Class isa;
//};
//
///*
// 这个就是Person类的底层结构体;我们可以看到结构体中有两个属性:
// 1)NSObject_IVARS属性:是NSObject_IMPL类型的属性,也可以理解为isa指针;因为NSObject_IMPL只有一个isa属性
// 2)_age 就是我们自定义的属性
// */
//struct Person_IMPL {
//    struct NSObject_IMPL NSObject_IVARS;
//    int _age;
//    int _height;
//};
///*
// 实例方法
// */
//static void _I_Person_run(Person * self, SEL _cmd) {
//}
///*
// 类方法
// */
//static void _C_Person_home(Class self, SEL _cmd) {
//}
///*
// 我们发现无论是对象方法还是类方法都没有在结构体内部,c++的结构体是可以定义方法的,但是为什么不在结构体内部定义;
// 这里是把方法实现单独定义成了函数,这些函数会单独存放在一个内存区域,这个函数的内存区域和结构体对象的内存区域是分开的;
// 也就是说结构只存储属性值,比如我们初始化一个结构体,系统就会给这个结构体分配内存,内存占用的多少是根据结构体的属性的多少来分配的;
// 如果结构体内部有方法的话,也会给方法分配内存,这样就会消耗大量内存;
// 如果把结构体的方法单独存放在一个内存区域,当我们取调用结构体对象的方法的时候,去这个内存区域找到对应的函数方法,并把结构体对象也传给这个方法,结构体对象相当于上下文功能,
// 这样就不用给每个结构体实例的方法都分配内存,结构体所有对象共用一个方法内存,结构体对象只需要保存好属性的值的内存就可以了;
// 下面会讲方法存储在什么地方
// */
//
///*
// 这个就是@property(nonatomic,assign)int height;由系统生成的set/get方法
// */
//static int _I_Person_height(Person * self, SEL _cmd) { return (*(int *)((char *)self + OBJC_IVAR_$_Person$_height)); }
//static void _I_Person_setHeight_(Person * self, SEL _cmd, int height) { (*(int *)((char *)self + OBJC_IVAR_$_Person$_height)) = height; }
//
//#pragma mark####################################  Person end  ########################################################
//#pragma mark#############################到这就是Person类被转成底层时的样子##################################
//#pragma mark####################################  Person end  ########################################################
//
///*
// 下面就是对Person的属性的配置
// */
//
///*
// 这个定义是用来记录Person_IMPL结构体中的_age属性的内存偏移量;
// 因为当我们给Person对象的_age属性设置值或者获取_age的值,都需要知道_age属性在内存中的位置,
// 然后找到_age内存,把值写入到_age内存中,或者从_age内存中读取值
// */
//extern "C" unsigned long OBJC_IVAR_$_Person$_age;
//extern "C" unsigned long OBJC_IVAR_$_Person$_height;
//
///*
// 用来计算OBJC_IVAR_$_Person$_age的值
// */
//extern "C" unsigned long int OBJC_IVAR_$_Person$_age __attribute__ ((used, section ("__DATA,__objc_ivar"))) = __OFFSETOFIVAR__(struct Person_IMPL, _age);
//
//extern "C" unsigned long int OBJC_IVAR_$_Person$_height __attribute__ ((used, section ("__DATA,__objc_ivar"))) = __OFFSETOFIVAR__(struct Person_IMPL, _height);
//
//
//int main(int argc, const char * argv[]) {
//
//    /*
//     这里是初始化一个Person对象;
//     Person *p = [[Person alloc] init];
//     */
//    Person *p = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
//
//    /*
//     p->_age = 20;
//
//     这里是给Person对象的_age属性赋值,我们来分解这个式子到底是什么意思;
//     0)其中p是Person类的一个对象,实际就是一个指针;是指针就好办了,我们可以转换成其他任意类型的指针;注意在ARC中编译器不让转化,可以在MRC中转换,把xcode修改成MRC;
//     1)(char *)p 的意思是把p转换成char *类型的指针;
//     2)((char *)p + OBJC_IVAR_$_Person$_age) 这个就是指针的移动,由于先前已经转换长char*类型的,所以指针移动的步长是一个字节,
//        总共移动OBJC_IVAR_$_Person$_age长度的字节,OBJC_IVAR_$_Person$_age就是_age属性在Person_IMPL结构体中的内存偏移量;
//        OBJC_IVAR_$_Person$_age的长度是这样计算的:__OFFSETOFIVAR__(struct Person_IMPL, _age)
//     3)(int *)((char *)p + OBJC_IVAR_$_Person$_age)这一步是指针移动完成后,把指针转成int *类型的;这是因为_age属性是int类型的;
//        转成int *类型是为了方便赋值或者取值;
//     4)*(int *)((char *)p + OBJC_IVAR_$_Person$_age)这一步我们看到在3)的基础上最左边添加了一个*号,由于式子是在等号=左边,
//        所以加*号是赋值的意思,
//     */
//    (*(int *)((char *)p + OBJC_IVAR_$_Person$_age)) = 20;
//
//    /*
//     int a = p->_age;
//
//     这里是取值,取Person对象的_age属性值;这里就不做过多介绍了
//     */
//    int a = (*(int *)((char *)p + OBJC_IVAR_$_Person$_age));
//
//    /*
//     下面是调用@proper描述的属性,我们可以发现和调用_age属性不同;
//     这里调用了set/get方法;而不是直接给属性赋值或者直接取属性的值;
//     其实是在set/get方法内部实现了取值和赋值操作;
//     不同点就是一个直接操作内存,另一个通过消息发送的方式调用set/get方法取操作内存;
//     效率的话,肯定是直接操作内存快;
//
//     */
//
//    /*
//     p.height = 100;
//
//     这是height的set方法,其方法内部实现和_age属性一样
//     _I_Person_setHeight_(Person * self, SEL _cmd, int height) { (*(int *)((char *)self + OBJC_IVAR_$_Person$_height)) = height; }
//     */
//    ((void (*)(id, SEL, int))(void *)objc_msgSend)((id)p, sel_registerName("setHeight:"), 100);
//
//    /*
//     int h = p.height;
//
//     这是height属性的get方法,我们可以看到方法内部的实现和_age属性一样
//     _I_Person_height(Person * self, SEL _cmd) { return (*(int *)((char *)self + OBJC_IVAR_$_Person$_height)); }
//     */
//    int h = ((int (*)(id, SEL))(void *)objc_msgSend)((id)p, sel_registerName("height"));
//
//
//    /*
//     调用对象方法
//
//     [p run];
//     */
//    ((void (*)(id, SEL))(void *)objc_msgSend)((id)p, sel_registerName("run"));
//
//    /*
//     调用类方法
//
//     [Person home];
//     */
//    ((void (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("home"));
//    /*
//     调用对象方法和类方法不同点在于:
//     调用对象方法是直接传p对象;
//     调用类方法是获取类对象objc_getClass("Person")
//     */
//
//    return 0;
//}
//
//#pragma mark ########### 以下是 Person的属性和方法是怎么保存的 #####
//#pragma mark #######################################################
//
///*
// 从转换后的.cpp文件中可以看到;Person类的变量,属性,方法,isa,父类的isa,以及缓存都可以从这里找到;
// _class_ro_t结构体非常重要,里面保存的都是Person类的所有的数据结构;
//
// 也就是说我们这样Person *p = [[Person alloc] init];创建的p对象;p的isa指针指向的就是_class_t结构体对象;
// 也即是Person *p = [[Person alloc] init];
// 可以把p->isa转成:
// struct _class_t *c = (struct _class_t *)(p->isa);
//
// 对于Person类来说,全局只有一个Person类对象,记住是类对象,不是Person对象,类对象全局只有一个,保存的是这个类的所有数据结构;
// 这个类对象就是_class_t对象,我们创建p对象的时候,会把类对象(也就是_class_t对象)的指针地址保存一份到p对象的isa上;
// 也就是我们每创建一个p对象,p对象都会在isa上保存一份类对象的指针地址
//
// 这样有什么用呢?非常重要,比如:
// 我们想要获取_age的值,平常我们是直接p._age就可以获取到,但是系统在底层帮我们做了好多事;
// 1)首先我们要知道Person类有没有这个属性?
// 2)我们还要知道_age属性在内存中的位置吧,不然怎么获取值呢?
// 3)找到这个属性后才能对这个属性操作;
// 所以Person的所有数据结构都保存在_class_t这个结构体中;
// 下面一步步讲解
// */
//struct _class_t {
//    struct _class_t *isa;
//    struct _class_t *superclass;
//    void *cache;
//    void *vtable;
//    struct _class_ro_t *ro;
//};
//
///*
// 这个结构体体保存的都是Person类的具体内容了;一个一个看:
// flags:不清楚,不用关心
// instanceStart:这个就是Person对象在内存地址中开始的位置,如果我们要获取某个对象,就需要先拿到这个属性,通过指针移动,获取到这个对象内存的起始位置
// instanceSize :这个就是对象的内存长度,也就是这个对象在内存中占用的字节数
// reserved:不清楚
// ivarLayout:不清楚
// name:类名
// baseMethods:保存方法的地方,类的方法都保存在这里
// baseProtocols:保存协议的地方
// ivars:保存对象变量的地方,就是在{int _age;}定义的变量;
// weakIvarLayout:不清楚
// properties:保存属性的地方,就是@proper()int height;定义的属性;
// */
//struct _class_ro_t {
//    unsigned int flags;
//    unsigned int instanceStart;
//    unsigned int instanceSize;
//    unsigned int reserved;
//    const unsigned char *ivarLayout;
//    const char *name;
//    const struct _method_list_t *baseMethods;
//    const struct _objc_protocol_list *baseProtocols;
//    const struct _ivar_list_t *ivars;
//    const unsigned char *weakIvarLayout;
//    const struct _prop_list_t *properties;
//};
//
///*
// 先看变量列表;在.cpp文件中可以找到这个;这个就是保存变量的列表
// entsize:是_ivar_t结构体的内存长度
// count:保存变量的数量,
// ivar_list:保存真的变量的具体内容,看下面的_ivar_t介绍
// */
//static struct _ivar_list_t {
//    unsigned int entsize;  // sizeof(struct _prop_t)
//    unsigned int count;
//    struct _ivar_t ivar_list[2];
//}
///*
// 这个是描述变量的,也就是这个变量的名字,类型,占用的内存字节数,内存偏移量
// offset:保存这个变量在结构体内存中的内存偏移量;方便找到这个变量的位置;类似_class_ro_t结构体中的instanceStart属性
// name:变量名字
// type:变量的类型,比如int,float,String等,是简写的类型;
// alignment:字节对齐
// size:这个变量占的内存长度;类似_class_ro_t结构体中的instanceSize属性
// */
//struct _ivar_t {
//    unsigned long int *offset;  // pointer to ivar offset location
//    const char *name;
//    const char *type;
//    unsigned int alignment;
//    unsigned int  size;
//};
//
///*
// 这个是方法列表;类的所有方法都保存在这个地方;
// entsize:保存的是_objc_method结构体的占内存的大小;
// method_count:保存的是方法数量
// method_list:所有的方法都保存在这个数组中;
// 一个方法的具体内容保存在_objc_method结构体中;
// 继续往下看
// */
//static struct _method_list_t {
//    unsigned int entsize;  // sizeof(struct _objc_method)
//    unsigned int method_count;
//    struct _objc_method method_list[1];
//}
///*
// 这个是描述一个方法;也就是这个方法具有哪些内容;
// _cmd:方法的名字
// method_type:方法的类型,像这样"v16@0:8",描述这个方法的返回值类型,参数类型等
// _imp:函数指针,可以理解为方法的实现的地址,通过这个指针就能拿到这个方法;从而调用这个方法;
//      runtime里面的黑魔法,方法交换;其实就是修改_imp指针,让它指针另一个函数的地址;
// */
//struct _objc_method {
//    struct objc_selector * _cmd;
//    const char *method_type;
//    void  *_imp;
//};
//
///*
// _objc_protocol_list  协议列表
// _prop_list_t  属性列表
// 有时间在讲解
// */
//
//#pragma mark #########################  类对象 到底是怎么产生的? ##############################
//#pragma mark #########################  类对象 属性和方法是怎么存储的?  ##############################
//
///*
// 这里是类对象实现的地方
//
// 在.cpp文件我们看到,这里初始化了一个_class_t类型的变量 OBJC_CLASS_$_Person
// OBJC_CLASS_$_Person就是 Person 类对象,全局只有这一个;
// 我们发现初始化的时候:
// struct _class_t *isa; 这个是0,也就是说类对象初始化的时候,他的isa指针式空的,别担心,后面会对他从新赋值
// struct _class_t *superclass; 这个也是0,也就是说类对象初始化的时候,他的指向父类的superclass指针式空的,别担心,后面会对他从新赋值
// void *cache;  缓存也是空的
// void *vtable; 也是空的
// struct _class_ro_t *ro; 这个有值_OBJC_CLASS_RO_$_Person,这个值保存的就是Person类的数据结构,保存的属性,方法,协议等
// 我们全局找到_OBJC_CLASS_RO_$_Person这个在那实现的;请继续看下面
// */
//extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_Person __attribute__ ((used, section ("__DATA,__objc_data"))) = {
//    0, // &OBJC_METACLASS_$_Person,
//    0, // &OBJC_CLASS_$_NSObject,
//    0, // (void *)&_objc_empty_cache,
//    0, // unused, was (void *)&_objc_empty_vtable,
//    &_OBJC_CLASS_RO_$_Person,
//};
//
///*
// 我们发现_OBJC_CLASS_RO_$_Person是_class_ro_t类型的结构体对象;
// 可以看到
// unsigned int flags; 值是0
// unsigned int instanceStart;可以看到内存初始位置就是竟然是Person类的第一个自定义属性_age的指针位置;竟然不是isa的指针位置,那是因为isa保存的是类对象的位置,
// 如果从isa开始取值,就取不到_age,和其他属性的值了;
// unsigned int instanceSize;可以看到内存长度是Person_IMPL结构体的长度
// unsigned int reserved; 值是0
// const unsigned char *ivarLayout;也是0
// const char *name; 类名"Person"
// const struct _method_list_t *baseMethods; 这个有值,_OBJC_$_INSTANCE_METHODS_Person,这个保存的是方法列表
// const struct _objc_protocol_list *baseProtocols;也是0,因为我们没有定义协议,所以没有
// const struct _ivar_list_t *ivars;保存的是变量列表
// const unsigned char *weakIvarLayout;应该是存的弱引用
// const struct _prop_list_t *properties;属性列表
//
// 下面主要看方法列表_method_list_t和_ivar_list_t变量列表
//
// */
//static struct _class_ro_t _OBJC_CLASS_RO_$_Person __attribute__ ((used, section ("__DATA,__objc_const"))) = {
//    0,
//    __OFFSETOFIVAR__(struct Person, _age),
//    sizeof(struct Person_IMPL),
//    (unsigned int)0,
//    0,
//    "Person",
//    (const struct _method_list_t *)&_OBJC_$_INSTANCE_METHODS_Person,
//    0,
//    (const struct _ivar_list_t *)&_OBJC_$_INSTANCE_VARIABLES_Person,
//    0,
//    (const struct _prop_list_t *)&_OBJC_$_PROP_LIST_Person,
//};
//
///*
// 这里是方法列表。初始化方法列表
// 我们可以看到run,这个是我们自己定义的方法
// 还有height和setHeight,这个是@property()定义的属性,系统帮我们实现了set/get方法
// 下面我们看看变量列表是怎么实现的
//
// _I_Person_run
// _I_Person_height
// _I_Person_setHeight_
// 这三个就是函数指针,保存的是函数实现的位置
// 当我的Person对象调用run方法的时候,其实就是根据“run”字符串去找到_I_Person_run这个函数指针;调用这个函数;
// 我们发现_I_Person_run函数的第一个参数就是Person类型的,
// */
//static struct /*_method_list_t*/ {
//    unsigned int entsize;  // sizeof(struct _objc_method)
//    unsigned int method_count;
//    struct _objc_method method_list[5];
//} _OBJC_$_INSTANCE_METHODS_Person __attribute__ ((used, section ("__DATA,__objc_const"))) = {
//    sizeof(_objc_method),
//    5,
//    {{(struct objc_selector *)"run", "v16@0:8", (void *)_I_Person_run},
//    {(struct objc_selector *)"height", "i16@0:8", (void *)_I_Person_height},
//    {(struct objc_selector *)"setHeight:", "v20@0:8i16", (void *)_I_Person_setHeight_},
//    }
//};
//
//
///*
// 这个就是变量列表,初始化变量列表
// 在.cpp文件中我们可以找到这个,这个就是把Person类的所有属性保存在 _OBJC_$_INSTANCE_VARIABLES_Person 这个变量里;
// _INSTANCE_VARIABLES_Person 是_ivar_list_t类型的,上面有介绍;
// 这个式子的意思是定义一个_ivar_list_t类型的结构体,并且创建一个结构体对象_OBJC_$_INSTANCE_VARIABLES_Person 并给这个对象初始化;初始化的时候把Persion类的属性都放进去了;
//
// */
//static struct _ivar_list_t {
//    unsigned int entsize;  // sizeof(struct _prop_t)
//    unsigned int count;
//    struct _ivar_t ivar_list[2];
//} _OBJC_$_INSTANCE_VARIABLES_Person __attribute__ ((used, section ("__DATA,__objc_const"))) = {
//    sizeof(_ivar_t),
//    2,
//    {
//        /*在这里说一下:
//         OBJC_IVAR_$_Person$_age :这个在上面有定义过,就是_age属性在结构体内存中的偏移量;
//         "_age":是属性的名字
//         "i":是属性的类型;
//         2:未知,可能是属性的数量;
//         4:就是这个属性的内存长度因为是int类型,所以长度是4
//         */
//        {(unsigned long int *)&OBJC_IVAR_$_Person$_age, "_age", "i", 2, 4},
//        {(unsigned long int *)&OBJC_IVAR_$_Person$_height, "_height", "i", 2, 4}
//    }
//};
//
//
//#pragma mark #############  重要  isa指针什么时候赋值的?  ############
///*
// 重要
// 其实在这里赋值的,
// 首先是NSObject的元类对象给Person的元类isa赋值;
// 最后Person的元类对象赋值给Person类对象的isa
// */
//static void OBJC_CLASS_SETUP_$_Person(void ) {
//    OBJC_METACLASS_$_Person.isa = &OBJC_METACLASS_$_NSObject;
//    OBJC_METACLASS_$_Person.superclass = &OBJC_METACLASS_$_NSObject;
//    OBJC_METACLASS_$_Person.cache = &_objc_empty_cache;
//    OBJC_CLASS_$_Person.isa = &OBJC_METACLASS_$_Person;
//    OBJC_CLASS_$_Person.superclass = &OBJC_CLASS_$_NSObject;
//    OBJC_CLASS_$_Person.cache = &_objc_empty_cache;
//}
//
//#pragma section(".objc_inithooks$B", long, read, write)
//__declspec(allocate(".objc_inithooks$B")) static void *OBJC_CLASS_SETUP[] = {
//    (void *)&OBJC_CLASS_SETUP_$_Person,
//};
//
//
//
//#pragma mark #########################   元类对象 到底是怎么产生的?  ##############################
//
//
///*
// 这里是元类对象实现的地方
//
// 在.cpp文件我们看到,这里初始化了一个_class_t类型的变量 OBJC_METACLASS_$_Person
// OBJC_METACLASS_$_Person就是 Person 元类对象,全局只有这一个;
// 我们发现初始化的时候:
// struct _class_t *isa; 这个是0,也就是说元类对象初始化的时候,他的isa指针式空的,别担心,后面会对他从新赋值
// struct _class_t *superclass; 这个也是0,也就是说元类对象初始化的时候,他的指向父类的superclass指针式空的,别担心,后面会对他从新赋值
// void *cache;  缓存也是空的
// void *vtable; 也是空的
// struct _class_ro_t *ro; 这个有值,这个值保存的就是Person元类的数据结构, 基本上保存的是类方法,+加号方法
// 我们全局找到_OBJC_METACLASS_RO_$_Person这个在那实现的;请继续看下面
// */
//extern "C" __declspec(dllexport) struct _class_t OBJC_METACLASS_$_Person __attribute__ ((used, section ("__DATA,__objc_data"))) = {
//    0, // &OBJC_METACLASS_$_NSObject,
//    0, // &OBJC_METACLASS_$_NSObject,
//    0, // (void *)&_objc_empty_cache,
//    0, // unused, was (void *)&_objc_empty_vtable,
//    &_OBJC_METACLASS_RO_$_Person,
//};
//
///*
// 我们发现上面的_OBJC_METACLASS_RO_$_Person是在这里实现的;
// 可以看到
// unsigned int flags; 值是1
// unsigned int instanceStart;可以看到内存初始位置就是_class_t结构体的长度
// unsigned int instanceSize;可以看到内存长度
// unsigned int reserved; 值是0
// const unsigned char *ivarLayout;也是0
// const char *name; 类名"Person"
// const struct _method_list_t *baseMethods; 这个有值,_OBJC_$_CLASS_METHODS_Person,我们可以看到初始化的时候保存的是类方法,也就是+加号方法
// const struct _objc_protocol_list *baseProtocols;也是0
// const struct _ivar_list_t *ivars;也是0
// const unsigned char *weakIvarLayout;也是0
// const struct _prop_list_t *properties;也是0
//
// 我们取看看_method_list_t的值是在哪初始化的,这个一开始保存的是类方法,也就是+加号方法
// 去找找类方法在哪实现的
//
// */
//static struct _class_ro_t _OBJC_METACLASS_RO_$_Person __attribute__ ((used, section ("__DATA,__objc_const"))) = {
//    1,
//    sizeof(struct _class_t),
//    sizeof(struct _class_t),
//    (unsigned int)0,
//    0,
//    "Person",
//    (const struct _method_list_t *)&_OBJC_$_CLASS_METHODS_Person,
//    0,
//    0,
//    0,
//    0,
//};
//
///*
// 类方法在这里实现的;我们发现类方法实现的方式和对象方法实现的是一样的,
// 那就不多介绍了
// */
//static struct /*_method_list_t*/ {
//    unsigned int entsize;  // sizeof(struct _objc_method)
//    unsigned int method_count;
//    struct _objc_method method_list[1];
//} _OBJC_$_CLASS_METHODS_Person __attribute__ ((used, section ("__DATA,__objc_const"))) = {
//    sizeof(_objc_method),
//    1,
//    {{(struct objc_selector *)"home", "v16@0:8", (void *)_C_Person_home}}
//};
//
