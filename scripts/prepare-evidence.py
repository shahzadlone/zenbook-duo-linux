#!/usr/bin/env python3
"""Reproduce the documented evidence transformations; manual review remains required."""
import argparse
import hashlib
import io
import json
from pathlib import Path
import re


def redact_log(text):
    counts = {'credential_related_lines': 0, 'windows_user_paths': 0,
              'home_user_paths': 0, 'mac_addresses': 0}
    secret = re.compile(r'password|passphrase|secret|token|private.?key', re.I)
    lines = []
    for line in text.splitlines(keepends=True):
        if secret.search(line):
            prefix = re.match(r'^\d{4}-\d{2}-\d{2} - [0-9:]+ \[[0-9]+\]:', line)
            line = ((prefix.group(0) + ' ' if prefix else '')
                    + '[REDACTED credential-related log line; original retained privately]\n')
            counts['credential_related_lines'] += 1
        line, n = re.subn(r'C:\\Users\\[^\\\s]+\\',
                          lambda match: 'C:\\Users\\[LOCAL_USER]\\', line)
        counts['windows_user_paths'] += n
        line, n = re.subn(r'/home/(?!liveuser(?:/|\b))[^/\s"\']+/',
                          '/home/[LOCAL_USER]/', line)
        counts['home_user_paths'] += n
        line, n = re.subn(r'(?i)\b[0-9a-f]{2}(?::[0-9a-f]{2}){5}\b',
                          '[MAC_REDACTED]', line)
        counts['mac_addresses'] += n
        lines.append(line)
    return ''.join(lines).encode(), counts


def prepare_jpeg(data):
    try:
        from PIL import Image
    except ImportError as exc:
        raise ValueError('JPEG pixel verification requires Pillow; no files changed.') from exc
    if data[:2] != b'\xff\xd8':
        raise ValueError('Input is not a JPEG.')
    before = Image.open(io.BytesIO(data))
    if before.getexif().get(274, 1) != 1:
        raise ValueError('Non-normal EXIF orientation: requires a deliberate evidence-preservation decision.')
    result = bytearray(data[:2])
    pos = 2
    removed = []
    while pos < len(data):
        start = pos
        if data[pos] != 0xff:
            raise ValueError('Unexpected JPEG marker layout.')
        while pos < len(data) and data[pos] == 0xff:
            pos += 1
        if pos >= len(data):
            raise ValueError('Truncated JPEG marker.')
        marker = data[pos]
        pos += 1
        if marker == 0xda:
            result.extend(data[start:])
            break
        if marker in (0x01, 0xd8, 0xd9) or 0xd0 <= marker <= 0xd7:
            result.extend(data[start:pos])
            continue
        length = int.from_bytes(data[pos:pos + 2], 'big')
        if length < 2 or pos + length > len(data):
            raise ValueError('Invalid JPEG segment length.')
        end = pos + length
        if marker in (0xe1, 0xed, 0xfe):
            removed.append(hex(marker))
        else:
            result.extend(data[start:end])
        pos = end
    cleaned = bytes(result)
    sos = cleaned.find(b'\xff\xda')
    eoi = cleaned.find(b'\xff\xd9', sos)
    if sos < 0 or eoi < 0:
        raise ValueError('Missing primary JPEG scan or end marker.')
    trailing = len(cleaned) - (eoi + 2)
    cleaned = cleaned[:eoi + 2]
    after = Image.open(io.BytesIO(cleaned))
    if (before.size != after.size or before.mode != after.mode
            or before.tobytes() != after.tobytes()):
        raise ValueError('Primary pixel equality failed; no output written.')
    if after.getexif() or b'Exif\0\0' in cleaned or b'http://ns.adobe.com/xap/' in cleaned:
        raise ValueError('Metadata remains in an unsupported JPEG layout; no output written.')
    return cleaned, {'removed_markers': removed, 'trailing_bytes_removed': trailing,
                     'pixel_comparison': 'identical', 'size': list(after.size)}


def main():
    parser = argparse.ArgumentParser(description=__doc__, epilog=(
        'Log filters are deliberately conservative but incomplete. Review every output before '
        'publication. JPEG handling preserves primary pixels; auxiliary/HDR data is removed.'))
    parser.add_argument('kind', choices=['log', 'jpeg'])
    parser.add_argument('source', type=Path)
    parser.add_argument('destination', type=Path)
    args = parser.parse_args()
    if args.source.resolve() == args.destination.resolve() or args.destination.exists():
        parser.error('Destination must be a new file distinct from the original.')
    original = args.source.read_bytes()
    try:
        if args.kind == 'log':
            prepared, details = redact_log(original.decode('utf-8', errors='replace'))
        else:
            prepared, details = prepare_jpeg(original)
    except ValueError as exc:
        parser.error(str(exc))
    args.destination.parent.mkdir(parents=True, exist_ok=True)
    with args.destination.open('xb') as output:
        output.write(prepared)
    print(json.dumps({'source_sha256': hashlib.sha256(original).hexdigest(),
                      'sha256': hashlib.sha256(prepared).hexdigest(),
                      'bytes': len(prepared), 'details': details,
                      'manual_review_required': True}, indent=2))


if __name__ == '__main__':
    main()
