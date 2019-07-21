//
//  Linstener.m
//  Saily.Daemon
//
//  Created by Lakr Aream on 2019/7/21.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import "Linstener.h"

NSString *read_rdi = @"";

static void read_begin() {
    NSLog(@"[*] 开始新的数据拼接 session");
    read_rdi = @"";
}

static void read_end() {
    NSLog(@"[*] 数据接受完成，内容为: %@", read_rdi);
    if ([read_rdi hasPrefix:@"init:path:"]) {
        setAppPath([read_rdi substringFromIndex:10]);
    }
}

static void read_space() {
    read_rdi = [read_rdi stringByAppendingString:@" "];
}

static void read_exclamation_mark() {
    read_rdi = [read_rdi stringByAppendingString:@"!"];
}

static void read_quto() {
    read_rdi = [read_rdi stringByAppendingString:@"\""];
}

static void read_shap() {
    read_rdi = [read_rdi stringByAppendingString:@"#"];
}

static void read_dollor() {
    read_rdi = [read_rdi stringByAppendingString:@"$"];
}

static void read_percent() {
    read_rdi = [read_rdi stringByAppendingString:@"%"];
}

static void read_and() {
    read_rdi = [read_rdi stringByAppendingString:@"&"];
}

static void read_signlequto() {
    read_rdi = [read_rdi stringByAppendingString:@"'"];
}

static void read_leftkh() {
    read_rdi = [read_rdi stringByAppendingString:@"("];
}

static void read_rightkh() {
    read_rdi = [read_rdi stringByAppendingString:@")"];
}

static void read_star() {
    read_rdi = [read_rdi stringByAppendingString:@"*"];
}

static void read_add() {
    read_rdi = [read_rdi stringByAppendingString:@"+"];
}

static void read_dotleft() {
    read_rdi = [read_rdi stringByAppendingString:@","];
}

static void read_line() {
    read_rdi = [read_rdi stringByAppendingString:@"-"];
}

static void read_dot() {
    read_rdi = [read_rdi stringByAppendingString:@"."];
}

static void read_leftsplsh() {
    read_rdi = [read_rdi stringByAppendingString:@"/"];
}

static void read_0() {
    read_rdi = [read_rdi stringByAppendingString:@"0"];
}

static void read_1() {
    read_rdi = [read_rdi stringByAppendingString:@"1"];
}

static void read_2() {
    read_rdi = [read_rdi stringByAppendingString:@"2"];
}

static void read_3() {
    read_rdi = [read_rdi stringByAppendingString:@"3"];
}

static void read_4() {
    read_rdi = [read_rdi stringByAppendingString:@"4"];
}

static void read_5() {
    read_rdi = [read_rdi stringByAppendingString:@"5"];
}

static void read_6() {
    read_rdi = [read_rdi stringByAppendingString:@"6"];
}

static void read_7() {
    read_rdi = [read_rdi stringByAppendingString:@"7"];
}

static void read_8() {
    read_rdi = [read_rdi stringByAppendingString:@"8"];
}

static void read_9() {
    read_rdi = [read_rdi stringByAppendingString:@"9"];
}

static void read_mh() {
    read_rdi = [read_rdi stringByAppendingString:@":"];
}

static void read_fh() {
    read_rdi = [read_rdi stringByAppendingString:@";"];
}

static void read_small() {
    read_rdi = [read_rdi stringByAppendingString:@"<"];
}

static void read_equal() {
    read_rdi = [read_rdi stringByAppendingString:@"="];
}

static void read_bigger() {
    read_rdi = [read_rdi stringByAppendingString:@">"];
}

static void read_question() {
    read_rdi = [read_rdi stringByAppendingString:@"?"];
}

static void read_at() {
    read_rdi = [read_rdi stringByAppendingString:@"@"];
}

static void read_A() {
    read_rdi = [read_rdi stringByAppendingString:@"A"];
}

static void read_B() {
    read_rdi = [read_rdi stringByAppendingString:@"B"];
}

static void read_C() {
    read_rdi = [read_rdi stringByAppendingString:@"C"];
}

