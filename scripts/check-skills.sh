#!/usr/bin/env bash
# scripts/check-skills.sh — validate skill manifests, frontmatter, and policy parity.
# Pure stdlib Python. No external dependencies.
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 is required (not found in PATH)" >&2
  exit 2
fi

python3 - <<'PY'
import json, os, re, sys

errors = []

EXPECTED_SKILLS = {
    "worldjen-install": {"deprecated": False, "destructive": False},
    "worldjen-runner": {"deprecated": False, "destructive": True},
    "worldjen-bench": {"deprecated": False, "destructive": True},
    "worldjen-score": {"deprecated": False, "destructive": True},
    "worldjen-rank": {"deprecated": False, "destructive": True},
    "worldjen-leaderboard": {"deprecated": False, "destructive": False},
    "worldjen-update": {"deprecated": False, "destructive": False},
}


def load_json(path):
    with open(path) as f:
        return json.load(f)


def parse_value(raw):
    """Coerce a raw YAML scalar string to bool/int/None/str. Strips quotes and trailing comments."""
    # Strip trailing inline comment (` # comment` only when not inside quotes — we only support unquoted scalars here for simplicity)
    s = raw.strip()
    if " #" in s and not (s.startswith('"') or s.startswith("'")):
        s = s.split(" #", 1)[0].rstrip()
    if s == "" or s.lower() in ("null", "~"):
        return None
    # YAML 1.1 booleans
    if s.lower() in ("true", "yes", "on"):
        return True
    if s.lower() in ("false", "no", "off"):
        return False
    if (s.startswith('"') and s.endswith('"')) or (s.startswith("'") and s.endswith("'")):
        return s[1:-1]
    return s


def parse_flat_yaml(text):
    """Parse a flat YAML mapping (no nesting, no lists). Returns dict."""
    result = {}
    for line in text.splitlines():
        line = line.rstrip()
        if not line or line.lstrip().startswith("#"):
            continue
        if ":" not in line:
            return None  # malformed
        key, _, raw = line.partition(":")
        result[key.strip()] = parse_value(raw)
    return result


def parse_two_level_yaml(text):
    """Parse a 2-level YAML mapping (top-level keys with indented children).
    No lists, no deeper nesting, no multiline strings. Returns dict-of-dicts and dict-of-scalars."""
    result = {}
    current_section = None
    for line in text.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if not line.startswith(" ") and not line.startswith("\t"):
            # top-level
            if ":" not in line:
                return None
            key, _, raw = line.partition(":")
            key = key.strip()
            raw_stripped = raw.strip()
            if raw_stripped == "":
                # section header
                result[key] = {}
                current_section = key
            else:
                result[key] = parse_value(raw)
                current_section = None
        else:
            # indented child
            if current_section is None:
                return None
            stripped = line.strip()
            if ":" not in stripped:
                return None
            k, _, v = stripped.partition(":")
            result[current_section][k.strip()] = parse_value(v)
    return result


# 1. Manifests
try:
    cp = load_json(".claude-plugin/plugin.json")
except Exception as e:
    errors.append(f".claude-plugin/plugin.json: {e}")
    cp = {}
try:
    cm = load_json(".claude-plugin/marketplace.json")
except Exception as e:
    errors.append(f".claude-plugin/marketplace.json: {e}")
    cm = {}
try:
    cxp = load_json(".codex-plugin/plugin.json")
except Exception as e:
    errors.append(f".codex-plugin/plugin.json: {e}")
    cxp = {}

if not isinstance(cp, dict) or cp.get("name") != "worldjen":
    errors.append(f".claude-plugin/plugin.json: name should be 'worldjen', got {cp.get('name') if isinstance(cp, dict) else cp!r}")

mp_plugins = cm.get("plugins") if isinstance(cm, dict) else None
if not isinstance(mp_plugins, list):
    errors.append(".claude-plugin/marketplace.json: 'plugins' must be a JSON array")
    mp_plugins = []
if not any(isinstance(p, dict) and p.get("name") == "worldjen" for p in mp_plugins):
    errors.append(".claude-plugin/marketplace.json: no plugin named 'worldjen'")

if not isinstance(cxp, dict) or cxp.get("name") != "worldjen":
    errors.append(f".codex-plugin/plugin.json: name should be 'worldjen', got {cxp.get('name') if isinstance(cxp, dict) else cxp!r}")
if not isinstance(cxp, dict) or cxp.get("skills") not in ("./skills/", "./skills"):
    errors.append(f".codex-plugin/plugin.json: skills should be './skills/', got {cxp.get('skills') if isinstance(cxp, dict) else cxp!r}")
if not os.path.isdir("skills"):
    errors.append(".codex-plugin/plugin.json: skills/ directory does not exist")

# 2. Skill discovery — guard against missing skills/ dir
if not os.path.isdir("skills"):
    actual = []
else:
    actual = sorted(d for d in os.listdir("skills") if os.path.isdir(os.path.join("skills", d)))
expected = sorted(EXPECTED_SKILLS.keys())
if actual != expected:
    errors.append(f"skills/: expected {expected}, got {actual}")

FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
LINK_RE = re.compile(r"\[[^\]]*\]\(([^)]+)\)")

