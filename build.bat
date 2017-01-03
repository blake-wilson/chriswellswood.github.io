@echo off
REM Build index
elm-make .\\src\\Index.elm --output=.\\site\\index.js

REM Build posts
SET pce="posts\\code\\elm"
elm-make .\\src\\content\\%pce%\\ElmAndNewLanguages.elm^
 --output=.\\site\\%pce%\\elm-and-learning-new-languages.js

elm-make .\\src\\content\\%pce%\\OOBrainAndTypes.elm^
 --output=.\\site\\%pce%\\object-oriented-brain-and-types.js

SET pcr="posts\\code\\rust"
elm-make .\\src\\content\\%pcr%\\EmptyRustStructs.elm^
 --output=.\\site\\%pcr%\\empty-rust-structs.js