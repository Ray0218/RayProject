//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by Ray on 15/6/26.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface ViewController (){

    UITextField *_nameLabel ;
    UITextField *_passWord ;
    
    UIButton *_singIn ;
}

@property(nonatomic,strong)UIButton* logOut ;
@property(nonatomic,strong)UILabel* textLabel  ;


@end

@implementation ViewController

-(void)commion{

    _nameLabel = [[UITextField alloc]initWithFrame:CGRectMake(20, 40, 120, 30) ];
    _nameLabel.placeholder = @"用户名" ;
    _nameLabel.backgroundColor = [UIColor grayColor] ;
    [self.view addSubview:_nameLabel];
    
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 120, 30) ];
    _passWord.placeholder = @"密码" ;
    _passWord.backgroundColor = [UIColor grayColor] ;
    [self.view addSubview:_passWord];
    
    _singIn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [_singIn setTitle:@"SingIn" forState:UIControlStateNormal];
    _singIn.backgroundColor = [UIColor grayColor] ;
    _singIn.frame = CGRectMake(60, 150, 200, 25) ;
    [self.view addSubview:_singIn];
    
    
    [self.view addSubview:self.logOut];
    
    [self.view addSubview:self.textLabel];

    
    
}

#pragma mark-RACCommand

-(void)testRAccomand{

    RACSignal *formValid = [RACSignal
                            combineLatest:@[
                                            _nameLabel.rac_textSignal,
                                            _passWord.rac_textSignal,
                                            ]
                            reduce:^(NSString *userName, NSString *email) {
                                return @(userName.length > 0
                                && email.length > 0);
                            }];
    

    
    //    [RACCommand commandWithCanExecuteSignal:formValid];
//    RACSignal *networkResults = [[[createAccountCommand
//                                   addSignalBlock:^RACSignal *(id value) {
//                                       //... 网络交互代码
//                                   }]
//                                  switchToLatest]
//                                 deliverOn:[RACScheduler mainThreadScheduler]];
//    
//    // 绑定创建按钮的 UI state 和点击事件
//    [[self.createButton rac_signalForControlEvents:UIControlEventTouchUpInside] executeCommand:createAccountCommand];
//    

}

-(void)signWithName:(NSString *)name passWord:(NSString*)pass complete:(void (^)(BOOL isComplete))compeete{

    if ([name isEqualToString:@"ray"] && pass.length>3) {
        if (compeete) {
            compeete(YES) ;
        }
    }

}
#pragma mark -RACStream
/**
 *  Streams 表现为RACStream类，可以看做是水管里面流动的一系列玻璃球，它们有顺序的依次通过，在第一个玻璃球没有到达之前，你没法获得第二个玻璃球。
 RACStream描述的就是这种线性流动玻璃球的形态，比较抽象，它本身的使用意义并不很大，一般会以signals或者sequences等这些更高层次的表现形态代替。

 *
  */

#pragma mark- RACSignal
/**
 *
 
 Signals 表现为RACSignal类，就是前面提到水龙头，ReactiveCocoa的核心概念就是Signal，它一般表示未来要到达的值，想象玻璃球一个个从水龙头里出来，只有了接收方（subscriber）才能获取到这些玻璃球（value）。
 
 Signal会发送下面三种事件给它的接受方（subscriber)，想象成水龙头有个指示灯来汇报它的工作状态，接受方通过-subscribeNext:error:completed:对不同事件作出相应反应
 
 next 从水龙头里流出的新玻璃球（value）
 error 获取新的玻璃球发生了错误，一般要发送一个NSError对象，表明哪里错了
 completed 全部玻璃球已经顺利抵达，没有更多的玻璃球加入了
 一个生命周期的Signal可以发送任意多个“next”事件，和一个“error”或者“completed”事件（当然“error”和“completed”只可能出现一种）
 */
#pragma mark- 注入效果 -doNext: -doError: -doCompleted:

-(void)testDoNext {
 NSLog(@"============doNext==============") ;
    __block unsigned subscriptions = 0;
    
    RACSignal *loggingSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        subscriptions++ ;
        [subscriber sendCompleted];
        return nil ;
    }] ;
    
    
    // 不会输出任何东西,需要下面的方法才会有输出
    loggingSignal = [loggingSignal doCompleted:^{
        NSLog(@"about to complete subscription %u", subscriptions);
    }] ;
    
    
    // 输出:
    // about to complete subscription 1
    // subscription 1
    [loggingSignal subscribeCompleted:^{
        NSLog(@"subscription %u", subscriptions);
    }];
    

}