for name in actual:
    skill_dir = os.path.join("skills", name)
    skill_md = os.path.join(skill_dir, "SKILL.md")
    if not os.path.isfile(skill_md):
        errors.append(f"{skill_dir}: missing SKILL.md")
        continue

    with open(skill_md) as f:
        content = f.read()
    # Normalize Windows line endings so the frontmatter regex matches on cross-platform checkouts
    content = content.replace("\r\n", "\n")
    m = FRONTMATTER_RE.match(content)
    if not m:
        errors.append(f"{skill_md}: missing or malformed YAML frontmatter")
        continue

    fm = parse_flat_yaml(m.group(1))
    if fm is None:
        errors.append(f"{skill_md}: failed to parse frontmatter as flat YAML")
        continue

    if fm.get("name") != name:
        errors.append(f"{skill_md}: frontmatter name {fm.get('name')!r} does not match dir basename {name!r}")
    if not fm.get("description"):
        errors.append(f"{skill_md}: frontmatter missing 'description'")

    dmi = fm.get("disable-model-invocation")
    if dmi is not None and not isinstance(dmi, bool):
        errors.append(f"{skill_md}: disable-model-invocation must be a boolean, got {dmi!r}")
    # Capability skills must be auto-invocable; deprecated skills MUST be explicit-only
    # (otherwise the deprecated router competes with the per-capability skills).
    if EXPECTED_SKILLS[name]["deprecated"]:
        if dmi is not True:
            errors.append(f"{skill_md}: deprecated skills must set disable-model-invocation: true (got {dmi!r})")
    else:
        if dmi is True:
            errors.append(f"{skill_md}: disable-model-invocation=true conflicts with auto-invoke policy (capability skills must be auto-invocable)")

    # 4. agents/openai.yaml
    openai_yaml = os.path.join(skill_dir, "agents", "openai.yaml")
    if not os.path.isfile(openai_yaml):
        errors.append(f"{skill_dir}: missing agents/openai.yaml")
    else:
        with open(openai_yaml) as f:
            oy_text = f.read()
        oy = parse_two_level_yaml(oy_text)
        if oy is None:
            errors.append(f"{openai_yaml}: failed to parse two-level YAML")
        else:
            iface = oy.get("interface", {}) or {}
            if not isinstance(iface, dict):
                errors.append(f"{openai_yaml}: interface should be a mapping")
                iface = {}
            if not iface.get("display_name"):
                errors.append(f"{openai_yaml}: interface.display_name missing")
            if not iface.get("short_description"):
                errors.append(f"{openai_yaml}: interface.short_description missing")
            policy = oy.get("policy", {}) or {}
            if not isinstance(policy, dict):
                errors.append(f"{openai_yaml}: policy should be a mapping")
                policy = {}
            aii = policy.get("allow_implicit_invocation")
            if not isinstance(aii, bool):
                errors.append(f"{openai_yaml}: policy.allow_implicit_invocation must be a boolean, got {aii!r}")
            else:
                expected_aii = not bool(dmi) if dmi is not None else True
                if aii != expected_aii:
                    errors.append(
                        f"{openai_yaml}: policy.allow_implicit_invocation={aii} does not mirror "
                        f"SKILL.md disable-model-invocation={dmi}"
                    )
                # Capability skills must be auto-invocable; deprecated skills MUST be
                # explicit-only (positive assertion, not just exemption).
                if EXPECTED_SKILLS[name]["deprecated"]:
                    if aii is not False:
                        errors.append(
                            f"{openai_yaml}: deprecated skills must set policy.allow_implicit_invocation: false "
                            f"(got {aii!r})"
                        )
                else:
                    if aii is False:
                        errors.append(
                            f"{openai_yaml}: policy.allow_implicit_invocation=false conflicts with auto-invoke policy "
                            "(capability skills must be auto-invocable)"
                        )

    # 5. Link resolution — relative links must resolve AND stay inside the skill dir
    # (so skills remain self-contained when copied individually with `cp -R`).
    skill_dir_abs = os.path.abspath(skill_dir)
    for link in LINK_RE.findall(content):
        if link.startswith(("http://", "https://", "mailto:", "#")):
            continue
        target = link.split("#")[0]
        if not target:
            continue
        target_path = os.path.normpath(os.path.join(skill_dir, target))
        target_abs = os.path.abspath(target_path)
        if not target_abs.startswith(skill_dir_abs + os.sep) and target_abs != skill_dir_abs:
            errors.append(f"{skill_md}: relative link {link!r} escapes the skill directory; skills must be self-contained")
            continue
        if not os.path.exists(target_path):
            errors.append(f"{skill_md}: broken relative link to {link!r}")

    # 6. Confirm-before-destructive section enforcement
    if EXPECTED_SKILLS[name]["destructive"]:
        if "Confirm before destructive operations" not in content:
            errors.append(
                f"{skill_md}: missing 'Confirm before destructive operations' section "
                "(required for skills that wrap destructive CLI operations)"
            )

if errors:
    print(f"FAIL: {len(errors)} issue(s)")
    for e in errors:
        print(f"  - {e}")
    sys.exit(1)

print(f"OK: {len(actual)} skills validated, manifests + frontmatter + policy parity + links + destructive sections all clean")
PY
