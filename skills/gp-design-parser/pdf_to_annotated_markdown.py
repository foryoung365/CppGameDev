#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "pymupdf>=1.24,<2.0",
# ]
# ///

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from datetime import datetime
from html import escape
from pathlib import Path
from typing import Iterable

import fitz


DEFAULT_MIN_FILL_AREA = 40.0
DEFAULT_MIN_BG_OVERLAP = 0.2

NAMED_COLORS: list[tuple[str, tuple[int, int, int]]] = [
    ("black", (0, 0, 0)),
    ("white", (255, 255, 255)),
    ("gray", (128, 128, 128)),
    ("dark-gray", (51, 51, 51)),
    ("light-gray", (153, 153, 153)),
    ("red", (255, 0, 0)),
    ("green", (0, 128, 0)),
    ("blue", (0, 0, 255)),
    ("yellow", (255, 255, 0)),
    ("orange", (255, 165, 0)),
    ("purple", (128, 0, 128)),
    ("cyan", (0, 255, 255)),
    ("magenta", (255, 0, 255)),
]


@dataclass(frozen=True)
class ColorInfo:
    rgb: tuple[int, int, int]
    hex_code: str
    label: str


@dataclass(frozen=True)
class ColorRegion:
    rect: fitz.Rect
    color: ColorInfo
    source: str


@dataclass
class SpanSegment:
    text: str
    fg: ColorInfo | None
    bg: ColorInfo | None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="将 PDF 转换为带颜色标注的 Markdown，保留文字前景色与背景填充色信息。"
    )
    parser.add_argument("--input", type=Path, required=True, help="输入 PDF 文件路径。")
    parser.add_argument(
        "--output",
        type=Path,
        help="输出 Markdown 文件路径。默认与输入文件同目录，文件名追加 .annotated.md。",
    )
    parser.add_argument(
        "--min-fill-area",
        type=float,
        default=DEFAULT_MIN_FILL_AREA,
        help=f"识别背景填充色时的最小矩形面积，默认 {DEFAULT_MIN_FILL_AREA}。",
    )
    parser.add_argument(
        "--min-bg-overlap",
        type=float,
        default=DEFAULT_MIN_BG_OVERLAP,
        help=f"文本框与填充矩形的最小重叠比例，默认 {DEFAULT_MIN_BG_OVERLAP}。",
    )
    parser.add_argument(
        "--mark-neutral-fg",
        action="store_true",
        help="默认仅标注彩色前景文字；指定后连黑、灰等中性色前景也一起标注。",
    )
    parser.add_argument(
        "--no-page-summary",
        action="store_true",
        help="不在每页前输出颜色摘要。",
    )
    return parser.parse_args()


def rgb_to_hex(rgb: tuple[int, int, int]) -> str:
    return "#" + "".join(f"{channel:02x}" for channel in rgb)


def normalize_rgb(rgb: Iterable[float | int]) -> tuple[int, int, int]:
    values = list(rgb)[:3]
    if not values:
        return (0, 0, 0)

    if any(isinstance(v, float) and 0.0 <= v <= 1.0 for v in values):
        scaled = [int(round(max(0.0, min(1.0, float(v))) * 255)) for v in values]
        return (scaled[0], scaled[1], scaled[2])

    ints = [int(v) for v in values]
    return (max(0, min(255, ints[0])), max(0, min(255, ints[1])), max(0, min(255, ints[2])))


def int_color_to_rgb(color_value: int) -> tuple[int, int, int]:
    return ((color_value >> 16) & 255, (color_value >> 8) & 255, color_value & 255)


def classify_color(rgb: tuple[int, int, int]) -> ColorInfo:
    hex_code = rgb_to_hex(rgb)
    best_name = None
    best_distance = None

    for name, sample in NAMED_COLORS:
        distance = sum((rgb[idx] - sample[idx]) ** 2 for idx in range(3))
        if best_distance is None or distance < best_distance:
            best_distance = distance
            best_name = name

    if best_name is None:
        label = hex_code
    elif best_distance is not None and best_distance <= 900:
        label = f"{best_name}({hex_code})"
    else:
        label = hex_code

    return ColorInfo(rgb=rgb, hex_code=hex_code, label=label)


