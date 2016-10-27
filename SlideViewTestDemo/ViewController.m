//
//  ViewController.m
//  SlideViewTestDemo
//
//  Created by 孙春磊 on 2016/10/27.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "ViewController.h"
static NSString *imageiocn = @"9d4636a301cbcdfa18125dcf88c1da6f";
@interface ViewController ()
@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, assign) BOOL isDraging;
@property (nonatomic, weak) UIButton *btnn;



@end

@implementation ViewController

- (void)viewDidLoad
{
      [super viewDidLoad];
//       1.添加子控件
    // left
    UIView *left = [[UIView alloc] initWithFrame:self.view.bounds];
    left.backgroundColor = [UIColor greenColor];
    [self.view addSubview:left];
    _leftView = left;
    // right
    UIView *right = [[UIView alloc] initWithFrame:self.view.bounds];
    right.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:right];
    _rightView = right;
    // main
    UIView *main = [[UIView alloc] initWithFrame:self.view.bounds];
    main.backgroundColor = [UIColor grayColor];
    [self.view addSubview:main];
    _mainView = main;
    
    CGFloat w = main.frame.size.width/3 - 20;
    UIButton *btn = [[UIButton alloc] init];
    btn.bounds = CGRectMake(0, 0, 50, 50);
//    btn.center = main.center;
    btn.center = CGPointMake(main.frame.size.width/2, main.frame.size.height-30);
    [btn setImage:[UIImage imageNamed:imageiocn] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.frame.size.height/2;
    [main addSubview:btn];
    _btnn = btn;
   
//       KVO监听_mainView的frame改变
//         KVO只能监听一个对象的属性
//         self 观察者
//         KeyPath:监听的属性
//         options:监听新值
            [_mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
  [_mainView removeObserver:self forKeyPath:@"frame"];
}

// 只要一有新值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (_mainView.frame.origin.x > 0) { // 显示左边，隐藏右边
             _leftView.hidden = NO;
             _rightView.hidden = YES;
        }else if (_mainView.frame.origin.x < 0){ // 显示右边，隐藏左边
               _leftView.hidden = YES;
               _rightView.hidden = NO;
   }
     NSLog(@"%@",NSStringFromCGRect(self.btnn.frame));
    //      NSLog(@"%@",NSStringFromCGRect(_mainView.frame));
}
// 监听手指移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
      UITouch *touch = [touches anyObject];
      CGPoint curP = [touch locationInView:self.view];
      CGPoint preP = [touch previousLocationInView:self.view];

      CGFloat offsetX = curP.x - preP.x;
 
     _mainView.frame = [self frameWithOffsetX:offsetX];
 
      _isDraging = YES;
}

#define HMMaxOffsetY 60

// 根据offsetX 算出当前main的frame
- (CGRect)frameWithOffsetX:(CGFloat)offsetX
{
    
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetY = offsetX * HMMaxOffsetY / screenW;
    CGFloat scale = (screenH - 2 * offsetY) / screenH;
 if (_mainView.frame.origin.x < 0) {
          scale = (screenH + 2 * offsetY) / screenH;
            }
 
         CGRect frame = _mainView.frame;
         frame.size.height = frame.size.height * scale;
         frame.size.width = frame.size.width * scale;
         frame.origin.x += offsetX;
        frame.origin.y = (screenH - frame.size.height) * 0.5;
 
       return frame;
}

#define HMRigthX 250
#define HMLeftX -220
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (_isDraging == NO && _mainView.frame.origin.x != 0) {
       [UIView animateWithDuration:0.25 animations:^{
 
          _mainView.frame = self.view.bounds;
                }];
           }
 
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
         CGFloat targetX = 0;
 
 if (_mainView.frame.origin.x > screenW * 0.5) { // 移动到右边
          targetX = HMRigthX;
          }else if (CGRectGetMaxX(_mainView.frame) < screenW * 0.5){
               // 移动到左边
          targetX = HMLeftX;
            }
       CGFloat offsetX = targetX - _mainView.frame.origin.x;
      [UIView animateWithDuration:0.25 animations:^{
 
  if (targetX) {
        _mainView.frame = [self frameWithOffsetX:offsetX];
        }else{
     _mainView.frame = self.view.bounds;
      }
  }];
     _isDraging = NO;
}


@end
