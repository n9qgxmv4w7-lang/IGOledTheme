import <UIKit/UIKit.h>
#import <substrate.h>

// --------------------------------------
// IGOledTheme modified to PinkTheme
// Original by DeNsor (https://t.me)
// Custom Pink Modifications Applied
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
        return YES;

    // alerts — remove this block if you want alerts to go pink
    if ([cls containsString:@"IGDSAlertDialogView"])
        return YES;

    // message bubbles in DMs — remove this block if you want chat bubbles to go pink
    if ([cls isEqualToString:@"IGDirectMessageBubbleView"] ||
        [cls isEqualToString:@"IGDirectReshareMessageFooterView"])
        return YES;

    return NO;
}

// DEFINING GLOBAL PINK COLOR (Bubblegum / Hot Pink)
UIColor *pinkColor = [UIColor colorWithRed:1.00 green:0.41 blue:0.71 alpha:1.0];

%hook UIView

- (void)setBackgroundColor:(UIColor *)color {
    if (shouldSkip(NSStringFromClass([self class]))) { %orig(color); return; }
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) { %orig(color); return; }
    if (!color || [color isEqual:[UIColor clearColor]]) { %orig(color); return; }

    CGFloat r = 0, g = 0, b = 0, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];

    CGFloat w = 0;
    [color getWhite:&w alpha:NULL];

    // If the original UI element was dark/black, overwrite it with Pink instead
    if (w < 0.3) {
        %orig([UIColor colorWithRed:1.00 green:0.41 blue:0.71 alpha:a]);
        return;
    }

    %orig(a < 0.95 ? color : color);
}

- (void)layoutSubviews {
    %orig;

    if (shouldSkip(NSStringFromClass([self class]))) return;
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) return;

    UIColor *bg = self.backgroundColor;
    if (!bg) return;

    ** w = 0, a = 0;
    [bg getWhite:&w alpha:&a];

    // Overwrite layout dark background views with Pink
    if (w < 0.3)
        self.backgroundColor = [UIColor colorWithRed:1.00 green:0.41 blue:0.71 alpha:a];
}

%end

%hook UITableView
- (void)setBackgroundColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig(pinkColor) : %orig(color);
}
%end

%hook UITableViewCell
- (void)setBackgroundColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig(pinkColor) : %orig(color);
}
%end

%hook UITabBar
- (void)setBarTintColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig(pinkColor) : %orig(color);
}
%end

%hook IGViewController
- (void)viewDidLoad {
    %orig;
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
        self.view.backgroundColor = pinkColor;
}
%end

// FIXING CUSTOM KEYBOARD COLOR (Now outputs Pink instead of forcing Black)
%hook UIKBBackdropView
- (void)setBackgroundColor:(UIColor *)color {
    UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? %orig(pinkColor) : %orig(color);
}
%end

%hook UIImageView
- (void)setBackgroundColor:(UIColor *)color {
    NSString *className = NSStringFromClass([self class]);
    if (shouldSkip(className)) {
        %orig(color);
        return;
    }

    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        %orig(pinkColor);
    } else {
        %orig(color);
    }
}
%end

// FIXING LIQUID GLASS TAB BAR COLOR (Now Pink background blur)
%hook IGLiquidGlassTabBarButtonContainerView
-(void)layoutSubviews{
    %orig;
    UIVisualEffectView *_visualEffectView = MSHookIvar<UIVisualEffectView *>(self, "_visualEffectView");
    _visualEffectView.backgroundColor = pinkColor;
}
%end
