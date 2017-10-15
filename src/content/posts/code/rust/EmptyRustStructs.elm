module EmptyRustStructs exposing (..)

import Html exposing (..)
import Markdown
import Skeleton exposing (ContentMetaData, skeleton, blogPostView, contentUrl)


main =
    blogPostView metaData content
        |> skeleton


name : String
name =
    "empty-rust-structs"


group : String
group =
    "Blog"


category : String
category =
    "Code"


subcategory : String
subcategory =
    "Elm"


metaData : ContentMetaData
metaData =
    { name = name
    , title = "Initialising Empty Structs in Rust"
    , date = [ 2016, 12, 11 ]
    , description = "A little article about methods for initialising empty/default structs in Rust, which can be more complicated than you might think!"
    , group = group
    , category = category
    , subcategory = subcategory
    , url = contentUrl group category subcategory name
    }


content : Html msg
content =
    Markdown.toHtml [] rawContent


rawContent : String
rawContent =
    """\x0D
In C/C++, you can initialise a struct without giving values for any of the fields:\x0D
\x0D
```C\x0D
struct Point {\x0D
  float x;\x0D
  float y;\x0D
  float z;\x0D
};\x0D
\x0D
int main() {\x0D
  Point my_point = {};\x0D
}\x0D
```\x0D
\x0D
Structs in RUST can't do this by default, you'll just get an error:\x0D
\x0D
```Rust\x0D
#[derive(Debug)]\x0D
struct Point {\x0D
    x: i32,\x0D
    y: i32,\x0D
    z: i32,\x0D
}\x0D
\x0D
fn main() {\x0D
    let p1 = Point{};\x0D
}\x0D
```\x0D
\x0D
```\x0D
error[E0063]: missing fields `x`, `y`, `z` in initializer of `Point`\x0D
 --> src\\main.rs:2:15\x0D
  |\x0D
2 |     let p1 = Point{};\x0D
  |              ^^^^^ missing `x`, `y`, `z`\x0D
```\x0D
\x0D
The proper way to do this for a struct in Rust is to implement the `Default` trait and then you can generate default values easily:\x0D
\x0D
```Rust\x0D
#[derive(Debug)]\x0D
struct Point {\x0D
    x: i32,\x0D
    y: i32,\x0D
    z: i32,\x0D
}\x0D
\x0D
impl Default for Point {\x0D
    fn default () -> Point {\x0D
        Point{x: 0, y: 0, z:0}\x0D
    }\x0D
}\x0D
fn main() {\x0D
  let p1 = Point::default(); \x0D
  let p2 = Point{ x: 34, ..Default::default() }; // Partial definition of fields\x0D
}\x0D
```\x0D
\x0D
You can even do this automatically using the `derive` attribute.\x0D
\x0D
```Rust\x0D
#[derive(Debug, Default)] // Derive is cool, I have no idea how it works!\x0D
struct Point {\x0D
    x: i32,\x0D
    y: i32,\x0D
    z: i32,\x0D
}\x0D
\x0D
fn main() {\x0D
  let p1 = Point::default();\x0D
  let p2 = Point{ x: 34, ..Default::default() };\x0D
}\x0D
```\x0D
\x0D
It's like magic! \x0D
\x0D
Initialising empty structs is especially useful when working with an API, where you might give a function a pointer to a struct and the fields are populated for you. If you're working with a RUST API that follows this pattern, we can just use our `Default` trait implementation to do this, right? Well, that depends on the API. If you're using using the `winapi` crate, this doesn't work as `Default` has not been implemented for any of the structs that I've used:\x0D
\x0D
```Rust\x0D
extern crate winapi;\x0D
\x0D
use winapi::windef::RECT;\x0D
\x0D
fn main() {\x0D
    let rect = RECT{ ..Default::default() };\x0D
    println!("{:?}", rect);\x0D
}\x0D
```\x0D
\x0D
```\x0D
error[E0277]: the trait bound `winapi::RECT: std::default::Default`\x0D
is not satisfied\x0D
 --> src\\main.rs:6:24\x0D
  |\x0D
6 |     let rect = RECT{ ..Default::default() };\x0D
  |                        ^^^^^^^^^^^^^^^^ trait `winapi::RECT: std::default::Default` not satisfied\x0D
```\x0D
\x0D
Unfortunately, you're not allowed to implement a trait that you did not define, for a type that you also did not define. So if you're using a struct from an external crate, you can't implement `Default` for it:\x0D
\x0D
```Rust\x0D
extern crate winapi;\x0D
\x0D
use winapi::windef::RECT;\x0D
\x0D
impl Default for RECT {\x0D
    fn default () -> RECT {\x0D
        RECT{left: 0, top: 0, right: 0, bottom: 0}\x0D
    }\x0D
}\x0D
\x0D
fn main() {\x0D
    let rect = RECT::default();\x0D
    println!("{:?}", rect);\x0D
}\x0D
```\x0D
\x0D
```\x0D
error[E0117]: only traits defined in the current crate can be implemented for arbitrary types\x0D
 --> src\\main.rs:5:1\x0D
  |\x0D
5 | impl Default for RECT {\x0D
  | ^ impl doesn't use types inside crate\x0D
```\x0D
\x0D
That's annoying... So what do you do? There's a couple of things you could do. Firstly, you could wrap the struct as a new type (so you're defining it in your own crate):\x0D
\x0D
```Rust\x0D
extern crate winapi;\x0D
\x0D
use winapi::windef::RECT;\x0D
\x0D
#[derive(Debug)]\x0D
struct WrappedRECT{rect: RECT}\x0D
\x0D
impl Default for WrappedRECT {\x0D
    fn default () -> WrappedRECT {\x0D
        WrappedRECT{rect: RECT{left: 0, top: 0, right: 0, bottom: 0}}\x0D
    }\x0D
}\x0D
\x0D
fn main() {\x0D
    let rect = WrappedRECT::default();\x0D
    println!("{:?}", rect);\x0D
}\x0D
```\x0D
\x0D
But this is a bit clunky, so I prefer just creating a new `trait`, and implementing it for the external struct:\x0D
\x0D
```Rust\x0D
extern crate winapi;\x0D
\x0D
use winapi::windef::RECT;\x0D
\x0D
trait Empty<T> {\x0D
    fn empty() -> T;\x0D
}\x0D
\x0D
impl Empty<RECT> for RECT {\x0D
    fn empty() -> RECT {\x0D
        RECT{left: 0, top: 0, right: 0, bottom: 0}\x0D
    }\x0D
}\x0D
\x0D
fn main() {\x0D
    let rect = RECT::empty();\x0D
    println!("{:?}", rect);\x0D
}\x0D
```\x0D
\x0D
It seems a little more transparent, and there's no clash with the name of the method. If you want to be a good citizen, the best way to deal with this is probably to just go and modify the crate you're using, adding `derive(Debug)` attributes to everything!\x0D
\x0D
Thanks to joshtriplett and yohanesu75 for some extra info.\x0D
"""
