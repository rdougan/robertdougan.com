// Renders the "dougan" wordmark to a PNG using CoreText.
//
// Requires macOS (Helvetica Neue ships with the OS at
// /System/Library/Fonts/HelveticaNeue.ttc).
//
// Build:  swiftc -O render.swift -o render
// List the available Helvetica Neue faces:
//         ./render list
// Render: ./render <postscriptName> <xHeightPx> <trackingEm> <out.png> <fgHex> <bgHex|none> <paddingPx>
//
// The PNGs in this folder were produced with:
//   ./render HelveticaNeue-CondensedBold 780 -0.01 dougan-logo-white.png ffffff none 200
//   ./render HelveticaNeue-CondensedBold 780 -0.01 dougan-logo-black.png 000000 none 200

import Foundation
import CoreText
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let a = CommandLine.arguments

if a.count > 1 && a[1] == "list" {
  let url = URL(fileURLWithPath: "/System/Library/Fonts/HelveticaNeue.ttc") as CFURL
  if let ds = CTFontManagerCreateFontDescriptorsFromURL(url) as? [CTFontDescriptor] {
    for d in ds { print(CTFontDescriptorCopyAttribute(d, kCTFontNameAttribute) as! String) }
  }
  exit(0)
}

guard a.count == 8 else {
  print("usage: render <psname> <xHeightPx> <trackingEm> <out.png> <fgHex> <bgHex|none> <paddingPx>")
  exit(1)
}

let name = a[1]
let xHeight = Double(a[2])!
let tracking = Double(a[3])!
let out = a[4]
let fg = a[5]
let bg = a[6]
let pad = Double(a[7])!

func color(_ hex: String) -> CGColor {
  let v = UInt32(hex, radix: 16)!
  return CGColor(red: CGFloat((v >> 16) & 255) / 255,
                 green: CGFloat((v >> 8) & 255) / 255,
                 blue: CGFloat(v & 255) / 255,
                 alpha: 1)
}

// Size the font so the lowercase x-height is exactly `xHeight` pixels.
let probe = CTFontCreateWithName(name as CFString, 100, nil)
let size = 100.0 * xHeight / Double(CTFontGetXHeight(probe))
let font = CTFontCreateWithName(name as CFString, CGFloat(size), nil)

let attrs: [NSAttributedString.Key: Any] = [
  NSAttributedString.Key(kCTFontAttributeName as String): font,
  NSAttributedString.Key(kCTKernAttributeName as String): tracking * size,
  NSAttributedString.Key(kCTForegroundColorAttributeName as String): color(fg),
]
let line = CTLineCreateWithAttributedString(NSAttributedString(string: "dougan", attributes: attrs))
let ink = CTLineGetImageBounds(line, nil)

let width = Int(ceil(ink.width + 2 * pad))
let height = Int(ceil(ink.height + 2 * pad))
let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpace(name: CGColorSpace.sRGB)!,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

if bg != "none" {
  ctx.setFillColor(color(bg))
  ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
}
ctx.setShouldAntialias(true)
ctx.setShouldSmoothFonts(false)
ctx.textPosition = CGPoint(x: pad - ink.minX, y: pad - ink.minY)
CTLineDraw(line, ctx)

let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: out) as CFURL,
                                           UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!,
                           [kCGImagePropertyDPIWidth: 300.0, kCGImagePropertyDPIHeight: 300.0] as CFDictionary)
CGImageDestinationFinalize(dest)
print("\(out) \(width)x\(height) fontSize=\(size)")
