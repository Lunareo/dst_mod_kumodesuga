# component / replica / player_classified 同步范式

本文记录玩家数值型组件（以原版 `sanity` 为参照）在主机、客户端和 `player_classified` 之间的同步约定。自定义资源组件应优先遵循本范式，而不是在每个 replica 中重新实现一套连接逻辑。

## 1. 三层职责

### 1.1 component：唯一权威状态

- 只在主机存在并修改真实值，例如 `current`、`max`、修正器和恢复逻辑。
- 组件字段通过 `addsetter` 注册变化回调。回调只负责把变化转交给对应 replica；必须判空：`inst.replica` 或 `inst.replica[name]` 可能尚未创建。
- 数值修改应集中在 `SetCurrent` / `SetMax` 等公开方法中。`SetCurrent` 负责边界限制；两者都应推送统一的业务事件，使主机直接监听与客户端 dirty 监听得到同一种 data。replica 不应反向修改主机组件。
- 事件名使用组件名加后缀，例如 `magicpointdelta`。事件 data 使用统一字段：

```lua
{
    oldpercent = old / max,
    newpercent = current / max,
    delta = current - old,
    current = current,
    max = max,
}
```

`current`、`max` 便于 HUD 直接刷新，百分比和 `delta` 便于通用监听器处理。`max` 为 0 时百分比使用 0，避免除零。

### 1.2 replica：主机桥接与客户端读取接口

- 主机侧 replica 不保存第二份业务状态；component setter 调用 replica 的 `SetCurrent` / `SetMax`，再由 replica 写入 classified 的 netvar。
- 客户端侧 replica 不计算或预测权威数值，只从 `classified.<field>:value()` 读取。
- `SetCurrent` / `SetMax` 在 replica 中的含义是“写入网络变量”，不是修改客户端 replica 自身字段。
- 客户端读取方法应同时支持：
  1. 有 component 时读 `inst.components[name]`（本地/主机）；
  2. 无 component 但已连接 classified 时读 netvar（远端玩家）；
  3. classified 尚未到达时返回安全默认值。
- 对外方法命名与 component 对齐：`GetCurrent`、`GetMax`、`Max`（兼容旧调用）、`GetPercent`。不要让 `magicpoint_replica` 再复制一份 scorebase 的通用实现。

### 1.3 player_classified：网络变量和 dirty 事件

- `player_classified` 只存可网络传输的数据，不存组件修正器、回调或业务规则。
- 网络字段命名按资源分组：

```lua
currentmagicpoint = net_ushortint(inst.GUID, "magicpoint.current", "magicpointdirty")
maxmagicpoint = net_ushortint(inst.GUID, "magicpoint.max", "magicpointdirty")
```

- `current` 与 `max` 共享 dirty 事件，使两者变化能在同一次刷新中生成完整 data。
- 客户端 dirty handler 必须：
  1. 读取当前 netvar；
  2. 用 `_old<name>current` 和 `_old<name>percent` 计算变化；
  3. 更新旧值缓存；
  4. 在存在 `_parent` 时向玩家实体推送 `<name>delta`；
  5. `_parent` 不存在时只初始化缓存，不丢弃未来变化。
- dirty handler 只能把网络状态转换为本地事件，不能调用 component 的写入方法。
- 初始化值应在 netvar 创建后设置，并通过 `DoStaticTaskInTime(0, RegisterNetListeners)` 注册监听，避免构造阶段漏掉 dirty 回调。

## 2. classified 的连接时序

玩家实体和 `player_classified` 的复制顺序不固定。replica 构造时应：

1. 主机且 `inst.player_classified` 已存在：直接保存引用；
2. 其它情况：启动等待协程；
3. 客户端发现 classified 后调用 `AttachClassified`；
4. `AttachClassified` 注册 `onremove`，classified 被移除时清空引用；
5. 主机延迟连接成功后，重新把 component 当前值和最大值写入 classified，补发构造期间遗漏的赋值。

等待协程必须检查 `inst:IsValid()`，否则实体先移除时不能继续访问 native 对象。`AttachClassified` 应避免重复挂载同一个对象；`DetachClassified` 应移除对应的 `onremove` 回调。

## 3. 数据流

```text
主机 component.current/max
        │ addsetter
        ▼
主机 replica:SetCurrent/SetMax
        │ classified:SetValue()
        ▼
player_classified netvar
        │ current/max dirty
        ▼
客户端 player_classified dirty handler
        │ PushEvent("<name>delta", data)
        ▼
玩家实体监听者 / HUD
```

客户端读取则反向经过 `replica:GetCurrent/GetMax/GetPercent` 读取 classified netvar；不会把客户端读数写回 component。

## 4. 与原版 sanity 的对应关系

- `sanity.lua` 的 `onmax`、`oncurrent` 将主机状态显式写入 `inst.replica.sanity`。
- `sanity_replica.lua` 在主机把值写入 `player_classified`，在客户端从 classified 读取；`AttachClassified` 负责复制时序。
- `player_classified.lua` 用 `currentsanity`、`maxsanity` 触发 `sanitydirty`，维护旧百分比并推送 `sanitydelta`。
- `sanity` 的模式、sane 状态等派生状态使用独立 netvar 和 dirty 事件；不要把这类事件与数值 dirty 混为一谈。

## 5. scorebase / magicpoint 约定

- `scorebase` 提供 current/max 的通用 setter、事件和 replica 读写接口。
- 派生 component 只负责自身业务（例如 magicpoint 的恢复、消费修正器），不重新安装 current/max 的同步回调。
- `magicpoint_replica` 只声明类型并调用 `Base._ctor(self, inst, "magicpoint")`；网络字段名由 scorebase 根据资源名生成。
- `postinits/prefabs/player_classified.lua` 是本模组 classified 扩展的实现位置。`magicpoint` 使用 `magicpoint.current`、`magicpoint.max` 和 `magicpointdirty`，dirty data 与 scorebase component 使用同一组字段。

## 6. 修改检查清单

- [ ] component 的公开字段和 replica 的读取方法名称一致。
- [ ] component setter 对 `inst.replica`、目标 replica 做判空。
- [ ] replica 没有重复实现继承自 scorebase 的 Attach/Detach/Set/Get 方法。
- [ ] classified 的 current/max netvar 使用同一 dirty 事件。
- [ ] dirty handler 有旧值缓存，并在 `_parent == nil` 时只更新缓存。
- [ ] 事件名、data 字段在主机 component 和客户端 classified 中一致。
- [ ] classified 重建或延迟挂载后，主机重新推送 authoritative current/max。
- [ ] 所有客户端 AnimState 或特效逻辑额外检查实体有效性；数值同步本身不得依赖客户端 native 状态。