static void read_D() {
    read_rdi = [read_rdi stringByAppendingString:@"D"];
}

static void read_E() {
    read_rdi = [read_rdi stringByAppendingString:@"E"];
}

static void read_F() {
    read_rdi = [read_rdi stringByAppendingString:@"F"];
}

static void read_G() {
    read_rdi = [read_rdi stringByAppendingString:@"G"];
}

static void read_H() {
    read_rdi = [read_rdi stringByAppendingString:@"H"];
}

static void read_I() {
    read_rdi = [read_rdi stringByAppendingString:@"I"];
}

static void read_J() {
    read_rdi = [read_rdi stringByAppendingString:@"J"];
}

static void read_K() {
    read_rdi = [read_rdi stringByAppendingString:@"K"];
}

static void read_L() {
    read_rdi = [read_rdi stringByAppendingString:@"L"];
}

static void read_M() {
    read_rdi = [read_rdi stringByAppendingString:@"M"];
}

static void read_N() {
    read_rdi = [read_rdi stringByAppendingString:@"N"];
}

static void read_O() {
    read_rdi = [read_rdi stringByAppendingString:@"O"];
}

static void read_P() {
    read_rdi = [read_rdi stringByAppendingString:@"P"];
}

static void read_Q() {
    read_rdi = [read_rdi stringByAppendingString:@"Q"];
}

static void read_R() {
    read_rdi = [read_rdi stringByAppendingString:@"R"];
}

static void read_S() {
    read_rdi = [read_rdi stringByAppendingString:@"S"];
}

static void read_T() {
    read_rdi = [read_rdi stringByAppendingString:@"T"];
}

static void read_U() {
    read_rdi = [read_rdi stringByAppendingString:@"U"];
}

static void read_V() {
    read_rdi = [read_rdi stringByAppendingString:@"V"];
}

static void read_W() {
    read_rdi = [read_rdi stringByAppendingString:@"W"];
}

static void read_X() {
    read_rdi = [read_rdi stringByAppendingString:@"X"];
}

static void read_Y() {
    read_rdi = [read_rdi stringByAppendingString:@"Y"];
}

static void read_Z() {
    read_rdi = [read_rdi stringByAppendingString:@"Z"];
}

static void read_leftfkh() {
    read_rdi = [read_rdi stringByAppendingString:@"["];
}

static void read_rightsplash() {
    read_rdi = [read_rdi stringByAppendingString:@"\\"];
}

static void read_rightfkh() {
    read_rdi = [read_rdi stringByAppendingString:@"]"];
}

static void read_xjj() {
    read_rdi = [read_rdi stringByAppendingString:@"^"];
}

static void read__() {
    read_rdi = [read_rdi stringByAppendingString:@"_"];
}

static void read_whatdot() {
    read_rdi = [read_rdi stringByAppendingString:@"`"];
}

static void read_a() {
    read_rdi = [read_rdi stringByAppendingString:@"a"];
}

static void read_b() {
    read_rdi = [read_rdi stringByAppendingString:@"b"];
}

static void read_c() {
    read_rdi = [read_rdi stringByAppendingString:@"c"];
}

static void read_d() {
    read_rdi = [read_rdi stringByAppendingString:@"d"];
}

static void read_e() {
    read_rdi = [read_rdi stringByAppendingString:@"e"];
}

static void read_f() {
    read_rdi = [read_rdi stringByAppendingString:@"f"];
}

static void read_g() {
    read_rdi = [read_rdi stringByAppendingString:@"g"];
}

static void read_h() {
    read_rdi = [read_rdi stringByAppendingString:@"h"];
}

static void read_i() {
    read_rdi = [read_rdi stringByAppendingString:@"i"];
}

static void read_j() {
    read_rdi = [read_rdi stringByAppendingString:@"j"];
}

static void read_k() {
    read_rdi = [read_rdi stringByAppendingString:@"k"];
}

static void read_l() {
    read_rdi = [read_rdi stringByAppendingString:@"l"];
}

