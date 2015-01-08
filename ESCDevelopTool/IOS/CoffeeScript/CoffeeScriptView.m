//
//  CoffeeScriptView.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 1/8/15.
//
//

#import "CoffeeScriptView.h"

@interface CoffeeScriptView ()<UITextViewDelegate>


@property (nonatomic, strong) UITextView *editorView;

@property (nonatomic, strong) UIScrollView *eScro;

@property (nonatomic, strong) UILabel *outputLael;

@property (nonatomic, strong) UIScrollView *oScro;

@end

@implementation CoffeeScriptView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.editorView = [[UITextView alloc] init];
        _editorView.backgroundColor = [UIColor whiteColor];
        _editorView.textColor = [UIColor blackColor];
        _editorView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _editorView.delegate = self;
        _editorView.font = [UIFont systemFontOfSize:15];
        
        self.outputLael = [[UILabel alloc] init];
        _outputLael.backgroundColor = [UIColor blackColor];
        _outputLael.textColor = [UIColor whiteColor];
        _outputLael.numberOfLines = 0;
        _outputLael.font = _editorView.font;
        
        self.eScro = [[UIScrollView alloc] init];
        self.oScro = [[UIScrollView alloc] init];
        _oScro.backgroundColor = [UIColor blackColor];
        
        [_eScro addSubview:_editorView];
        [_oScro addSubview:_outputLael];
        
        [self addSubview:_eScro];
        [self addSubview:_oScro];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    BOOL ver = frame.size.width <= frame.size.height;
    
    if (ver) {
        _eScro.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/3*2);
        _oScro.frame = CGRectMake(0, frame.size.height/3*2 + 10, frame.size.width, frame.size.height/3-10);
    }else{
        _oScro.frame = CGRectMake(0, 0, frame.size.width/3, frame.size.height);
        _eScro.frame = CGRectMake(frame.size.width/3+10, 0, frame.size.width/3*2-10, frame.size.height);
    }
    CGRect rect = _editorView.frame;
    if (rect.size.width < _eScro.frame.size.width) rect.size.width = _eScro.frame.size.width;
    if (rect.size.height < _eScro.frame.size.height) rect.size.height = _eScro.frame.size.height;
    _editorView.frame = rect;
    _eScro.contentSize = rect.size;
    rect = _outputLael.frame;
    if (rect.size.width < _oScro.frame.size.width) rect.size.width = _oScro.frame.size.width;
    _outputLael.frame = rect;
    _oScro.contentSize = rect.size;
    
    CGRect cursorPosition = [_editorView caretRectForPosition:_editorView.selectedTextRange.start];
    [_eScro scrollRectToVisible:cursorPosition animated:NO];
}

- (NSString *)coffee
{
    return self.editorView.text;
}
- (void)output:(NSString *)output
{
    _outputLael.text = output;
    CGSize size = [output sizeWithAttributes:@{NSFontAttributeName:_outputLael.font}];
    CGRect rect = _outputLael.frame;
    rect.size.width = MAX(rect.size.width, size.width+20);
    rect.size.height = MAX(rect.size.height, size.height+20);
    _outputLael.frame = rect;
    _oScro.contentSize = rect.size;
}

- (void)clear
{
    [self output:nil];
    _editorView.text = nil;
    _editorView.frame = (CGRect){0.0,0.0,_eScro.frame.size};
}
#pragma mark- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    CGRect rect = textView.frame;
    rect.size = _eScro.frame.size;
    rect.size.width = MAX(rect.size.width, size.width+20);
    rect.size.height = MAX(rect.size.height, size.height+20);
    textView.frame = rect;
    _eScro.contentSize = rect.size;
    
    CGRect cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start];
    [_eScro scrollRectToVisible:cursorPosition animated:NO];
}
@end
