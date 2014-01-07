//
//  ViewController.m
//  254p
//
//  Created by Youp on 2014. 1. 8..
//  Copyright (c) 2014년 admin. All rights reserved.
//

#import "ViewController.h"
#define IMAGE_NUM 4

@interface ViewController (){
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    int _loadedPageCount;
}

@end

@implementation ViewController

// 인자로 넘어온 페이지를 로딩
-(void)loadContentsPage:(int)pageNo{
    // 이미 로딩한 페이지 인지, 페이지 한계를 넘었는지를 체크
    if (pageNo < 0 || pageNo < _loadedPageCount || pageNo >= IMAGE_NUM) {
        return;
    }
    
    float width = _scrollView.frame.size.width;
    float height = _scrollView.frame.size.height;
    
    NSString *fileName = [NSString stringWithFormat:@"image%d", pageNo];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(width*pageNo, 0, width, height);
    [_scrollView addSubview:imageView];
    _loadedPageCount++;
    
}


// 스크롤이 끝나면 새로운 페이지로딩
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //페이지 인덱스 계산
    float width = scrollView.frame.size.width;
    float offSetX = scrollView.contentOffset.x;
    int pageNo = floorf(offSetX/width);
    _pageControl.currentPage = pageNo;
    
    //전, 후페이지까지 함께 로딩
    [self loadContentsPage:pageNo-1];
    [self loadContentsPage:pageNo];
    [self loadContentsPage:pageNo+1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    //스크롤뷰의 크기를 구함
    float width = _scrollView.frame.size.width;
    float height = _scrollView.frame.size.height;
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(width*IMAGE_NUM, height);
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(130, 400, 60, 40)];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = IMAGE_NUM;
    
    //초기값 설정
    _loadedPageCount = 0;
    [self loadContentsPage:0];
    [self loadContentsPage:1];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
