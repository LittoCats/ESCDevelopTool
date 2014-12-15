//
//  UIColor+ESC.m
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/4/14.
//	Copyright (c) 12/4/14 Littocats. All rights reserved.
//

#import "UIColor+ESC.h"

static NSString *kESCSDEFAULTCRIPTCOLORDEFINE = @"@LIGHTPINK#FFB6C1(浅粉色)-@PINK#FFC0CB(粉红)-@CRIMSON#DC143C(猩红)-@LAVENDERBLUSH#FFF0F5(脸红的淡紫色)-@PALEVIOLETRED#DB7093(苍白的紫罗兰红色)-@HOTPINK#FF69B4(热情的粉红)-@DEEPPINK#FF1493(深粉色)-@MEDIUMVIOLETRED#C71585(适中的紫罗兰红色)-@ORCHID#DA70D6(兰花的紫色)-@THISTLE#D8BFD8(蓟)-@PLUM#DDA0DD(李子)-@VIOLET#EE82EE(紫罗兰)-@MAGENTA#FF00FF(洋红)-@FUCHSIA#FF00FF(灯笼海棠（紫红色）)-@DARKMAGENTA#8B008B(深洋红色)-@PURPLE#800080(紫色)-@MEDIUMORCHID#BA55D3(适中的兰花紫)-@DARKVOILET#9400D3(深紫罗兰色)-@DARKORCHID#9932CC(深兰花紫)-@INDIGO#4B0082(靛青)-@BLUEVIOLET#8A2BE2(深紫罗兰的蓝色)-@MEDIUMPURPLE#9370DB(适中的紫色)-@MEDIUMSLATEBLUE#7B68EE(适中的板岩暗蓝灰色)-@SLATEBLUE#6A5ACD(板岩暗蓝灰色)-@DARKSLATEBLUE#483D8B(深岩暗蓝灰色)-@LAVENDER#E6E6FA(薰衣草花的淡紫色)-@GHOSTWHITE#F8F8FF(幽灵的白色)-@MEDIUMBLUE#0000CD(适中的蓝色)-@MIDNIGHTBLUE#191970(午夜的蓝色)-@DARKBLUE#00008B(深蓝色)-@NAVY#000080(海军蓝)-@ROYALBLUE#4169E1(皇军蓝)-@CORNFLOWERBLUE#6495ED(矢车菊的蓝色)-@LIGHTSTEELBLUE#B0C4DE(淡钢蓝)-@LIGHTSLATEGRAY#778899(浅石板灰)-@SLATEGRAY#708090(石板灰)-@DODERBLUE#1E90FF(道奇蓝)-@ALICEBLUE#F0F8FF(爱丽丝蓝)-@STEELBLUE#4682B4(钢蓝)-@LIGHTSKYBLUE#87CEFA(淡蓝色)-@SKYBLUE#87CEEB(天蓝色)-@DEEPSKYBLUE#00BFFF(深天蓝)-@LIGHTBLUE#ADD8E6(淡蓝)-@POWDERBLUE#B0E0E6(火药蓝)-@CADETBLUE#5F9EA0(军校蓝)-@AZURE#F0FFFF(蔚蓝色)-@LIGHTCYAN#E1FFFF(淡青色)-@PALETURQUOISE#AFEEEE(苍白的绿宝石)-@CYAN#00FFFF(青色)-@AQUA#00FFFF(水绿色)-@DARKTURQUOISE#00CED1(深绿宝石)-@DARKSLATEGRAY#2F4F4F(深石板灰)-@DARKCYAN#008B8B(深青色)-@TEAL#008080(水鸭色)-@MEDIUMTURQUOISE#48D1CC(适中的绿宝石)-@LIGHTSEAGREEN#20B2AA(浅海洋绿)-@TURQUOISE#40E0D0(绿宝石)-@AUQAMARIN#7FFFAA(绿玉/碧绿色)-@MEDIUMAQUAMARINE#00FA9A(适中的碧绿色)-@MEDIUMSPRINGGREEN#F5FFFA(适中的春天的绿色)-@MINTCREAM#00FF7F(薄荷奶油)-@SPRINGGREEN#3CB371(春天的绿色)-@SEAGREEN#2E8B57(海洋绿)-@HONEYDEW#F0FFF0(蜂蜜)-@LIGHTGREEN#90EE90(淡绿色)-@PALEGREEN#98FB98(苍白的绿色)-@DARKSEAGREEN#8FBC8F(深海洋绿)-@LIMEGREEN#32CD32(酸橙绿)-@LIME#00FF00(酸橙色)-@FORESTGREEN#228B22(森林绿)-@DARKGREEN#006400(深绿色)-@CHARTREUSE#7FFF00(查特酒绿)-@LAWNGREEN#7CFC00(草坪绿)-@GREENYELLOW#ADFF2F(绿黄色)-@OLIVEDRAB#556B2F(橄榄土褐色)-@BEIGE#6B8E23(米色（浅褐色）)-@LIGHTGOLDENRODYELLOW#FAFAD2(浅秋麒麟黄)-@IVORY#FFFFF0(象牙色)-@LIGHTYELLOW#FFFFE0(浅黄色)-@OLIVE#808000(橄榄)-@DARKKHAKI#BDB76B(深卡其布)-@LEMONCHIFFON#FFFACD(柠檬薄纱)-@PALEGODENROD#EEE8AA(灰秋麒麟)-@KHAKI#F0E68C(卡其布)-@GOLD#FFD700(金)-@CORNISLK#FFF8DC(玉米色)-@GOLDENROD#DAA520(秋麒麟)-@FLORALWHITE#FFFAF0(花的白色)-@OLDLACE#FDF5E6(老饰带)-@WHEAT#F5DEB3(小麦色)-@MOCCASIN#FFE4B5(鹿皮鞋)-@ORANGE#FFA500(橙色)-@PAPAYAWHIP#FFEFD5(番木瓜)-@BLANCHEDALMOND#FFEBCD(漂白的杏仁)-@NAVAJOWHITE#FFDEAD(NAVAJO白)-@ANTIQUEWHITE#FAEBD7(古代的白色)-@TAN#D2B48C(晒黑)-@BRULYWOOD#DEB887(结实的树)-@BISQUE#FFE4C4(（浓汤）乳脂，番茄等)-@DARKORANGE#FF8C00(深橙色)-@LINEN#FAF0E6(亚麻布)-@PERU#CD853F(秘鲁)-@PEACHPUFF#FFDAB9(桃色)-@SANDYBROWN#F4A460(沙棕色)-@CHOCOLATE#D2691E(巧克力)-@SADDLEBROWN#8B4513(马鞍棕色)-@SEASHELL#FFF5EE(海贝壳)-@SIENNA#A0522D(黄土赭色)-@LIGHTSALMON#FFA07A(浅鲜肉（鲑鱼）色)-@CORAL#FF7F50(珊瑚)-@ORANGERED#FF4500(橙红色)-@DARKSALMON#E9967A(深鲜肉（鲑鱼）色)-@TOMATO#FF6347(番茄)-@MISTYROSE#FFE4E1(薄雾玫瑰)-@SALMON#FA8072(鲜肉（鲑鱼）色)-@SNOW#FFFAFA(雪)-@LIGHTCORAL#F08080(淡珊瑚色)-@ROSYBROWN#BC8F8F(玫瑰棕色)-@INDIANRED#CD5C5C(印度红)-@BROWN#A52A2A(棕色)-@FIREBRICK#B22222(耐火砖)-@DARKRED#8B0000(深红色)-@MAROON#800000(栗色)-@WHITESMOKE#F5F5F5(白烟)-@GAINSBORO#DCDCDC(GAINSBORO)-@SILVER#C0C0C0(银白色)-@DIMGRAY#696969(暗淡的灰色)";

