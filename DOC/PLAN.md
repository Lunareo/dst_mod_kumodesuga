# 计划

1. [进行中] 完善shiro的skilltree，添加技能成就锁 —— 明细见 DOC/TODO.md
2. [已完成] 为shiro和wakaba构造完整的全套台词，基于文件DOC/CHARACTOR.md，有需要时再查看。

## 工程优化（全仓库代码审查，2026/10/23）

审查范围：129 个 Lua 文件（≈1.31 万行逻辑代码，另有 3.17 万行台词表）。

- [x] P0 修复 `postinits/components/builder.lua` 断裂的 `if/elseif`：该语法错误会让 modmain 整体加载失败。
- [x] P1 清理无引用组件 `components/combataware.lua` 与失效的公共 UI 助手。
- [x] P2 去重：`HasSpaceMotor`/`CanTransferToPoint` 收敛到 `scripts/prefabs/playerskillutil.lua`；五把魔剑共用 `MakeSword` 骨架。
- [x] 兼容游戏 v759671：combat 伤害入口改为 `GetAttacked_Internal`，暴击补偿与爱丽儿毒伤拦截改挂新入口。
- [x] P5 建立语法检查 gate：`tests/check_syntax.js` + `tests/hooks/pre-commit`（已接入 `core.hooksPath`）。
- [x] P3a 拆分 `storing_space.lua`：Shiro 的随身异空间独立为 `scripts/prefabs/other_space.lua`。
- [x] P3b 核实 `satura` 挂载范围：hunger 溢出、配方成本与状态栏都读它，必须挂在所有玩家上；与 `scorebase` 的关系已在代码注释中说明，不合并基类。
- [ ] P3c 拆分 `shiro.lua`：无状态行为（空间机动、饥饿掉理智、二重打击、恶食/醉酒、忍耐）可迁出为组件，`_other_space` 的存读档需留在角色 prefab。动手前先确认。
- [x] P4 台词表改继承 Wilson：核对后决定不改动。五份台词表里与原版逐字相同的条目只有 334 个（wakaba 336），且全是 `only_used_by_*` 占位符（叶子 270 + 纯占位符子表 64），真实台词 100% 已汉化；原版 `stringutil.lua` 的查表链本就以 `STRINGS.CHARACTERS.GENERIC`（= `speech_wilson`）兜底，这些占位符运行时为空转，且它们维持着 `speech_extension.lua` 约定的「与 speech_wilson 键集、行号同构」。原先估算的 1.2 万行重复不成立。另外核出模组台词表比当前原版少 56 个键（Shrouden、Charlie、新 Boss 的 DESCRIBE 等），由上述兜底承接，不影响显示。
- [ ] P4 其余项（`GLOBAL` 注入收敛、`skinutil.lua` 版本守卫、41 个 hook 文件的集中注册与可卸载）：本轮暂缓。