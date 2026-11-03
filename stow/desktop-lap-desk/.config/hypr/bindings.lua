local mod = 'SUPER'

local bind = hl.bind
local dsp = hl.dsp

hl.config({
  binds = {
    allow_pin_fullscreen = true,
  },
})

bind(mod .. ' + RETURN', dsp.exec_cmd('uwsm app -- alacritty'))
bind(mod .. ' + Q', dsp.window.close())
bind(mod .. ' + space', dsp.window.float({ action = 'toggle' }))
bind(mod .. ' + R', dsp.exec_cmd('uwsm app -- hyprctl reload'))
bind(mod .. ' + SHIFT + F', dsp.window.fullscreen_state({ internal = 0, client = 2 }))
bind(mod .. ' + F', dsp.window.fullscreen())
-- bind(mod .. ' + S', dsp.layout('togglesplit'))
bind(mod .. ' + G', dsp.group.toggle())
bind(mod .. ' + TAB', dsp.group.next())
bind(mod .. ' + H', dsp.layout('preselect r'))
bind(mod .. ' + V', dsp.layout('preselect d'))
bind(mod .. ' + SHIFT + C', dsp.exec_cmd('cliphist list | rofi -dmenu | cliphist decode | wl-copy'))
bind(mod .. ' + SHIFT + V', dsp.exec_cmd('bash -c "wl-paste | ydotool type -f -"'))
bind(mod .. ' + SHIFT + left', dsp.window.move({ direction = 'left' }))
bind(mod .. ' + SHIFT + right', dsp.window.move({ direction = 'right' }))
bind(mod .. ' + SHIFT + up', dsp.window.move({ direction = 'up' }))
bind(mod .. ' + SHIFT + down', dsp.window.move({ direction = 'down' }))
bind(mod .. ' + left', dsp.focus({ direction = 'left' }))
bind(mod .. ' + right', dsp.focus({ direction = 'right' }))
bind(mod .. ' + up', dsp.focus({ direction = 'up' }))
bind(mod .. ' + down', dsp.focus({ direction = 'down' }))
bind(mod .. ' + CTRL + left', dsp.window.resize({ x = -60, y = 0, relative = true }))
bind(mod .. ' + CTRL + right', dsp.window.resize({ x = 60, y = 0, relative = true }))
bind(mod .. ' + CTRL + up', dsp.window.resize({ x = 0, y = -60, relative = true }))
bind(mod .. ' + CTRL + down', dsp.window.resize({ x = 0, y = 60, relative = true }))
bind('ALT + right', dsp.focus({ workspace = '+1' }))
bind('ALT + left', dsp.focus({ workspace = '-1' }))
for i = 1, 9 do
  bind(mod .. ' + ' .. i, dsp.focus({ workspace = i }))
end
bind(mod .. ' + 0', dsp.focus({ workspace = 10 }))
bind(mod .. ' + M', dsp.exec_cmd('bash ~/.config/hypr/scripts/swapmonitors'))
bind(mod .. ' + ALT + h', dsp.workspace.toggle_special('special'))
bind(mod .. ' + P', dsp.window.pin())
for i = 1, 9 do
  bind('ALT + ' .. i, dsp.window.move({ workspace = i }))
end
bind('ALT + 0', dsp.window.move({ workspace = 10 }))
bind('SHIFT + ALT + h', dsp.window.move({ workspace = 'special:special' }))
for i = 1, 9 do
  bind(mod .. ' + SHIFT + ' .. i, dsp.window.move({ workspace = i, follow = false }))