static NSMutableString *kESCCUSTOMSCRIPTCOLORDEFINED;

@implementation UIColor (ESC)

+ (UIColor *)colorWithScript:(NSString *)script
{
    if ([script hasPrefix:@"#"]) {
        return [self __ColorWithHexString:script];
    }else{
        return [self __ColorNamed:script];
    }
}

+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
}

- (NSString *)script
{
    return nil;
}

+ (NSString *)colorDefined
{
    return [NSString stringWithFormat:@"%@",kESCSDEFAULTCRIPTCOLORDEFINE];
}

+ (void)registScriptColor:(NSString *)scripts
{
    if (!scripts || ![scripts isKindOfClass:NSString.class] || !scripts.length) return;
    
    @synchronized(kESCSDEFAULTCRIPTCOLORDEFINE){
        if (!kESCCUSTOMSCRIPTCOLORDEFINED) kESCCUSTOMSCRIPTCOLORDEFINED = [NSMutableString new];
        [kESCCUSTOMSCRIPTCOLORDEFINED appendFormat:@"-%@",scripts];
    }
}

#pragma mark- private mathod
+ (UIColor *)__ColorWithHexString:(NSString *)hexString
{
    const char *src = [[hexString substringFromIndex:1] UTF8String];
    char *hex = malloc(sizeof(char)*9);
    memset(hex, 'F', sizeof(char)*9);
    hex[8] = '\0';
    
    if (hexString.length < 6) {
        for (int i = 0; i < strlen(src); i ++) {
            hex[i*2] = src[i];
            hex[i*2+1] = src[i];
        }
    }else{
        for (int i = 0; i < strlen(src); i ++) {
            hex[i] = src[i];
        }
    }
    
    char *p;
    NSInteger hexValue = strtoul(hex, &p, 16);
    NSInteger red,green,blue,alpha;
    alpha   = (hexValue & 0x000000ff) >> 0;
    blue    = (hexValue & 0x0000ff00) >> 8;
    green   = (hexValue & 0x00ff0000) >> 16;
    red     = (hexValue & 0xff000000) >> 24;
    
    free(hex);
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

+ (UIColor *)__ColorNamed:(NSString *)colorName
{
    static NSCache *colorCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorCache = [[NSCache alloc] init];
        colorCache.name = @"__ESC_Script_Color_Defined";
    });

    UIColor *color = [colorCache objectForKey:colorName];
    if (!color) {
        NSString *hex = [self __ColorHEXWithName:colorName lib:kESCCUSTOMSCRIPTCOLORDEFINED];
        if (!hex) hex = [self __ColorHEXWithName:colorName lib:kESCSDEFAULTCRIPTCOLORDEFINE];
        
        if (hex) {
            color = [self __ColorWithHexString:hex];
            [colorCache setObject:color forKey:colorName];
        }else
            color = [self randomColor];
    }
    return color;
}

+ (NSString *)__ColorHEXWithName:(NSString *)name lib:(NSString *)lib
{
    NSRange hexRange = [lib rangeOfString:[NSString stringWithFormat:@"@%@",[name uppercaseString]]];
    if (hexRange.location == NSNotFound) {
        return nil;
    }else{
        hexRange.location += hexRange.length;
        hexRange.length = 7;
        NSString *hex = [lib substringWithRange:hexRange];
        return hex;
    }
}
@end