#pragma mark - RACSequence
/**
 *  Sequences
 
 sequence 表现为RACSequence类，可以简单看做是RAC世界的NSArray，RAC增加了-rac_sequence方法，可以使诸如NSArray这些集合类（collection classes）直接转换为RACSequence来使用。
 */
#pragma mark- -map: 映射，可以看做对玻璃球的变换、重新组装

-(void)testMap{

    NSLog(@"============filter==============") ;
    RACSequence *letters = [[@"A B C D E F G H I" componentsSeparatedByString:@" "]rac_sequence] ;
    // Contains: AA BB CC DD EE FF GG HH II

    RACSequence *mapped = [letters map:^id(id value) {
        return [value stringByAppendingString:value] ;
    }] ;

}

#pragma mark- -filter: 过滤，不符合要求的玻璃球不允许通过
-(void)testFiltering {
    
NSLog(@"============filter==============") ;
    RACSequence *letters = [[@"1 2 3 4 5 6  7 8 9" componentsSeparatedByString:@" "]rac_sequence] ;
    
    // Contains: 2 4 6 8
     RACSequence *filtered = [letters filter:^BOOL(NSString* value) {
        return (value.intValue %2) == 0 ;
    }] ;
    
    [[ _nameLabel.rac_textSignal takeUntilBlock:^BOOL(id x) {
        return [x isEqualToString:@"Begin"] ; //对于每个next值，运行block，当block返回YES时停止取值
    }] subscribeNext:^(id x) {
        NSLog(@"current value is not'Begin' :%@ ",x) ;
    }] ;
    

    
    
 [[_nameLabel.rac_textSignal ignore:@"rr"]subscribeNext:^(id x) {
     NSLog(@"'rr' could never appear :%@",x) ;
 }];
    
    [[_passWord.rac_textSignal filter:^BOOL(NSString* value) {
        return [value hasPrefix:@"11"] ;
    }] subscribeNext:^(id x) {
        NSLog(@"This value has prefix '11':%@",x) ;
    }];
    
    
    
    
    
    //从开始一共取N次的next值，不包括Competion和Error
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];

        [subscriber sendNext:@"3"];

        [subscriber sendNext:@"4"];

        [subscriber sendNext:@"5"];

        [subscriber sendNext:@"6"];

        [subscriber sendCompleted];
        return nil ;
    }] take:3]  subscribeNext:^(id x) {
        NSLog(@"##########  %@",x) ;
    }] ;
    
    //    RAC(self.textLabel,text) = [RACObserve(_nameLabel, text) distinctUntilChanged] ;
//     RAC(self.textLabel,text,@"收到nil时就显示我") = _passWord.rac_textSignal ;
    
    //用户输入3个字母以上才输出到label，当不足3个时显示提示
//    RAC(self.textLabel,text) = [[_nameLabel.rac_textSignal startWith:@"key is >3"]filter:^BOOL(NSString* value) {
//        return value.length >3 ;
//    }];
    
    RAC(self.textLabel,text) = [[[_nameLabel.rac_textSignal startWith:@"key is >3"]filter:^BOOL(NSString* value) {
        return value.length >3 ;
    }]map:^id(NSString* value) {
        return [value isEqualToString:@"Begin"]?@"bingo":value ;
    }];
    
 }



#pragma mark- -concat: 把一个水管拼接到另一个水管之后
-(void)testCconcat  {
    NSLog(@"============concat==============") ;
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;

    // Contains: A B C D E F G H I 1 2 3 4 5 6 7 8 9
    RACSequence *concatenated = [letters concat:numbers] ;

}

#pragma mark- RACSubject
/**
 *  Subjects
 
 subjects 表现为RACSubject类，可以认为是“可变的（mutable）”信号/自定义信号，它是嫁接非RAC代码到Signals世界的桥梁，很有用。嗯。。。 这样讲还是很抽象，举个例子吧：
 
 RACSubject *letters = [RACSubject subject];
 RACSignal *signal = [letters sendNext:@"a"];
 可以看到@"a"只是一个NSString对象，要想在水管里顺利流动，就要借RACSubject的力。
 *
 */


