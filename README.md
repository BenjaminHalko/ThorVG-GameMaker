# ThorVG GameMaker

Lottie and SVG support for GameMaker using [ThorVG](https://github.com/thorvg/thorvg)

## Development

ThorVG has already been included in the plugin, but in case you want to build it yourself, here's how:

- Install [Meson](https://mesonbuild.com/Getting-meson.html) and [Ninja](https://ninja-build.org)

  - Windows: `pip install meson ninja`
  - MacOS: `brew install meson`
  - Linux: `sudo apt install meson`

- Compile ThorVG:
  
```bash
cd ThorVG-GM
meson setup build -Dbuildtype=release
meson compile -C build
```

- Copy the shared library from `ThorVG-GM/build/src` to `extensions/ThorVG`
