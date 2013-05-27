//
//  PhotoView.m
//  Elong_Shake
//
//  图片展示控件
//  支持图片的手势缩放、双击缩放、翻页、单击选择
//
//  Created by Wang Shuguang on 13-1-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PhotoView.h"
#import "UIImageView+WebCache.h"

#define PHOTOVIEW_CACHECOUNT 3
#define	PHOTO_MAX_ZOOM_SCALE 3
#define PHOTO_MIN_ZOOM_SCALE 1
#define PHOTO_TAP_MAX_ZOOM_SCALE 2
@implementation PhotoView
@synthesize photoUrls = _photoUrls;
@synthesize delegate;


- (void) dealloc{
    self.photoUrls = nil;
    [photoArray release];
    [super dealloc];
}

// 初始化图片
- (id)initWithFrame:(CGRect)frame photoUrls:(NSArray *)urs{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoUrls = urs;
        
        // 图片数量
        if (urs) {
            photoCount = urs.count;
        }else{
            photoCount = 0;
        }
        // 当前页码
        page = 0;
        
        // 是否已经放大
        isScaled = NO;
        
        // 图片大小
        photoSize = CGSizeMake(frame.size.width, frame.size.height);
        
        // 图片滚动翻页容器
        photosView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, photoSize.width, photoSize.height)];
        photosView.showsHorizontalScrollIndicator = YES;
        photosView.showsVerticalScrollIndicator = NO;
        photosView.pagingEnabled = YES;
        photosView.contentSize = CGSizeMake(photoCount * photoSize.width, photoSize.height);
        photosView.delegate = self;
        [self addSubview:photosView];
        [photosView release];
        photosView.showsHorizontalScrollIndicator = NO;
        photosView.showsVerticalScrollIndicator = NO;
        
        // 页面中图片在内存中的容器
        photoArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < PHOTOVIEW_CACHECOUNT; i++) {
            
            if(i==self.photoUrls.count)
                break;
            
            NSInteger x = photoSize.width * i;
            NSInteger y = 0;
            
            // 图片缩放容器
            UIScrollView *scaleView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, photoSize.width, photoSize.height)];
            scaleView.delegate = self;
            scaleView.bouncesZoom = YES;
            scaleView.showsVerticalScrollIndicator = NO;
            scaleView.showsHorizontalScrollIndicator = NO;
            scaleView.minimumZoomScale = PHOTO_MIN_ZOOM_SCALE;
            scaleView.maximumZoomScale = PHOTO_MAX_ZOOM_SCALE;
            scaleView.contentSize = CGSizeMake(photoSize.width, photoSize.height);
            scaleView.zoomScale = PHOTO_MIN_ZOOM_SCALE;
            [photosView addSubview:scaleView];
            [scaleView release];
            
            
            // 图片容器
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, photoSize.width, photoSize.height)];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [scaleView addSubview:imageView];
            
            // 双击手势
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgDoubleTap:)];
            doubleTap.numberOfTapsRequired = 2;
            doubleTap.numberOfTouchesRequired = 1;
            [imageView addGestureRecognizer:doubleTap];
            [doubleTap release];
            
            
            // 单击手势
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgSingleTap:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [singleTap requireGestureRecognizerToFail:doubleTap];
            [imageView addGestureRecognizer:singleTap];
            [singleTap release];
            
            
            [imageView setImageWithURL:[NSURL URLWithString:[self.photoUrls objectAtIndex:i]]
                               options:SDWebImageLowPriority
                              progress:YES];
            
            [scaleView addSubview:imageView];
            [imageView release];
            [photoArray addObject:imageView];
        }
        
    }
    return self;
}

