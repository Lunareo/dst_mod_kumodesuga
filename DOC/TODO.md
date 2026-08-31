# TODO

> 由 `DOC/shiro_skilltree_settings.md` 与 `DOC/PLAN.md` 整理而成。
> 状态标记：`[x]` 已完成 / `[ ]` 未完成 / `[!]` 部分完成（备注中说明缺口）。
> 代码位置：`scripts/prefabs/skilltree_shiro.lua`（技能树定义）、`scripts/prefabs/shiro.lua`（角色与跳跃逻辑）、`scripts/prefabs/spells_shiro.lua`（法术书）、`scripts/prefabs/storing_space.lua`（储物空间）。

## Shiro 技能树

### 常驻魔法组（constmagic）

- [x] **visual_enhance 视觉强化**（原表 #5 visual_enhancement）
  - 夜视（夜晚/洞穴强制夜视，含查理免疫）+ 护目（`ForceGoggleVision`，防沙尘）。
  - 组件：`scripts/components/nightvision.lua`；法术书含开关（spells_shiro 中已注释，当前随技能自动启用）。
- [ ] **vision_overlook 望远**（原表 #6 telescope）——已写好骨架，整段注释中。
- [x] **spacemagic_1 空间魔法**（原表 #7）——获得 3x2 储物空间（`other_space_3x2`），法术书可开启储物代理。
- [x] **spacemagic_2 空间魔法2**（原表 #8）——升级 3x3，并获得短距空间跳跃（屏幕内目标点转移）。
- [!] **spacemagic_3 空间魔法3**（原表 #9）——升级 3x4，并获得长距跳跃（地图上对已探明位置使用 TRANSFER）。
  - 缺口：**背负的雕像自动收入储物空间**未实现（`storing_space.lua` 的 testfn 仅阻止放入带生命值的生物）。
- [x] **spacemotor**（计划外新增）——水面行走（碰撞掩码变更 + 溺水豁免）。
- [x] **skanda 韦驮天**（计划外新增）——高移速进入半透明状态。

### 邪眼（spellbook 法术，尚未绑定技能树）

- [!] **绑定技能 evil_eyes_1~3**——技能定义已注释，标有 `TODO: 绑定技能`，法术与技能树尚未挂钩。
- [x] **死灭之邪眼**（原表 #13）——对应 destruction：以自身 90% HP 为代价造成巨额伤害并附加生命上限惩罚。
- [x] **诅咒之邪眼**（原表 #14）——对应 curse：持续伤害 debuff。
- [ ] **麻痹之邪眼**（原表 #15）。
- [ ] **石化之邪眼**（原表 #16，根节点应为麻痹之邪眼）。
- [ ] **不快之邪眼**（原表 #17，强制吸引仇恨）。
- [ ] **幻痛之邪眼**（原表 #18，大范围微量伤害）。
- [ ] **狂气之邪眼**（原表 #19，范围内随机目标重排）。
- [ ] **魅惑之邪眼**（原表 #20，强制友好）。
- [x] **催眠之邪眼**（原表 #21）——对应 freeze：催眠 debuff（`fx_book_sleep`）。
- [ ] **恐怖之邪眼**（原表 #22，范围恐惧）。
- [ ] **引斥之邪眼**（原表 #23，范围减速与地形破坏）。

### 支配者组（donimator，整体未启用）

- [!] **dominator_lock 成就锁**——锁定义已写好（学会 12 个技能后开启，连接四个支配者技能），整段注释中。
- [ ] **reincarnation 升级恢复**（原表 #1）——定义已注释。
- [ ] **pati 忍耐**（原表 #2，称号「忍耐的支配者」）——定义已注释。
  - 依赖：MP 系统已有 `scripts/components/magicpoint.lua`（含消耗源注册与全局消耗系数 `SetMultiplier`），但缺少 **经验/等级系统**、MP>0 时 HP 不低于 1 的守护、按等级伤害减免、受击获得经验。
- [ ] **desidiae 怠惰**（原表 #3，称号「怠惰的支配者」）——定义已注释，备注可能替换为别的技能。
- [ ] **arrogans 傲慢**（原表 #4，称号「傲慢的支配者」）——定义已注释，备注需先制作升级系统。
- [ ] **sapiens 睿智**（原表 #24，称号「睿智的支配者」）——定义已注释，备注可能替换掉。

### 进化组（evolution）

- [x] **进化路线互斥锁**——小蜘蛛路线 / 大蜘蛛路线各一个锁，未选对方路线时开启。
- [!] **小型蜘蛛怪**（原表 #25，备注「学会制作丝」）——目前只有 `shiro_evolution_tiny_spider_meter`（infographic 进化计量表），**学会制作丝**未实现。
- [x] **死神之镰**（原表 #26，备注「近战附带腐蚀伤害」）——`shiro_evolution_death_scythe`：添加 `erosiondamage` 组件并 +5 腐蚀伤害加成（作为 spdamage 附着于所有攻击）。
- [ ] **不死蛛后**（原表 #27）——`shiro_evolution_undying_queen` 定义为空壳，标有 `TODO: 制作不死技能`（血量触底不死并尝试恢复，满血原地复活）。
- [ ] **女郎蜘蛛**（原表 #28）——`shiro_evolution_arachne` 定义为空壳，标有 `TODO: 制作二重攻击机制`。
- [x] **大型蜘蛛怪**（原表 #29，备注「大幅提高血量上限及防御」）——`shiro_evolution_advance_spider`：+`TUNING.SHIRO_HEALTH` 生命上限、15% 吸收修正。
- [x] **巨型蜘蛛怪（mega）**——`shiro_evolution_mega_spider`：再次 +生命上限与 15% 吸收（原表未列出，属追加实现）。
- [ ] **女王蜘蛛怪**（原表 #30，备注「可制作蜘蛛巢、视作蜘蛛女王+1、无消耗雇佣蜘蛛」）——`shiro_evolution_queen_spider` 定义为空壳，标有 `TODO: 制作产卵技能`。

### 亲和组（allegiance）

- [x] **暗影亲和**（原表 #32 暗影中坚）——暗影麋鹿锁 + 非月亮锁；激活后获得 `player_shadow_aligned` 标签与月影双抗性。
- [x] **月亮亲和**（原表 #31 月光代理人）——天体英雄锁 + 非暗影锁；激活后获得 `player_lunar_aligned` 标签与对月影双伤害加成。

### 全局遗留项

- [ ] **称号系统**——原表中「忍耐/怠惰/傲慢/睿智的支配者」等称号均未实现。

## 计划（原 PLAN.md）

- [!] **1. 完善 shiro 的 skilltree，添加技能成就锁**
  - 已完成：进化组路线互斥锁、亲和组成就锁（击杀暗影麋鹿/天体英雄）。
  - 未完成：dominator 组的 12 技能成就锁仍在注释中；constmagic 组无锁。
- [x] **2. 为 shiro 和 wakaba 构造完整的全套台词**
  - `scripts/speech_shiro.lua` 与 `scripts/speech_wakaba.lua` 均已覆盖原版 `speech_wilson` 的全部顶级键位，无空表、无 TODO 残留，并已通过 `scripts/languages_kmds/strings.lua` 挂载到 `STRINGS.CHARACTERS`。