end
bind(mod .. ' + SHIFT + 0', dsp.window.move({ workspace = 10, follow = false }))
bind(mod .. ' + SHIFT + h', dsp.window.move({ workspace = 'special:special', follow = false }))
bind(mod .. ' + ALT + right', dsp.workspace.swap_monitors({ monitor1 = 'current', monitor2 = 'r' }))
bind(mod .. ' + ALT + left', dsp.workspace.swap_monitors({ monitor1 = 'current', monitor2 = 'l' }))
bind('XF86AudioMute', dsp.exec_cmd('uwsm app -- swayosd-client --output-volume mute-toggle'))
bind(mod .. ' + F4', dsp.exec_cmd('uwsm app -- swayosd-client --input-volume mute-toggle'))
bind('XF86AudioPlay', dsp.exec_cmd('uwsm app -- swayosd-client --playerctl play-pause'))
bind('XF86AudioPause', dsp.exec_cmd('uwsm app -- swayosd-client --playerctl play-pause'))
bind('XF86AudioNext', dsp.exec_cmd('uwsm app -- swayosd-client --playerctl next'))
bind('XF86AudioPrev', dsp.exec_cmd('uwsm app -- swayosd-client --playerctl prev'))
bind('XF86AudioStop', dsp.exec_cmd('uwsm app -- swayosd-client --playerctl stop'))
bind(mod .. ' + L', dsp.exec_cmd('pidof hyprlock || uwsm app -- hyprlock'))
bind(mod .. ' + SHIFT + L', dsp.exec_cmd('systemctl suspend-then-hibernate'))
-- bind(mod .. ' + E', dsp.exec_cmd('uwsm app -- wlogout'))
bind(mod .. ' + N', dsp.exec_cmd('uwsm app -- nemo'))
bind(mod .. ' + D',
  dsp.exec_cmd('uwsm app -- rofi -show drun -theme ~/.config/rofi/themes/custom -run-command "uwsm app -- {cmd}"'))
bind('ALT + L', dsp.exec_cmd(
  [[bash -c 'notify-send "Starting latexocr..."; ]]
    .. 'source .local/opt/latexocr/.venv/bin/activate; '
    .. 'NO_ALBUMENTATIONS_UPDATE=1 uwsm app -- pix2tex_gui'))
bind('ALT + space', dsp.exec_cmd('uwsm app -- walker -k'))
bind(mod .. ' + C', dsp.exec_cmd('uwsm app -- qalculate-gtk'))
-- bind(mod .. ' + C', dsp.exec_cmd('rofi -show calc -modi calc -no-sort -theme gruvbox-dark'))
bind(mod .. ' + B', dsp.exec_cmd('hyprshade toggle blue-light-filter'))
bind(mod .. ' + SHIFT + E', dsp.exec_cmd('uwsm app -- rofi -modi emoji -show emoji -theme gruvbox-dark'))
bind('XF86Calculator', dsp.exec_cmd('uwsm app -- rofi -show calc -modi calc -no-sort -theme gruvbox-dark'))
bind(mod .. ' + I', dsp.exec_cmd('XDG_CURRENT_DESKTOP=gnome uwsm app -- gnome-control-center'))
bind('PRINT', dsp.exec_cmd('uwsm app -- wl-copy < $(grimshot --notify save screen)'))
bind(mod .. ' + SHIFT + S', dsp.exec_cmd('uwsm app -- wl-copy < $(grimshot --notify save area)'))
bind(mod .. ' + F5', dsp.exec_cmd('uwsm app -- swayosd-client --brightness lower'), { repeating = true })
bind(mod .. ' + F6', dsp.exec_cmd('uwsm app -- swayosd-client --brightness raise'), { repeating = true })
bind('XF86AudioRaiseVolume',
  dsp.exec_cmd('uwsm app -- swayosd-client --output-volume raise --max-volume 120'), { repeating = true })
bind('XF86AudioLowerVolume',
  dsp.exec_cmd('uwsm app -- swayosd-client --output-volume lower --max-volume 120'), { repeating = true })
bind('SHIFT + XF86AudioRaiseVolume',
  dsp.exec_cmd('uwsm app -- swayosd-client --output-volume raise --max-volume 120'), { repeating = true })
bind('SHIFT + XF86AudioLowerVolume',
  dsp.exec_cmd('uwsm app -- swayosd-client --output-volume lower --max-volume 120'), { repeating = true })
bind(mod .. ' + SHIFT + Q', dsp.exec_cmd('uwsm app -- hyprlock -c ~/.config/hypr/hyprlock.conf'))
bind('switch:[Switch Device at 67d953a0]',
  dsp.exec_cmd('uwsm app -- hyprlock -c ~/.config/hypr/hyprlock.conf'), { locked = true })
bind('XF86Sleep', dsp.exec_cmd('uwsm app -- hyprlock -c ~/.config/hypr/hyprlock.conf'), { locked = true })
bind(mod .. ' + mouse:272', dsp.window.drag(), { mouse = true })
bind(mod .. ' + mouse:273', dsp.window.resize(), { mouse = true })

-- Pypr
bind(mod .. ' + Z', dsp.exec_cmd('pypr zoom ++0.5'))
bind(mod .. ' + SHIFT + Z', dsp.exec_cmd('pypr zoom'))

-- eww
-- bind(mod .. ' + E', dsp.exec_cmd('uwsm app -- eww -c ~/.config/eww/powermenu open powermenu'))
