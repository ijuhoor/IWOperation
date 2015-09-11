//
//  IWExclusivityController.h
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

@class IWOperation;

/**
 * The exclusivity controller will guaranty that the condition that mutually 
 * excludes each other will _always_ run one after the other and never in 
 * parallel.
 * This class is a singleton to keep track of all mutex. However it is OK to 
 * instanciate it for a local mutal exclusion
 */
@interface IWExclusivityController : NSObject

/**
 *  Returns the default initializer for the Exclusibity controler
 *
 *  @return a default instance of the Exclusivity controller
 */
+ (instancetype)defaultExclusivityController;

/**
 *  Adds an operation to the list of mutual exlusions with the given categories
 *
 *  @param operation  the operation that is locked by the mutex
 *  @param categories an array of NSStrings that identifies the mutex
 */
- (void)addOperation:(IWOperation*)operation withCategories:(NSArray *)categories;

/**
 *  Removes an operation to the list of mutual exlusions with the given categories
 *
 *  @param operation  the operation that is unlocked by the mutex
 *  @param categories an array of NSStrings that identifies the mutex
 */
- (void)removeOperation:(IWOperation*)operation withCategories:(NSArray *)categories;



@end
