project('ThorVG-GM', 'cpp', version: '1.0.0')

# Configure ThorVG
thorvg_options = [
    # Use software rendering
    'engines=sw',

    # Enable support for Lottie, SVG, and image formats
    'loaders=svg,lottie,png,jpg,webp',

    # ThorVG is linked statically
    'static=true',
    'default_library=static',

    # Disable unnecessary features
    'threads=false',
    'partial=false',
    'file=false',
    'extra=',
]

# Build the shared library
thorvg = subproject('thorvg', default_options: thorvg_options)
thorvg_dep = thorvg.get_variable('thorvg_dep')

shared_library('thorvg-gm',
    'src/api.cpp',
    dependencies : thorvg_dep
)
