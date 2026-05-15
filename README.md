# Face Detection & PDF Generator

Detect human faces in images using Apple's Vision framework, and generate an A4 PDF from the results.

## Features

- Batch scan images to identify those containing human faces
- Generate a multi-page A4 PDF with auto-scaled, centered images
- Pure Swift + system frameworks — zero external dependencies

## Requirements

- macOS 14.0+
- Swift 5.9+ (bundled with macOS)
- Frameworks: Vision, AppKit, CoreGraphics (all system-provided, no installation needed)

## Quick Start

```bash
# One-liner: detect faces and generate PDF
swift src/detect_faces.swift && swift src/create_pdf.swift
```

## Usage

### 1. Prepare Images

Place your images in the `picture/` directory. Both JPG and PNG formats are supported.

### 2. Detect Faces

```bash
swift src/detect_faces.swift
```

Scans all images under `picture/`, detects faces in each, and writes filenames of images containing faces to `person_images.txt`.

### 3. Generate PDF

```bash
swift src/create_pdf.swift
```

Reads `person_images.txt` and composes the images into a multi-page A4 PDF, output as `person.pdf`.

## Project Structure

```
├── picture/                # Input images
├── src/
│   ├── detect_faces.swift  # Face detection script
│   └── create_pdf.swift    # PDF generation script
├── person_images.txt       # Detection results (auto-generated)
└── person.pdf              # Output PDF (auto-generated)
```

## How It Works

- **detect_faces.swift** — Uses `VNDetectFaceRectanglesRequest` to detect faces in each image and filters out images with one or more faces.
- **create_pdf.swift** — Creates a PDF via `CGContext`, laying out each image on an A4 page (595×842 pt) with proportional scaling, centered placement, and 40pt margins.

## License

MIT
