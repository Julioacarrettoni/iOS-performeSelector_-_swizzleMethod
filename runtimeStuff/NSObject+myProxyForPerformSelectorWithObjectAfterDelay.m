//
//  NSObject+myProxyForPerformSelectorWithObjectAfterDelay.m
//  runtimeStuff
//
//  Created by Julio Andrés Carrettoni on 21/09/12.
//  Copyright (c) 2012 Julio Andrés Carrettoni. All rights reserved.
//

#import "NSObject+myProxyForPerformSelectorWithObjectAfterDelay.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject(myProxyForPerformSelectorWithObjectAfterDelay_v3w4ef3wfed)

const static NSString* ORIGINAL_SELECTOR_KEY_v3w4ef3wfed = @"originalSelector";
const static NSString* ORIGINAL_ARGUMENT_KEY_v3w4ef3wfed = @"originalArgument";

static NSMutableDictionary* delayedObjectsPerformingStuff = nil;

- (void) performSelector_v3w4ef3wfed:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;
{
    NSString* selectorName = NSStringFromSelector(aSelector);
    
    //We create a new argument that contains the original argument (if any) and the current selector name
    NSDictionary* argumentForProxyPerformSelector = nil;
    if (anArgument)
        argumentForProxyPerformSelector = [NSDictionary dictionaryWithObjectsAndKeys:selectorName, ORIGINAL_SELECTOR_KEY_v3w4ef3wfed, anArgument, ORIGINAL_ARGUMENT_KEY_v3w4ef3wfed, nil];
    else
        argumentForProxyPerformSelector = [NSDictionary dictionaryWithObject:selectorName forKey:ORIGINAL_SELECTOR_KEY_v3w4ef3wfed];
    
    NSString* newSelectorName = [NSString stringWithFormat:@"__alternative_sel_for_%@_v3w4ef3wfed:", selectorName];
    SEL newSelector = NSSelectorFromString(newSelectorName);
    
    if (![self respondsToSelector:newSelector])
    {
        class_addMethod([self class], newSelector, method_getImplementation(class_getInstanceMethod([self class], @selector(myProxyForPerformSelectorWithObjectAfterDelay_v3w4ef3wfed:))), "");
    }
    
    // call through to the original performSelectorWithObjectAfterDelay, really, remember than now they are suposed to be swapped
    [self performSelector_v3w4ef3wfed:newSelector withObject:argumentForProxyPerformSelector afterDelay:delay];
    
    [self addSelfToSetOfObjectsForSelector:selectorName withArguments:argumentForProxyPerformSelector];    
}

- (void) addSelfToSetOfObjectsForSelector:(NSString*) selectorName withArguments:(NSDictionary*) arguments
{
    @synchronized(delayedObjectsPerformingStuff)
    {
        if (!delayedObjectsPerformingStuff)
            delayedObjectsPerformingStuff = [NSMutableDictionary new];
        
        NSMutableSet* set = [delayedObjectsPerformingStuff objectForKey:selectorName];
        if (!set)
        {
            set = [NSMutableSet set];
            [delayedObjectsPerformingStuff setObject:set forKey:selectorName];
        }
        NSDictionary* payload = [NSDictionary dictionaryWithObjectsAndKeys:self, @"object", arguments, @"arguments", nil];
        [set addObject:payload];
    }
}

- (void) removeSelfFromSetOfObjectsForSelector:(NSString*) selectorName withArguments:(NSDictionary*) arguments
{
    @synchronized(delayedObjectsPerformingStuff)
    {
        NSMutableSet* set = [delayedObjectsPerformingStuff objectForKey:selectorName];

        NSArray* allObjects = [NSArray arrayWithArray:[set allObjects]];
        for (NSDictionary* dic in allObjects)
        {
            if ([dic objectForKey:@"object"] == self && [dic objectForKey:@"arguments"] == arguments)
            {
                [set removeObject:dic];
                break;
            }
        }
        
        if (set.count == 0)
        {
            [delayedObjectsPerformingStuff removeObjectForKey:selectorName];
        }
    }
}

- (void) myProxyForPerformSelectorWithObjectAfterDelay_v3w4ef3wfed:(NSDictionary*) argumentForProxyPerformSelector
{
    //We retrieve the name of the original selector
    NSString* selectorName = [argumentForProxyPerformSelector objectForKey:ORIGINAL_SELECTOR_KEY_v3w4ef3wfed];
    SEL originalSelector = NSSelectorFromString(selectorName);
    
    //We retrieve the original
    NSDictionary* originalArgument = [argumentForProxyPerformSelector objectForKey:ORIGINAL_ARGUMENT_KEY_v3w4ef3wfed];
    
    [self performSelector:originalSelector withObject:originalArgument];
    [self removeSelfFromSetOfObjectsForSelector:selectorName withArguments:argumentForProxyPerformSelector];
}

