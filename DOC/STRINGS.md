# 游戏文本(STRINGS)

## 文件索引

| 文件 | 作用 | 是否手写 |
| --- | --- | --- |
| `scripts\languages_kmds\strings.lua` | 通用游戏文本(中文)，并 require 五个角色语音表、合并语音扩展 | 手写 |
| `scripts\speech_xxx.lua` | 角色游戏文本(中文)，**键集与原版 speech_wilson.lua 完全一致** | 手写 |
| `scripts\speech_extension.lua` | 模组独有台词(原版没有的键)，GENERIC + 五个角色各一区块 | 手写 |
| `scripts\languages_kmds\strings.pot` | 其他语言翻译模板(msgstr 全空) | **自动生成** |
| `scripts\languages_kmds\strings_en.po` | 英文翻译文件 | **自动生成，只手填 msgstr** |
| `main\language.lua` | 运行时加载：中文强制合并 strings.lua，非中文再套 strings_en.po | 手写 |

## 两条对齐约定

**1. 语音文件对齐原版。** 五个 `speech_xxx.lua` 都是 6299 行、3964 个键，与原版 `data\scripts\speech_wilson.lua` 键集完全相同、行号整体偏移 -11，彼此之间偏移 0。也就是说同一个键在五个文件里落在同一行，`diff scripts\speech_shiro.lua scripts\speech_wakaba.lua` 只显示语气差异。注释和空行也来自原版骨架，因此更新游戏版本后能直接和新的 wilson 对照。

模组独有的键（吃薯片、看白织、醉酒 buff 之类原版没有的条目）不写进语音文件，统一放在 `speech_extension.lua`：一个角色一个区块，键顺序与缩进完全一致，六个区块同样逐行对齐。加一条新台词只改这一个文件，不用动五份语音表。

**2. pot 与 po 逐行对齐。** 两个文件由同一份排序键表生成，每条 4 行正文 + 1 行空行，第 N 条从第 `6 + 5×(N-1)` 行开始，所以 `diff strings.pot strings_en.po` 的差异只会落在 `msgstr` 行上。

## GENERIC 先行

`speech_extension.lua` 里的 `GENERIC` 区块是模组独有键的**键清单基准**，语气要求是无角色设定的中立陈述句（"酥脆可口的小零食。"这种）。它同时承担运行时兜底：原版 `stringutil.lua` 查 `STRINGS.CHARACTERS[角色]` 找不到时会回落到 `STRINGS.CHARACTERS.GENERIC` 取同一个键，所以只要 GENERIC 有，非本模组的角色（乃至将来新加的角色）也能看到描述。

新增一条模组独有台词的顺序是固定的：

1. 先在 `GENERIC` 区块加这个键，用中立陈述语气写一句；
2. 再到下面每个角色区块的同一位置各加一行，用各自语气改写；
3. 跑 `speech_generic_check.py` 复核，`NO-FALLBACK` 和 `UNCUSTOMIZED` 都应为 0。

反过来说，**任何角色有、GENERIC 没有的模组独有键都是缺陷**（`NO-FALLBACK`），检查工具会以非零退出码报错。

## 标点约定

中文文本统一使用**全角标点**：`，。！？：；（）`。半角逗号 `,` 混用全角句号 `。` 是最常见的漂移，用 `zh_punct.py` 检查和修正，它只改字符串字面量内部，不动缩进、注释和语法逗号。

以下情况**不转**：无汉字的纯英文串与 `only_used_by_*` 占位标记、`%s`／`%2.1d`／`{weight}`／`<color=…>` 内部、数字之间的 `.` 和 `,`、省略号 `...`、拉丁文缩写如 `C.W.`。波浪号 `～` 已是全角，`ariel` 大量使用属于刻意的语气风格，保留。

## 编写要求

1. 新增文本只写进中文源文件：UI 文本进 `strings.lua`，原版已有的角色台词键进 `speech_xxx.lua`，模组独有的键进 `speech_extension.lua`。
2. 模组独有键先写 `GENERIC`，再补五个角色，顺序不能反（见上一节）。
3. **禁止**手动往 `.pot` / `.po` 末尾追加句段或手动排序——追加会破坏 msgctxt 排序和行对齐。
4. 改完源文件后跑一遍生成流程（见下），然后只按报告里的 `MISSING` 条目去填 `strings_en.po` 的 `msgstr`。
5. 不要往 `speech_xxx.lua` 里加原版没有的键，那会打破与 wilson 的对齐；这类键属于 `speech_extension.lua`。
6. 源文本为空字符串的键无法进入 po（`msgid ""` 是 gettext 头），报告会列为 `EMPTY-SOURCE`；需要翻译就先给它真实中文。

## 生成流程

工具在 dst-mod-helper skill 里：`C:\Users\lunar\.pi\agent\skills\dst-mod-helper\dst-character-speech\scripts`。
Lua 脚本用 `C:\ProgramUnregistered\lua-5.4.2_Win64_bin\lua54.exe`，参数要用 `C:/...` 形式的 Windows 路径。

