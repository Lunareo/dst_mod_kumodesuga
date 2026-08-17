import re
src = open('scripts/languages_kmds/strings.lua', encoding='utf-8').read()
s = re.sub(r'--[^\n]*', '', src)
print('braces delta:', s.count('{') - s.count('}'))
q = re.findall(r'(?<!\\)"', s)
print('quotes even:', len(q) % 2 == 0)
m = re.search(r'CHARACTERS = \{.*?\n    \},', s, re.S)
block = m.group(0) if m else ''
print('CHARACTERS block lines:', block.count('\n'), '| contains SHIRO=:', bool(re.search(r'\bSHIRO = \{', block)), '| contains WAKABA=:', bool(re.search(r'\bWAKABA = \{', block)), '| GENERIC kept:', 'GENERIC = {' in block)
print('SKILLTREE shiro kept:', 'ARROGANS_DESC' in s)
print('WAKABA skilltree kept:', 'CONCENTRATION_DESC' in s)