static void read_m() {
    read_rdi = [read_rdi stringByAppendingString:@"m"];
}

static void read_n() {
    read_rdi = [read_rdi stringByAppendingString:@"n"];
}

static void read_o() {
    read_rdi = [read_rdi stringByAppendingString:@"o"];
}

static void read_p() {
    read_rdi = [read_rdi stringByAppendingString:@"p"];
}

static void read_q() {
    read_rdi = [read_rdi stringByAppendingString:@"q"];
}

static void read_r() {
    read_rdi = [read_rdi stringByAppendingString:@"r"];
}

static void read_s() {
    read_rdi = [read_rdi stringByAppendingString:@"s"];
}

static void read_t() {
    read_rdi = [read_rdi stringByAppendingString:@"t"];
}

static void read_u() {
    read_rdi = [read_rdi stringByAppendingString:@"u"];
}

static void read_v() {
    read_rdi = [read_rdi stringByAppendingString:@"v"];
}

static void read_w() {
    read_rdi = [read_rdi stringByAppendingString:@"w"];
}

static void read_x() {
    read_rdi = [read_rdi stringByAppendingString:@"x"];
}

static void read_y() {
    read_rdi = [read_rdi stringByAppendingString:@"y"];
}

static void read_z() {
    read_rdi = [read_rdi stringByAppendingString:@"z"];
}

static void read_lefthkh() {
    read_rdi = [read_rdi stringByAppendingString:@"{"];
}

static void read_sg() {
    read_rdi = [read_rdi stringByAppendingString:@"|"];
}

static void read_righthkh() {
    read_rdi = [read_rdi stringByAppendingString:@"}"];
}

static void read_bl() {
    read_rdi = [read_rdi stringByAppendingString:@"~"];
}

void regLinstenersOnMsgPass() {
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_space,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read "),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_exclamation_mark,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read!"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_quto,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read\""),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_shap,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read#"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_dollor,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read$"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_percent,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read%"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_and,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read&"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_signlequto,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read'"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_leftkh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read("),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_rightkh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read)"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_star,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read*"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_add,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read+"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_dotleft,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read,"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_line,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read-"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_dot,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read."),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_leftsplsh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read/"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_0,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read0"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_1,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read1"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_2,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read2"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_3,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read3"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_4,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read4"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_5,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read5"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_6,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read6"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_7,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read7"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_8,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read8"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_9,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read9"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_mh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read:"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_fh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read;"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_small,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read<"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_equal,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read="),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_bigger,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read>"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_question,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read?"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_at,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read@"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_A,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readA"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_B,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readB"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_C,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readC"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_D,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readD"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_E,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readE"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_F,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readF"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_G,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readG"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_H,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readH"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_I,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readI"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_J,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readJ"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_K,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readK"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_L,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readL"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_M,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readM"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_N,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readN"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_O,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readO"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_P,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readP"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_Q,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readQ"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_R,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readR"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_S,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readS"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_T,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readT"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_U,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readU"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_V,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readV"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_W,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readW"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_X,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readX"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_Y,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readY"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_Z,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readZ"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_leftfkh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read["),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_rightsplash,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read\\"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_rightfkh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read]"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_xjj,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read^"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read__,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read_"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_whatdot,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read`"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_a,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.reada"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_b,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readb"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_c,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readc"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_d,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readd"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_e,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.reade"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_f,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readf"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_g,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readg"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_h,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readh"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_i,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readi"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_j,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readj"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_k,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readk"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_l,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readl"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_m,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readm"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_n,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readn"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_o,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.reado"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_p,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readp"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_q,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readq"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_r,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readr"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_s,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.reads"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_t,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readt"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_u,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readu"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_v,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readv"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_w,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readw"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_x,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readx"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_y,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.ready"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_z,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readz"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_lefthkh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read{"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_sg,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read|"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_righthkh,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read}"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_bl,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.read~"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_begin,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readBegin"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    read_end,
                                    CFSTR("com.Lakr233.Saily.MsgPas.UIPasteBoard.readEnd"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    
}
