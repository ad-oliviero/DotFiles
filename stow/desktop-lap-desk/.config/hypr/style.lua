local curve = hl.curve
local animation = hl.animation

hl.config({
  decoration = {
    -- inactive_opacity = 0.9,
    blur = {
      size               = 4,
      passes             = 2,
      special            = true,
      popups             = true,
      popups_ignorealpha = 0,
    },
  },
  dwindle = {
    preserve_split = true,
  },
  general = {
    border_size = 1,
    col = {
      active_border   = { colors = { 'rgb(399EE6)', 'rgb(0B0E14)' }, angle = 90 },
      inactive_border = 'rgb(0B0E14)',
    },
    gaps_in  = 0,
    gaps_out = 0,
  },
  misc = {
    animate_manual_resizes       = true,
    animate_mouse_windowdragging = true,
    disable_autoreload           = true,
    disable_hyprland_logo        = true,
    -- vfr = true,
  },
})

curve('fast_eio', { type = 'bezier', points = { {1, 0}, {0.1, 1} } })
curve('ease_out', { type = 'bezier', points = { {0, 0}, {0.6, 1} } })
curve('linear',   { type = 'bezier', points = { {0, 0}, {1, 1} } })

animation({ leaf = 'windowsMove', enabled = true, speed = 1,  bezier = 'default' })
animation({ leaf = 'windows',     enabled = true, speed = 5,  bezier = 'fast_eio', style = 'slide' })
animation({ leaf = 'workspaces',  enabled = true, speed = 5,  bezier = 'ease_out' })
animation({ leaf = 'borderangle', enabled = true, speed = 30, bezier = 'linear' })
animation({ leaf = 'border',      enabled = true, speed = 10, bezier = 'default' })

-- hl.layer_rule({ match = { namespace = 'eww_top_bar_main' }, blur = true })
hl.layer_rule({ match = { namespace = 'quickshell' }, blur = true })

hl.workspace_rule({
  workspace   = 'special:exposed',
  gaps_out    = 60,
  gaps_in     = 30,
  border_size = 5,
  no_border   = false,
  no_shadow   = true,
})