#pragma mark - Flattening
-(void)testFlattening{
NSLog(@"============Flattening==============") ;
//    Sequences are concatenated
    
//    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
//    RACSequence *sequenceOfSequences = @[ letters, numbers ].rac_sequence;
//    
//    // Contains: A B C D E F G H I 1 2 3 4 5 6 7 8 9
//    RACSequence *flattened = [sequenceOfSequences flatten];
    
    RACSubject *letters = [RACSubject subject] ;
    RACSubject *numbers = [RACSubject subject] ;
    RACSignal *signaleOfSignls = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:letters];
        [subscriber sendNext:numbers];
        [subscriber sendCompleted];
        return nil;
    }] ;
    
    RACSignal * flattened = [signaleOfSignls flatten] ;
    // Outputs: A 1 B C 2
    [flattened subscribeNext:^(id x) {
        NSLog(@"%@",x) ;
    }];
    
    
    [letters sendNext:@"A"] ;
    [numbers sendNext:@"1"];
    [letters sendNext:@"B"] ;
    [numbers sendNext:@"2"];
    [letters sendNext:@"C"] ;
    [numbers sendNext:@"3"];

}

#pragma mark- -flattenMap: 先 map 再 flatten
-(void)testFlattenMap{
 NSLog(@"============flattenMap==============") ;
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    
    // Contains: 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9
    RACSequence *extened = [numbers flattenMap:^RACStream *(id value) {
        return @[value,value].rac_sequence ;
    }] ;
    
    // Contains: 1_ 3_ 5_ 7_ 9_
    RACSequence *edited = [numbers flattenMap:^RACStream *(NSString* value) {
        if (value.intValue %2 == 0) {
            return [RACSequence empty] ;
        }else
        {
            NSString *newNum = [value stringByAppendingString:@"_"] ;
            return [RACSequence return:newNum] ;
        }
    }];
    
    

}

#pragma mark - -switchToLatest: 取指定的那个水龙头的吐出的最新
-(void)testSwitch{

    
    NSLog(@"============switchToLatest==============") ;
    RACSubject *letters = [RACSubject subject] ;
    RACSubject *numbers = [RACSubject subject] ;
    RACSubject *signalOfSignals = [RACSubject subject] ;
    
    RACSignal *switched = [signalOfSignals switchToLatest] ;
    
    
    // Outputs: A B 1 D
    [switched subscribeNext:^(id x) {
        NSLog(@"%@",x) ;
    }] ;
    
    
    
    [signalOfSignals sendNext:letters] ;
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    
    [signalOfSignals sendNext:numbers];
    [letters sendNext:@"C"];
    [numbers sendNext:@"1"];
    
    [signalOfSignals sendNext:letters];
    [numbers sendNext:@"2"];
    [letters sendNext:@"D"];
    
    
    
}


#pragma mark- +combineLatest: 任何时刻取每个水龙头吐出的最新的那个玻璃球
-(void)testCombinLatest {
    NSLog(@"============combineLatest==============") ;

    RACSubject *letters = [RACSubject subject] ;
    RACSubject *numbers = [RACSubject subject] ;
    
    RACSignal *combined = [RACSignal combineLatest:@[letters,numbers] reduce:^id(NSString *letter,NSString *number){
        
        return [letter stringByAppendingString:number] ;
    
    }] ;
    
    // Outputs: B1 B2 C2 C3
    [combined subscribeNext:^(id x) {
        NSLog(@"%@",x) ;
    }];
    
    
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    [numbers sendNext:@"1"];
    [numbers sendNext:@"2"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"3"];
    

    
}