// 重新加载图片
- (void)reloadPhotosWith:(NSArray *)urls{
    self.photoUrls = urls;
    if (urls) {
        photoCount = urls.count;
    }else{
        photoCount = 0;
    }
    page = 0;
    isScaled = NO;
    
    for (int i = 0; i < PHOTOVIEW_CACHECOUNT; i++) {
        UIImageView *imageView =  (UIImageView *)[photoArray objectAtIndex:i];
        UIScrollView *scaleView = (UIScrollView *)[imageView superview];
        scaleView.zoomScale = scaleView.minimumZoomScale;
        scaleView.contentSize = photoSize;
        scaleView.frame = CGRectMake(photoSize.width * i, 0, photoSize.width, photoSize.height);
        
        [imageView setImageWithURL:[NSURL URLWithString:[self.photoUrls objectAtIndex:i]]
                           options:SDWebImageLowPriority
                          progress:YES];
    }
}


#pragma mark -
#pragma mark Private Methode

- (void) photoPageUp{
    NSInteger index = page - 1;
    if (index >= photoCount) {
        return;
    }
    
    // 交换数据源
    for (int i = PHOTOVIEW_CACHECOUNT - 1; i > 0; i--) {
		[photoArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
	}
    UIImageView *imageView =[photoArray objectAtIndex:0];
    UIScrollView *scrollView = (UIScrollView *)[imageView superview];
    
    [imageView setImageWithURL:[NSURL URLWithString:[self.photoUrls objectAtIndex:index]]
                       options:SDWebImageLowPriority
                      progress:YES];
    scrollView.frame = CGRectMake(index * photoSize.width, 0, photoSize.width, photoSize.height);
}

- (void) photoPageDownSilently{
    NSInteger index = page + 1;
    if (index >= photoCount) {
        return;
    }
    
    // 交换数据源
    for (int i = 0; i < PHOTOVIEW_CACHECOUNT - 1; i++) {
		[photoArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
	}
    UIImageView *imageView =[photoArray objectAtIndex:PHOTOVIEW_CACHECOUNT - 1];
    UIScrollView *scrollView = (UIScrollView *)[imageView superview];
    
    scrollView.frame = CGRectMake(index * photoSize.width, 0, photoSize.width, photoSize.height);
}

- (void) photoPageDown{
    NSInteger index = page + 1;
    if (index >= photoCount) {
        return;
    }
    
    // 交换数据源
    for (int i = 0; i < PHOTOVIEW_CACHECOUNT - 1; i++) {
		[photoArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
	}
    UIImageView *imageView =[photoArray objectAtIndex:PHOTOVIEW_CACHECOUNT - 1];
    UIScrollView *scrollView = (UIScrollView *)[imageView superview];
    [imageView setImageWithURL:[NSURL URLWithString:[self.photoUrls objectAtIndex:index]]
                       options:SDWebImageLowPriority
                      progress:YES];
    
    scrollView.frame = CGRectMake(index * photoSize.width, 0, photoSize.width, photoSize.height);
    
    
}

- (void) resetScaleView{
    for (int i = 0; i < PHOTOVIEW_CACHECOUNT; i++) {
        if(i==photoArray.count)
            break;
        
        UIImageView *imageView =  (UIImageView *)[photoArray objectAtIndex:i];
        UIScrollView *scaleView = (UIScrollView *)[imageView superview];
        scaleView.zoomScale = scaleView.minimumZoomScale;
        scaleView.contentSize = photoSize;
    }
}

#pragma mark -
#pragma mark GestureRecognizer on photo

- (void)imgDoubleTap:(UIGestureRecognizer *)gestureRecognizer{
	UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
	
	UIScrollView *scrollView = (UIScrollView *)[imageView superview];
	
	CGPoint point = [gestureRecognizer locationOfTouch:0 inView:imageView];
	if(isScaled == YES){
		[self zoomToPointInRootView:point atScale:scrollView.minimumZoomScale imageView:imageView];
		isScaled = NO;
	}else{
		[self zoomToPointInRootView:point atScale:PHOTO_TAP_MAX_ZOOM_SCALE imageView:imageView];
		isScaled = YES;
	}
}

-(void)imgSingleTap:(UIGestureRecognizer *)gestureRecognizer{
	if ([delegate respondsToSelector:@selector(photoView:didSelectedAtIndex:)]) {
        [delegate photoView:self didSelectedAtIndex:page];
    }
}


- (void)zoomToPointInRootView:(CGPoint)center atScale:(float)scale imageView:(UIImageView *)imageView{
	
	UIScrollView *scrollView = (UIScrollView *)[imageView superview];
    CGRect zoomRect;
	
    zoomRect.size.height = scrollView.frame.size.height / scale;
	
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
	
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
	
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
	
	
    [scrollView zoomToRect:zoomRect animated:YES];
	
}

- (void) pageToIndex:(NSInteger)_index{
    if (_index == 0) {
        return;
    }else if(_index == 1){
        photosView.contentOffset = CGPointMake(photoSize.width, 0);
    }else{
        for (int i = 0; i < _index + 1; i++) {
            page = i;
            [self photoPageDown];
        }
        photosView.contentOffset = CGPointMake(photoSize.width * _index, 0);
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView != photosView) {
		return;
	}
    
	NSInteger tpage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    
    if (tpage > page || tpage < page) {
        [self resetScaleView];
    }
	
    if (tpage > page && tpage > 1 && tpage < photoCount - 1) {
        page = tpage;
        [self photoPageDown];
    }else if(tpage < page && tpage < photoCount - 2 && tpage > 0){
        page = tpage;
        [self photoPageUp];
    }else{
        page = tpage;
    }
    
    if ([delegate respondsToSelector:@selector(photoView:didPageToIndex:)]) {
        [delegate photoView:self didPageToIndex:page];
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	if (scrollView != photosView) {
		if ([[scrollView subviews] count]>0) {
            UIImageView *imageView = (UIImageView *)[[scrollView subviews] objectAtIndex:0];
            if (!imageView.image) {
                return nil;
            }else{
                return imageView;
            }
			return nil;
		}
        return nil;
	}else {
		return nil;
	}
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
	if (scrollView == photosView) {
		return;
	}
	
	UIImageView *imgView = [[scrollView subviews] objectAtIndex:0];
	if (imgView.image == nil) {
		return;
	}
	
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
	
	scrollView.contentSize = CGSizeMake(MAX(imgView.frame.size.width,photoSize.width),MAX(imgView.frame.size.height,photoSize.height));
    
}


// 重新调整所有的子类控件
#pragma mark -
#pragma mark Layout Subviews
- (void) layoutSubviews{
    if (photoSize.width == self.frame.size.width) {
        return;
    }
    
    NSLog(@"layout");
    photosView.delegate = nil;
    photoSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    photosView.frame = CGRectMake(0, 0, photoSize.width, photoSize.height);
    photosView.contentSize = CGSizeMake(photoCount * photoSize.width , photoSize.height);
    photosView.contentOffset = CGPointMake(page * photoSize.width, 0);
    
    for (int i = 0; i < PHOTOVIEW_CACHECOUNT; i++) {
        UIScrollView *scaleView = (UIScrollView *)[((UIImageView *)[photoArray objectAtIndex:i]) superview];
		NSInteger x = photoSize.width * (scaleView.frame.origin.x / scaleView.frame.size.width);
		NSInteger y = 0;
		
        float formerScale = scaleView.zoomScale;
        
        scaleView.frame = CGRectMake(x, y, photoSize.width, photoSize.height);
        scaleView.zoomScale = scaleView.minimumZoomScale;
        scaleView.contentSize = photoSize;
        
        UIImageView *imageView = (UIImageView *)[photoArray objectAtIndex:i];
        imageView.frame = CGRectMake(0, 0, photoSize.width, photoSize.height);
        
        scaleView.zoomScale = formerScale;
	}
    
    photosView.delegate = self;
}

@end
