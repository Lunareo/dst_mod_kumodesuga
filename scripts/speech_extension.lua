-- speech_extension.lua
-- 模组独有、原版 speech_wilson.lua 中不存在的角色台词。
--
-- GENERIC 是本文件的键清单基准，使用无角色设定的陈述语气，
-- 同时充当运行时兜底：原版 stringutil.lua 查不到角色自己的条目时，
-- 会回落到 STRINGS.CHARACTERS.GENERIC 取同一个键。
--
-- 新增模组独有台词的顺序：
--   1. 先在 GENERIC 里加这个键，用中立陈述语气写一句；
--   2. 再在下面每个角色区块的同一位置各加一行，用各自的语气改写；
--   3. 用 speech_generic_check.py 复核 GENERIC 的键在五个角色里都存在。
--
-- 六个区块的键顺序与缩进完全一致，因此逐行对齐，可以直接 diff 比对语气差异。
-- speech_<char>.lua 保持与原版 speech_wilson.lua 同构（键集、行号一致），
-- 模组独有键只在本文件维护。
--
-- 由 scripts/languages_kmds/strings.lua 合并进 STRINGS.CHARACTERS.<CHAR>。

return {
    GENERIC = {
        ACTIONFAIL = {
            CASTAOE = {
                SPELL_NOT_ENOUGH_COST = "施放这个法术需要更多的魔力！",
            },
        },
        ANNOUNCE_ATTACH_BUFF_DRUNKEN = "喝下去之后，脚步开始不受控制了。",
        ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "生命上限的损伤开始缓慢恢复。",
        ANNOUNCE_DETACH_BUFF_DRUNKEN = "酒劲过去了，头脑重新清醒。",
        ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "损伤恢复结束了。",
        DESCRIBE = {
            ARAMASA = "寄宿了强大力量的手套。",
            CHIPS = "酥脆可口的小零食。",
            KURIKUTA_DRIED = "味道很好的干果。",
            SHIRO = "她真好看。",
            SILK_ROBE = "坚韧但不厚重，丝滑但不透凉。",
            SPIDERSCYTHE = "用传说级蜘蛛的前腿打造的大镰刀。",
            TRINITY_IMPACT = "火、冰、电三种属性会轮流附在攻击上。",
            WAKABA = "她真好看。",
        },
    },
    ARIEL = {
        ACTIONFAIL = {
            CASTAOE = {
                SPELL_NOT_ENOUGH_COST = "魔力不够了呢～急什么，慢慢攒嘛。",
            },
        },
        ANNOUNCE_ATTACH_BUFF_DRUNKEN = "呵呵～这才刚有点意思～",
        ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "哎呀，眼睛有点花呢～我就是这样，乖孩子多担待哟。",
        ANNOUNCE_DETACH_BUFF_DRUNKEN = "两桶就到此为止了吗。真是不经喝～",
        ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "嗯，舒服多啦～谢谢关心，真乖。",
        DESCRIBE = {
            ARAMASA = "八连击的手套呀～挥起来很漂亮，可惜挑人。",
            CHIPS = "薯片呀～咔嚓咔嚓，一眨眼就见底了。D那孩子在这方面倒是有好品味嘛～",
            KURIKUTA_DRIED = "干燥的库利库塔果实～甜甜的，配茶最合适。收起来，全都收起来～",
            SHIRO = "小白（%s）～今天也辛苦啦。要不要我给你做顿好吃的？我的手艺可是有口皆碑的哟～",
            SILK_ROBE = "小白织的丝，柔软得没话说～不愧是我看中的孩子，这手艺连我都想夸两句呢。",
            SPIDERSCYTHE = "小白的镰刀呀～挥的时候可要小心哦，那孩子出手从来不留余地的。",
            TRINITY_IMPACT = "火、冰、电轮着来呢～真够热闹的。",
            WAKABA = "那孩子……在她开口说笑之前，还是装作没看见比较好～冷场这件事，我可是专家哟。",
        },
    },
    SHIRO = {
        ACTIONFAIL = {
            CASTAOE = {
                SPELL_NOT_ENOUGH_COST = "……魔力，不够。……等。",
            },
        },
        ANNOUNCE_ATTACH_BUFF_DRUNKEN = "呜哇！",
        ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "……眼睛。好痛。要看，一会儿……",
        ANNOUNCE_DETACH_BUFF_DRUNKEN = "……咦。这里，哪里。……我，做了什么？",
        ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "……眼睛，好多了。",
        DESCRIBE = {
            ARAMASA = "……一挥。……八次。……够用。",
            CHIPS = "……没想到，这里，也有。D，在看吗。",
            KURIKUTA_DRIED = "……干果。……比，毒魔物，的肉，好吃。",
            SHIRO = "……我。……%s，是，替身？",
            SILK_ROBE = "……织丝，的，基本功。",
            SPIDERSCYTHE = "……我，的，前脚。……做成，镰。……顺手。",
            TRINITY_IMPACT = "……火。冰。电。……轮着，来。",
            WAKABA = "……D。……这里，也是，你的，游戏？",
        },
    },
    SOPHIA = {
        ACTIONFAIL = {
            CASTAOE = {
                SPELL_NOT_ENOUGH_COST = "魔力不够！……才不是我不行，是储量的问题！",
            },
        },
        ANNOUNCE_ATTACH_BUFF_DRUNKEN = "唔……只是、一小口而已……",
        ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "眼睛好痛……要我一直盯着看？我的眼睛可是很金贵的。",
        ANNOUNCE_DETACH_BUFF_DRUNKEN = "我、我刚才没说什么丢人的话吧？！",
        ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "眼睛舒服多了。本来就不该让我受这种罪。",
        DESCRIBE = {
            ARAMASA = "仿制品……不过八连击的手感，还算能接受。",
            CHIPS = "薯片……哼，膨化食品我才不看在眼里。……就吃一片。",
            KURIKUTA_DRIED = "果干……聊胜于无。我更想吃带血的肉。",
            SHIRO = "主人……%s……哼，才不是特意来看你的！只是路过！",
            SILK_ROBE = "丝绸长袍。做工勉强，反正我穿什么都好看。",
            SPIDERSCYTHE = "被这东西捆住过的回忆……不许笑！",
            TRINITY_IMPACT = "三种属性换着打……哼，倒是挺花哨的。",
            WAKABA = "那家伙……跟她说话总觉得会输，讨厌。",
        },
    },
    WAKABA = {
        ACTIONFAIL = {
            CASTAOE = {
                SPELL_NOT_ENOUGH_COST = "魔力不足。条件不满足，就不会发生。",
            },
        },
        ANNOUNCE_ATTACH_BUFF_DRUNKEN = "这具身体开始不听话了。有趣。",
        ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "有趣。这具身体的损耗被压住了。",
        ANNOUNCE_DETACH_BUFF_DRUNKEN = "醒了。这种状态，记录一次就够了。",
        ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "结束了。它又会照常损耗。",
        DESCRIBE = {
            ARAMASA = "创世者的仿品。八次判定，很直白。",
            CHIPS = "薯片。观战的时候需要它。",
            KURIKUTA_DRIED = "干掉的果实。味道很奇怪。",
            SHIRO = "我的东西。在我的掌心里飞得不错。",
            SILK_ROBE = "丝做的。比女仆装体面一些。",
            SPIDERSCYTHE = "死神的镰刀。给她的东西，用得还行。",
            TRINITY_IMPACT = "三属性轮换。下一次是什么，由随机数决定。",
            WAKABA = "我。……模仿得不太像。",
        },
    },
    WRATH = {
        ACTIONFAIL = {
            CASTAOE = {
                SPELL_NOT_ENOUGH_COST = "魔力不足。在下还需忍耐。",
            },
        },
        ANNOUNCE_ATTACH_BUFF_DRUNKEN = "酒会夺走理智。我不该喝的。只此一杯。",
        ANNOUNCE_ATTACH_BUFF_HEALTH_PENALTY_REDUCTION = "痛还能忍。撑住。",
        ANNOUNCE_DETACH_BUFF_DRUNKEN = "……清醒了。刚才的我，不像话。",
        ANNOUNCE_DETACH_BUFF_HEALTH_PENALTY_REDUCTION = "……忍过去了。没事了。",
        DESCRIBE = {
            ARAMASA = "神代之器的仿作。八连之技，不可轻慢。",
            CHIPS = "点心。偶尔的奢侈，可以原谅。多谢款待。",
            KURIKUTA_DRIED = "干果。能吃饱，就该感恩。",
            SHIRO = "白小姐。%s……在下随时听候差遣。",
            SILK_ROBE = "丝织的衣裳。针线扎实。让我想起那件和服。",
            SPIDERSCYTHE = "白小姐的镰刀。刀工无可挑剔。",
            TRINITY_IMPACT = "火、冰、雷三相轮转。一击之中藏着三重杀意。",
            WAKABA = "那位大人，深不可测。不可失礼。",
        },
    },
}
