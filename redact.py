#!/usr/bin/env python3
"""Print a JSON file with secret-looking values replaced by "<REDACTED>".
Usage: redact.py FILE  (or '-' for stdin). Non-JSON input is passed through unchanged."""
import json, re, sys

KEY_RE = re.compile(r"(key|token|secret|password|passwd|credential|bearer|cookie|session|auth)", re.I)
VAL_RE = re.compile(r"^(sk-|ghp_|gho_|github_pat_|xox[abp]-|AKIA|AIza|Bearer |eyJ[A-Za-z0-9_-]{10,}\.)")
HEX_RE = re.compile(r"^[A-Fa-f0-9]{40,}$")
SAFE_KEYS = {"authType", "auth_type", "oauth"}  # structural keys whose values are not secrets


def redact(obj, key=None):
    if isinstance(obj, dict):
        return {k: redact(v, k) for k, v in obj.items()}
    if isinstance(obj, list):
        return [redact(v, key) for v in obj]
    if isinstance(obj, str):
        if key and key not in SAFE_KEYS and KEY_RE.search(key) and obj and not obj.lower() in ("true", "false", "none", "oauth"):
            return "<REDACTED>"
        if VAL_RE.match(obj) or (HEX_RE.match(obj) and len(obj) >= 40):
            return "<REDACTED>"
        # env-style "FOO_API_KEY=xxx" inside strings (e.g. in args)
        return re.sub(r"((?:KEY|TOKEN|SECRET|PASSWORD)=)[^\s\"']+", r"\1<REDACTED>", obj, flags=re.I)
    return obj


src = sys.stdin if len(sys.argv) < 2 or sys.argv[1] == "-" else open(sys.argv[1], encoding="utf-8")
text = src.read()
try:
    print(json.dumps(redact(json.loads(text)), indent=2))
except json.JSONDecodeError:
    sys.stdout.write(text)
