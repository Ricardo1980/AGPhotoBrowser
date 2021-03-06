//
//  AGPhotoBrowserCell.m
//  AGPhotoBrowser
//
//  Created by Hellrider on 1/5/14.
//  Copyright (c) 2014 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowserCell.h"
#import "AGPhotoBrowserZoomableView.h"

@interface AGPhotoBrowserCell () <AGPhotoBrowserZoomableViewDelegate>

@property (nonatomic, strong) AGPhotoBrowserZoomableView *zoomableView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation AGPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)updateConstraints
{
	[self.contentView removeConstraints:self.contentView.constraints];
	
	NSDictionary *constrainedViews = NSDictionaryOfVariableBindings(_zoomableView);
	
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_zoomableView]|"
																			 options:0
																			 metrics:@{}
																			   views:constrainedViews]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_zoomableView]|"
																			 options:0
																			 metrics:@{}
																			   views:constrainedViews]];
	
	[super updateConstraints];
}

- (void)setFrame:(CGRect)frame
{
    // -- Force the right frame
    CGRect correctFrame = frame;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation) || UIDeviceOrientationIsLandscape(orientation) || orientation == UIDeviceOrientationFaceUp) {
        if (UIDeviceOrientationIsPortrait(orientation) || orientation == UIDeviceOrientationFaceUp) {
            correctFrame.size.width = CGRectGetHeight([[UIScreen mainScreen] bounds]);
            correctFrame.size.height = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        } else {
            correctFrame.size.width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
            correctFrame.size.height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        }
    }
    
    [super setFrame:correctFrame];
}


#pragma mark - Getters

- (AGPhotoBrowserZoomableView *)zoomableView
{
	if (!_zoomableView) {
		_zoomableView = [[AGPhotoBrowserZoomableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_zoomableView.userInteractionEnabled = YES;
        _zoomableView.zoomableDelegate = self;
		
		//[_zoomableView addGestureRecognizer:self.panGesture];
	}
	
	return _zoomableView;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_imageViewPanned:)];
		_panGesture.delegate = self;
		_panGesture.maximumNumberOfTouches = 1;
		_panGesture.minimumNumberOfTouches = 1;
    }
    
    return _panGesture;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGesture) {
        UIView *imageView = [gestureRecognizer view];
        CGPoint translation = [gestureRecognizer translationInView:[imageView superview]];
        
        // -- Check for horizontal gesture
        if (fabsf(translation.x) > fabsf(translation.y)) {
            return YES;
        }
    }
	
    return NO;
}

#pragma mark - Setters

- (void)setCellImage:(UIImage *)cellImage
{
    [self setCellImage:cellImage animated:NO];
}

- (void)setCellImage:(UIImage *)cellImage animated:(BOOL)animated
{
    if (animated) {
        self.zoomableView.alpha = 0.f;
        [self.zoomableView setImage:cellImage];
        [UIView animateWithDuration:0.3f animations:^{
            self.zoomableView.alpha = 1.f;
        }];
    } else {
        [self.zoomableView setImage:cellImage];
    }

	[self setNeedsUpdateConstraints];
}


#pragma mark - Public methods

- (void)resetZoomScale
{
	[self.zoomableView setZoomScale:1.];
}


#pragma mark - Private methods

- (void)setupCell
{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:self.zoomableView];
}

- (void)p_imageViewPanned:(UIPanGestureRecognizer *)recognizer
{
	[self.delegate didPanOnZoomableViewForCell:self withRecognizer:recognizer];
}


#pragma mark - AGPhotoBrowserZoomableViewDelegate

- (void)didDoubleTapZoomableView:(AGPhotoBrowserZoomableView *)zoomableView
{
	[self.delegate didDoubleTapOnZoomableViewForCell:self];
}

@end