```bash
# 0. 先规范标点（改了源文本才需要），落盘前先看报告
python zh_punct.py "<mod>/scripts/speech_*.lua" "<mod>/scripts/languages_kmds/strings.lua"
python zh_punct.py --marks ',.!?:;()' --in-place --backup-dir C:/tmp/punct "<mod>/scripts/speech_*.lua"

# 1. 导出中文基准表（require 解析到本模组 scripts/，并应用 speech_extension 合并）
lua54.exe loc_dump.lua --out C:/tmp/base.jsonl \
  --scripts-dir "<mod>/scripts" "<mod>/scripts/languages_kmds/strings.lua"

# 2. 重新生成模板 + 合并英文翻译（保留已有 msgstr）
python loc_sync.py --base C:/tmp/base.jsonl \
  --pot "<mod>/scripts/languages_kmds/strings.pot" \
  --po  "<mod>/scripts/languages_kmds/strings_en.po" \
  --newline crlf --report C:/tmp/loc_report.txt --stale-out C:/tmp/loc_stale.po

# 3. 用游戏自己的 LoadPOFile / TranslateStringTable 验证
lua54.exe loc_verify.lua --translator "D:/Document/dst/languages/kmds/scripts" \
  --po "<mod>/scripts/languages_kmds/strings_en.po" \
  --scripts-dir "<mod>/scripts" "<mod>/scripts/languages_kmds/strings.lua"
```

`--newline crlf` 是必须的：仓库没有 `.gitattributes`，不指定会让两个文件各自沿用旧换行符，导致整文件 diff。
提交前可以用 `loc_sync.py --check`（不写盘，有漂移就退出码 1）确认生成结果是最新的。
标点规范要在生成 po **之前**做，否则每条改动都会变成 `SOURCE-CHANGED`，把真正需要重译的条目埋掉。

报告标签含义：

- `MISSING` —— 缺翻译，要填。
- `SOURCE-CHANGED` —— 中文原文改过而 `msgstr` 还是旧译，需要复核。
- `PLACEHOLDER` —— 中英格式占位符不一致，有 `string.format` 崩溃风险。
- `DROPPED` —— 已翻译但源表里已不存在，先从 `--stale-out` 里捞回再决定丢弃。
- `EMPTY-SOURCE` —— 源文本为空，被跳过。

## 语音文件对齐检查

```bash
# 与原版对照：distinct_offsets=1 表示只是整体位移，仍然对齐
python speech_align.py --reference "<game>/data/scripts/speech_wilson.lua" "<mod>/scripts/speech_*.lua"

# 五个文件互相对照（以 shiro 为基准，应全部 same_line=3964/3964 offset +0）
python speech_align.py --reference "<mod>/scripts/speech_shiro.lua" "<mod>/scripts/speech_*.lua"

# 游戏更新后按新的 wilson 重排（--strip-extra 保证不引入原版没有的键）
python speech_align.py --reference "<game>/data/scripts/speech_wilson.lua" \
  --rewrite "<mod>/scripts/speech_ariel.lua" --out C:/tmp/speech_ariel.lua --strip-extra
```

重排是把目标文件引号内的文本填进参考文件的行骨架，缩进、注释、空行都来自参考文件。工具会重新扫描自己的输出，任何键值对丢失或变动都会拒绝写入。重排一次动几千行，落盘前必须人工确认，之后再用 `luac54.exe -p` 和 `loc_dump.lua` 复核。

## 模组独有键一致性检查

```bash
# 先导出基准表和原版 wilson 的叶子（wilson 用 --root 单独导）
lua54.exe loc_dump.lua --out C:/tmp/wilson.jsonl --root W \
  "<skill>/dst-character-speech/speech_wilson.lua"

# GENERIC 与五个角色的模组独有键是否一致
python speech_generic_check.py C:/tmp/base.jsonl --vanilla C:/tmp/wilson.jsonl --limit 0
```

报告四类问题，`NO-FALLBACK` / `EXCESS-FORMAT` / `BRACE-DRIFT` 会让退出码非零：

- `NO-FALLBACK` —— 角色有、GENERIC 没有的模组独有键，**必须补 GENERIC**。
- `UNCUSTOMIZED` —— GENERIC 有而某角色没写，该角色会说中立那句；加 `--strict` 可让它也算失败。
- `COPIED` —— 角色的值和 GENERIC 一模一样，大概是复制忘改语气。
- `EXCESS-FORMAT` —— 一条里出现两个以上 `%s`，运行时只传一个参数，会崩。
- `BRACE-DRIFT` —— `{token}` 集合与 GENERIC 不一致，多出来的会原样显示。

## 备注

- 旧的外部 po 生成工具 `D:\Document\dst\languages\kmds`（`gen_po.py` + `scripts/languages/zh/` 手工同步副本）已不再作为生成入口，只保留其中的 `class.lua` / `translator.lua` 供 `loc_verify.lua` 做真机解析验证。
- `only_used_by_*` 占位标记会原样复制到 `msgstr`，不算缺翻译；运行时它们只被图鉴界面按前缀识别。
- `ARIEL` / `SOPHIA` / `WRATH` 尚未注册为可玩角色，但它们的语音表已进入 STRINGS。原版只按键直接查 `STRINGS.CHARACTERS`，从不遍历，所以多出的角色条目是惰性的，不影响运行。
