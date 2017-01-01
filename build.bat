@echo off
REM Build index
elm-make .\\src\\Index.elm --output=index.html

REM Build posts
SET pcr="posts\\code\\rust"
elm-make .\\src\\content\\%pcr%\\empty_rust_structs.elm^
 --output=%pcr%\\empty_rust_structs.html