//
//  IWConditionEvalutation.m
//
//  Created by Idriss on 20/07/2015.
//

#import "IWConditionEvalutation.h"

@implementation IWConditionEvalutation

+ (IWConditionEvalutation*)success
{
    IWConditionEvalutation *condition = [[IWConditionEvalutation alloc] init];
    condition.success = YES;

    return condition;
}

+ (IWConditionEvalutation*)failureWithError:(NSError*)error
{
    IWConditionEvalutation *condition = [[IWConditionEvalutation alloc] init];
    condition.error = error;
    
    return condition;

}

@end
