// 全量 Lua 语法检查：modmain 加载期的语法错误会直接让整个模组失效，
// 提交前跑一次即可拦住（例如 postinits/components/builder.lua 曾经的 if/elseif 断裂）。
//
// 用法：
//   node tests/check_syntax.js            # 检查整个仓库
//   node tests/check_syntax.js scripts    # 只检查指定目录/文件
//
// 依赖 luaparse（仅开发期，不随模组运行）：
//   npm i -g luaparse        # 或 npm i -D luaparse，或设置 LUAPARSE_PATH 指向其目录
//
// 退出码：0 通过，1 存在语法错误，2 缺少 luaparse。
'use strict';

const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');

function loadLuaparse() {
    const candidates = [
        () => require('luaparse'),
        () => require(path.join(process.env.LUAPARSE_PATH || '', 'luaparse')),
        () => require(path.join(root, '.pi_tmp', 'node_modules', 'luaparse')),
    ];
    for (const load of candidates) {
        try {
            return load();
        } catch (err) { /* 继续尝试下一个位置 */ }
    }
    console.error('找不到 luaparse：请执行 npm i -g luaparse，或设置 LUAPARSE_PATH 指向其所在目录。');
    process.exit(2);
}

const luaparse = loadLuaparse();

// 只跳过资源与非 Lua 目录；DOC 与 exported 里没有参与运行的脚本。
const SKIP_DIRS = new Set([
    '.git', '.pi_tmp', 'node_modules', 'LSP', 'DOC', 'exported',
    'anim', 'images', 'bigportraits', 'sound', 'shaders',
]);

function collectLuaFiles(target, out) {
    const stat = fs.statSync(target);
    if (stat.isFile()) {
        if (target.endsWith('.lua')) out.push(target);
        return out;
    }
    for (const entry of fs.readdirSync(target, { withFileTypes: true })) {
        if (entry.isDirectory()) {
            if (SKIP_DIRS.has(entry.name) || entry.name.startsWith('.')) continue;
            collectLuaFiles(path.join(target, entry.name), out);
        } else if (entry.name.endsWith('.lua')) {
            out.push(path.join(target, entry.name));
        }
    }
    return out;
}

const targets = process.argv.slice(2).map((p) => path.resolve(root, p));
const files = [];
for (const target of targets.length > 0 ? targets : [root]) {
    collectLuaFiles(target, files);
}

let failed = 0;
for (const file of files.sort()) {
    const source = fs.readFileSync(file, 'utf8');
    try {
        luaparse.parse(source, { luaVersion: '5.1' });
    } catch (err) {
        failed++;
        console.error(`SYNTAX ERROR ${path.relative(root, file)} :: ${err.message}`);
    }
}

console.log(`checked ${files.length} files, ${failed} with syntax errors`);
process.exit(failed === 0 ? 0 : 1);
