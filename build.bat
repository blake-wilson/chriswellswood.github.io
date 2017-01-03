@echo off
REM Build index
elm-make .\\src\\Index.elm --output=.\\site\\index.js

REM Build posts
SET pcr="posts\\code\\rust"
elm-make .\\src\\content\\%pcr%\\EmptyRustStructs.elm^
 --output=.\\site\\%pcr%\\empty-rust-structs.js