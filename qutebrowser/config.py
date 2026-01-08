# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

import os

old_path = os.environ["PATH"]
os.environ["PATH"] = f"/opt/homebrew/bin:{old_path}"

c.scrolling.bar = "always"

# pylint settings included to disable linting errors
config.load_autoconfig(False) # load settings done via the gui

import subprocess
def read_xresources(prefix):
    props = {}
    x = subprocess.run(['xrdb', '-query'], capture_output=True, check=True, text=True)
    lines = x.stdout.split('\n')
    for line in filter(lambda l : l.startswith(prefix), lines):
        prop, _, value = line.partition(':\t')
        props[prop] = value
    return props

# c.url.start_pages = ""
# c.url.default_page = ""

c.tabs.title.format = "{audio}{current_title}"
c.fonts.web.size.default = 15
c.zoom.default = 110

c.url.searchengines = {
# note - if you use duckduckgo, you can make use of its built in bangs, of which there are many! https://duckduckgo.com/bangs
        'DEFAULT': 'https://duckduckgo.com/?q={}',
        '!gg': 'https://www.google.com/search?q={}',
        '!bl' : 'https://search.bilibili.com/all?keyword={}&search_source=1',
        '!yt': 'https://www.youtube.com/results?search_query={}',
        }

c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem']


c.auto_save.session = True # save tabs on quit/restart
# unbind key
config.unbind('d')
config.unbind('u')
config.unbind('m')
config.unbind('<Ctrl-t>')
config.unbind('tsh')
config.unbind('tsH')
config.unbind('tsu')

# keybinding changes
config.bind('x', 'tab-close')
config.bind('U', 'undo')
config.bind('u', 'scroll-page 0 -0.5')
# config.bind('j', 'scroll-page 0 0.1')
# config.bind('k', 'scroll-page 0 -0.1')
config.bind('d', 'scroll-page 0 0.5')
config.bind('h', 'history')
config.bind('cc', 'hint images spawn sh -c "cliphist link {hint-url}"')
config.bind('cs', 'cmd-set-text -s :config-source')
config.bind('tH', 'config-cycle tabs.show multiple never')
config.bind('sH', 'config-cycle statusbar.show always never')
config.bind('T', 'hint links tab')
config.bind('pP', 'open -- {primary}')
config.bind('pp', 'open -- {clipboard}')
config.bind('pt', 'open -t -- {clipboard}')
config.bind('qm', 'macro-record')
config.bind('<ctrl-y>', 'spawn --userscript ytdl.sh')
config.bind('tT', 'config-cycle tabs.position top left')
config.bind('gJ', 'tab-move +')
config.bind('gK', 'tab-move -')
config.bind('ts', 'cmd-set-text -s :tab-select')

# dark mode setup
c.colors.webpage.darkmode.enabled = True 
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

c.aliases['darkmode'] = 'config-cycle colors.webpage.darkmode.enabled'
# styles, cosmetics
# c.content.user_stylesheets = ["~/.config/qutebrowser/styles/youtube-tweaks.css"]
c.tabs.padding = {'top': 5, 'bottom': 5, 'left': 9, 'right': 9}
c.tabs.indicator.width = 0 # no tab indicators
# c.window.transparent = true # apparently not needed
c.tabs.width = '7%'

# fonts
c.fonts.default_family = "serif"
c.fonts.default_size = '12pt'
# c.fonts.web.family.fixed = 'monospace'
# c.fonts.web.family.sans_serif = 'monospace'
# c.fonts.web.family.serif = 'monospace'
# c.fonts.web.family.standard = 'monospace'

# privacy - adjust these settings based on your preference
# config.set("completion.cmd_history_max_items", 0)
# config.set("content.private_browsing", true)
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)
# config.set("content.javascript.enabled", false) # tsh keybind to toggle

# adblocking info -->
# for yt ads: place the greasemonkey script yt-ads.js in your greasemonkey folder (~/.config/qutebrowser/greasemonkey).
# the script skips through the entire ad, so all you have to do is click the skip button.
# yeah it's not ublock origin, but if you want a minimal browser, this is a solution for the tradeoff.
# you can also watch yt vids directly in mpv, see qutebrowser faq for how to do that.
# if you want additional blocklists, you can get the python-adblock package, or you can uncomment the ublock lists here.
c.content.blocking.enabled = True
c.content.blocking.adblock.lists = [
        "https://github.com/ublockorigin/uassets/raw/master/filters/legacy.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/filters.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/filters-2020.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/filters-2021.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/filters-2022.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/filters-2023.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/filters-2024.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/badware.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/privacy.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/badlists.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/annoyances.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/annoyances-cookies.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/annoyances-others.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/badlists.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/quick-fixes.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/resource-abuse.txt",
        "https://github.com/ublockorigin/uassets/raw/master/filters/unbreak.txt",
        "https://easylist.to/easylist/easylist.txt",
        "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
        "https://easylist.to/easylist/easyprivacy.txt",
        "https://secure.fanboy.co.nz/fanboy-annoyance.txt",]
cmd_trans_script = "spawn --userscript ~/.config/qutebrowser/greasemonkey/translate"
config.bind("tr", cmd_trans_script)

c.bindings.commands["caret"] = {
    "tr": cmd_trans_script
}


enabled_scripts = [
        "https://greasyfork.org/zh-CN/scripts/420352-csdn-focus",
        "https://greasyfork.org/zh-CN/scripts/396171-%E7%9F%A5%E4%B9%8E%E5%85%8D%E7%99%BB%E5%BD%95",
]

# 禁用的插件 (暂时不想用，但不想删文件，下次启用不用重新下载)
disabled_scripts = [
]

# 注入环境变量
os.environ["QB_GM_LIST"] = " ".join(enabled_scripts)
os.environ["QB_GM_DISABLED_LIST"] = " ".join(disabled_scripts)

# 绑定快捷键 gr 刷新当前配置并调用同步脚本
config.bind("gr", "config-source ;; spawn --userscript ~/.config/qutebrowser/greasemonkey/plugins_mg")
