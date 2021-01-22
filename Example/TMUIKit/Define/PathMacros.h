//
//  PathMacros.h
//  Matafy
//
//  Created by Cheng on 2017/12/21.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#ifndef PathMacros_h
#define PathMacros_h


// 沙盒目录
#define SANDBOX_HOME_PATH           NSHomeDirectory()
// MyApp.app
#define SANDBOX_BUNDLE_PATH         [[NSBundle mainBundle] bundlePath]
// tmp
#define SANDBOX_TEMP_PATH           NSTemporaryDirectory()
// Documents
#define SANDBOX_DOCUMENT_PATH       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// Library
#define SANDBOX_LIBRARY_PATH        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]


// 机票js文件名
#define AIRLINE_JS            @"airline.js"
#define AIRLINE               @"airline"

// 酒店js文件名
#define HOTEL_JS              @"hotel.js"
#define HOTEL                 @"hotel"


#endif /* PathMacros_h */
