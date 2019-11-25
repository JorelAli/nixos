let color = id: (import ./configutil.nix).getColor id true; in
''
customtheme = {
    'base03': '${color "bg"}',
    'base02': '${color "bgl"}', 
    'base01': '#586e75',
    'base00': '${color 8}',
    'base0': '#839496',
    'base1': '${color "fg"}',
    'base2': '#eee8d5',
    'base3': '#fdf6e3',
    'yellow': '${color 3}',
    'orange': '#cb4b16',
    'red': '${color 1}',
    'magenta': '#d33682',
    'violet': '${color 5}',
    'blue': '${color 4}',
    'cyan': '${color 6}',
    'green': '${color 2}'
}

## Background color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.bg = customtheme['base03']

## Bottom border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.bottom = customtheme['base03']

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.top = customtheme['base03']

## Foreground color of completion widget category headers.
## Type: QtColor
c.colors.completion.category.fg = customtheme['base3']

## Background color of the completion widget for even rows.
## Type: QssColor
c.colors.completion.even.bg = customtheme['base02']

## Text color of the completion widget.
## Type: QtColor
c.colors.completion.fg = customtheme['base3']

## Background color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.bg = customtheme['violet']

## Bottom border color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.border.bottom = customtheme['violet']

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.item.selected.border.top = customtheme['violet']

## Foreground color of the selected completion item.
## Type: QtColor
c.colors.completion.item.selected.fg = customtheme['base3']

## Foreground color of the matched text in the completion.
## Type: QssColor
c.colors.completion.match.fg = customtheme['base2']

## Background color of the completion widget for odd rows.
## Type: QssColor
c.colors.completion.odd.bg = customtheme['base02']

## Color of the scrollbar in completion view
## Type: QssColor
c.colors.completion.scrollbar.bg = customtheme['base0']

## Color of the scrollbar handle in completion view.
## Type: QssColor
c.colors.completion.scrollbar.fg = customtheme['base2']

## Background color for the download bar.
## Type: QssColor
c.colors.downloads.bar.bg = customtheme['base03']

## Background color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.bg = customtheme['red']

## Foreground color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.fg = customtheme['base3']

## Color gradient start for download backgrounds.
## Type: QtColor
# c.colors.downloads.start.bg = '#0000aa'

## Color gradient start for download text.
## Type: QtColor
c.colors.downloads.start.fg = customtheme['base3']

## Color gradient stop for download backgrounds.
## Type: QtColor
# c.colors.downloads.stop.bg = '#00aa00'

## Color gradient end for download text.
## Type: QtColor
# c.colors.downloads.stop.fg = customtheme['base3']

## Color gradient interpolation system for download backgrounds.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
# c.colors.downloads.system.bg = 'rgb'

## Color gradient interpolation system for download text.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
# c.colors.downloads.system.fg = 'rgb'

## Background color for hints. Note that you can use a `rgba(...)` value
## for transparency.
## Type: QssColor
c.colors.hints.bg = customtheme['violet']

## Font color for hints.
## Type: QssColor
c.colors.hints.fg = customtheme['base3']

## Font color for the matched part of hints.
## Type: QssColor
c.colors.hints.match.fg = customtheme['base2']

## Background color of the keyhint widget.
## Type: QssColor
# c.colors.keyhint.bg = 'rgba(0, 0, 0, 80%)'

## Text color for the keyhint widget.
## Type: QssColor
c.colors.keyhint.fg = customtheme['base3']

## Highlight color for keys to complete the current keychain.
## Type: QssColor
c.colors.keyhint.suffix.fg = customtheme['yellow']

## Background color of an error message.
## Type: QssColor
c.colors.messages.error.bg = customtheme['red']

## Border color of an error message.
## Type: QssColor
c.colors.messages.error.border = customtheme['red']

## Foreground color of an error message.
## Type: QssColor
c.colors.messages.error.fg = customtheme['base3']

## Background color of an info message.
## Type: QssColor
c.colors.messages.info.bg = customtheme['base03']

## Border color of an info message.
## Type: QssColor
c.colors.messages.info.border = customtheme['base03']

