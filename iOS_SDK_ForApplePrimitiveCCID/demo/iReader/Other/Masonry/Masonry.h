//
//  Masonry.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Masonry.
FOUNDATION_EXPORT double MasonryVersionNumber;

//! Project version string for Masonry.
FOUNDATION_EXPORT const unsigned char MasonryVersionString[];

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "MASUtilities.h"
#import "View+MASAdditions.h"
#import "View+MASShorthandAdditions.h"
#import "ViewController+MASAdditions.h"
#import "NSArray+MASAdditions.h"
#import "NSArray+MASShorthandAdditions.h"
#import "MASConstraint.h"
#import "MASCompositeConstraint.h"
#import "MASViewAttribute.h"
#import "MASViewConstraint.h"
#import "MASConstraintMaker.h"
#import "MASLayoutConstraint.h"
#import "NSLayoutConstraint+MASDebugAdditions.h"

// Made In China
#import "MASConstraintMaker+Forbearance.h"
#import "UIView+Forbearance.h"
#import "NSArray+Sudoku.h"