//
//  ViewController.m
//  线程
//
//  Created by Ray on 15/6/8.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多线程测试" ;
    // Do any additional setup after loading the view, typically from a nib.
    [self testbarrier_async];
}

#pragma mark- 第一个是实例方法，第二个是类方法
//1、[NSThread detachNewThreadSelector:@selector(doSomething:) toTarget:self withObject:nil];
//
//2、NSThread* myThread = [[NSThread alloc] initWithTarget:self
//                                               selector:@selector(doSomething:)
//                                                 object:nil];
//[myThread start];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- dispatch_semaphore 信号量基于计数器的一种多线程同步机制。在多个线程访问共有资源时候，会因为多线程的特性而引发数据出错的问题。

-(void)testdispatch_semaphore_t {

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int index = 0; index < 100000; index++) {
        
        dispatch_async(queue, ^(){
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//
            
            NSLog(@"addd :%d", index);
            
            [array addObject:[NSNumber numberWithInt:index]];
            
            dispatch_semaphore_signal(semaphore);
            
        });
        
    }

}

#pragma mark- dispathc_apply 是dispatch_sync 和dispatch_group的关联API.它以指定的次数将指定的Block加入到指定的队列中。并等待队列中操作全部完成.
-(void)testdispatch_apply {

    NSArray *array = [NSArray arrayWithObjects:@"/Users/chentao/Desktop/copy_res/gelato.ds",
                      @"/Users/chentao/Desktop/copy_res/jason.ds",
                      @"/Users/chentao/Desktop/copy_res/jikejunyi.ds",
                      @"/Users/chentao/Desktop/copy_res/molly.ds",
                      @"/Users/chentao/Desktop/copy_res/zhangdachuan.ds",
                      nil];
    NSString *copyDes = @"/Users/chentao/Desktop/copy_des";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
        dispatch_apply([array count], dispatch_get_global_queue(0, 0), ^(size_t index){ //dispatch_get_global_queue是并行队列
            NSLog(@"copy-%ld", index);
            NSString *sourcePath = [array objectAtIndex:index];
            NSString *desPath = [NSString stringWithFormat:@"%@/%@", copyDes, [sourcePath lastPathComponent]];
            [fileManager copyItemAtPath:sourcePath toPath:desPath error:nil];
        });
        NSLog(@"done");
    });

}


#pragma mark-  dispatch_sync(),同步添加操作。他是等待添加进队列里面的操作完成之后再继续执行。

-(void)textdispatch_sync {

    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT) ;
    NSLog(@"开始") ;
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"结束") ;
        [NSThread sleepForTimeInterval:3] ;
        NSLog(@"结束2") ;
    }) ;
    NSLog(@"结束3") ;
    
}
#pragma mark-  dispatch_async ,异步添加进任务队列，它不会做任何等待

-(void)testdispatch_async {

    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT) ;
    NSLog(@"开始") ;
    dispatch_async(concurrentQueue, ^{
        NSLog(@"结束") ;
        [NSThread sleepForTimeInterval:3] ;
        NSLog(@"结束2") ;
    }) ;
    NSLog(@"结束3") ;
}

#pragma mark - dispatch_group_async 如果想在dispatch_queue中所有的任务执行完成后在做某种操作，在串行队列中，可以把该操作放到最后一个任务执行完成后继续，但是在并行队列中怎么做呢。这就有dispatch_group 成组操作。
-(void)testgroup_async {

    dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        NSLog(@"dispatch_group-1");
    });
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        NSLog(@"dispatch_group-2");
    });
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"dispatch_group_end");
    });
}

#pragma mark-  dispatch_barrier_async
//dispatch_barrier_async 作用是在并行队列中，等待前面两个操作并行操作完成，这里是并行输出
//dispatch-1，dispatch-2
//然后执行
//dispatch_barrier_async中的操作，(现在就只会执行这一个操作)执行完成后，即输出
//"dispatch-barrier，
//最后该并行队列恢复原有执行状态，继续并行执行
//dispatch-3,dispatch-4

-(void)testbarrier_async {


    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-1");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-2");
    });
    dispatch_barrier_async(concurrentQueue, ^(){
        NSLog(@"dispatch-barrier");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-3");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-4");
    });
}


@end
