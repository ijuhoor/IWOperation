//
//  IWTestObserver.h
//  TestOperations
//
//  Created by Idriss on 05/08/2015.
//  Copyright © 2015 lastminute. All rights reserved.
//


#import "IWOperationObserver.h"

@interface IWTestObserver : NSObject <IWOperationObserver>

@property (nonatomic, strong) NSArray *errors;
@property (nonatomic) BOOL opStarted;
@property (nonatomic) BOOL opFinished;

@end