## Foreground color an info message.
## Type: QssColor
c.colors.messages.info.fg = customtheme['base3']

## Background color of a warning message.
## Type: QssColor
c.colors.messages.warning.bg = customtheme['orange']

## Border color of a warning message.
## Type: QssColor
c.colors.messages.warning.border = customtheme['orange']

## Foreground color a warning message.
## Type: QssColor
c.colors.messages.warning.fg = customtheme['base3']

## Background color for prompts.
## Type: QssColor
c.colors.prompts.bg = customtheme['base02']

## Border used around UI elements in prompts.
## Type: String
c.colors.prompts.border = '1px solid ' + customtheme['base3']

## Foreground color for prompts.
## Type: QssColor
c.colors.prompts.fg = customtheme['base3']

## Background color for the selected item in filename prompts.
## Type: QssColor
c.colors.prompts.selected.bg = customtheme['base01']

## Background color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.bg = customtheme['blue']

## Foreground color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.fg = customtheme['base3']

## Background color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.bg = customtheme['violet']

## Foreground color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.fg = customtheme['base3']

## Background color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.bg = customtheme['base03']

## Foreground color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.fg = customtheme['base3']

## Background color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.bg = customtheme['base01']

## Foreground color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.fg = customtheme['base3']

## Background color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.bg = customtheme['green']

## Foreground color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.fg = customtheme['base3']

## Background color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.bg = customtheme['base03']

## Foreground color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.fg = customtheme['base3']

## Background color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.bg = customtheme['magenta']

## Foreground color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.fg = customtheme['base3']

## Background color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.bg = customtheme['base01']

## Foreground color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.fg = customtheme['base3']

## Background color of the progress bar.
## Type: QssColor
c.colors.statusbar.progress.bg = customtheme['base3']

## Foreground color of the URL in the statusbar on error.
## Type: QssColor
c.colors.statusbar.url.error.fg = customtheme['red']

## Default foreground color of the URL in the statusbar.
## Type: QssColor
c.colors.statusbar.url.fg = customtheme['base3']

## Foreground color of the URL in the statusbar for hovered links.
## Type: QssColor
c.colors.statusbar.url.hover.fg = customtheme['base2']

## Foreground color of the URL in the statusbar on successful load
## (http).
## Type: QssColor
c.colors.statusbar.url.success.http.fg = customtheme['base3']

## Foreground color of the URL in the statusbar on successful load
## (https).
## Type: QssColor
c.colors.statusbar.url.success.https.fg = customtheme['base3']

## Foreground color of the URL in the statusbar when there's a warning.
## Type: QssColor
c.colors.statusbar.url.warn.fg = customtheme['yellow']

## Background color of the tab bar.
## Type: QtColor
# c.colors.tabs.bar.bg = customtheme['base03']

## Background color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.bg = customtheme['base01']

## Foreground color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.fg = customtheme['base2']

## Color for the tab indicator on errors.
## Type: QtColor
c.colors.tabs.indicator.error = customtheme['red']

## Color gradient start for the tab indicator.
## Type: QtColor
c.colors.tabs.indicator.start = customtheme['violet']

## Color gradient end for the tab indicator.
## Type: QtColor
c.colors.tabs.indicator.stop = customtheme['orange']

## Color gradient interpolation system for the tab indicator.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
# c.colors.tabs.indicator.system = 'rgb'

## Background color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.bg = customtheme['base01']

## Foreground color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.fg = customtheme['base2']

## Background color of selected even tabs.
## Type: QtColor
c.colors.tabs.selected.even.bg = customtheme['base03']

## Foreground color of selected even tabs.
## Type: QtColor
c.colors.tabs.selected.even.fg = customtheme['base3']

## Background color of selected odd tabs.
## Type: QtColor
c.colors.tabs.selected.odd.bg = customtheme['base03']

## Foreground color of selected odd tabs.
## Type: QtColor
c.colors.tabs.selected.odd.fg = customtheme['base3']

## Background color for webpages if unset (or empty to use the theme's
## color)
## Type: QtColor
# c.colors.webpage.bg = 'white'
''
