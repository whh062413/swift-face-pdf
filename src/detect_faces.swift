import Vision
import AppKit
import Foundation

let pictureDir = FileManager.default.currentDirectoryPath + "/picture"
let outputFile = FileManager.default.currentDirectoryPath + "/person_images.txt"

let fm = FileManager.default
let files = try fm.contentsOfDirectory(atPath: pictureDir).filter {
    $0.lowercased().hasSuffix(".jpg") || $0.lowercased().hasSuffix(".jpeg") || $0.lowercased().hasSuffix(".png")
}

let detectRequest = VNDetectFaceRectanglesRequest()
var personFiles: [String] = []

for file in files.sorted() {
    let path = pictureDir + "/" + file
    guard let img = NSImage(contentsOfFile: path),
          let cgImg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        print("SKIP: \(file)")
        continue
    }
    let handler = VNImageRequestHandler(cgImage: cgImg, options: [:])
    try handler.perform([detectRequest])
    let count = detectRequest.results?.count ?? 0
    print("\(count > 0 ? "PERSON" : "NOPE  "): \(file) (\(count) faces)")
    if count > 0 {
        personFiles.append(file)
    }
}

// Write person image filenames to file
let content = personFiles.joined(separator: "\n")
try content.write(toFile: outputFile, atomically: true, encoding: .utf8)
print("\n\(personFiles.count) person images written to person_images.txt")
