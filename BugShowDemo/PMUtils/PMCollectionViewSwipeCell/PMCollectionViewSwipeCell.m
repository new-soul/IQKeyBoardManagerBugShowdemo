// Copyright (c) 2013-2014 Peter Meyers
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
//
//  PMCollectionViewSwipeCell.m
//  Created by Peter Meyers on 8/21/14.
//
//

#import "PMCollectionViewSwipeCell.h"


@interface PMCollectionViewSwipeCellScrollView : UIScrollView

+ (instancetype) scrollViewWithCell:(PMCollectionViewSwipeCell *)cell;

@end


@interface PMCollectionViewSwipeCell() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, getter=isEditing) BOOL editing;
@end

@implementation PMCollectionViewSwipeCell
{
    PMCollectionViewSwipeCellScrollView *_scrollView;
    BOOL _delegateRespondsToDidMoveToPosition;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonPMCollectionViewSwipeCellInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonPMCollectionViewSwipeCellInit];
}


#pragma mark - Public Methods


- (void) setDelegate:(id<PMSwipeCellDelegate>)delegate
{
    _delegate = delegate;
    _delegateRespondsToDidMoveToPosition = [_delegate respondsToSelector:@selector(swipeCell:didMoveToPosition:)];
}

- (void) setSwipeEnabled:(BOOL)swipeEnabled
{
    _scrollView.scrollEnabled = swipeEnabled;
}

- (BOOL) swipeEnabled
{
    return _scrollView.scrollEnabled;
}

- (void) setBouncesOpen:(BOOL)bounces
{
    _scrollView.bounces = bounces;
}

- (BOOL) bouncesOpen
{
    return _scrollView.bounces;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (_editing != editing) {
        _editing = editing;
        if (_delegateRespondsToDidMoveToPosition) {
            [self.delegate swipeCell:self didMoveToPosition:self.cellPosition];
        }
    }
}

- (void) setCellPosition:(PMCellPosition)position animated:(BOOL)animated
{
    CGPoint offset = [self contentOffsetForPosition:position];
    [_scrollView setContentOffset:offset animated:animated];
    _scrollView.panGestureRecognizer.enabled = NO;
    _scrollView.panGestureRecognizer.enabled = YES;
    self.editing = (position != PMCellPositionCentered);
    if (!animated) {
        switch (position) {
            case PMCellPositionCentered:
                self.leftUtilityView.hidden = YES;
                self.rightUtilityView.hidden = YES;
                break;
            case PMCellPositionLeftUtilityViewVisible:
                self.leftUtilityView.hidden = NO;
                self.rightUtilityView.hidden = YES;
                break;
            case PMCellPositionRightUtilityViewVisible:
                self.leftUtilityView.hidden = YES;
                self.rightUtilityView.hidden = NO;
                break;
        }
    }
}

- (void) setCellPosition:(PMCellPosition)cellPosition
{
    [self setCellPosition:cellPosition animated:NO];
}

- (PMCellPosition) cellPosition
{
    CGPoint offset = _scrollView.contentOffset;
    
    if (offset.x >= [self contentOffsetForPosition:PMCellPositionLeftUtilityViewVisible].x) {
        return PMCellPositionLeftUtilityViewVisible;
    }
    else if (offset.x <= [self contentOffsetForPosition:PMCellPositionRightUtilityViewVisible].x) {
        return PMCellPositionRightUtilityViewVisible;
    }
    else {
        return PMCellPositionCentered;
    }
}

- (void) setLeftUtilityView:(UIView *)leftUtilityView
{
    if (_leftUtilityView != leftUtilityView) {
        [_leftUtilityView removeFromSuperview];
        _leftUtilityView = leftUtilityView;
        _leftUtilityView.hidden = YES;
        [self insertSubview:_leftUtilityView belowSubview:_scrollView];
    }
}