#pragma mark- -then:
-(void)testThen{
    NSLog(@"============then==============") ;
    
    RACSignal *signal  = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    // 新水龙头只包含: 1 2 3 4 5 6 7 8 9
    //
    // 但当有接收时，仍会执行旧水龙头doNext的内容，所以也会输出 A B C D E F G H I
    RACSignal *sequenced = [[[signal
                             doNext:^(NSString* x) {
                                  NSLog(@"%@",x) ;
                              } ]
                            
                            then:^RACSignal *{
                                 return [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal;
                             }] subscribeNext:^(id x) {
                                 NSLog(@" subscribeNext == %@",x) ;
                             }];


}

-(RACSignal*)signUnSignal{

    return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self signWithName:_nameLabel.text passWord:_passWord.text complete:^(BOOL isComplete) {
            [subscriber sendNext:@(isComplete) ];
            [subscriber sendCompleted];
        }] ;
        
        return  nil ;
    }] ;
}
#pragma mark-  NSObject+RACLifting.h 有时我们希望满足一定条件时，自动触发某个方法，有了这个category就可以这么办
- (void)testLifting
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [subscriber sendNext:@"A"];
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendNext:@"Another B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(doA:withB:) withSignals:signalA, signalB, nil];
}

- (void)doA:(NSString *)A withB:(NSString *)B
{
    NSLog(@"A:%@ and B:%@", A, B);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self commion];
    [self testDoNext];
    [self testMap];
    [self testFiltering];
    [self testCconcat];
    [self testFlattening];
    [self testFlattenMap];
    
    [self testSwitch];
    
    [self testCombinLatest];
    [self testThen];
    [self testLifting];
    
    

    
    
    
    [NSError errorWithDomain:@"" code:0 userInfo:nil] ;
//    __weak typeof(self)  weakSelf = self ;
    @weakify(self)
 
    
   RACSignal *filterUserName =[[_nameLabel.rac_textSignal map:^id(NSString* value) {
       return @(value.length) ;
   }]  filter:^BOOL(NSNumber* value) {
        return [value integerValue] < 10  && [value integerValue]>3;
    } ] ;
    
    filterUserName = [_nameLabel.rac_textSignal map:^id(id value) {
        return value ;
    }] ;
    
    //    [filterUserName subscribeNext:^(id x) {
//        NSLog(@"x === %@",x) ;
//    }];
    
    
    RACSignal *filterPassword =[_passWord.rac_textSignal map:^id(NSString* value) {
        return @(value.length) ;
    }] ;
//                                 filter:^BOOL(NSNumber* value) {
//        return [value integerValue] < 10  && [value integerValue]>3;
//                                 }];
                                
//                                subscribeNext:^(id x) {
//        NSLog(@"x === %@",x) ;
//    }];
    
    
     
    
   [[ [_singIn rac_signalForControlEvents:UIControlEventTouchUpInside]map:^id(id value) {
        return [self signUnSignal];
    } ] subscribeNext:^(id x) {
        NSLog(@" ====  %@",x) ;
    }] ;
    
    /*
    RACSignal *signSignal = [RACSignal combineLatest:@[_nameLabel.rac_textSignal,filterPassword] reduce:^id(NSString *userNameLength ,NSNumber*passWordLength ){
        return @([userNameLength isEqualToString:@"Ray"] && [passWordLength intValue]>3) ;
    }] ;
    
    [signSignal subscribeNext:^(NSNumber* x) {
        _singIn.enabled = [x boolValue] ;
    }];
    [[[_singIn rac_signalForControlEvents:UIControlEventTouchUpInside]doNext:^(id x) {
        _singIn.enabled = NO ;
    } ] subscribeNext:^(id x) {
        _singIn.enabled = YES ;
        NSLog(@"=== Button Click ====") ;
    }];

     */
    
    
    /*
    _singIn.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"按钮被点击") ;
        return [RACSignal empty] ;
        
    }];
    */
    
    RAC(_singIn,enabled) = [RACSignal combineLatest:@[_nameLabel.rac_textSignal,_passWord.rac_textSignal] reduce:^id(NSString *name ,NSString *passWord){
        return @(name.length >=6 && passWord.length>=6) ;
    }] ;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIButton*)logOut{
    if (_logOut == nil) {
        _logOut = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_logOut setTitle:@"LogOut" forState:UIControlStateNormal];
        _logOut.backgroundColor = [UIColor grayColor] ;
        _logOut.frame = CGRectMake(60, 200, 200, 25) ;
        [[_logOut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            NSLog(@"点击button！！！！") ;
        }];
    }
    
    return _logOut ;
}

-(UILabel*)textLabel{

    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.backgroundColor = [UIColor grayColor] ;
        _textLabel.frame = CGRectMake(60, 250, 200, 45) ;
        _textLabel.numberOfLines = 0 ;
    }
    
    return _textLabel ;
}


@end
