# 游戏文本(STRINGS)

## 编写要求

- 添加新的STRINGS时，首先向对应的基础文本文件中添加，然后向模板和现有的其他语言翻译文件末尾添加对应的句段，如果是大量添加，添加后调用po生成工具进行格式化的重新合并生成
- po生成工具路径(lua脚本) `D:\Document\dst\languages\kmds`
- 语言文本文件如下所示

## 文件索引

- 通用游戏文本(中文) `scripts\languages_kmds\strings.lua`
- 角色游戏文本(中文) `scripts\speech_xxx.lua`
- 其他语言翻译模板文件 `scripts\languages_kmds\strings.pot`
- 英文翻译文件 `scripts\languages_kmds\strings_en.po`