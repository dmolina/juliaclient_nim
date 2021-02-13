# Package

version       = "0.1.0"
author        = "Daniel Molina"
description   = "Julia client binary using DaemonMode.jl package"
license       = "MIT"
srcDir        = "src"
bin           = @["jclient"]


# Dependencies

requires "nim >= 1.4.2"
