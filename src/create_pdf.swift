import AppKit
import Foundation

let baseDir = FileManager.default.currentDirectoryPath
let pictureDir = baseDir + "/picture"
let listFile = baseDir + "/person_images.txt"
let outPath = baseDir + "/person.pdf"
let outURL = URL(fileURLWithPath: outPath) as CFURL

// Read the list of person images
let content = try String(contentsOfFile: listFile, encoding: .utf8)
let files = content.components(separatedBy: "\n").filter { !$0.isEmpty }

guard !files.isEmpty else {
    print("ERROR: no images listed in person_images.txt")
    exit(1)
}

let pageWidth: CGFloat = 595
let pageHeight: CGFloat = 842
var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

guard let ctx = CGContext(outURL, mediaBox: &mediaBox, nil) else {
    print("ERROR: cannot create PDF context")
    exit(1)
}

for file in files {
    let path = pictureDir + "/" + file
    guard let img = NSImage(contentsOfFile: path) else {
        print("SKIP: cannot load \(file)")
        continue
    }

    let rep = img.representations.first!
    let imgSize = NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)

    let margin: CGFloat = 40
    let maxW = pageWidth - 2 * margin
    let maxH = pageHeight - 2 * margin
    let scale = min(maxW / imgSize.width, maxH / imgSize.height)
    let drawW = imgSize.width * scale
    let drawH = imgSize.height * scale
    let x = (pageWidth - drawW) / 2
    let y = (pageHeight - drawH) / 2

    ctx.beginPage(mediaBox: &mediaBox)
    let rect = CGRect(x: x, y: y, width: drawW, height: drawH)

    if let cgImg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        ctx.draw(cgImg, in: rect)
    }
    ctx.endPage()
}

ctx.closePDF()
print("OK: person.pdf created with \(files.count) images")