- (void) setRightUtilityView:(UIView *)rightUtilityView
{
    if (_rightUtilityView != rightUtilityView) {
        [_rightUtilityView removeFromSuperview];
        _rightUtilityView = rightUtilityView;
        _rightUtilityView.hidden = YES;
        [self insertSubview:_rightUtilityView belowSubview:_scrollView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.contentSize = self.bounds.size;
    _scrollView.contentInset = UIEdgeInsetsMake(0.0f,
                                                self.leftUtilityView.frame.size.width,
                                                0.0f,
                                                self.rightUtilityView.frame.size.width);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.bouncesOpen = YES;
    self.delegate = nil;
    self.leftUtilityView = nil;
    self.rightUtilityView = nil;
    self.cellPosition = PMCellPositionCentered;
    self.swipeEnabled = YES;
}


#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(PMCollectionViewSwipeCellScrollView *)scrollView
{
    if ((self.leftUtilityView && !self.leftUtilityView.hidden && scrollView.contentOffset.x > 0.0f) ||
        (self.rightUtilityView && !self.rightUtilityView.hidden && scrollView.contentOffset.x < 0.0f) ||
        (!self.leftUtilityView && scrollView.contentOffset.x < 0.0f) ||
        (!self.rightUtilityView && scrollView.contentOffset.x > 0.0f)) {
        [self setCellPosition:PMCellPositionCentered animated:NO];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.x < 0.0f  && velocity.x < 0.0f) {
        *targetContentOffset = [self contentOffsetForPosition:PMCellPositionLeftUtilityViewVisible];
    }
    else if (scrollView.contentOffset.x > 0.0f && velocity.x > 0.0f) {
        *targetContentOffset = [self contentOffsetForPosition:PMCellPositionRightUtilityViewVisible];
    }
    else {
        *targetContentOffset = [self contentOffsetForPosition:PMCellPositionCentered];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView.panGestureRecognizer.view];
    CGPoint centeredOffset = [self contentOffsetForPosition:PMCellPositionCentered];
    
    if (scrollView.contentOffset.x == centeredOffset.x) {
        if (velocity.x < 0.0f && self.rightUtilityView) {
            self.rightUtilityView.hidden = NO;
        }
        else if (velocity.x > 0.0f && self.leftUtilityView) {
            self.leftUtilityView.hidden = NO;
        }
        else {
            scrollView.scrollEnabled = NO;
            scrollView.scrollEnabled = YES;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        if (scrollView.contentOffset.x == 0.0f) {
            self.leftUtilityView.hidden = YES;
            self.rightUtilityView.hidden = YES;
            self.editing = NO;
        }
        else {
            self.editing = YES;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0.0f) {
        self.leftUtilityView.hidden = YES;
        self.rightUtilityView.hidden = YES;
        self.editing = NO;
    }
    else {
        self.editing = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0.0f) {
        self.leftUtilityView.hidden = YES;
        self.rightUtilityView.hidden = YES;
        self.editing = NO;
    }
    else {
        self.editing = YES;
    }
}


#pragma mark - Internal Methods


- (CGPoint) contentOffsetForPosition:(PMCellPosition)position
{
    CGPoint offset = CGPointZero;
    switch (position) {
        case PMCellPositionCentered:
            break;
        case PMCellPositionRightUtilityViewVisible:
            offset.x = _scrollView.contentInset.right;
            break;
        case PMCellPositionLeftUtilityViewVisible:
            offset.x = -_scrollView.contentInset.left;
            break;
    }
    return offset;
}

- (void) commonPMCollectionViewSwipeCellInit
{
    _scrollView = [PMCollectionViewSwipeCellScrollView scrollViewWithCell:self];
    _scrollView.delegate = self;
    self.cellPosition = PMCellPositionCentered;
    self.swipeEnabled = YES;
}


@end


#pragma mark - PMSwipeCellScrollView


@implementation PMCollectionViewSwipeCellScrollView
{
    __weak PMCollectionViewSwipeCell *_cell;
}

+ (instancetype)scrollViewWithCell:(PMCollectionViewSwipeCell *)cell
{
    return [[self alloc] initWithCell:cell];
}

- (instancetype) initWithCell:(PMCollectionViewSwipeCell *)cell
{
    
    self = [self initWithFrame:cell.bounds];
    if (self) {
        [self addSubview:cell.contentView];
        [cell addSubview:self];
        _cell = cell;
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.scrollEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.alwaysBounceHorizontal = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!_cell.isEditing) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.canCancelContentTouches) {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent:event];
    if (_cell.isEditing) {
        [_cell setCellPosition:PMCellPositionCentered animated:YES];
    }
    else {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint velocity = [self.panGestureRecognizer velocityInView:self.panGestureRecognizer.view];
        return (fabs(velocity.y) < fabs(velocity.x));
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}


@end
