# kumodesuga — Agent Guidelines

## LuaCATS / EmmyLua 注释（强制）

- **若对象、函数、字段原本已有 LuaCATS 注释（`---@class` / `---@field` / `---@param` / `---@return` / `---@type` / `---@alias` 等），修改代码时必须保留。**
- 可以**更新**注释以匹配新签名或新字段（例如字段改名、类型变化），但不要在重构时整段删掉。
- 新增公开 API、组件字段、prefab 自定义字段时，应沿用项目现有风格补全对应注解。
- 全文件重写前，先扫一遍原有 `---@` 块，改完后对照保留/迁移，避免类型提示与 LSP 定义丢失。

## 其它约定

- 优先最小改动；不要无关格式化整文件。
- 组件索引前注意判空（`components.X` / `replica.X`）。
- 客户端特效与 `AnimState` 调用需校验实体 `IsValid`，避免 native 崩溃。

## 计划

- 计划在文件DOC/PLAN.md中，有需要时再观看。