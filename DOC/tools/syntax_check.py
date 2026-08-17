import re
for name in ['shiro', 'wakaba', 'ariel', 'sophia', 'wrath']:
    path = f'scripts/speech_{name}.lua'
    raw = open(path, 'rb').read()
    src = raw.decode('utf-8')
    s = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    s = re.sub(r'--[^\n]*', '', s)
    q = len(re.findall(r'(?<!\\)"', s))
    br = s.count('{') - s.count('}')
    stray = re.findall(r'%(?![-+ #0]*\d*\.?\d*[sdqfXxc])(?!%)', s)
    first = src.startswith('return {')
    last = src.rstrip().endswith('}')
    bom = raw[:3] == b'\xef\xbb\xbf'
    crlf = src.count('\r')
    backtick = src.count('`')
    print(f'{name}: quotes={q}({"even" if q % 2 == 0 else "ODD!"}) braces_delta={br} '
          f'starts_ok={first} ends_ok={last} BOM={bom} CR={crlf} stray_pct={len(stray)} backticks={backtick}')
