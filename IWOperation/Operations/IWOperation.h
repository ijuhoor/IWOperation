//
//  IWOperation.h
//  
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2015 Idriss Juhoor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <Foundation/Foundation.h>

#import "IWConditionOperationProtocol.h"
#import "IWOperationObserver.h"

typedef NS_ENUM(NSUInteger, IWOperationState) {
    IWOperationStateCreated = 0,   /*! the operation is created but not ready to run */
    IWOperationStateReady,     /*! the operation is ready to run on the queue */
    IWOperationStateStarted,   /*! the operation task has started */
    IWOperationStateFinishing, /*! the operation is finishing */
    IWOperationStateCancelled, /*! the operation was cancelled */
    IWOperationStateFinished   /*! the operation finished sucessfully or failed */
};

extern NSString * const operationCancelledErrorDomain;
extern NSInteger  const operationCancelledErrorCode;


/**
 *  An IWOperation is a subclass of NSOperation designed to be used with an IWOperationQueue.
 *  It adds the following features:
 *  *Conditions*: An operation will not start until all the conditions are satisfied.
 *  *State*:      Extended state machine
 *  *Observers*:  Observers can be attached and are notified when the operation starts and finishes.
 */
@interface IWOperation : NSOperation

@property (nonatomic, readonly)         IWOperationState  state;
@property (nonatomic, readonly, strong) NSArray          *conditions;
@property (nonatomic, readonly, strong) NSArray          *observers;
@property (nonatomic, strong)           NSError          *error;

/**
 *  Add a condition to the operation.
 *  The operation will execute only if all its conditions are satisfied
 *
 *  @param condition a condition to be satisfied
 */
- (void)addCondition:(IWOperation<IWConditionOperationProtocol>*)condition;


/**
 *  Add an observer to the operation. The observer is retained
 *
 *  @param observer the observer
 */
- (void)addObserver:(id<IWOperationObserver>)observer;


/**
 *  This method represents the work to be done. It needs to be subclassed for the desired result.
 */
- (void)run;


/**
 *  *finish* needs to be called when an operation finised. Errors should be passed as parameter.
 *
 *  @param errors an array of errors in case the task failed. Nil if the task is successful.
 */
- (void)finish:(NSArray*)errors;

@end

