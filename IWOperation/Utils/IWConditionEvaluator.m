//
//  IWConditionEvaluator.m
//
//  Created by Idriss on 20/07/2015.
//

#import <dispatch/dispatch.h>

#import "IWConditionEvaluator.h"

#import "IWOperation.h"
#import "IWConditionOperationProtocol.h"

@implementation IWConditionEvaluator

+ (void)evaluateConditions:(NSArray *)conditions ofOperation:(IWOperation*)operation onCompletion:(void(^)(NSArray *errors))completionBlock
{
    
    dispatch_group_t conditionGroup = dispatch_group_create();
    
    NSMutableArray *errors = [NSMutableArray arrayWithCapacity:conditions.count];
    
    [conditions enumerateObjectsUsingBlock:^(IWOperation <IWConditionOperationProtocol> *condition, NSUInteger idx, BOOL *stop) {
        
        dispatch_group_enter(conditionGroup);
        [condition evaluateConditionForOperation:operation
                                      completion:^(IWConditionEvalutation *result){
                                          errors[idx] = result;
                                          dispatch_group_leave(conditionGroup);
                                      }];
    }];

    dispatch_group_notify(conditionGroup, dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        
        NSArray * failures = [[errors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"error != nil"]] valueForKeyPath:@"error"];
    
        if (operation.isCancelled) {
            
            NSError *operationCancelledError =  [NSError errorWithDomain:operationCancelledErrorDomain
                                                                    code:operationCancelledErrorCode
                                                                userInfo:nil];
            
            failures = [failures arrayByAddingObject:operationCancelledError];
        }
        if (completionBlock){
            completionBlock(failures);
        }

    });
    
}

@end
