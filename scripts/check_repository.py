#!/usr/bin/env python3
"""Validate documentation and recorded evidence, not laptop behavior."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
errors = []
excluded = {'.git', '.local', '__pycache__', 'node_modules', 'target'}
files = [p for p in ROOT.rglob('*') if p.is_file()
         and not any(part in excluded for part in p.relative_to(ROOT).parts)
         and not p.relative_to(ROOT).as_posix().startswith('logs/incoming/')]

for path in files:
    rel = path.relative_to(ROOT)
    if path.suffix == '.json':
        try:
            json.loads(path.read_text())
        except (ValueError, UnicodeError) as exc:
            errors.append(f'{rel}: invalid JSON: {exc}')
    if path.suffix == '.md':
        for target in re.findall(r'\[[^\]]*\]\(([^)]+)\)', path.read_text()):
            target = target.strip().split(' "', 1)[0].strip('<>')
            parsed = urlsplit(target)
            if parsed.scheme or target.startswith('#'):
                continue
            local = unquote(parsed.path)
            if not local:
                continue
            if local.startswith('/'):
                errors.append(f'{rel}: non-portable absolute link: {local}')
            elif not (path.parent / local).exists():
                errors.append(f'{rel}: missing link target: {local}')

manifest_path = ROOT / 'evidence/manifest.json'
if not manifest_path.exists():
    errors.append('Missing evidence manifest')
else:
    manifest = json.loads(manifest_path.read_text())
    for entry in manifest['artifacts']:
        path = ROOT / entry['path']
        if not path.is_file():
            errors.append(f'Missing evidence: {entry["path"]}')
            continue
        if hashlib.sha256(path.read_bytes()).hexdigest() != entry['sha256']:
            errors.append(f'Evidence hash mismatch: {entry["path"]}')
        if path.suffix.lower() == '.jpg':
            data = path.read_bytes()
            if b'Exif\x00\x00' in data or b'http://ns.adobe.com/xap/' in data:
                errors.append(f'Unexpected EXIF/XMP metadata: {entry["path"]}')

tracked = subprocess.run(['git', 'ls-files', '-z'], cwd=ROOT,
                         capture_output=True, check=True).stdout.split(b'\0')
for item in tracked:
    if not item:
        continue
    rel = item.decode()
    if rel.startswith(('.local/', 'evidence/private/')) or (
            rel.startswith('logs/incoming/') and not rel.endswith('/.gitkeep')):
        errors.append(f'Private raw path tracked: {rel}')
    if any(part in {'target', 'node_modules', '__pycache__'} for part in Path(rel).parts):
        errors.append(f'Build/cache file tracked: {rel}')
    path = ROOT / rel
    if path.is_file() and path.suffix.lower() not in {'.jpg', '.png'}:
        data = path.read_text(errors='replace')
        if re.search(r'-----BEGIN (?:OPENSSH|RSA|EC|DSA) PRIVATE KEY-----', data):
            errors.append(f'Private-key material: {rel}')

if errors:
    print('\n'.join(errors), file=sys.stderr)
    sys.exit(1)
print(f'PASS: {len(files)} files checked; JSON, Markdown targets, evidence hashes and tracked-path checks passed.')
print('These checks do not certify log redaction completeness or hardware stability.')
