@echo off
REM Build index
elm-make .\\src\\Index.elm --output=index.html

REM Build posts
SET pcr="posts\\code\\rust"
elm-make .\\src\\content\\%pcr%\\EmptyRustStructs.elm^
 --output=%pcr%\\empty-rust-structs.html