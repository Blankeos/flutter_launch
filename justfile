# set positional-arguments

default:
    just --list

dev *args:
    dashmon {{args}}

build *args:
    flutter build {{args}}

routegen:
    dart run build_runner build