def is_neutral_color(rgb: tuple[int, int, int], tolerance: int = 18) -> bool:
    return abs(rgb[0] - rgb[1]) <= tolerance and abs(rgb[1] - rgb[2]) <= tolerance


def is_effectively_white(rgb: tuple[int, int, int], threshold: int = 245) -> bool:
    return all(channel >= threshold for channel in rgb)


def build_output_path(input_path: Path, output_path: Path | None) -> Path:
    if output_path is not None:
        return output_path
    return input_path.with_name(f"{input_path.stem}.annotated.md")


def collect_fill_regions(
    page: fitz.Page,
    min_fill_area: float,
) -> list[ColorRegion]:
    regions: list[ColorRegion] = []

    for drawing in page.get_drawings():
        fill = drawing.get("fill")
        rect = drawing.get("rect")
        fill_opacity = drawing.get("fill_opacity") or 0.0
        if fill is None or rect is None or fill_opacity <= 0:
            continue

        if rect.get_area() < min_fill_area:
            continue

        if min(rect.width, rect.height) < 3:
            continue

        rgb = normalize_rgb(fill)
        if is_effectively_white(rgb):
            continue

        regions.append(ColorRegion(rect=rect, color=classify_color(rgb), source="drawing"))

    for annot in page.annots() or []:
        annot_type = (annot.type[1] or "").lower()
        if "highlight" not in annot_type and "underline" not in annot_type:
            continue

        colors = annot.colors or {}
        stroke = colors.get("stroke")
        if stroke is None:
            continue

        color = classify_color(normalize_rgb(stroke))
        for quad in annot.vertices or []:
            if len(quad) != 4:
                continue
            rect = fitz.Quad(quad).rect
            if rect.get_area() < min_fill_area:
                continue
            regions.append(ColorRegion(rect=rect, color=color, source="annotation"))

    return regions


def match_background(
    span_rect: fitz.Rect,
    regions: list[ColorRegion],
    min_bg_overlap: float,
) -> ColorInfo | None:
    best_color = None
    best_ratio = 0.0
    area = span_rect.get_area()
    if area <= 0:
        return None

    for region in regions:
        overlap = span_rect & region.rect
        if overlap.is_empty:
            continue

        ratio = overlap.get_area() / area
        if ratio < min_bg_overlap:
            continue

        if ratio > best_ratio:
            best_ratio = ratio
            best_color = region.color

    return best_color


def should_mark_foreground(color: ColorInfo, mark_neutral_fg: bool) -> bool:
    if mark_neutral_fg:
        return True
    return not is_neutral_color(color.rgb)


def merge_segments(segments: list[SpanSegment]) -> list[SpanSegment]:
    if not segments:
        return []

    merged: list[SpanSegment] = [segments[0]]
    for segment in segments[1:]:
        prev = merged[-1]
        if prev.fg == segment.fg and prev.bg == segment.bg:
            prev.text += segment.text
        else:
            merged.append(segment)
    return merged


def format_segment(segment: SpanSegment) -> str:
    text = escape(segment.text)
    attrs: list[str] = []
    if segment.fg is not None:
        attrs.append(f'fg="{segment.fg.label}"')
    if segment.bg is not None:
        attrs.append(f'bg="{segment.bg.label}"')

    if not attrs:
        return text

    return f'[color {" ".join(attrs)}]{text}[/color]'


