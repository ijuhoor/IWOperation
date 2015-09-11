//
//  IWTestObserver.m
//  TestOperations
//
//  Created by Idriss on 05/08/2015.
//  Copyright © 2015 lastminute. All rights reserved.
//

#import "IWTestObserver.h"


@implementation IWTestObserver

- (void)operation:(IWOperation *)operation didFinishWithErrors:(NSArray *)errors
{
    self.errors = errors;
    self.opFinished = YES;
}

- (void)operationDidStart:(IWOperation *)operation
{
    self.opStarted = YES;
}

@end
