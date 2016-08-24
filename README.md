# ReflectionDemo
A demo for iOS was written by Objective-C. Get the list of all classes , includes created by ourselves and system,  or excludes system created.  
在Objective-C下获取app的所有的类的列表，有包括系统创建的类和自己创建的类列表，也有仅仅是自己创建的类列表

以下有两个方法

test()   获取当前app运行过程中，由开发者(自己)创建的类的列表，不包括运行时系统创建的类
test2()  获取当前app运行时所用到所有的文件，包括 系统创建的类和开发者创建的类的   列表

请分开测试


```

#import "ViewController.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "MyClass2.h"


//http://stackoverflow.com/questions/19298553/get-list-of-all-native-classes
//这个stackoverflow上有说明

//方式1
//获取当前app运行过程中，由开发者创建的类的  列表
void test()
{
    unsigned int count;
    const char **classes;
    Dl_info info;

    //1.获取app的路径
    dladdr(&_mh_execute_header, &info);

    //2.返回当前运行的app的所有类的名字，并传出个数
    //classes：二维数组 存放所有类的列表名称
    //count：所有的类的个数
    classes = objc_copyClassNamesForImage(info.dli_fname, &count);

    for (int i = 0; i < count; i++) {
        //3.遍历并打印，转换Objective-C的字符串
        NSString *className = [NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding];
        Class class = NSClassFromString(className);
        NSLog(@"class name = %@", class);

        //根据类名调用
        if ([className isEqualToString:@"MyClass2"]) {
            MyClass2 *my = [[class alloc] init];

            //调用实例方法
            [my test1];

            //调用类方法
            [class test2];
        }

    }
}

//方式2
//获取当前app运行时所用到所有的文件，包括 系统创建的类和开发者创建的类的   列表
void test2()
{
    int numClasses;
    Class * classes = NULL;

    //1.获取当前app运行时所有的类，包括系统创建的类和开发者创建的类的  个数
    numClasses = objc_getClassList(NULL, 0);

    if (numClasses > 0 )
    {
        //2.创建一个可以容纳numClasses个的大小空间
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);

        //3.重新获取具体类的列表和个数
        numClasses = objc_getClassList(classes, numClasses);

        //4.遍历
        for (int i = 0; i < numClasses; i++) {
            Class class = classes[i];
            const char *className = class_getName(class);
            NSLog(@"class name2 = %s", className);

            //根据类名调用
            if (strcmp(className, "MyClass2") == 0) {
                MyClass2 *my = [[class alloc] init];

                //调用实例方法
                [my test1];

                //调用类方法
                [class test2];
            }
        }
        free(classes);
    }
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    test();
    test2();


}

@end

```

