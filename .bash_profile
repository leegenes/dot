# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:/Users/lee/Library/Python/3.8/bin"

# Python 3.8
# python@3.8 is keg-only, which means it was not symlinked into /usr/local,
# because this is an alternate version of another formula.

# For compilers to find python@3.8 you may need to set:
export LDFLAGS="-L/usr/local/opt/python@3.8/lib"

# For pkg-config to find python@3.8 you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/python@3.8/lib/pkgconfig"