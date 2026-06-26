#import <UIKit/UIKit.h>
#import <substrate.h>


// --------------------------------------
// IGOledTheme made by DeNsor
// If you wanna use it, Credit me
// Telegram : DENS0R ( https://t.me/DENS0R )
// X/Twitter : xDeNsor
// --------------------------------------



@interface UIKBBackdropView : UIView
@end

@interface IGViewController : UIViewController
@end


@interface IGLiquidGlassTabBarButtonContainerView : UIView
@end



static BOOL shouldSkip(NSString *cls) {
    if ([cls isEqualToString:@"IGMusicStickerEditorStylePicker"] ||
        [cls isEqualToString:@"IGKaraokeDynamicTextView"] ||
        [cls isEqualToString:@"IGStoryMusicLyricsSticker"])
        // [cls containsString:@"IGDelegatedHitTestView"]
        return YES;
        // IGDelegatedHitTestView optional

    // alerts — remove this block if you want alerts to go black
    if ([cls containsString:@"IGDSAlertDialogView"])
        return YES;

    // buttons — uncomment this block if you dont want buttons to go black
    // if ([cls isEqualToString:@"IGShortenableTextButton"])
    //     return YES;

    // message bubbles in DMs — remove this block if you want chat bubbles to go black
    if ([cls isEqualToString:@"IGDirectMessageBubbleView"] ||
        [cls isEqualToString:@"IGDirectReshareMessageFooterView"])
        return YES;


    return NO;
}

UIColor *black = [UIColor blackColor]; // Or any color you want

%hook UIView

// Apply the color
// Fixes sheet/alert backgrounds

- (void)setBackgroundColor:(UIColor *)color {

    // if ([self isKindOfClass:[UIImageView class]]) {
    //     UIView *subv = self.superview;
    //     while (subv) {
    //         NSString *aCls = NSStringFromClass([subv class]);
    //         if ([aCls containsString:@"IGFollowButton.IGFollowButton"] ||
    //             [aCls containsString:@"_TtC14IGFollowButton14IGFollowButton"]) {
    //             %orig(color); return;
    //         }
    //         subv = subv.superview;
    //     }
    // }

    // If you dont want to apply the color to follow button , uncomment this block


    if (shouldSkip(NSStringFromClass([self class]))) { %orig(color); return; }
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) { %orig(color); return; }
    if (!color || [color isEqual:[UIColor clearColor]]) { %orig(color); return; }

    CGFloat r = 0, g = 0, b = 0, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];

    CGFloat w = 0;
    [color getWhite:&w alpha:NULL];

    if (w < 0.3) {
        %orig([UIColor colorWithRed:0 green:0 blue:0 alpha:a]);
        return;
    }

    %orig(a < 0.95 ? color : color);
}

// Apply the color
// Fixes sheet/alert backgrounds

- (void)layoutSubviews {
    %orig;

    // if ([self isKindOfClass:[UIImageView class]]) {
    //     UIView *subv = self.superview;
    //     while (subv) {
    //         NSString *aCls = NSStringFromClass([subv class]);
    //         if ([aCls containsString:@"IGFollowButton.IGFollowButton"] ||
    //             [aCls containsString:@"_TtC14IGFollowButton14IGFollowButton"]) {
    //             return;
    //         }
    //         subv = subv.superview;
    //     }
    // }

    // If you dont want to apply the color to follow button , uncomment this block

    if (shouldSkip(NSStringFromClass([self class]))) return;
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) return;

    UIColor *bg = self.backgroundColor;
    if (!bg) return;

    CGFloat w = 0, a = 0;
    [bg getWhite:&w alpha:&a];

    if (w < 0.3)
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:a];
}

%end

%hook UITableView
- (void)setBackgroundColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig(black) : %orig(color);
}
%end

%hook UITableViewCell
- (void)setBackgroundColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig(black) : %orig(color);
}
%end

%hook UITabBar
- (void)setBarTintColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig(black) : %orig(color);
}
%end

%hook IGViewController
- (void)viewDidLoad {
    %orig;
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
        self.view.backgroundColor = black;
}
%end


// OLED - Keyboard
%hook UIKBBackdropView
- (void)setBackgroundColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig([UIColor blackColor]) : %orig(color);
}
%end


// :Im just making sure follow button goes black

%hook UIImageView

- (void)setBackgroundColor:(UIColor *)color {
    NSString *className = NSStringFromClass([self class]);
    if (shouldSkip(className)) {
        %orig(color);
        return;
    }

    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {

        // UIView *subv = self.superview;
        //     while (subv) {
        //         NSString *aCls = NSStringFromClass([subv class]);
        //         if ([aCls containsString:@"IGFollowButton.IGFollowButton"] ||
        //             [aCls containsString:@"_TtC14IGFollowButton14IGFollowButton"]) {
        //             %orig(color); return;
        //         }
        //         subv = subv.superview;
        // }


        // If you dont want to apply the color to follow button , uncomment this block

        %orig(black);

    } else {

        %orig(color);
    }
}

%end


// For the liquid glass tab-bar

%hook IGLiquidGlassTabBarButtonContainerView

-(void)layoutSubviews{
    %orig;
    UIVisualEffectView *_visualEffectView = MSHookIvar<UIVisualEffectView *>(self, "_visualEffectView");
    _visualEffectView.backgroundColor = black;
}

%end