# Bulk HEIC to JPG Converter for Windows

A simple Windows batch workflow to convert a folder of HEIC photos to
high-quality JPG images using ImageMagick.

Conversion happens locally on your computer. Photos are not uploaded.

## Features

- Bulk converts `.heic` files in a selected folder.
- Keeps original HEIC files untouched.
- Saves converted images in a separate `JPG` subfolder.
- Uses maximum JPEG quality and 4:4:4 chroma sampling.
- Keeps image resolution without resizing.
- Applies orientation so photos display correctly.
- Copies original file creation and modification dates where possible.
- Skips JPG files that already exist.
- Reports conversion failures.

## Important limitations

JPEG uses lossy compression, even at quality 100. This workflow cannot
produce an exact, lossless copy of a HEIC image.

- HDR, high bit depth, transparency, depth information, and auxiliary images
  cannot all be represented in a standard JPG.
- Only the first image exposed by ImageMagick is converted.
- Color and brightness can differ, especially with HDR photos.
- EXIF, GPS, and other metadata are retained only where ImageMagick supports
  reading and writing them. Complete metadata preservation is not guaranteed.
- File dates are copied separately; this does not guarantee that every
  embedded photo date is preserved.
- Subfolders are not processed.
- Large images at quality 100 may produce large JPG files.

Keep your original HEIC files if preserving everything matters.

## Requirements

- Windows 10 or Windows 11.
- Windows PowerShell.
- ImageMagick 7 with HEIC decoding support.

## 1. Install ImageMagick

Open Windows Terminal or PowerShell and run:

```powershell
winget install --id ImageMagick.ImageMagick -e
```

Complete any installation prompts. Close and reopen Terminal afterward.

Check the installation:

```powershell
magick -version
```

Check HEIC support:

```powershell
magick -list format | findstr /I HEIC
```

The HEIC entry should include read support (`r`).

If `winget` is unavailable, download ImageMagick from:

https://imagemagick.org/script/download.php#windows

During installation, enable the option to add ImageMagick to your system PATH.

## 2. Download this project

On the GitHub repository page:

1. Click **Code → Download ZIP**.
2. Extract the ZIP file.
3. Locate `Convert-HEIC.bat`.

## 3. Convert your photos

### Option A: Drag and drop

Drag the folder containing your HEIC photos onto `Convert-HEIC.bat`.

### Option B: Enter a folder path

Double-click `Convert-HEIC.bat`, then paste your photo folder path:

```text
C:\Users\YourName\Pictures\HEIC Photos
```

### Option C: Run from Command Prompt

```bat
Convert-HEIC.bat "C:\Users\YourName\Pictures\HEIC Photos"
```

Wait for the completion message and check for any reported failures.

## Output example

Before:

```text
HEIC Photos/
├── IMG_0001.HEIC
└── IMG_0002.HEIC
```

After:

```text
HEIC Photos/
├── IMG_0001.HEIC
├── IMG_0002.HEIC
└── JPG/
    ├── IMG_0001.jpg
    └── IMG_0002.jpg
```

Original HEIC files remain in place.

If a matching JPG already exists, the script skips it. To retry that image,
move the existing JPG elsewhere and run the script again.

## Recommended first run

Convert a small test folder first. Check:

- Image appearance and orientation.
- Image dimensions.
- Photo metadata you need.
- File creation and modification dates.

## Troubleshooting

### “ImageMagick is required” or “magick is not recognized”

Install ImageMagick, then close and reopen Terminal and the BAT file.
If necessary, reinstall ImageMagick with its PATH option enabled.

### “No decode delegate” or HEIC decoding fails

Your ImageMagick installation may lack HEIC support.
Install a current Windows build with HEIC decoding support.

### No images are converted

Confirm that the selected folder contains `.heic` files directly.
The script does not search subfolders or convert `.heif` files.

### A photo has different brightness or colors

HEIC can contain HDR and color information that standard JPG cannot fully
represent. Keep the original HEIC for its full image information.

### A file fails to convert

Check the error shown in the conversion window. Confirm that the source
file opens normally and that the destination drive has enough free space.

## Privacy

The BAT script processes photos locally and contains no upload commands.
Installing ImageMagick requires an internet connection.

Converted photos may retain sensitive metadata, including GPS locations.
Review metadata before sharing photos publicly.