def render_page(
    page: fitz.Page,
    regions: list[ColorRegion],
    min_bg_overlap: float,
    mark_neutral_fg: bool,
    show_page_summary: bool,
) -> str:
    data = page.get_text("dict", sort=True)
    block_groups: list[list[str]] = []
    fg_counter: Counter[str] = Counter()
    bg_counter: Counter[str] = Counter(region.color.label for region in regions)

    for block in data.get("blocks", []):
        if block.get("type") != 0:
            continue

        block_output: list[str] = []
        for line in block.get("lines", []):
            segments: list[SpanSegment] = []
            for span in line.get("spans", []):
                text = span.get("text", "")
                if not text:
                    continue

                span_rect = fitz.Rect(span["bbox"])
                fg_color = classify_color(int_color_to_rgb(span.get("color", 0)))
                bg_color = match_background(span_rect, regions, min_bg_overlap)

                fg_marker = fg_color if should_mark_foreground(fg_color, mark_neutral_fg) else None
                if fg_marker is not None:
                    fg_counter[fg_marker.label] += 1

                if bg_color is not None:
                    bg_counter[bg_color.label] += 0

                segments.append(SpanSegment(text=text, fg=fg_marker, bg=bg_color))

            merged = merge_segments(segments)
            rendered = "".join(format_segment(segment) for segment in merged).strip()
            if rendered:
                block_output.append(rendered)

        if block_output:
            block_groups.append(block_output)

    page_lines: list[str] = [f"## Page {page.number + 1}", ""]

    if show_page_summary:
        page_lines.append("- Colors:")
        if bg_counter:
            bg_desc = ", ".join(f"`{label}` x{count}" for label, count in sorted(bg_counter.items()))
            page_lines.append(f"  - background fills: {bg_desc}")
        else:
            page_lines.append("  - background fills: none")

        if fg_counter:
            fg_desc = ", ".join(f"`{label}` x{count}" for label, count in sorted(fg_counter.items()))
            page_lines.append(f"  - marked foregrounds: {fg_desc}")
        else:
            page_lines.append("  - marked foregrounds: none")

        page_lines.append("")

    for block_output in block_groups:
        page_lines.extend(block_output)
        page_lines.append("")

    while page_lines and not page_lines[-1]:
        page_lines.pop()

    page_lines.append("")
    return "\n".join(page_lines)


def render_document(
    input_path: Path,
    output_path: Path,
    doc: fitz.Document,
    min_fill_area: float,
    min_bg_overlap: float,
    mark_neutral_fg: bool,
    show_page_summary: bool,
) -> str:
    lines = [
        f"# {input_path.stem} 颜色标注 Markdown",
        "",
        f"- Source: `{input_path}`",
        f"- Pages: `{doc.page_count}`",
        f"- Generated: `{datetime.now().isoformat(timespec='seconds')}`",
        f"- Output: `{output_path}`",
        "",
        "## 标注语法",
        "",
        "- 前景色：`[color fg=\"red(#ff0000)\"]文本[/color]`",
        "- 背景色：`[color bg=\"yellow(#ffff00)\"]文本[/color]`",
        "- 前景 + 背景：`[color fg=\"red(#ff0000)\" bg=\"yellow(#ffff00)\"]文本[/color]`",
        "",
        "## 内容",
        "",
    ]

    for page_number in range(doc.page_count):
        page = doc.load_page(page_number)
        regions = collect_fill_regions(page, min_fill_area=min_fill_area)
        lines.append(
            render_page(
                page=page,
                regions=regions,
                min_bg_overlap=min_bg_overlap,
                mark_neutral_fg=mark_neutral_fg,
                show_page_summary=show_page_summary,
            )
        )

    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    args = parse_args()
    input_path = args.input.resolve()
    output_path = build_output_path(input_path, args.output.resolve() if args.output else None)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    if not input_path.exists():
        raise FileNotFoundError(f"输入文件不存在：{input_path}")

    with fitz.open(input_path) as doc:
        markdown = render_document(
            input_path=input_path,
            output_path=output_path,
            doc=doc,
            min_fill_area=args.min_fill_area,
            min_bg_overlap=args.min_bg_overlap,
            mark_neutral_fg=args.mark_neutral_fg,
            show_page_summary=not args.no_page_summary,
        )

    output_path.write_text(markdown, encoding="utf-8")
    print(output_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