+ (void)cancelALLPreviousPerformRequestsWithSelector:(SEL) selector
{
    @synchronized(delayedObjectsPerformingStuff)
    {
        NSString* selectorName = NSStringFromSelector(selector);
        NSMutableSet* mutSet = [delayedObjectsPerformingStuff objectForKey:selectorName];
        if (mutSet)
        {
            NSSet* set = [NSSet setWithSet:mutSet];
            [delayedObjectsPerformingStuff removeObjectForKey:selectorName];
            
            NSString* newSelectorName = [NSString stringWithFormat:@"__alternative_sel_for_%@_v3w4ef3wfed:", selectorName];
            SEL newSelector = NSSelectorFromString(newSelectorName);
            
            for (NSDictionary* dic in set)
            {
                NSObject* obj = [dic objectForKey:@"object"];
                NSDictionary* arguments = [dic objectForKey:@"arguments"];
                [NSObject cancelPreviousPerformRequestsWithTarget_v3w4ef3wfed:obj selector:newSelector object:arguments];
            }
        }
    }
}

+ (void)cancelPreviousPerformRequestsWithTarget_v3w4ef3wfed:(id)aTarget selector:(SEL)aSelector object:(id)anArgument
{
    @synchronized(delayedObjectsPerformingStuff)
    {
        NSString* selectorName = NSStringFromSelector(aSelector);
        NSMutableSet* setOfPerformSelectors = [delayedObjectsPerformingStuff objectForKey:selectorName];
        if (setOfPerformSelectors)
        {
            NSSet* set = [NSSet setWithSet:setOfPerformSelectors];
            
            NSString* newSelectorName = [NSString stringWithFormat:@"__alternative_sel_for_%@_v3w4ef3wfed:", selectorName];
            SEL newSelector = NSSelectorFromString(newSelectorName);
            
            for (NSDictionary* dic in set)
            {
                NSObject* obj = [dic objectForKey:@"object"];
                NSDictionary* arguments = [dic objectForKey:@"arguments"];
                if (aTarget == obj && anArgument == [arguments objectForKey:ORIGINAL_ARGUMENT_KEY_v3w4ef3wfed])
                {
                    [NSObject cancelPreviousPerformRequestsWithTarget_v3w4ef3wfed:obj selector:newSelector object:arguments];
                    [setOfPerformSelectors removeObject:dic];
                }
            }
            
            if (setOfPerformSelectors.count == 0)
            {
                [delayedObjectsPerformingStuff removeObjectForKey:selectorName];
            }
        }
    }
}

+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector
{
    @synchronized(delayedObjectsPerformingStuff)
    {
        NSString* selectorName = NSStringFromSelector(aSelector);
        NSMutableSet* setOfPerformSelectors = [delayedObjectsPerformingStuff objectForKey:selectorName];
        if (setOfPerformSelectors)
        {
            NSSet* set = [NSSet setWithSet:setOfPerformSelectors];
            
            NSString* newSelectorName = [NSString stringWithFormat:@"__alternative_sel_for_%@_v3w4ef3wfed:", selectorName];
            SEL newSelector = NSSelectorFromString(newSelectorName);
            
            for (NSDictionary* dic in set)
            {
                NSObject* obj = [dic objectForKey:@"object"];
                if (aTarget == obj)
                {
                    NSDictionary* arguments = [dic objectForKey:@"arguments"];
                    [NSObject cancelPreviousPerformRequestsWithTarget_v3w4ef3wfed:obj selector:newSelector object:arguments];
                    [setOfPerformSelectors removeObject:dic];
                }
            }
            
            if (setOfPerformSelectors.count == 0)
            {
                [delayedObjectsPerformingStuff removeObjectForKey:selectorName];
            }
        }
    }
}

static bool methodSwapped = NO;
+ (void) swapPerformSelectorWithObjectAfterDelayWithProxyMethod
{
    @synchronized(self)
    {
        if (!methodSwapped)
        {
            methodSwapped = YES;
            //With this we change the perform selector with delay with our own method :)
            [self jr_swizzleMethod:@selector(performSelector:withObject:afterDelay:) withMethod:@selector(performSelector_v3w4ef3wfed:withObject:afterDelay:) error:nil];
            [self jr_swizzleClassMethod:@selector(cancelPreviousPerformRequestsWithTarget:selector:object:) withClassMethod:@selector(cancelPreviousPerformRequestsWithTarget_v3w4ef3wfed:selector:object:) error:nil];
        }
    }
}

//Just by adding the category into your proyect the power is unleashed :)
+ (void) load
{
    [self swapPerformSelectorWithObjectAfterDelayWithProxyMethod];
}

@end