#!/usr/bin/env python3
"""Process gallery photos: resize, watermark, create thumbnails."""

from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

WATERMARK = "© Nikhil Bastikar"
FULL_MAX = 2400
THUMB_MAX = 480
JPEG_QUALITY = 92


def load_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/Library/Fonts/Arial.ttf",
    ]
    for path in candidates:
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def add_watermark(img: Image.Image) -> Image.Image:
    base = img.convert("RGBA")
    overlay = Image.new("RGBA", base.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    width, height = base.size
    font_size = max(11, width // 90)
    font = load_font(font_size)
    bbox = draw.textbbox((0, 0), WATERMARK, font=font)
    text_w = bbox[2] - bbox[0]
    text_h = bbox[3] - bbox[1]
    margin = max(10, width // 120)
    x = width - text_w - margin
    y = height - text_h - margin

    # Subtle watermark — readable but not dominant
    draw.text((x + 1, y + 1), WATERMARK, font=font, fill=(0, 0, 0, 45))
    draw.text((x, y), WATERMARK, font=font, fill=(255, 255, 255, 72))

    return Image.alpha_composite(base, overlay).convert("RGB")


def resize_max(img: Image.Image, max_dim: int, allow_upscale: bool = False) -> Image.Image:
    w, h = img.size
    if max(w, h) <= max_dim:
        return img if allow_upscale else img.copy()
    if w >= h:
        new_w = max_dim
        new_h = round(h * max_dim / w)
    else:
        new_h = max_dim
        new_w = round(w * max_dim / h)
    return img.resize((new_w, new_h), Image.Resampling.LANCZOS)


def process_source(src: Path, dst_dir: Path, slug: str) -> tuple[Path, Path]:
    img = Image.open(src)
    # Never upscale — keeps native sharpness from the source file
    img = resize_max(img, FULL_MAX, allow_upscale=False)
    img = add_watermark(img)

    full_path = dst_dir / f"{slug}.jpg"
    thumb_path = dst_dir / f"{slug}-thumb.jpg"
    img.save(full_path, "JPEG", quality=JPEG_QUALITY, optimize=True)

    thumb = resize_max(img, THUMB_MAX, allow_upscale=False)
    thumb.save(thumb_path, "JPEG", quality=85, optimize=True)
    return full_path, thumb_path


def main() -> int:
    if len(sys.argv) != 4:
        print("Usage: process_photos.py <manifest.json> <src_dir> <dst_dir>", file=sys.stderr)
        return 1

    manifest_path = Path(sys.argv[1])
    src_dir = Path(sys.argv[2])
    dst_dir = Path(sys.argv[3])
    dst_dir.mkdir(parents=True, exist_ok=True)

    entries = json.loads(manifest_path.read_text())
    for entry in entries:
        src = src_dir / entry["src"]
        if not src.exists():
            print(f"MISSING {src}")
            continue
        process_source(src, dst_dir, entry["slug"])
        print(f"OK {entry['slug']}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
