//
//  IWOperationQueue.h
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

@protocol IWOperationQueueDelegate;

/**
 The operation queue is responsible to run IWOperations.
 It will make sure that the dependencies are satisfied and the conditions are met.
 A delegate can be added to be notified of the termination of an operation
 */

/**
 *  The operation queue is responsible to run IWOperations.
 *  It will make sure that the dependencies are satisfied and the conditions are met.
 *  A delegate can be added to be notified of the termination of an operation
 */
@interface IWOperationQueue : NSOperationQueue

/**
 *  Queue delegate.
 *  It will be notified when an operation finishes.
 */
@property (nonatomic, assign) id <IWOperationQueueDelegate> delegate;

@end


@protocol IWOperationQueueDelegate <NSObject>

/**
 *  The delegate will be notified when an operation finishes
 *
 *  @param queue     the queue on which the operation finished
 *  @param operation the operation that finished
 *  @param errors    an array of NSError thrown by the operation in case of failure
 */
- (void)operationQueue:(IWOperationQueue*)queue didFinishOperation:(NSOperation*)operation withErrors:(NSArray*)errors;

@end
