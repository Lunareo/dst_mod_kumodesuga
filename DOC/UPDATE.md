## 2026/10/23
1. 新增开发期 Lua 语法检查：`node tests/check_syntax.js`（可传入目录或文件），已把 `tests/hooks/pre-commit` 接入 `core.hooksPath`，提交前拦截会中断 modmain 加载的语法错误；
2. 适配游戏 v759671：combat 伤害入口改为 `GetAttacked_Internal`，暴击补偿与爱丽儿的毒伤拦截改挂新入口（旧版本自动回退）；
3. 收敛重复实现：空间机动判定统一到 `scripts/prefabs/playerskillutil.lua`，五把魔剑共用 `MakeSword` 骨架；
4. 移除无引用组件 `components/combataware.lua` 与失效的公共 UI 助手。

## 2026/8/3
1. 为几个预构造魔术添加了开关;

## 2026/8/1


