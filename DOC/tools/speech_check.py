"""Parse DST speech lua files and compare key structures / format placeholders."""
import re, sys, json

def parse(path):
    with open(path, encoding='utf-8') as f:
        src = f.read()
    # strip comments
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    src = re.sub(r'--[^\n]*', '', src)
    root = {}
    stack = [root]
    src = re.sub(r'return\s*\{', 'ROOTKEY = {', src, count=1)
    # match KEY = { | KEY = "str" | "str" (list item) | }
    token = re.compile(r'(\w+)\s*=\s*(\{)|(\w+)\s*=\s*(?:"((?:[^"\\]|\\.)*)"|\'((?:[^\'\\]|\\.)*)\')|(\{)|(\})|"((?:[^"\\]|\\.)*)"|\'((?:[^\'\\]|\\.)*)\'|(\w+)\s*=')
    for m in token.finditer(src):
        if m.group(1):  # KEY = {
            d = {}
            stack[-1][m.group(1)] = d
            stack.append(d)
        elif m.group(3):  # KEY = "str"
            v = m.group(4) if m.group(4) is not None else m.group(5)
            stack[-1][m.group(3)] = v
        elif m.group(6):  # bare {
            d = {}
            stack[-1].setdefault('__list__', []).append(d)
            stack.append(d)
        elif m.group(7):  # }
            if len(stack) > 1:
                stack.pop()
        elif m.group(8) is not None or m.group(9) is not None:  # bare string list item
            v = m.group(8) if m.group(8) is not None else m.group(9)
            stack[-1].setdefault('__list__', []).append(v)
        elif m.group(10):  # dangling key
            stack[-1][m.group(10)] = None
    return root

def flatten(d, prefix=''):
    keys = {}
    for k, v in d.items():
        if isinstance(v, dict):
            if '__list__' in v:
                keys[prefix + k + '.__list__'] = len(v['__list__'])
            for fk, fv in flatten(v, prefix + k + '.').items():
                keys[fk] = fv
        else:
            keys[prefix + k] = v
    return keys

def fmtspec(s):
    if not isinstance(s, str):
        return None
    return tuple(re.findall(r'%[-+ #0]*\d*\.?\d*[sdqfXx]', s)) if s and not s.startswith('only_used_by') else ()

if __name__ == '__main__':
    ref = sys.argv[1]
    tgt = sys.argv[2]
    a = flatten(parse(ref))
    b = flatten(parse(tgt))
    missing = [k for k in a if k not in b]
    extra = [k for k in b if k not in a]
    fmt_mismatch = []
    for k in a:
        if k in b:
            if fmtspec(a[k]) != fmtspec(b[k]):
                fmt_mismatch.append((k, fmtspec(a[k]), fmtspec(b[k])))
            if isinstance(a[k], int) and isinstance(b[k], int) and a[k] != b[k]:
                fmt_mismatch.append((k, f'listlen {a[k]}', f'listlen {b[k]}'))
    print(f'ref keys: {len(a)}, target keys: {len(b)}')
    print(f'missing in target: {len(missing)}')
    for k in missing[:80]:
        print('  MISSING', k)
    print(f'extra in target: {len(extra)}')
    for k in extra[:80]:
        print('  EXTRA', k)
    print(f'format/list mismatches: {len(fmt_mismatch)}')
    for k, x, y in fmt_mismatch[:80]:
        print('  FMT', k, x, '->', y)
    empty = [k for k, v in b.items() if v == '']
    print(f'empty strings in target: {len(empty)}')
    for k in empty[:40]:
        print('  EMPTY', k)
    leftover = [k for k, v in b.items() if isinstance(v, str) and re.fullmatch(r'[A-Za-z0-9 \'\.,!?]+', v or '') and not v.startswith('only_used_by') and len(v) > 3]
    print(f'possible untranslated english: {len(leftover)}')
    for k in leftover[:40]:
        print('  EN?', k, repr(b[k]))
