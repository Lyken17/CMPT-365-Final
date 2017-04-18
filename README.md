# CMPT-365-Final

# how to use
Load `scr` folder in matlab, then run.

# external libraries 
* built-in function `VideoReader` to extract frame from video.

# algorithms details
We implemented the algorithm by following the GIF standard `GIF89a`. The spefication document we refers is [w3 GIF89a specifics](https://www.w3.org/Graphics/GIF/spec-gif89a.txt). Also, we get a lot of help from the intuitive explanation by [3MF project](http://www.matthewflickinger.com/lab/whatsinagif/bits_and_bytes.asp).

Overall structure, we ignore , `Comment Extension`, `Plain Text Extension`, `Local Color Lookup Table`.

## Header Block  

## Logicl Screnn Descriptor

## Global Color Table
R:3
G:3
B:2

## Graphical Control Extension
Time delay -- video time / frame


## Image Descriptor

## Application Extension
NETSCAPE 2.0

## Image Data
LZW 

[w3 GIF89a specifics](https://www.w3.org/Graphics/GIF/spec-gif89a.txt)
[What's In A GIF - Bit by Byte](http://www.matthewflickinger.com/lab/whatsinagif/bits_and_bytes.asp)
