module Content exposing (..)

import EmptyRustStructs
import ElmAndNewLanguages
import OOBrainAndTypes
import ElmStaticSiteP1
import ElmStaticSiteP2
import CounterReusableView
import LetsElmEp1
import LetsElmEp2
import LetsElmEp3
import LetsElmEp4
import LetsElmEp5
import LetsElmEp6
import Skeleton exposing (ContentMetaData)


allPosts : List ContentMetaData
allPosts =
    [ EmptyRustStructs.metaData
    , ElmAndNewLanguages.metaData
    , OOBrainAndTypes.metaData
    , ElmStaticSiteP1.metaData
    , ElmStaticSiteP2.metaData
    , CounterReusableView.metaData
    , LetsElmEp1.metaData
    , LetsElmEp2.metaData
    , LetsElmEp3.metaData
    , LetsElmEp4.metaData
    , LetsElmEp5.metaData
    , LetsElmEp6.metaData
    ]


allSnippets : List ContentMetaData
allSnippets =
    [ { name = "markdown-cheatsheet"
      , title = "Markdown Cheatsheet"
      , date = [ 2016, 12, 11 ]
      , description = "A great cheatsheet for markdown written by @adam-p. I always forget how to make tables..."
      , group = "Snippet"
      , category = "Code"
      , subcategory = "Markdown"
      , url = "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
      }
    , { name = "python-packages"
      , title = "Packaging a Python Project and Distributing on PyPi"
      , date = [ 2017, 8, 17 ]
      , description = "Workflow for making and distributing a Python package."
      , group = "Snippet"
      , category = "Code"
      , subcategory = "Python"
      , url = "https://gist.github.com/ChrisWellsWood/165e3144f4a8199482ab50a8146c8069"
      }
    , { name = "random-git-commands"
      , title = "A Random Selection of Useful Git Commands"
      , date = [ 2017, 8, 24 ]
      , description = "A bunch of useful Git commands and notes."
      , group = "Snippet"
      , category = "Code"
      , subcategory = "Git"
      , url = "https://gist.github.com/ChrisWellsWood/d68b3b4a603e603c052f2e8bf6413014"
      }
    ]
