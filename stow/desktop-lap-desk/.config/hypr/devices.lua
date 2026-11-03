hl.monitor({
  output   = 'HDMI-A-1',
  mode     = '1920x1080@60',
  position = '1920x0',
  scale    = 1,
})
-- hl.on('hyprland.start', function() hl.exec_cmd('hyprctl output create headless HEADLESS-2') end)
-- hl.monitor({ output = 'HEADLESS-2', mode = '1920x1080@60', position = '0x0',
--   scale = 1, transform = 1, mirror = 'HDMI-A-1' })
-- hl.workspace_rule({ workspace = '1', monitor = 'eDP-1' })

hl.config({
  input = {
    kb_options         = 'compose:menu,lv3:menu_switch',
    numlock_by_default = true,
    follow_mouse       = 1,
    accel_profile      = 'flat',
    sensitivity        = -0.2,
    touchpad = {
      natural_scroll       = true,
      disable_while_typing = false,
      scroll_factor        = 0.2,
      clickfinger_behavior = false,
    },
  },
})

hl.device({
  name      = 'at-translated-set-2-keyboard',
  kb_layout = 'it',
})
