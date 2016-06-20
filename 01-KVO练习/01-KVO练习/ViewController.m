//
//  ViewController.m
//  01-KVO练习
//
//  Created by qingyun on 16/6/3.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ViewController.h"
#import "QYmode.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *volumeView;
@property (weak, nonatomic) IBOutlet UILabel *volumeLab;
@property (strong,nonatomic) QYmode *mode;
@property (strong,nonatomic) NSArray *colorArr;

@property(assign,nonatomic)CGFloat maxY;

@end

@implementation ViewController


-(void)swipeGetsure:(UISwipeGestureRecognizer *)Gestrue{
    


     if (Gestrue.direction==UISwipeGestureRecognizerDirectionUp) {
         //加血操作
         if (_mode.volume!=400) {
             //更改属性值,触发KVO监听
             _mode.volume+=100;
         }else{
             UIAlertController *alterController=[UIAlertController alertControllerWithTitle:@"提示" message:@"血量已满" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
             [alterController addAction:action];
             [self presentViewController:alterController animated:YES completion:nil];
         }
        
     }else if(Gestrue.direction==UISwipeGestureRecognizerDirectionDown){
        //减血操作
         if(_mode.volume!=100){
           //更改属性值,触发kvo监听
             _mode.volume-=100;
         }else{
         
             UIAlertController *alterController=[UIAlertController alertControllerWithTitle:@"警告" message:@"血量过低" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
             [alterController addAction:action];
             [self presentViewController:alterController animated:YES completion:nil];
         }
     
     }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    _colorArr=@[[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor blueColor]];

    self.volumeLab.text = @"血量：400";
    //1.添加手势
    UISwipeGestureRecognizer *swipUp=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGetsure:)];
    swipUp.direction=UISwipeGestureRecognizerDirectionUp;
    [_volumeView addGestureRecognizer:swipUp];
    
    UISwipeGestureRecognizer *swipDown=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGetsure:)];
    swipDown.direction=UISwipeGestureRecognizerDirectionDown;
    [_volumeView addGestureRecognizer:swipDown];
    
    
    _volumeView.backgroundColor=[_colorArr lastObject];
    //2.添加KVO
    _mode=[[QYmode alloc] init];
    _mode.volume=400;
    [_mode addObserver:self forKeyPath:@"volume" options:NSKeyValueObservingOptionNew context:NULL];
    
    _maxY=CGRectGetMaxY(_volumeView.frame);
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - kvo 监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"volume"]){
      //1取值操作
        float volume=[change[@"new"] floatValue];
      //2.更新UI
        CGRect rect=self.volumeView.frame;
        rect.size.height=volume;
        rect.origin.y=_maxY-volume;
        self.volumeView.frame=rect;
        self.volumeView.backgroundColor=_colorArr[((int)volume/100-1)];
        
        _volumeLab.text=[NSString stringWithFormat:@"血量:%g",volume];
        
        
    }
}


-(void)dealloc{
    [_mode removeObserver:self forKeyPath:@"volume"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
