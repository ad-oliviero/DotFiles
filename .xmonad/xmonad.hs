{-# LANGUAGE TupleSections #-}
import XMonad
import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Util.SpawnOnce
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders

defaultTerminal = "alacritty"

borderWidth' = 2
modMask'     = mod4Mask
workspaces'  = ["1","2","3","4","5","6","7","8","9", "10"]

normalBorderColor'  = "#2E3440"
focusedBorderColor' = "#BF616A"

keys' conf@XConfig {XMonad.modMask = modm} = M.fromList $
    [ ((modm,               xK_Return), spawn defaultTerminal                               )
    , ((modm,               xK_n     ), spawn "pcmanfm"                                       )
    , ((modm,                    xK_d), spawn "rofi -show drun -show-icons -drun-icon-theme")
    , ((modm,                    xK_e), spawn "rofi -theme powermenu -show power-menu -modi power-menu:~/.config/scripts/rofi/rofi-powermenu.sh")
    , ((modm .|. shiftMask,      xK_e), io exitSuccess                                      )
    , ((0,                   xK_Print), spawn "maim ~/Pictures/Screenshots/`date +%Y-%m-%d_%H:%M:%S`.png && notify-send Screenshot")
    , ((0,    xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%"   )
    , ((0,    xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%"   )
    , ((0,           xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"   )
    , ((0,           xF86XK_AudioPlay), spawn "playerctl play-pause"                        )
    , ((0,          xF86XK_AudioPause), spawn "playerctl play-pause"                        )
    , ((0,           xF86XK_AudioNext), spawn "playerctl next"                              )
    , ((0,           xF86XK_AudioPrev), spawn "playerctl previous"                          )
    , ((0,           xF86XK_AudioStop), spawn "playerctl stop"                              )
    , ((modm,               xK_q     ), kill                                                )
    , ((modm,               xK_r     ), spawn "xmonad --restart"                            )
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart"        )
    , ((modm .|. shiftMask, xK_space ), sendMessage ToggleStruts                            )
    , ((modm,               xK_space ), sendMessage NextLayout                              )
    , ((modm,               xK_Down  ), windows W.focusDown                                 )
    , ((modm,               xK_Up    ), windows W.focusUp                                   )
    , ((modm,               xK_m     ), windows W.focusMaster                               )
    , ((modm,               xK_i     ), windows W.swapMaster                                )
    , ((modm .|. shiftMask, xK_Down  ), windows W.swapDown                                  )
    , ((modm .|. shiftMask, xK_Up    ), windows W.swapUp                                    )
    , ((modm              , xK_f     ), sendMessage $ Toggle FULL                           )
    , ((modm .|. shiftMask, xK_Left  ), sendMessage Shrink                                  )
    , ((modm .|. shiftMask, xK_Right ), sendMessage Expand                                  )
    , ((modm,               xK_t     ), withFocused $ windows . W.sink                      )
    ]

    ++

    [((m .|. modm, k), windows $ f i) | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0]), (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f)) | (key, sc) <- zip [xK_s, xK_a] [0..], (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


mouseBindings' XConfig {XMonad.modMask = modm} = M.fromList 
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)
    ]

layout' = mkToggle (NOBORDERS ?? FULL ?? EOT) $ tiledLayout ||| Mirror tiledLayout ||| noBorders Full               --smartBorders $ 

tiledLayout = outerGaps $ innerGaps $ Tall nmaster delta ratio
  where
     gapsSize   = 5
     outerGaps  = gaps $ map (, gapsSize) [U, L, R, D]
     innerGaps  = spacing gapsSize
     nmaster    = 1
     ratio      = 1/2
     delta      = 3/100

eventHook' = fullscreenEventHook

startupHook' = do
    spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
    spawnOnce "picom --experimental-backends --backend glx &"
    spawnOnce "dunst &"
    spawnOnce "nm-applet &"
    --spawnOnce "v4l2-ctl -d /dev/video42 -c timeout=3000"
    spawn "numlockx on &"
    spawn "xinput set-prop 9 309 -0.5 &"
    spawn "xinput set-prop 9 312 1 0 &"
    spawn "feh --bg-fill ~/Pictures/cyberfennec.jpg &"
    spawn "dconf reset -f /org/gnome/control-center/ &"
    spawn "~/.config/polybar/launch.sh &"

main = xmonad $ docks $ ewmh defaults

defaults = def {
        terminal           = defaultTerminal,
        focusFollowsMouse  = True,
        clickJustFocuses   = False,
        borderWidth        = borderWidth',
        modMask            = modMask',
        workspaces         = workspaces',
        normalBorderColor  = normalBorderColor',
        focusedBorderColor = focusedBorderColor',

        keys               = keys',
        mouseBindings      = mouseBindings',

        layoutHook         = avoidStruts layout',
        handleEventHook    = eventHook',
        startupHook        = startupHook'
    }
