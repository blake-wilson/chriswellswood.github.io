module EmptyRustStructs exposing (..)

import Html exposing (..)
import Markdown

import Types exposing (ContentMetaData)

name : String
name = "empty-rust-structs"

metaData : ContentMetaData msg
metaData =
    { name = name
    , title = "Initialising Empty Structs in Rust"
    , date = [2016, 12, 11]
    , description = "A little article about methods for initialising empty/default structs in Rust, which can be more complicated than you might think!"
    , category = "Code"
    , subcategory = "Rust"
    , url = "#blog/" ++ name
    , content = content
    }

content : Html msg
content = Markdown.toHtml [] rawContent

rawContent: String
rawContent = """
In C/C++, you can initialise a struct without giving values for any of the fields:

```C
struct Point {
  float x;
  float y;
  float z;
};

int main() {
  Point my_point = {};
}
```

Structs in RUST can't do this by default, you'll just get an error:

```Rust
#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

fn main() {
    let p1 = Point{};
}
```

```
error[E0063]: missing fields `x`, `y`, `z` in initializer of `Point`
 --> src\\main.rs:2:15
  |
2 |     let p1 = Point{};
  |              ^^^^^ missing `x`, `y`, `z`
```

The proper way to do this for a struct in Rust is to implement the `Default` trait and then you can generate default values easily:

```Rust
#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

impl Default for Point {
    fn default () -> Point {
        Point{x: 0, y: 0, z:0}
    }
}
fn main() {
  let p1 = Point::default(); 
  let p2 = Point{ x: 34, ..Default::default() }; // Partial definition of fields
}
```

You can even do this automatically using the `derive` attribute.

```Rust
#[derive(Debug, Default)] // Derive is cool, I have no idea how it works!
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

fn main() {
  let p1 = Point::default();
  let p2 = Point{ x: 34, ..Default::default() };
}
```

It's like magic! 

Initialising empty structs is especially useful when working with an API, where you might give a function a pointer to a struct and the fields are populated for you. If you're working with a RUST API that follows this pattern, we can just use our `Default` trait implementation to do this, right? Well, that depends on the API. If you're using using the `winapi` crate, this doesn't work as `Default` has not been implemented for any of the structs that I've used:

```Rust
extern crate winapi;

use winapi::windef::RECT;

fn main() {
    let rect = RECT{ ..Default::default() };
    println!("{:?}", rect);
}
```

```
error[E0277]: the trait bound `winapi::RECT: std::default::Default`
is not satisfied
 --> src\\main.rs:6:24
  |
6 |     let rect = RECT{ ..Default::default() };
  |                        ^^^^^^^^^^^^^^^^ trait `winapi::RECT: std::default::Default` not satisfied
```

Unfortunately, you're not allowed to implement a trait that you did not define, for a type that you also did not define. So if you're using a struct from an external crate, you can't implement `Default` for it:

```Rust
extern crate winapi;

use winapi::windef::RECT;

impl Default for RECT {
    fn default () -> RECT {
        RECT{left: 0, top: 0, right: 0, bottom: 0}
    }
}

fn main() {
    let rect = RECT::default();
    println!("{:?}", rect);
}
```

```
error[E0117]: only traits defined in the current crate can be implemented for arbitrary types
 --> src\\main.rs:5:1
  |
5 | impl Default for RECT {
  | ^ impl doesn't use types inside crate
```

That's annoying... So what do you do? There's a couple of things you could do. Firstly, you could wrap the struct as a new type (so you're defining it in your own crate):

```Rust
extern crate winapi;

use winapi::windef::RECT;

#[derive(Debug)]
struct WrappedRECT{rect: RECT}

impl Default for WrappedRECT {
    fn default () -> WrappedRECT {
        WrappedRECT{rect: RECT{left: 0, top: 0, right: 0, bottom: 0}}
    }
}

fn main() {
    let rect = WrappedRECT::default();
    println!("{:?}", rect);
}
```

But this is a bit clunky, so I prefer just creating a new `trait`, and implementing it for the external struct:

```Rust
extern crate winapi;

use winapi::windef::RECT;

trait Empty<T> {
    fn empty() -> T;
}

impl Empty<RECT> for RECT {
    fn empty() -> RECT {
        RECT{left: 0, top: 0, right: 0, bottom: 0}
    }
}

fn main() {
    let rect = RECT::empty();
    println!("{:?}", rect);
}
```

It seems a little more transparent, and there's no clash with the name of the method. If you want to be a good citizen, the best way to deal with this is probably to just go and modify the crate you're using, adding `derive(Debug)` attributes to everything!

Thanks to joshtriplett and yohanesu75 for some extra info.
"""