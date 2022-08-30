# polybar-spotify with cache

I modified this [polybar-spotify](https://github.com/PrayagS/polybar-spotify) to cache the output of playerctl. The string scrolls as fast as specified in zscroll.

![sample](img/sample.gif)


## Setup

Edit `spotify_status_vars` to match your environment.

Then add the following lines to your polybar configuration `config.ini`.

```ini
[module/spotify]
type = custom/script
tail = true
interval = 0
format = <label>
exec = ~/.config/polybar/polybar_spotify/polybar_spotify.sh
click-left = playerctl play-pause -p spotifyd

[module/spotify-prev]
type = custom/ipc
hook-0 = echo "玲"
hook-1 = echo "玲"
hook-2 = echo "%{F#71839b}玲%{F-}"
initial = 1
click-left = playerctl previous -p spotifyd

[module/spotify-play-pause]
type = custom/ipc
hook-0 = echo ""
hook-1 = echo "契"
hook-2 = echo "%{F#71839b}契%{F-}"
initial = 1
click-left = playerctl play-pause -p spotifyd

[module/spotify-next]
type = custom/ipc
hook-0 = echo "怜"
hook-1 = echo "怜"
hook-2 = echo "%{F#71839b}怜%{F-}"
initial = 1
click-left = playerctl next -p spotifyd
```

See [here](https://github.com/PrayagS/polybar-spotify/blob/master/README.md) for more information.

