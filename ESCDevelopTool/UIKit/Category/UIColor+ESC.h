//
//  UIColor+ESC.h
//  ESCDevelopTool
//
//  Created by 程巍巍 on 12/4/14.
//	Copyright (c) 12/4/14 Littocats. All rights reserved.
//

#ifndef ESCDevelopTool_UIColor_ESC
#define ESCDevelopTool_UIColor_ESC

#import <UIKit/UIKit.h>

/**
 *  预定义的颜色值，可增加其中的内容，以扩充颜色名称
 *  格式：@颜色名#六位HEX(description) 。颜色名及HEX不区分大小写,颜色名只充许包含字母及数字
 例： red#FF0000(红色)
 *  库中已定义了127种颜色（1)，可以通过 registScriptColor 注册新的颜色值
 */

#ifndef UIColorWithScript
#define UIColorWithScript(script) [UIColor colorWithScript:script]
#endif

@interface UIColor (ESC)

+ (UIColor *)colorWithScript:(NSString *)script;

+ (UIColor *)randomColor;

@property (nonatomic, readonly) NSString *script;

+ (NSString *)colorDefined;

+ (void)registScriptColor:(NSString *)scripts;

@end

// 注（1）
/**
 @LightPink#FFB6C1(浅粉色)
 @Pink#FFC0CB(粉红)
 @Crimson#DC143C(猩红)
 @LavenderBlush#FFF0F5(脸红的淡紫色)
 @PaleVioletRed#DB7093(苍白的紫罗兰红色)
 @HotPink#FF69B4(热情的粉红)
 @DeepPink#FF1493(深粉色)
 @MediumVioletRed#C71585(适中的紫罗兰红色)
 @Orchid#DA70D6(兰花的紫色)
 @Thistle#D8BFD8(蓟)
 @Plum#DDA0DD(李子)
 @Violet#EE82EE(紫罗兰)
 @Magenta#FF00FF(洋红)
 @Fuchsia#FF00FF(灯笼海棠（紫红色）)
 @DarkMagenta#8B008B(深洋红色)
 @Purple#800080(紫色)
 @MediumOrchid#BA55D3(适中的兰花紫)
 @DarkVoilet#9400D3(深紫罗兰色)
 @DarkOrchid#9932CC(深兰花紫)
 @Indigo#4B0082(靛青)
 @BlueViolet#8A2BE2(深紫罗兰的蓝色)
 @MediumPurple#9370DB(适中的紫色)
 @MediumSlateBlue#7B68EE(适中的板岩暗蓝灰色)
 @SlateBlue#6A5ACD(板岩暗蓝灰色)
 @DarkSlateBlue#483D8B(深岩暗蓝灰色)
 @Lavender#E6E6FA(薰衣草花的淡紫色)
 @GhostWhite#F8F8FF(幽灵的白色)
 @MediumBlue#0000CD(适中的蓝色)
 @MidnightBlue#191970(午夜的蓝色)
 @DarkBlue#00008B(深蓝色)
 @Navy#000080(海军蓝)
 @RoyalBlue#4169E1(皇军蓝)
 @CornflowerBlue#6495ED(矢车菊的蓝色)
 @LightSteelBlue#B0C4DE(淡钢蓝)
 @LightSlateGray#778899(浅石板灰)
 @SlateGray#708090(石板灰)
 @DoderBlue#1E90FF(道奇蓝)
 @AliceBlue#F0F8FF(爱丽丝蓝)
 @SteelBlue#4682B4(钢蓝)
 @LightSkyBlue#87CEFA(淡蓝色)
 @SkyBlue#87CEEB(天蓝色)
 @DeepSkyBlue#00BFFF(深天蓝)
 @LightBLue#ADD8E6(淡蓝)
 @PowDerBlue#B0E0E6(火药蓝)
 @CadetBlue#5F9EA0(军校蓝)
 @Azure#F0FFFF(蔚蓝色)
 @LightCyan#E1FFFF(淡青色)
 @PaleTurquoise#AFEEEE(苍白的绿宝石)
 @Cyan#00FFFF(青色)
 @Aqua#00FFFF(水绿色)
 @DarkTurquoise#00CED1(深绿宝石)
 @DarkSlateGray#2F4F4F(深石板灰)
 @DarkCyan#008B8B(深青色)
 @Teal#008080(水鸭色)
 @MediumTurquoise#48D1CC(适中的绿宝石)
 @LightSeaGreen#20B2AA(浅海洋绿)
 @Turquoise#40E0D0(绿宝石)
 @Auqamarin#7FFFAA(绿玉\碧绿色)
 @MediumAquamarine#00FA9A(适中的碧绿色)
 @MediumSpringGreen#F5FFFA(适中的春天的绿色)
 @MintCream#00FF7F(薄荷奶油)
 @SpringGreen#3CB371(春天的绿色)
 @SeaGreen#2E8B57(海洋绿)
 @Honeydew#F0FFF0(蜂蜜)
 @LightGreen#90EE90(淡绿色)
 @PaleGreen#98FB98(苍白的绿色)
 @DarkSeaGreen#8FBC8F(深海洋绿)
 @LimeGreen#32CD32(酸橙绿)
 @Lime#00FF00(酸橙色)
 @ForestGreen#228B22(森林绿)
 @DarkGreen#006400(深绿色)
 @Chartreuse#7FFF00(查特酒绿)
 @LawnGreen#7CFC00(草坪绿)
 @GreenYellow#ADFF2F(绿黄色)
 @OliveDrab#556B2F(橄榄土褐色)
 @Beige#6B8E23(米色（浅褐色）)
 @LightGoldenrodYellow#FAFAD2(浅秋麒麟黄)
 @Ivory#FFFFF0(象牙色)
 @LightYellow#FFFFE0(浅黄色)
 @Olive#808000(橄榄)
 @DarkKhaki#BDB76B(深卡其布)
 @LemonChiffon#FFFACD(柠檬薄纱)
 @PaleGodenrod#EEE8AA(灰秋麒麟)
 @Khaki#F0E68C(卡其布)
 @Gold#FFD700(金)
 @Cornislk#FFF8DC(玉米色)
 @GoldEnrod#DAA520(秋麒麟)
 @FloralWhite#FFFAF0(花的白色)
 @OldLace#FDF5E6(老饰带)
 @Wheat#F5DEB3(小麦色)
 @Moccasin#FFE4B5(鹿皮鞋)
 @Orange#FFA500(橙色)
 @PapayaWhip#FFEFD5(番木瓜)
 @BlanchedAlmond#FFEBCD(漂白的杏仁)
 @NavajoWhite#FFDEAD(Navajo白)
 @AntiqueWhite#FAEBD7(古代的白色)
 @Tan#D2B48C(晒黑)
 @BrulyWood#DEB887(结实的树)
 @Bisque#FFE4C4(（浓汤）乳脂，番茄等)
 @DarkOrange#FF8C00(深橙色)
 @Linen#FAF0E6(亚麻布)
 @Peru#CD853F(秘鲁)
 @PeachPuff#FFDAB9(桃色)
 @SandyBrown#F4A460(沙棕色)
 @Chocolate#D2691E(巧克力)
 @SaddleBrown#8B4513(马鞍棕色)
 @SeaShell#FFF5EE(海贝壳)
 @Sienna#A0522D(黄土赭色)
 @LightSalmon#FFA07A(浅鲜肉（鲑鱼）色)
 @Coral#FF7F50(珊瑚)
 @OrangeRed#FF4500(橙红色)
 @DarkSalmon#E9967A(深鲜肉（鲑鱼）色)
 @Tomato#FF6347(番茄)
 @MistyRose#FFE4E1(薄雾玫瑰)
 @Salmon#FA8072(鲜肉（鲑鱼）色)
 @Snow#FFFAFA(雪)
 @LightCoral#F08080(淡珊瑚色)
 @RosyBrown#BC8F8F(玫瑰棕色)
 @IndianRed#CD5C5C(印度红)
 @Brown#A52A2A(棕色)
 @FireBrick#B22222(耐火砖)
 @DarkRed#8B0000(深红色)
 @Maroon#800000(栗色)
 @WhiteSmoke#F5F5F5(白烟)
 @Gainsboro#DCDCDC(Gainsboro)
 @Silver#C0C0C0(银白色)
 @DimGray#696969(暗淡的灰色)
 */


#endif