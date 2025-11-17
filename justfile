# set positional-arguments

default:
    just --list

dev *args:
    dashmon {{args}}

install:
    cd ios
    pod install

api-gen:
    # Make sure to install https://pub.dev/packages/swagger_parser
    dart run swagger_parser
    dart run build_runner build --delete-conflicting-outputs -d

build *args:
    flutter build {{args}}

gen:
    dart run build_runner build

genw:
    dart run build_runner watch
