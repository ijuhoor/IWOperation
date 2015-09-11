//
//  IWTestCondition.m
//  TestOperations
//
//  Created by Idriss on 05/08/2015.
//  Copyright © 2015 lastminute. All rights reserved.
//

#import "IWTestCondition.h"

#import "IWConditionEvalutation.h"

@implementation IWTestCondition

- (BOOL) conditionSatisfied
{
    return self.succeeds;
}

- (BOOL)isMutuallyExclusive
{
    return NO;
}

- (void)evaluateConditionForOperation:(IWOperation *)operation completion:(void (^)(IWConditionEvalutation *))completionBlock
{
    if (self.succeeds) {
        completionBlock([IWConditionEvalutation success]);
    } else {
        completionBlock([IWConditionEvalutation failureWithError:[NSError errorWithDomain:@"tests"
                                                                                     code:1
                                                                                 userInfo:nil]]);
    }
}


@end
