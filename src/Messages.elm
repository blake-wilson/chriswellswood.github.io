module Messages exposing (..)

import Http

import Content exposing (allPosts, ContentIndex, PostInfo)

-- This file contains the declaration of all the messages used in the app

type Msg
    = Home
    | GetPost PostInfo
    | ShowContent (Result Http.Error String)