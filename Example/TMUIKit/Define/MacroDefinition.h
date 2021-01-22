//
//  MacroDefinition.h
//  RichTextView
//
//  Created by     songguolin on 16/6/3.
//  Copyright © 2016年 innos-campus. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h


//重写NSLog,Debug模式下打印日志和当前行数
//fprintf(stderr,"\nfile:%s \nfunction:%s\nline:%d \ncontent:%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
//} while (0)
#if DEBUG
#define NSLog(FORMAT, ...) do {\
fprintf(stderr,"\n<%s, line:%d>:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
} while (0)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(FORMAT, ...) nil
#define debugMethod()
#endif

//-------------------获取设备大小-------------------------
#define kMTFYScreenW [UIScreen mainScreen].bounds.size.width
#define kMTFYScreenH [UIScreen mainScreen].bounds.size.height

//----------------------颜色类---------------------------
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


//----------------------其他----------------------------
//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define BIWeakObj(o)   @autoreleasepool {} __weak typeof(o) o ## Weak = o;
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

#define SemaphoreBegin \
static dispatch_semaphore_t semaphore; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
semaphore = dispatch_semaphore_create(1); \
}); \
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

#define SemaphoreEnd \
dispatch_semaphore_signal(semaphore);

#endif /* MacroDefinition_h */
