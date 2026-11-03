local window_rule = hl.window_rule
local gesture = hl.gesture

hl.config({
  ecosystem = {
    enforce_permissions = false,
  },
})

-- hl.permission({ binary = '/usr/bin/grim', type = 'screencopy', mode = 'allow' })
-- hl.permission({ binary = '/usr/bin/hyprpm', type = 'plugin', mode = 'allow' })
-- hl.permission({ binary = '/usr/bin/hyprlock', type = 'screencopy', mode = 'allow' })
-- hl.permission({ binary = '/usr/bin/sunshine', type = 'screencopy', mode = 'allow' })
-- hl.permission({ binary = '/usr/bin/systemctl', type = 'screencopy', mode = 'allow' })

gesture({ fingers = 3, direction = 'horizontal', scale = 0.7, action = 'workspace' })
gesture({ fingers = 3, direction = 'up', action = 'fullscreen' })
gesture({ fingers = 3, direction = 'pinchout', action = 'float' })
gesture({ fingers = 4, direction = 'up', action = 'special', workspace_name = 'special' })

-- window_rule({ match = { class = 'Screenshare' }, float = true })
window_rule({ match = { class = 'imv' }, float = true })
window_rule({ match = { class = 'mpv' }, float = true })
window_rule({ match = { class = 'org.gnome.Settings' }, float = true })
window_rule({ match = { class = 'qalculate-gtk' }, float = true })
window_rule({ match = { class = 'org.gnome.Settings' }, size = { 1280, 720 } })

window_rule({ match = { class = 'xwaylandvideobridge' }, opacity = '0.0 override' })
window_rule({ match = { class = 'xwaylandvideobridge' }, no_anim = true })
window_rule({ match = { class = 'xwaylandvideobridge' }, no_initial_focus = true })
window_rule({ match = { class = 'xwaylandvideobridge' }, max_size = { 1, 1 } })
window_rule({ match = { class = 'xwaylandvideobridge' }, no_blur = true })

window_rule({ match = { class = 'org.kde.kdeconnect.daemon' }, no_blur = true })
window_rule({ match = { class = 'org.kde.kdeconnect.daemon' }, fullscreen_state = '0' })
window_rule({ match = { class = 'org.kde.kdeconnect.daemon' }, float = true })
window_rule({ match = { title = '^(LaTeX OCR)$' }, float = true })
window_rule({ match = { class = 'org.kde.kdeconnect.daemon' }, size = { 1920, 1080 } })
window_rule({ match = { class = 'org.kde.kdeconnect.daemon' }, no_anim = true })
window_rule({ match = { class = 'org.kde.kalm' }, fullscreen = true })

-- development
window_rule({ match = { title = '^(.*should.popup.*)$' }, float = true })
window_rule({ match = { title = '^(.*should.focus.*)$' }, stay_focused = true })
window_rule({ match = { title = '^(.*should.fullscreen.*)$' }, fullscreen = true })
