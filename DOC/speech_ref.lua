-- 本文件为萌新(正在尝试)制作的mod角色德谬歌的台词本
-- 制作于“保持不沉没”版本,发条骑士之年”版本
-- 我对几乎所有台词都进行了注释，并按照一定规律进行了分类排布
-- 原版的角色台词本则是以更新顺序排序，每次更新内以字母顺序排序
-- 比如玩家制作的工具都被我分在“工具”一栏，其余同理
-- 不过，目前此文件依旧存在不少问题
-- 比如缺少部分角色的专属台词
-- 也可能存在缺漏台词、注释错误的情况，希望发现的大佬将其更正(并且最好能告诉我)
-- 以及目前仍然存在不少我不清楚具体表示什么的台词(均标注为“未知”“暂时未明”)
-- 希望这个文件能够帮助到希望通过更改台词来让自己的角色更富个性的moder
-- 希望有帮到你AuA

-- by 孤独之星俱乐部/流泪猫猫头

return {

 ---------------------------------------------------------------------------------------------------------------------------------
-- 注：直到DESCRIBE之前的内容，均为玩家在各种情况下进行某种行为时触发的台词
--     DESCRIBE内是对游戏中实体(生物、角色、物品、建筑等等)的检查台词
--  尝试进行动作失败
	ACTIONFAIL =
	{
		--  通用
        GENERIC =
        {
            ITEMMIMIC = "欺君之罪！",  -- 道具是拟态蠕虫伪装的
        },

		-- 刮毛
		SHAVE =
		{
			AWAKEBEEFALO = "它在清醒时是不会配合的。", -- 当目标醒着无法剃须时(例如皮弗娄牛清醒时)
			GENERIC = "这可不是能剃的东西。",          -- 无法剃须的通用情况
			NOBITS = "已经剃得一干二净了。",           -- 没有胡须可以剃时(目标已经被剃过了)
			REFUSE = "only_used_by_woodie",		     -- 拒绝刮胡子(伍迪专用)
			SOMEONEELSESBEEFALO = "最好别这么做。", -- 不能刮队友牛的毛
		},

		-- (向容器内)存放物品
		STORE =
		{
			GENERIC = "已经塞满了。",             		 -- 容器已满
			NOTALLOWED = "这不是该放进去的东西。", 	 	  -- 不能放入容器内
			INUSE = "我正在排队。",               		 -- 有其他玩家正在翻找
			NOTMASTERCHEF = "专业的厨具需要专业的厨师。", -- 非厨师尝试往便携锅里放食材
		},

		-- 翻找(打开容器)
		RUMMAGE =
		{
			GENERIC = "这我做不到。",    -- 通用无法翻找
			INUSE = "我在排队。",	     -- 有其他玩家正在翻找
			NOTMASTERCHEF = "专业的厨具需要专业的厨师。", -- 非厨师尝试打开便携锅
			NOTAMERM = "只有那些“鱼”蠢的家伙才用这些。",  -- 非鱼人不能打开鱼人工具棚和军械库
		},

		-- 烹饪
		COOK =
        {
            GENERIC = "这不是能入锅的东西。",  -- 不能烹饪
            INUSE = "正在烹饪。",             -- 烹饪工具或者位置被占用
            TOOFAR = "这里够不到。",          -- 距离烹饪容器太远
        },

		-- 递物品
		GIVE =
        {
			-- 向生物给予失败
            DEAD = "死人可接不了东西。",			-- 给予目标已死亡
            SLEEPING = "还是等他睡醒再说吧。",      -- 给予目标处于睡眠状态
            BUSY = "看起来现在没空。",     			-- 给予目标正处于其他动作或状态导致无法给予，例如玩家正在工作，生物被冰冻
			NOMOON = "这里无法接引月光。",		 	-- 洞穴里无法使用天体传送门换人
			NOTATRIUMKEY = "这不是它的钥匙。。", 	-- 远古大门钥匙不对
			NOTSTAFF = "这很明显是个法杖的凹槽。",   -- 向月台塞入非法杖道具
			-- 灵魂与告密的心
			ABIGAILHEART = "她的灵魂不是这个能救赎的。", -- 给阿比盖尔告密的心
            GHOSTHEART = "怨灵无法凭借这个复生。",		-- 给鬼魂告密的心
			-- 织影者复活相关
			CANTSHADOWREVIVE = "暗影的力量还在恢复。", -- 远古大门冷却中
			WRONGSHADOWFORM = "显而易见，拼装错误。",  -- 化石骨架形态错误，无法用心脏复活
			-- 蘑菇农场相关
            MUSHROOMFARM_NEEDSSHROOM = "需要一些蘑菇或孢子来接种。", -- 蘑菇农场需要蘑菇
            MUSHROOMFARM_NEEDSLOG = "这东西需要活木来补充肥力。",	 -- 蘑菇农场需要活木
            MUSHROOMFARM_NOMOONALLOWED = "这需要专门的技术。",      -- 不是点了技能的植物人试图在蘑菇农场种月蘑菇
			-- 陶轮相关
            DUPLICATE = "已经有个这个草图了。",	  -- 给陶轮已有的草图
            NOTSCULPTABLE = "这只能放得了草图。", -- 向陶轮放入非图纸道具
			SLOTFULL = "先把手里的做完吧。",	  -- 陶轮已有底料后试图再次给予
			-- 猪王年活动-抢元宝游戏
			PIGKINGGAME_MESSY = "恐怕场地不太够。",		-- 猪王旁边有建筑，不能开始抢元宝
			PIGKINGGAME_DANGER = "等等，周围有危险。",	-- 危险，不能开始抢元宝
			PIGKINGGAME_TOOLATE = "它嫌现在太晚了。",   -- 不是白天，不能开始抢元宝
            -- 鸦年华活动-各项游戏
			CARNIVALGAME_INVALID_ITEM = "我需要去买代币。",	-- 非代币无法开启鸦年华游戏
			CARNIVALGAME_ALREADY_PLAYING = "已经满客了。",  -- 有人正在使用
			-- 暴食活动-向暴食祭祀
			FOODFULL = "它还没享用完上一餐。", -- 祭坛上已经有菜肴
			NOTDISH = "这可不是料理。",		  -- 祭坛上不能摆非料
			-- 盒中泰拉
            TERRARIUM_REFUSE = "它只需要噩梦燃料。",     -- 给予非噩梦燃料
            TERRARIUM_COOLDOWN = "那家伙暂时看不过来。", -- 正在冷却
			-- 月亮码头女王/猴子女王交易
			NOTAMONKEY = "我没研究过猴子的语言。", -- 非芜猴玩家不能给予月亮码头女王物品
			QUEENBUSY = "她还在忙着藏那些香蕉。",  -- 月亮码头女王忙碌中无法接受物品
			-- 疑似向远古档案馆塞宝石
            NOTGEM = "需要彩虹宝石作为动力。",            -- 给予非宝石物品
            WRONGGEM = "仅有彩虹宝石才能提供足够的能源。", -- 给予非彩虹宝石
			-- 非学习了技能的薇洛娜(女工)试图给宝石发电机安装纯粹辉煌、启迪碎片
			NOGENERATORSKILL = "熟练的技师才能胜任这项工作。",
			-- 韦伯(蜘蛛人)试图给物品栏中的蜘蛛戴帽子
			SPIDERNOHAT = "我的口袋不能同时装下它们", -- 物品栏里的蜘蛛不能戴帽子
        },

		-- 给予玩家单件物品
		GIVETOPLAYER =
        {
			FULL = "他已经拿不下了。",
            DEAD = "慢了一步。",
            SLEEPING = "他正处于深眠之中。",
            BUSY = "他现在没空。",
		},

		-- 给予玩家整组物品
		GIVEALLTOPLAYER =
        {
			FULL = "他已经拿不下了，或许我给的太多了？",
            DEAD = "慢了一步。",
            SLEEPING = "他正处于深眠之中。",
            BUSY = "他现在无暇接受。",
		},

		-- 给小木牌绘画
		WRITE =
        {
            GENERIC = "刚刚错失了灵感……我该再试一次。",
            INUSE = "没有足够的空白了。",-- 已经被画了
        },

        DRAW =
        {
            NOIMAGE = "我需要一个参照物。",-- 旁边没东西时试图绘画
        },

		-- 换装
		CHANGEIN =
        {
			-- 衣柜
            GENERIC = "没有那件礼服吗？我该再找找？",-- 通用无法成功
            BURNING = "现在已经是“热门装扮”了！",   -- 着火状态
            INUSE = "我在排队。",                  -- 等待
			-- 皮弗娄牛美妆台
			NOTENOUGHHAIR = "皮毛不够用来装扮。",-- 皮弗娄牛美妆台上的牛被剃毛了
			NOOCCUPANT = "得在上面栓点东西。",	 -- 皮弗娄牛美妆台上没有牛
        },

		ATTUNE =
        {
            NOHEALTH = "继续进行这个仪式恐怕会危害我的生命。",  -- 建造肉块雕像时血量不足
        },

        -- 骑牛
		MOUNT =
        {
            TARGETINCOMBAT = "它正在勉力奋战！",-- 牛正在战斗
            INUSE = "有人捷足先登了。",         -- 骑乘(牛被占据)
			SLEEPING = "它被梦境迷惑了。",      -- 牛在睡觉
        },

		-- 栓牛(？)
        HITCHUP =
        {
            NEEDBEEF = "我的牛去哪了？",		     -- 没有牛
            NEEDBEEF_CLOSER = "绳子不够长，近一些。", -- 牛太远
            BEEF_HITCHED = "老实待着吧。",		     -- 牛已经被拴起来了
            INMOOD = "它在向往一些别的东西。",		  -- 牛在发情
        },

		-- 上鞍
		SADDLE =
        {
            TARGETINCOMBAT = "战斗不容分心。",-- 给战斗状态的牛上鞍
        },

		-- 学习/使用蓝图类道具
		TEACH =
        {
            KNOWN = "我早就知道那个了。",		-- 学习已经知道的蓝图
            CANTLEARN = "这些知识在抗拒我？",	-- 学习无法学习的蓝图
            WRONGWORLD = "让我看看我未来的领土。",-- 学习另外一个世界的地图(？)
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "这里没有大海。",-- 在地下使用漂流瓶
            STASH_MAP_NOT_FOUND = "这是张假冒的藏宝图！",      -- 宝藏图纸没有宝藏
        },

		-- 打包纸
		WRAPBUNDLE =
        {
            EMPTY = "到底要打包什么？",-- 试图空打包/打包纸没有打包的对象
        },

		-- 拿起错误的物品
		PICKUP =
        {
			RESTRICTION = "它不适合我。", -- 熔炉模式下捡起错误的武器
			INUSE = "是别人的。",		  -- 捡起已经打开的容器
            NOTMINE_YOTC =
            {
                "这只橙黄色老鼠有主人了。",	 -- 捡起别人的胡萝卜鼠
                "这只不是我的。",		    -- 捡起别人的胡萝卜鼠
            },

			-- 满诅咒
		    FULL_OF_CURSES = "诅咒的力量开始发作了！",

		},

		-- 暴食相关
		-- 装盘
		REPLATE =
        {
            MISMATCH = "试试另外的餐具吧。", -- 换盘子换错了 比如用碗换碟子
            SAMEDISH = "已经在装了。",		-- 换盘子已经换了
        },

		-- 屠宰
		SLAUGHTER =
        {
            TOOFAR = "它逃走了。",
        },

		-- 将船停入修船厂(单机版海难DLC)
		SAIL =
		{
			REPAIR = "她状态良好。",-- 船的状态完好
		},

		-- 划船失败
		ROW_FAIL =
        {
            BAD_TIMING0 = "动作太急躁了。",		         -- 第1次
            BAD_TIMING1 = "应该划船，而不是拍浪。",       -- 第2次
            BAD_TIMING2 = "我应该去创造一种更方便的船！", -- 第3次
        },

		-- 降帆失败
		LOWER_SAIL_FAIL =
        {
            "没降下来？",
            "我确信这将是我最后一次失手。",
            "我应该做个更方便的装置！",
        },

		-- 给陶轮已有的图纸
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "已经有这张图纸了。",
		},

		-- 称重
		COMPARE_WEIGHABLE =
		{
            FISH_TOO_SMALL = "这些鱼都不长个吗？",	        	 -- 鱼秤 手上的没鱼缸里的大
            OVERSIZEDVEGGIES_TOO_SMALL = "这个不足以打破记录。", -- 蔬菜秤 手上的没秤上的大
		},

        -- 耕地研究
		PLANTREGISTRY_RESEARCH_FAIL =
        {
            GENERIC = "我已经很了解这颗植物了。",	   -- 研究作物失败
            FERTILIZER = "它的成分列表我已经知道了。", -- 研究肥料失败
        },

		-- 水壶在海里灌水
		FILL_OCEAN =
        {
            UNSUITABLE_FOR_PLANTS = "需要淡水。",
        },

		-- 水壶快没水了
		POUR_WATER =
        {
            OUT_OF_WATER = "快没水了，得尽快装满。",
        },

		-- 水壶没有水了
		POUR_WATER_GROUNDTILE =
        {
            OUT_OF_WATER = "没水了，需要打水。",
        },

		-- 使用牛玲
		USEITEMON =
        {
            BEEF_BELL_INVALID_TARGET = "对牛弹琴。",		 -- 对无效目标使用牛铃铛
            BEEF_BELL_ALREADY_USED = "它已经有主人了。",	 -- 对已有主人的牛使用牛铃铛
            BEEF_BELL_HAS_BEEF_ALREADY = "这个铃铛绑定过了。",-- 已有牛 使用牛铃铛
        },

		-- 疑似为给有弹窗的建筑物添加材料失败
        CONSTRUCT =
        {
            INUSE = "得等等。",	                -- 建筑正在使用
            NOTALLOWED = "那个位置不适合它。",	 -- 建筑不允许使用
            EMPTY = "需要继续添砖加瓦。",		 -- 建筑空了
            MISMATCH = "这不是它该用到的东西。", -- 升级套件错误
            NOTREADY = "我有些看不清了。",       -- 没有视野？
        },

		-- 对赃物袋使用非克劳斯钥匙
		UNLOCK =
        {
        	WRONGKEY = "这不是它的钥匙。",
        },

	    -- 解锁克劳斯的赃物袋
		USEKLAUSSACKKEY =
		{
			WRONGKEY = "这不是钥匙。", -- 使用普通鹿角
			KLAUS = "先得干掉原主！",  -- 克劳斯在场，无法打开
			QUAGMIRE_WRONGKEY = "我得再找一把钥匙。",
		},

		-- 激活
		ACTIVATE =
		{
			MANNEQUIN_EQUIPSWAPFAILED = "他穿不上。", -- 与假人互换装备失败
			EMPTY_CATCOONDEN = "已经被洗劫一空了。",   -- 浣猫窝/空心树桩里没东西
			-- 活动
			-- 浣猫年捉迷藏
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDERS = "猫太少了，没法游戏。",	-- 小浣猫太少，无法捉迷藏
			KITCOON_HIDEANDSEEK_ONE_GAME_PER_DAY = "它们已经累坏了。",	   -- 每天只能玩一次捉迷藏
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDING_SPOTS = "周围没有足够的地方供它们藏身。",-- 可藏身物体太少，无法捉迷藏
			-- 鸦年华良羽鸦
			HOSTBUSY = "他抽不出身。",		    -- 良羽鸦正在忙
			CARNIVAL_HOST_HERE = "他就在附近。",-- 良羽鸦已经在树旁
			NOCARNIVAL = "他不在这。",		    -- 良羽鸦已离开
			-- 兔人年枕头大战
			PILLOWFIGHT_NO_HANDPILLOW = "我需要一个枕头来开战！",-- 没有枕头，无法进行枕头大战
			-- 暴食
			LOCKED_GATE = "显而易见，这需要钥匙。",	-- 暴食的铁门(未开启)
			-- 薇洛(火女)专属
			NOTMYBERNIE = "它不属于我。",-- 无法安抚别人的伯尼
			-- 沃特专属
			NOTMERM = "那些鱼脑袋只信任鱼人。",	   -- 非鱼人不能用食堂海带盘召集鱼人
			NOKELP = "only_used_by_wurt",	     -- 食堂海带盘无海带，不能召集鱼人(沃特专用)
			HASMERMLEADER = "only_used_by_wurt", -- 已经有其他玩家用这个海带盘集鱼人了(沃特专用)
		},

        APPRAISE =
        {
            NOTNOW = "还没准备好。",-- 给牛评价，时间不对(疑似为牛年选美活动)
        },

        REPAIR =
        {
            WRONGPIECE = "很明显的失误。",-- 化石骨架拼接错误
        },

		-- 领养宠物失败
        BUILD =
        {
            MOUNTED = "骑士的坐骑太高了。",		-- 骑乘状态无法领养
            HASPET = "观赏用的宠物一个就够了。",-- 已经有一个宠物了
			TICOON = "追随者已经够多了。",
        },

		-- 使用角色专属道具/放置为建筑型道具
		OPEN_CRAFTING =
		{
			PROFESSIONALCHEF = "专业的厨具需要专业的厨师。", -- 非大厨角色使用便携厨具
			SHADOWMAGIC = "记载着暗影的奥秘……",	 -- 非老麦角色使用暗影秘典
		},

		-- 进行胡萝卜鼠赛跑
		START_CARRAT_RACE =
		{
			NO_RACERS = "选手还未就位。",-- 赛场上没有胡萝卜鼠
		},

		-- 拆除大厨便携物品
		DISMANTLE =
		{
			COOKING = "还在做菜呢。",          -- 正在做饭
			INUSE = "有人正在使用。",			-- 有人正在使用
			NOTEMPTY = "先把里面的东西收拾好。",-- 里面有物品
        },

	------ 角色专属
        -- 释放技能失败(施法滚轮)
		CASTAOE =
		{
			-- 麦斯威尔
			NO_MAX_SANITY = "only_used_by_waxwell",	-- SAN值消耗达上限(已经召唤了6个暗影傀儡)
			-- 薇落(火女)
			NOT_ENOUGH_EMBERS = "only_used_by_willow", -- 余烬不足
			NO_TARGETS = "only_used_by_willow",	       -- 燃烧术没有目标
			CANT_SPELL_MOUNTED = "only_used_by_willow",-- 无法在骑乘时释放月焰
			SPELL_ON_COOLDOWN = "only_used_by_willow", -- 技能正处于冷却中
			-- 薇落娜(女工)
			NO_BATTERY = "only_used_by_winona",	 -- 称手遥控器没电了
			NO_CATAPULTS = "only_used_by_winona",-- 遥控范围内没有投石机
		},

		-- 温蒂收服小惊吓
        BEGIN_QUEST =
        {
            ONEGHOST = "only_used_by_wendy",
        },

        -- 沃尔夫冈
        -- 使用强大健身房
		ENTER_GYM =
		{
			NOWEIGHT = "only_used_by_wolfang",  -- 没有负重
			UNBALANCED = "only_used_by_wolfang",-- 不平衡(有一侧没有负重？或者负重不均匀)
			ONFIRE = "only_used_by_wolfang",    -- 正在着火
			SMOULDER = "only_used_by_wolfang",  -- 正在闷烧
			HUNGRY = "only_used_by_wolfang",    -- 饥饿值过低
			FULL = "only_used_by_wolfang",      -- 有人在使用
		},

		-- 薇克巴顿(老奶奶)/麦斯威尔读书失败
		READ =
		{
			GENERIC = "暂时不行。",-- 通用阅读失败
			-- 《世界鸟类大全》
			NOBIRDS = "千山鸟飞绝。",		                 -- 召唤不出鸟
			TOOMANYBIRDS = "鸟群几乎落尽了，没法叫出太多了。", -- 附近超过20只鸟则大幅减少读书后的召唤量，以防崩内存
			WAYTOOMANYBIRDS = "鸟群已然落尽。",	             -- 附近超过30只鸟则禁止读书召唤，以防崩内存
            BIRDSBLOCKED = "飞鸟可进不来这樊笼",			  -- 瓦格斯塔夫竞技场内
			DEADBIRDS = "鸟群正在死亡处赴宴。",				  -- 月雹期间
			-- 《垂钓者指南》
			NOWATERNEARBY = "显而易见，这本书得对着水读。", -- 附近没有水，无法生成鱼群
			-- 《意念控火术》
			NOFIRES = "这附近没有可以操控的火焰。",	-- 附近没有火焰
			-- 《应用造林学》
			NOSILVICULTURE = "没有可聚焦的树栖主体。",	    -- 附近没有树木或树精
            -- 《园艺学简编版》/《园艺学拓展版》》
			NOHORTICULTURE = "没有能听懂这个的植物。",	    -- 附近没有作物
			-- 《触手的召唤》
			NOTENTACLEGROUND = "触手没法抵达这个地方。",	-- 附近没有可生成触手的地形
			-- 《睡前故事》
			NOSLEEPTARGETS = "这里没有幻梦境的受害者。",	-- 附近没有可以睡眠的生物
			-- 《养蜂笔记》
			TOOMANYBEES = "已经够了，太多的蜜蜂只会过分喧闹。", -- 嗡嗡蜜蜂数量达到上限
			-- 《月之魔典》
			NOMOONINCAVES  = "“祂”看不到这里。",	-- 洞穴里无法改变月相
			ALREADYFULLMOON = "“祂”已经看过来了。",	-- 已经是满月了
		},

		-- 薇格弗德(女武神)唱战歌失败
		SING_FAIL =
		{
			SAMESONG = "only_used_by_wathgrithr",
		},

		-- 沃尔特(童子军)讲故事
		TELLSTORY =
		{
			GENERIC = "only_used_by_walter",
		},

		-- WX-78插入电路
        APPLYMODULE =
        {
            COOLDOWN = "only_used_by_wx78",		  -- 电路冷却中？
            NOTENOUGHSLOTS = "only_used_by_wx78", -- 槽位不足
        },
		-- WX-78拔出电路
        REMOVEMODULES =
        {
            NO_MODULES = "only_used_by_wx78",-- 没有电路
        },
		-- WX-78充能
        CHARGE_FROM =
        {
            NOT_ENOUGH_CHARGE = "only_used_by_wx78",-- 电力不够？
            CHARGE_FULL = "only_used_by_wx78",		-- 电力已满
        },

		-- 非机器人角色获取生物扫描仪数据
		HARVEST =
		{
			DOER_ISNT_MODULE_OWNER = "只有二进制生命能跟它沟通。",
		},

		-- 麦斯威尔
		CAST_SPELLBOOK =
		{
			NO_TOPHAT = "首先……需要一个高礼帽",	-- 老麦施法时，没有高礼帽可变为魔术师高礼帽
		},

		-- 沃特(小鱼人)
		CASTSPELL =
		{
			TERRAFORM_TOO_SOON = "only_used_by_wurt",	-- 投泥带仍处在冷却中(沃特专用)
		},


		-- 韦伯(蜘蛛人)
		-- 使用韦伯口哨(？)
		HERD_FOLLOWERS =-- 召集蜘蛛
		{
			WEBBERONLY = "虽然它们不听我的，但是可能会听韦伯的。",-- 不是韦伯，无法召集蜘蛛
		},

		-- 装饰蜘蛛巢
		BEDAZZLE =
		{
			BURNING = "only_used_by_webber",-- 蜘蛛巢正在燃烧
			BURNT = "only_used_by_webber",  -- 蜘蛛巢烧毁了
			FROZEN = "only_used_by_webber", -- 蜘蛛巢被冰冻了
			ALREADY_BEDAZZLED = "only_used_by_webber",-- 蜘蛛巢已经装饰过了
		},

		-- 升级蜘蛛巢
		UPGRADE =
		{
			BEDAZZLED = "only_used_by_webber",		-- 无法给已装饰过的蜘蛛巢升级
		},

		-- 旺达
		-- 使用怀表
		CAST_POCKETWATCH =
		{
			GENERIC = "only_used_by_wanda",
			REVIVE_FAILED = "only_used_by_wanda",
			WARP_NO_POINTS_LEFT = "only_used_by_wanda",
			SHARD_UNAVAILABLE = "only_used_by_wanda",
		},

		-- 拆解怀表
		DISMANTLE_POCKETWATCH =
		{
			ONCOOLDOWN = "only_used_by_wanda",-- 怀表冷却中，无法拆解
		},

	-----钓鱼鱼竿不对
        FISH_OCEAN =
		{
			TOODEEP = "对于大海来说，这根鱼竿太短了。",-- 拿普通鱼竿去深海钓鱼
		},
        OCEAN_FISHING_POND =
		{
			WRONGGEAR = "里面没有大鱼适合它。",-- 拿深海鱼竿去普通的池子里钓鱼
		},

		PICK =
		{
			NOTHING_INSIDE = "已经被洗劫一空了。",-- 水獭掠夺者窝点里没东西
		},

		HEAL =
		{
			NOT_MERM = "只有鱼脑袋才会用这种东西。",-- 蚊血注射液只对鱼人有效
		},

		-- 薇洛娜(女工)
		-- 使用玫瑰色眼镜检查
		LOOKAT =
		{
			ROSEGLASSES_INVALID = "黑魔法也一无所获。",          -- 检查无结果
			ROSEGLASSES_COOLDOWN = "哪怕是黑魔法也不能如此滥用。",-- 检查冷却中
			ROSEGLASSES_DISMISS = "消散吧，等待我的下次征召。",   -- 检查黑暗痕迹使其消失
			ROSEGLASSES_STUMPED = "我还没有掌握这种法术……",      -- 检查天赋不够
		},
		-- 传送伞
		REMOTE_TELEPORT =
		{
			NOSKILL = "only_used_by_winona",-- 没有对应技能无法使用传送伞
			NODEST = "only_used_by_winona",	-- 激活传送伞无传输站
		},

		-- 皮弗娄牛年活动相关
	    -- 选择参与牛
        MARK =
        {
            ALREADY_MARKED = "这就是我的坐骑了。",-- 已经选择了
            NOT_PARTICIPANT = "要再等等了。",	 -- 不是参与者(疑似一场比赛已经开始了)
        },

		-- 裁判席
        YOTB_STARTCONTEST =
        {
            DOESNTWORK = "他不在这。",	 -- NPC不在
            ALREADYACTIVE = "暂时不行。",-- NPC已经激活
        },

		-- 缝纫机
        YOTB_UNLOCKSKIN =
        {
            ALREADYKNOWN = "我已经知道这个造型了。",-- 解锁已知皮肤
        },

		-- 温蒂草药使用失败
		APPLYELIXIR =
		{
			TOO_SUPER 	  = "这顶草帽承受不住域外的力量。",	-- 尝试使用
			NO_ELIXIRABLE = "only_used_by_wendy",		  -- 温蒂对无法接受药剂的目标使用药剂
		},

		-- 对温泉使用沐浴球失败
		BATHBOMB =
		{
			GLASSED = "显而易见，只能扔到水里。",    -- 温泉凝固为玻璃结晶状态
			ALREADY_BOMBED = "已经备好了。",        -- 温泉已经使用过沐浴球
		},

		-- 嘉年华投喂小游戏失败
		CARNIVALGAME_FEED =
		{
			TOO_LATE = "我需要动作更快一些！",      -- 超时
		},

		-- 雕刻南瓜失败
		CARVEPUMPKIN =
		{
			INUSE   = "已经有人在刻画了。",          -- 已经有其他玩家正在雕刻
			BURNING = "火焰抢先一步。",              -- 南瓜着火了
		},

		-- 装饰雪人失败
		DECORATESNOWMAN =
		{
			INUSE = "我没有兴趣去抢夺别人的作品。",          -- 已经有其他玩家正在装饰雪人
			HASHAT = "它已经有一顶帽子了。", 				-- 雪人头上有帽子遮挡装饰位置
			STACKEDTOOHIGH = "再继续堆叠就无法保持稳定了。", -- 雪人堆叠部件超出上限
			MELTING = "它已经汗流浃背了。",					-- 雪人处于融化状态
		},

		-- 温蒂尝试令阿比盖尔变身失败
		MUTATE =
		{
			NOGHOST = "only_used_by_wendy",          -- 尝试变异但周围无可用幽灵
			NONEWMOON = "only_used_by_wendy",        -- 尝试新月变异但非新月阶段
			NOFULLMOON = "only_used_by_wendy",       -- 尝试满月变异但非满月阶段
			NOTNIGHT = "only_used_by_wendy",         -- 尝试夜间变异但当前是白天
			CAVE = "only_used_by_wendy",             -- 在洞穴中尝试依赖月光的变异
		},

		-- 改装弹弓失败
		MODSLINGSHOT =
		{
			NOSLINGSHOT = "only_used_by_walter",     -- 沃尔特尝试改装弹弓但未携带弹弓
		},

		-- 扑捉动作失败
		POUNCECAPTURE =
		{
			MISSED = "让它逃得一劫！",                 -- 扑捉技能因目标移动失败
		},

		-- 俯冲抓取失败
		DIVEGRAB =
		{
			MISSED = "让它逃得一劫！",                 -- 俯冲抓取因目标移动失败
		},

		-- 尝试泡温泉失败
		SOAKIN =
		{
			NOSPACE = "这里已经满员了。", -- 已经满员了
		},

	},

------ 常见通用台词 --------------------------------------------------------------------------------------
    ANNOUNCE_DESPAWN = "让我们把目光移向新的嘉宾……",--  在天体之门换人

	ACTIONFAIL_GENERIC = "这行不通！",         --  通用动作失败默认设置
	ANNOUNCE_ADVENTUREFAIL = "我该再试一次。", --  动作失败

	-- 制作失败
	ANNOUNCE_CANNOT_BUILD =
	{
		NO_INGREDIENTS = "材料不足。",	   --  材料不足
		NO_TECH = "还需要进一步研究解锁。", --  科技不够
		NO_STATION = "现在做不了这个。",   --  不在科技建筑旁边
	},

	ANNOUNCE_CRAFTING_FAIL = "材料不足。", --  制作时材料不足

	ANNOUNCE_DUSK = "绚烂的黄昏。适合一杯晚茶。", --  进入黄昏时

	ANNOUNCE_ENTER_DARK = "这可不是拥抱暗影的好时候……", --  进入黑暗
	ANNOUNCE_ENTER_LIGHT = "亮堂起来了。",              --  进入光源

	-- 玩家死亡和鬼魂
	ANNOUNCE_GHOSTDRAIN = "我的人性……在流失？",    -- 有玩家队友鬼魂

	-- 特殊检查情况
	DESCRIBE_GENERIC = "这是……什么？",      --  默认未知检查
	DESCRIBE_TOODARK = "太暗了，看不清。",  --  黑暗中没有视野
	DESCRIBE_SMOLDERING = "快要烧起来了！", --  检查闷烧冒烟的东西
	ANNOUNCE_BURNT   = "已经烧毁了。",      --  检查烧毁的建筑物
	ANNOUNCE_BECOMEGHOST = "……", -- 死后作为鬼魂检查物品的台词、

	-- 特殊状态
	ANNOUNCE_INV_FULL = "抱歉，我暂时腾不出手。", -- 超出携带上限
	ANNOUNCE_COLD = "大自然还真是冷酷……",    -- 过冷
	ANNOUNCE_HOT  = "真是令人焦头烂额……",         -- 过热
	ANNOUNCE_HUNGRY = "我已饥肠辘辘。",       -- 饥饿值过低
	ANNOUNCE_COZY_SLEEP = "我从幻梦境归来了。",   -- 睡醒(舒适地睡醒？)
	ANNOUNCE_KNOCKEDOUT = "竟敢干涉我的意志……!", -- 被催眠后醒来
	ANNOUNCE_TOWNPORTALTELEPORT = "真是一路风尘仆仆。",   -- 使用强征塔传送
	ANNOUNCE_HERMITCRAB_SHELL_BADTELEPORTPOINT = "看来海洋巫术不怎么靠谱。", 	  -- 使用搬运海螺传送失败
	ANNOUNCE_HERMITCRAB_SHELL_ARRIVE           = "想不到这种原始巫术居然能起效。", -- 使用搬运海螺传送
	ANNOUNCE_WORTOX_REVIVER_FAILTELEPORT = "啧，失效了。", -- 使用双尾心传送失败
	ANNOUNCE_CHAIR_ON_FIRE = "这样就好。",      -- TODO:疑似在烧毁的椅子

    -- 潮湿状态
	ANNOUNCE_DAMP   = "啧……潮湿。",            				 -- 1级
	ANNOUNCE_WET    = "……我需要换一身干爽的行头。",			   -- 2级
	ANNOUNCE_WETTER = "这幅落汤模样不止有失体面！",			   -- 3级
	ANNOUNCE_SOAKED = "一时失意，竟狼狈至此，真是……何其难堪……",	-- 4级

	-- 进食动作
	ANNOUNCE_EAT =
	{
		GENERIC = "多谢款待。",-- 表示正常进食
		PAINFUL = "……这是刺杀！",-- 食用了有减益效果的食品
		STALE = "竟敢用剩饭来羞辱我！？",-- 食物不新鲜了(黄色新鲜度)
		SPOILED = "这玩意已经快烂掉了！",-- 食物已经变质(红色新鲜度)
		INVALID = "只有精心烹饪的美食才有资格上我的餐桌。",-- 不能进食此食物(包括非食品物品和因为角色特殊原因无法进食)
		YUCKY = "我可不会吃这种东西。",-- 拒绝食用恶心食物，例如永恒水晶蛋糕，可能还有猪皮？

		-- 沃利(大厨)专属台词
		COOKED = "值得褒奖的厨艺。",-- 进食料理
		DRIED = "丰盛而美味。", -- 疑似进食肉干？
		PREPARED = "值得欣赏的美味。",-- 暂时未知
		RAW = "灾难性的口感！",   -- 进食潮湿食物
		SAME_OLD_1 = "only_used_by_warly",-- 食物记忆1次
		SAME_OLD_2 = "only_used_by_warly",-- 食物记忆2次
		SAME_OLD_3 = "only_used_by_warly",-- 食物记忆3次
		SAME_OLD_4 = "only_used_by_warly",-- 食物记忆4次
		SAME_OLD_5 = "only_used_by_warly",-- 食物记忆5次
		TASTY = "味道不错。",     -- 吃不属于上述类型的食物
	},

    -- 搬运重物(雕像/可疑的大理石/天体祭坛部件等)
	ANNOUNCE_ENCUMBERED =
	{
		"这东西太重了！",
		"我的奴隶在哪！？",
		"这完全就是一场酷刑！",
		"我怎么会蠢到亲自搬运……",
		"我该想办法强化我的肉体力量……",
		"看来驯养一头畜生也不是毫无用处……",
		"还有多久！？",
		"我该创造一些工具来解脱我自己……",
		"我的管家呢？！",
	},

	-- 挖开天体祭坛部件(吸引人的结构)
	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "原来在这里。",
		GLASS_LOW = "再挖两下。",
		GLASS_REVEAL = "出来了。",
		IDOL_MED = "里面有月的力量。",
		IDOL_LOW = "看到了……",
		IDOL_REVEAL = "出来了。",
		SEED_MED = "里面是什么？",
		SEED_LOW = "原来是这个……",
		SEED_REVEAL = "找到你了。",
	},

	-- 道具损坏、脱手、错误应用
	ANNOUNCE_TOOL_SLIP = "它脱离了掌控！",           -- 工具脱手
	ANNOUNCE_TOOL_TOOWEAK = "这个胜任不了。",        -- 没有强力开采的工具试图敲绝望石柱、开采纯粹辉煌和绝望石
	ANNOUNCE_COMPASS_OUT = "它已经不能再指明方向了。",-- 指南针损坏
	ANNOUNCE_TORCH_OUT = "火炬燃尽了！",             -- 火把用尽
	ANNOUNCE_THURIBLE_OUT = "该添加新的诱饵了。",     -- 暗影香炉燃尽
	ANNOUNCE_BOOK_MOON_DAYTIME = "要到夜里才能看到效果。",-- 白天读书改变月相
	ANNOUNCE_FAN_OUT = "它随风而去了",-- (存疑)小风车停下了/坏掉了/物品被风吹走
	ANNOUNCE_GATHER_MERM = "只有鱼人能这么做。",	-- 食堂海带盘处召集鱼人
	ANNOUNCE_SACREDCHEST_YES = "简单的谜题。",-- 远古宝箱物品正确给出蓝图
	ANNOUNCE_SACREDCHEST_NO = "嗯？不是这些？",-- 远古宝箱物品错误
	ANNOUNCE_RABBITKINGHORN_BADSPAWNPOINT = "兔子可挖不到这来。",--  不在陆地上使用兔王号角，召唤兔子洞失败

	ANNOUNCE_SHELTER = "大树底下好乘凉。",-- 进入普通树荫

	ANNOUNCE_WORMHOLE = "真是奇诡的生物！……这东西是生物吗？",-- 从虫洞里出来

	ANNOUNCE_CANFIX = "\n我能修好它。",-- 可以修好目标

	ANNOUNCE_PREFALLINVOID = "这里已经摇摇欲坠了！", --  吊桥正在开裂崩溃
	ANNOUNCE_OTTERBOAT_OUTOFSHALLOWS = "这简陋的东西无法在深海航行。",-- 水獭掠夺者窝点无法在深海航行
	ANNOUNCE_OTTERBOAT_DENBROKEN = "打掉那个窝点可能引发了连锁反应……",-- 水獭掠夺者窝点毁掉后船体开始损坏

	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "真是大发雷霆。",-- 附近打下闪电

	ANNOUNCE_HUNT_BEAST_NEARBY = "新鲜的足迹，这家伙就在附近。",        -- 找到第一个大象脚印
	ANNOUNCE_HUNT_LOST_TRAIL = "已经没有踪迹了……被它逃过一劫。",       -- 脚印中断
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "已经没有踪迹了……被它逃过一劫。",-- 湿地找不到脚印(？)

	-- 暴食相关
    QUAGMIRE_ANNOUNCE_NOTRECIPE = "This combination of food was ill-advised.",
    QUAGMIRE_ANNOUNCE_MEALBURNT = "Curses! Too slow.",
    QUAGMIRE_ANNOUNCE_LOSE = "This may be the end.",
    QUAGMIRE_ANNOUNCE_WIN = "The Gateway is ready!",

	-- 对头戴蜂王冠的玩家
    ANNOUNCE_ROYALTY =
    {
        "看起来你继承了膜翅目的皇位？",
        "你的国又在何方呢，殿下？",
        "看来权威给了你足够的自信。",
    },
	-- 对头戴蜂王冠小丑帽皮肤的玩家
    ANNOUNCE_ROYALTY_JOKER =
    {
        "小丑皇。",
        "希斯·莱杰真该向你学习什么叫“本色出演”。",
        "你根本不是小丑，你就是一整个马戏团。",
    },

------ 预警、受伤与BOSS战相关
	ANNOUNCE_CHARLIE = "贵安，暗夜的女王。",     -- 查理攻击预警
	ANNOUNCE_CHARLIE_ATTACK = "嘶……不觉得你有点太失礼了吗，女士？",  -- 被查理攻击

	ANNOUNCE_HOUNDS = "那些猎犬要来送死了。",    -- 猎犬袭击预警
	ANNOUNCE_WORMS = "那些虫子要来送死了。",     -- 蠕虫袭击预警
	ANNOUNCE_PIRATES_ARRIVE = "有黑帆在附近！", -- 猴子海盗袭击预警
	ANNOUNCE_ACIDBATS = "那些烦人的蝙蝠又来了。",-- 酸雨蝙蝠袭击预警

	ANNOUNCE_DEERCLOPS = "听起是一头足够分量的猎物。", -- BOSS(巨鹿、熊獾)刷新预警

    ANNOUNCE_MOUNT_LOWHEALTH = "我的坐骑已经遍体鳞伤了！", -- 牛血量过低

	ANNOUNCE_THORNS = "嘶……植物的保护策略起效了。", 	-- 被玫瑰、仙人掌、荆棘灌木扎伤
	ANNOUNCE_TRAP_WENT_OFF = "这是个卑鄙的陷阱！",      -- 触发陷阱
	ANNOUNCE_BOOMERANG = "该死的叛逆……!",              -- 被自己丢出的回旋镖攻击到(没接住回旋镖)
	ANNOUNCE_MOSQUITOS = "烦人的东西，就像亚巴顿的害虫！",-- 被蚊子攻击
	ANNOUNCE_BEES = "像亚巴顿的害虫一样烦人！",          -- 戴着养蜂帽时被蜜蜂攻击
	ANNOUNCE_PECKED = "胆敢弑君？",						-- 被小高鸟啄

	--  兔王
    --  召唤出敌对兔王
    ANNOUNCE_RABBITKING_AGGRESSIVE = "听起来有自寻死路的逆臣想要发起叛乱？",
    --  召唤出友善兔王
    ANNOUNCE_RABBITKING_PASSIVE = "我的藩臣正在赶来向我朝贡。",
    --  遇到幸运兔
    ANNOUNCE_RABBITKING_LUCKY = "出逃的爱丽丝？",
    --  抓到幸运兔
    ANNOUNCE_RABBITKING_LUCKYCAUGHT = "你逃不出命运的掌心，不是吗？",

	--  克劳斯
	ANNOUNCE_KLAUS_ENRAGE = "哦，无能狂怒，难道它们其实是你仅剩的家人？", -- 克劳斯开始狂暴(杀死了鹿)
	ANNOUNCE_KLAUS_UNCHAINED = "这就是你的底牌？",		                -- 克劳斯死后变身(二阶段)
	ANNOUNCE_KLAUS_CALLFORHELP = "一群乌合之众能干什么？",		        -- 克劳斯召唤小偷

	--  织影者
	ANNOUNCE_SNARED 	= "你以为这个能困住我！？",		-- 远古织影者的骨笼
	ANNOUNCE_REPELLED 	= "先得斩断那些疯狂视界的手！",	-- 远古织影者保护状态

	-- 中庭刷新预告
	ANNOUNCE_ATRIUM_DESTABILIZING =
	{
		"看起来暗影要重塑这里。",
		"我最好先行离开。",
		"一切都将推倒重来。",
	},

	ANNOUNCE_RUINS_RESET = "一切都将推倒重来。",-- 地下重置

	-- 被恶液丸吞之后吐出来
    ANNOUNCE_EXIT_GELBLOB = "……杰森——！",

	ANNOUNCE_WEAPON_TOOWEAK = "需要更强力的武器！", -- 需要强力武器(攻击蜈蚣墨荒被弹开)
	ANNOUNCE_MUTATED_BUZZARD_ARRIVAL = "那些令人作呕的东西在等待机会。", -- 变异秃鹫生成并开始盘旋玩家


	-- 被蛇墨荒/狞笑在隐身形态下攻击
	ANNOUNCE_SHADOWTHRALL_STEALTH = "有刺客！",

	ANNOUNCE_TOADESCAPING = "嗯！？这东西想逃跑！", -- 蟾蜍正在逃跑
	ANNOUNCE_TOADESCAPED = "被它逃得一命……哼！",   -- 蟾蜍逃走了

    ANNOUNCE_QUAKE = "地震要来了。",         -- 地震
	ANNOUNCE_CAVEIN = "真是烦人的地质运动。", -- 地震(洞穴)

    -- 蚁狮地震
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"现在该跑了！",
		"在它结束前不要停下奔跑。",
		"或许可以想个一劳永逸的办法。",
	},

    -- 蚁狮互动
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "沙漠的藩王。",		         -- 向蚁狮致敬
        "赏你的，记住你的承诺。",	  -- 给蚁狮上供
        "……我的杀意已经开始沸腾了。",-- 给蚁狮上供
	},

	-- 进入战斗状态
	BATTLECRY =
	{
		GENERIC = "来吧，面对你的命运。",    -- 通用
		PIG = "死劫已至，蠢物。",	-- 猪人
		PREY = "是时候狩猎了。", -- 小动物(兔子等)
		DEER = "猎鹿季到了，你明白吗。", -- 无眼鹿
		SPIDER = "准备好面对灭绝了吗？", -- 蜘蛛
		SPIDER_WARRIOR = "尽情挣扎吧，这就是你仅有的一切。", -- 蜘蛛战士
	},

	-- 脱离战斗
	COMBAT_QUIT =
	{
		GENERIC = "我的仁慈仅此一次。",  -- 退出战斗
		PIG = "看在火腿砰砰的面上，我与你宽恕。",
		PREY = "也许我该把杀戮留待下一次再品尝。",
		SPIDER = "它们的产物还有些用处……灭绝延后。",
		SPIDER_WARRIOR = "希望下次你能表演更值得欣赏的丑态。",
	},

    ANNOUNCE_OFF_SCRIPT = "看起来剧本不容自由。", -- 舞台剧表演错误

    ANNOUNCE_LUNAR_RIFT_MAX = "真是明亮的月光，看来裂隙扩张到极限了。",  -- 天体裂隙达到最大
    ANNOUNCE_SHADOW_RIFT_MAX = "如此浓郁的暗影，看来虚空已经彻底展开了。",-- 暗影裂隙达到最大

    ANNOUNCE_SCRAPBOOK_FULL = "塞不下更多书了。",-- 书架放满了

	DIRTPILE = "猎物的踪迹……我很快就能享受一场愉悦的杀戮了。", -- 可疑的土堆
	ANIMAL_TRACK = "受害者预备役的路引。",                -- 动物足迹

	-- 关于恐怖之眼战
	ANNOUNCE_EYEOFTERROR_ARRIVE = "我喜欢这个入侵者的眼神……",-- 恐怖之眼出现
    ANNOUNCE_EYEOFTERROR_FLYBACK = "这一次它在劫难逃！", -- 恐怖之眼再次出现(上一次因为天亮逃脱)
    ANNOUNCE_EYEOFTERROR_FLYAWAY = "它逃得一命……但不会有下次。",-- 天亮导致恐怖之眼逃脱

	ANNOUNCE_LUNARGUARDIAN_INCOMING = "唉，你又回来了。", -- 月之守护者生成并向玩家靠近

    -- 获得buff
    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "是时候大发雷霆了。",		     -- 获得电击buff(目前指的是伏特羊角冻)
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "一抹战争的狂热。",		     -- 获得攻击加强的buff(目前是指辣椒粉料理)
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "那份料理给了我一种无形的守护。",-- 获得防御加强的buff(目前是指大蒜粉料理)
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "令人精神百倍。",		         -- 获得工作效率加强的buff(目前是指蜂蜜粉料理)
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "干爽，整洁，舒适。",		      -- 获得潮湿免疫的buff(目前是指蓝带鱼排)
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "我脑海里的月光驱散了睡意。",	   -- 获得睡眠减缓的buff(目前是指月蘑菇料理)

	-- 温蒂草药
	ANNOUNCE_ELIXIR_BOOSTED      = "呼……修补身心。",      -- 回血类药剂
	ANNOUNCE_ELIXIR_GHOSTVISION  = "准备好洞悉幽冥了吗？", -- 饮用夜影万金油(幽灵夜视)
	ANNOUNCE_ELIXIR_PLAYER_SPEED = "现在可以健步如飞了。", -- 饮用强健精油(减少减速效果)
	ANNOUNCE_ELIXIR_TOO_SUPER    = "药性过猛，不宜饮用。", -- 尝试使用位面药剂

    -- 失去buff
    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "好像没电了。",		     -- 失去电击buff(目前指的是伏特羊角冻)
    ANNOUNCE_DETACH_BUFF_ATTACK            = "热情消退了。",	         -- 失去攻击加强的buff(目前是指辣椒粉料理)
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "那份料理的强韧效果结束了。",-- 失去防御加强的buff(目前是指大蒜粉料理)
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "疲倦突然就涌上来了。",	  -- 失去工作效率加强的buff(目前是指蜂蜜粉料理)
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "啧，潮湿。",		         -- 失去潮湿免疫的buff(目前是指蓝带鱼排)
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "月光褪去了。",             -- 失去睡眠减缓的buff(目前是指月蘑菇料理)
	ANNOUNCE_HEALINGSALVE_ACIDBUFF_DONE    = "抵抗酸雨的药剂失效了。",	  -- 药膏的防酸雨buff结束

	-- 因为处于危险(战斗状态)而无法行动/交互(例如睡觉、收在线礼物)
    ANNOUNCE_NOWARDROBEONFIRE = "这不是第一要事。",
    ANNOUNCE_NODANGERGIFT = "这不是第一要事。",
	ANNOUNCE_NODANGERSLEEP = "这不是第一要事。",

	-- 无法入睡状态
	-- 有关帐篷
	ANNOUNCE_NODAYSLEEP = "还没到午休时间。",   -- 在白天
	ANNOUNCE_NODAYSLEEP_CAVE = "我还精力充沛。",-- 在洞穴白天(？)
	ANNOUNCE_NOHUNGERSLEEP = "我想先吃点夜宵。",-- 饥饿值过低无法入睡
	ANNOUNCE_NOSLEEPONFIRE = "我只想小睡，而不是长眠。",-- 着火状态下无法入睡
	ANNOUNCE_NODANGERSIESTA = "稍等，我先去送这些家伙长眠。",-- 有怪物打扰
	-- 有关遮阳棚
	ANNOUNCE_NONIGHTSIESTA = "我不觉得这东西有助于一个好梦。",-- 夜间使用凉棚
	ANNOUNCE_NONIGHTSIESTA_CAVE = "我不觉得这东西有助于一个好梦。",-- 洞穴夜晚使用凉棚
	ANNOUNCE_NOHUNGERSIESTA = "我想先吃些点心。",            -- 饥饿值过低
	ANNOUNCE_NODANGERAFK = "稍等，我先去送这些家伙长眠。",    -- (未知？疑似被怪物打扰无法午睡)

------ 耕作与农艺相关------------------------------------------------------------------------------------
    ANNOUNCE_SNARED_IVY = "我早该铲除这叛逆！",-- 被针刺旋花攻击

------ 火荨麻buff
	-- 得到buff
	ANNOUNCE_FIRENETTLE_TOXIN =
	{
		"烈火在我体内滋长！",
		"一种生物毒素正在令我体温飙涨！",
	},

    -- buff结束
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "那股灼热感终于消失了。",

------ 检查农作物对话
    DESCRIBE_PLANTHAPPY = "它现在无忧无虑。",		-- 植物极低压力
	DESCRIBE_PLANTSTRESSED = "它生长的有点艰难。",	-- 植物压力较大(没有使用耕作先驱帽)
    DESCRIBE_PLANTVERYSTRESSED = "它快不堪重压了。",-- 植物压力极大(没有使用耕作先驱帽)
------ 有耕作先驱帽时显示具体压力来源
	DESCRIBE_PLANTSTRESSORMOISTURE = "需要浇水。",	  -- 水分压力
    DESCRIBE_PLANTSTRESSORNUTRIENTS = "缺乏养分。",	  -- 养分压力
    DESCRIBE_PLANTSTRESSORHAPPINESS = "它想跟我对话？",-- 幸福压力
    DESCRIBE_PLANTSTRESSORKILLJOYS = "周围杂物太多了。",	   -- 杂物压力
    DESCRIBE_PLANTSTRESSORFAMILY = "它感到孤独。",-- 家庭压力
    DESCRIBE_PLANTSTRESSOROVERCROWDING = "这块地住不下了。",   -- 拥挤压力
    DESCRIBE_PLANTSTRESSORSEASON = "它不适应现在的季节。",		-- 季节压力

	ANNOUNCE_INSUFFICIENTFERTILIZER = "土地肥力不足。",-- 土地肥力不足

	ANNOUNCE_PLANT_RESEARCHED =
    {
        "让我来看看这株植物的构造。",-- 研究植物
    },

	ANNOUNCE_FERTILIZER_RESEARCHED = "让我来看看它的成分配比。",-- 研究肥料

    ANNOUNCE_PLANT_RANDOMSEED = "别报太大希望，大部分是杂草。",-- 种下随机种子


	-- 沃姆伍德专属：铲除植物时的愧疚台词
    ANNOUNCE_KILLEDPLANT =
    {
        "它不该呆在这。",
        "一次干净利落的处刑。",
        "不知道那块活的绿宝石对此有何看法。",
    },

	-- 沃姆伍德专属：对话植物
    ANNOUNCE_GROWPLANT =
    {
        "快长大吧，我等着收获。",
        "有人比我更适合做这个。",
        "快长吧，我要等不耐烦了。",
    },

	-- 沃姆伍德专属：开花
    ANNOUNCE_BLOOMING =
    {
        "感觉开花了。",
    },

    -- 照料植物时会说的台词
	ANNOUNCE_TALK_TO_PLANTS =
	{
		"我命令你无忧无虑地茁壮成长。",
		"一株植物所需的一切，无非水分、土壤和我的注视，不是吗？",
	    "已经理解了被我食用代表着怎样的荣誉了吗，很好。",
		"让你的根再努力些。",
		"为了早日登上我的餐桌，你需要更加努力地成长。",
	},

------ 航海与钓鱼相关-------------------------------------------------------------------------------------

	ANNOUNCE_WASHED_ASHORE = "真是……何其难堪。", -- 落水被冲上岸

	ANNOUNCE_FLOATER_HELD   = "……我需要……更有效的……发明！", -- 落水后依靠个人漂浮装置浮起
	ANNOUNCE_FLOATER_LETGO  = "……好吧，富坦，我来了。", -- 放弃个人漂浮装置选择落水

	-- 海钓失败
	ANNOUNCE_OCEANFISHING_LINESNAP = "太用力了！",		-- 线崩断了
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "狡诈的家伙。",-- 渔具丢失
	ANNOUNCE_OCEANFISHING_GOTAWAY = "它亡命而逃了。",	-- 鱼跑远了
	ANNOUNCE_OCEANFISHING_BADCAST = "地上可钓不出鱼。",	-- 抛竿扔地面上去了

	-- 海钓闲聊内容
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE =
	{
		"耐心……需要耐心……",
		"时间就这样随着水波逝去。",
		"也许我需要创造更有效率的工具……",
		"或许我可以找个人来代替我……",
	},

    -- 给鱼称重
	ANNOUNCE_WEIGHT = "也就：{weight}kg,普普通通。",		    -- 普通
	ANNOUNCE_WEIGHT_HEAVY  = "有: {weight}kg,\n是条真正的大鱼。", -- 大鱼

    -- 夹夹绞盘
	ANNOUNCE_WINCH_CLAW_MISS = "没命中……得找准位置。",-- 没命中
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "还没捞到好处。",	   -- 没东西

	ANNOUNCE_BOAT_LEAK = "听到了吗，船在哭泣。", -- 船撞了个洞
	ANNOUNCE_BOAT_SINK = "唉……送我上岸，富坦。", -- 船漏水

-----一些单独的检查台词 ------------------------------------------------------------------------------------------------
	-- 检查相同角色
	-- DESCRIBE_SAMECHARACTER = "",

	ANNOUNCE_LUNARHAIL_BIRD_SOUNDS = "What is that racket?",
	ANNOUNCE_LUNARHAIL_BIRD_CORPSES = "That's not a good sign.", -- 月雹期间鸟类坠落死亡
	ANNOUNCE_FLOAT_SWIM_TIRED = "I can't!",
	ANOUNCE_MUTATED_BIRD_ATTACK = "Blasted birds!",

	-- 猴子诅咒
    ANNOUNCE_CANT_ESCAPE_CURSE = "恶心的感觉……", -- 得到猴子诅咒
    ANNOUNCE_MONKEY_CURSE_1 = "这种诅咒不应对我有效才对……?", -- 开始变成猴子
    ANNOUNCE_MONKEY_CURSE_CHANGE = "",-- 完全变成猴子
    ANNOUNCE_MONKEY_CURSE_CHANGEBACK = "终于摆脱了。",		    -- 解除诅咒

	-- 角色专属
	ANNOUNCE_FOODMEMORY = "only_used_by_warly",-- 沃利(大厨)触发食物记忆

	-- 温蒂专属
	ANNOUNCE_SISTURN_FULL_EVIL = "only_used_by_wendy", -- 温蒂的灵柩充满邪恶能量时触发
	ANNOUNCE_SISTURN_FULL_BLOSSOM = "only_used_by_wendy", -- 温蒂的灵柩充满生命能量时触发
	ANNOUNCE_GHOST_QUEST = "only_used_by_wendy",-- 温蒂为小惊吓找到玩具
	-- 温蒂召唤阿比盖尔
	ANNOUNCE_ABIGAIL_SUMMON =
	{
		LEVEL1 = "only_used_by_wendy",
		LEVEL2 = "only_used_by_wendy",
		LEVEL3 = "only_used_by_wendy",
	},
	-- 阿比盖尔升级
	ANNOUNCE_GHOSTLYBOND_LEVELUP =
	{
		LEVEL2 = "only_used_by_wendy",
		LEVEL3 = "only_used_by_wendy",
	},

	-- 女武神专属
	ANNOUNCE_NOINSPIRATION = "only_used_by_wathgrithr", -- 瓦格弗德尝试创作但灵感不足时触发
	ANNOUNCE_NOTSKILLEDENOUGH = "only_used_by_wathgrithr", -- 瓦格弗德尝试使用未解锁的技能时触发
	ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr", -- 瓦格弗德激活嘲讽类战歌时触发
	ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr", -- 瓦格弗德激活恐慌类战歌时触发
	ANNOUNCE_BATTLESONG_INSTANT_REVIVE_BUFF = "only_used_by_wathgrithr", -- 瓦格弗德激活复活类战歌时触发

	-- 旺达专属
	ANNOUNCE_WANDA_YOUNGTONORMAL = "only_used_by_wanda", -- 旺达使用怀表从年轻形态恢复正常时触发
	ANNOUNCE_WANDA_NORMALTOOLD = "only_used_by_wanda", -- 旺达使用怀表从正常形态变年老时触发
	ANNOUNCE_WANDA_OLDTONORMAL = "only_used_by_wanda", -- 旺达使用怀表从年老形态恢复正常时触发
	ANNOUNCE_WANDA_NORMALTOYOUNG = "only_used_by_wanda", -- 旺达使用怀表从正常形态变年轻时触发

	-- 旺达传送相关
	ANNOUNCE_POCKETWATCH_PORTAL = "……真是，何等难堪！", 				   -- 使用时空门传送摔倒 *注：这句所有角色都需要
	ANNOUNCE_POCKETWATCH_MARK = "就在这里埋下锚点吧。", 				   -- 使用怀表标记位置时触发
	ANNOUNCE_POCKETWATCH_RECALL = "我已经习惯了穿越时空之门。", 			-- 使用怀表召回至标记位置时触发
	ANNOUNCE_POCKETWATCH_OPEN_PORTAL = "抓紧时间，时空裂隙无法常驻。",		-- 使用怀表开启传送门时触发
	ANNOUNCE_POCKETWATCH_OPEN_PORTAL_DIFFERENTSHARD = "来吧，跨越两界。",  -- 尝试开启跨服务器传送门时触发

	-- WX-78过载状态
	ANNOUNCE_CHARGE = "only_used_by_wx78",	  -- 被闪电击中进入过载状态
	ANNOUNCE_DISCHARGE = "only_used_by_wx78", -- 过载状态结束

	--  薇落娜激活黑暗痕迹时的台词
	--  本mod中使用蔷薇桥、跳虫洞等技能也使用这个台词
	ANNOUNCE_ROSEGLASSES =
	{
		"这里就使用一种简单的黑魔法……",
		"暗影的魔力会服务于我。",
		"来吧，试试这个。",
	},

	ANNOUNCE_CHARLIE_MISSED = "嗯？你在做什么？", -- 薇落娜抵挡查理攻击

	-- 麦斯威尔与暗影强化装备
	ANNOUNCE_SHADOWLEVEL_ITEM = "它寄宿着暗影的力量……!",	      -- 检查可提供暗影魔法的物品时添加在语句后的描述
	ANNOUNCE_EQUIP_SHADOWLEVEL_T1 = "有趣,我的暗影仆从们变强了。", -- 穿戴可提升1级暗影魔法强度的装备
	ANNOUNCE_EQUIP_SHADOWLEVEL_T2 = "暗影的力量在我身上滋长……",   -- 穿戴可提升2级暗影魔法强度的装备
	ANNOUNCE_EQUIP_SHADOWLEVEL_T3 = "暗影已经完全向我称臣！",	   -- 穿戴可提升3级暗影魔法强度的装备
	ANNOUNCE_EQUIP_SHADOWLEVEL_T4 = "恭迎你们新的暗影之王吧！",    -- 穿戴可提升4级暗影魔法强度的装备

	-- 沃尔夫冈(大力士)训练时闲聊
	ANNOUNCE_COACH =
    {
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
    },
    -- 沃尔夫冈不同形态变化
	ANNOUNCE_NORMALTOMIGHTY = "only_used_by_wolfang",-- 吃饱到猛男形态
	ANNOUNCE_NORMALTOWIMPY = "only_used_by_wolfang", -- 饿到弱鸡形态
	ANNOUNCE_WIMPYTONORMAL = "only_used_by_wolfang", -- 吃到一般形态
	ANNOUNCE_MIGHTYTONORMAL = "only_used_by_wolfang",-- 饿到一般形态
	-- 沃尔夫冈不同形态退出健身房
	ANNOUNCE_EXITGYM = {
		MIGHTY = "only_used_by_wolfang",-- 猛男形态退出健身房
		NORMAL = "only_used_by_wolfang",-- 一般形态退出健身房
		WIMPY = "only_used_by_wolfang",	-- 弱鸡形态退出健身房
	},
	-- 沃尔夫冈不同形态锻炼
    ANNOUNCE_WOLFGANG_WIMPY_COACHING = "only_used_by_wolfgang", -- 小力士锻炼
    ANNOUNCE_WOLFGANG_MIGHTY_COACHING = "only_used_by_wolfgang",-- 中力士锻炼
    ANNOUNCE_WOLFGANG_BEGIN_COACHING = "only_used_by_wolfgang", -- 大力士锻炼
    ANNOUNCE_WOLFGANG_END_COACHING = "only_used_by_wolfgang",   -- 疑似停止锻炼
	-- 沃尔夫冈 暂时未知
    ANNOUNCE_WOLFGANG_NOTEAM =
    {
        "only_used_by_wolfang",
        "only_used_by_wolfang",
        "only_used_by_wolfang",
    },

	-- 温蒂保姆模式？
	ANNOUNCE_WENDY_BABYSITTER_SET = "only_used_by_wendy",
	ANNOUNCE_WENDY_BABYSITTER_STOP = "only_used_by_wendy",

	-- 温蒂专属-召唤阿比盖尔
	ANNOUNCE_NO_ABIGAIL_FLOWER = "only_used_by_wendy", -- 温蒂尝试召唤阿比盖尔但未携带阿比盖尔之花

	-- 远古档案馆相关
	ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "原来如此。",		 -- 解锁新知识
    ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "我已经知道这个了。",-- 解锁旧知识
    ANNOUNCE_ARCHIVE_NO_POWER = "没有能量。",		      -- 没能量

	-- 圣殿相关
	ANNOUNCE_VAULT_TELEPORTER_DOES_NOTHING = "另一端出了故障。", -- 使用圣殿路标但没有反应
	ANNOUNCE_LIGHTSOUT_SHADOWHAND = "暗影想要阻止我前行？痴心妄想。", -- 圣殿内点灯解密时与暗影之手交互

------ 活动内容
    -- 冬季盛宴：
	ANNOUNCE_EATING_NOT_FEASTING = "我还不想吃这个。",		-- 冬季盛宴的植物 单人吃(但是没调用)
	ANNOUNCE_WINTERS_FEAST_BUFF = "一种古怪的力量……源自某种奇迹。",-- 冬季盛宴食物buff开始
	ANNOUNCE_IS_FEASTING = "我赏赐尔等共享盛宴的殊荣！",		    -- 冬季盛宴 大家一起吃
	ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "那股力量消失了。",	       -- 冬季盛宴食物buff结束
	-- 堆雪人
	ANNOUNCE_SNOWBALL_TOO_BIG = "好了，它已经不能更大了。", -- 雪人堆到体积上限。
	ANNOUNCE_SNOWBALL_NO_SNOW = "这里没有雪来充当血肉。",   -- 当前区域没有雪

	-- 有关进食食物的进食台词
    EAT_FOOD =
	{
		TALLBIRDEGG_CRACKED = "我能品尝出一种欢愉的气氛。",-- 冬季盛宴台词
	},

	-- 万圣节：
	ANNOUNCE_SPOOKED = "那是什么？",					-- 被蝙蝠吓到
	ANNOUNCE_BRAVERY_POTION = "现在它们无法影响到我了。",-- 喝了减轻/终止恐惧的药液
	ANNOUNCE_MOONPOTION_FAILED = "月光无法点化它。",	-- 万圣节月亮药水 对不能变化的物品使用
	ANNOUNCE_NOPUMPKINCARVINGONFIRE = "别太焦躁。", -- 玩家尝试在燃烧的南瓜上雕刻


	-- 龙蝇年赛龙舟
	ANNOUNCE_YOTD_NOBOATS = "我得把船移到离起点塔更近的地方。",	-- 距离起点太远，无法开始龙舟比赛
	ANNOUNCE_YOTD_NOCHECKPOINTS = "我该先立几个检查点。",	   -- 无检查点，无法开始龙舟比赛
	ANNOUNCE_YOTD_NOTENOUGHBOATS = "不够空间容纳其余选手了。", -- 周围太拥挤无法生成查理的选手，无法开始龙舟比赛

	-- 浣猫年捉迷藏活动
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN  = "好吧，猫科动物派对。我的玩家已经满眼都是你们了。", -- 加入游戏
	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "知道吗，小家伙们，没有人能逃过命运。", 		-- 小猫躲好开始寻找
	-- 玩家找到小猫时
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND =
	{
		"我说过，没有猫能逃过命运。",
		"到这来，小家伙。",
		"你藏不住自己的可爱，不是吗？",
		"现在你可以和自己的尾巴互相推诿责任了。",
	},
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_ONE_MORE = "还差最后一个。",				-- 还差最后一个
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE = "好了，一家猫就该整整齐齐。",	 -- 找齐所有
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE_TEAM = "好眼力，{name}。", 		-- 其他玩家提前找到
	ANNOUNCE_KITCOON_HIDANDSEEK_TIME_ALMOST_UP = "游戏快要结束了。",			-- 捉迷藏将要结束
	ANNOUNCE_KITCOON_HIDANDSEEK_LOSEGAME = "……好吧，狡诈的毛球，你们赢了一次。",  -- 输给猫猫
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR = "离得有点太远了。",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR_RETURN = "它就在附近……仔细看看。",
	ANNOUNCE_KITCOON_FOUND_IN_THE_WILD = "不在这里？",
	ANNOUNCE_TICOON_START_TRACKING			= "很好，它开始带路了。",
	ANNOUNCE_TICOON_NOTHING_TO_TRACK 		= "小猫不在这。",
	ANNOUNCE_TICOON_WAITING_FOR_LEADER 		= "它在等我。",
	ANNOUNCE_TICOON_GET_LEADER_ATTENTION 	= "跟着它，看看能找到什么？",
	ANNOUNCE_TICOON_NEAR_KITCOON 			= "有些小动物藏在这附近。",
	ANNOUNCE_TICOON_LOST_KITCOON 			= "已经找到小猫了。",
	ANNOUNCE_TICOON_ABANDONED 				= "自己去玩吧，我要做些其他事了。",
	ANNOUNCE_TICOON_DEAD 					= "不见了。",

    -- 皮弗娄牛年活动相关
	ANNOUNCE_CALL_BEEF = "过来，到这来。",		      -- 栓牛？
    ANNOUNCE_CANTBUILDHERE_YOTB_POST = "它得靠过去。",-- 建造牛舞台 离裁判太远
    ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "新的装饰品。",-- 纺织机出新皮肤

	-- 熔炉相关，暂时未明
	ANNOUNCE_REVIVING_CORPSE = "试试其他的。",
    ANNOUNCE_REVIVED_OTHER_CORPSE = "换一个。",
    ANNOUNCE_REVIVED_FROM_CORPSE = "更好了！",

	-- 胡萝卜鼠之年
	ANNOUNCE_CARRAT_START_RACE = "去吧！", -- 胡萝卜鼠赛跑倒计时结束，裁判喊出起跑口令时触发
	-- 胡萝卜鼠朝赛跑终点反方向移动时触发
	ANNOUNCE_CARRAT_ERROR_WRONG_WAY = {
		"蠢货，你跑错方向了！",
		"你在南辕北辙！",
	},
	ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "醒来！我沉睡的奴隶！", -- 胡萝卜鼠长时间未移动进入睡眠状态时触发
	ANNOUNCE_CARRAT_ERROR_WALKING = "加速，燃烧你的维生素！", 	-- 胡萝卜鼠移动速度过慢未达到奔跑状态时触发
	ANNOUNCE_CARRAT_ERROR_STUNNED = "集中注意力！", 		   -- 胡萝卜鼠被眩晕(冰杖/催眠吹箭)时触发
	ANNOUNCE_WEAK_RAT = "死神已经快追上它了。", 				-- 胡萝卜鼠衰老了

	-- 发条骑士之年
	ANNOUNCE_YOTH_ONCOOLDOWN = "……居然胆敢耽误我的号召，一群马虎骑士。", -- 冷却期间尝试召唤四骑士

------ 检查 	-------------------------------------------------------------------------------------------------------------------------------------------
	DESCRIBE =
	{
        -- 检查玩家，模版
        PLAYER =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

-----------检查其他玩家角色&角色专属物品-----------------------------------------------------------------------------------
------- 威尔逊
		WILSON =
		{
            GENERIC		= "日安，%s，祝你灵感泉涌。", -- 普通
            ATTACKER	= "这可不是绅士所为，%s。", -- 目标在攻击其他玩家
            MURDERER	= "终于被可悲的现实迫入疯狂了吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s。", -- 目标正处于鬼魂状态
            FIRESTARTER	= "%s", -- 目标在放火
		},

------- 沃尔夫冈
		WOLFGANG =
		{
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "小心些，大块头。", -- 目标在攻击其他玩家
            MURDERER	= "这就是你炫耀暴力的手段吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "感谢你强而有力的援手，%s。", -- 目标正复活其他玩家
            GHOST		= "看来死亡比你更有力，%s。", -- 目标正处于鬼魂状态
            FIRESTARTER	= "%s", -- 目标在放火
		},

		WOLFGANG_WHISTLE = "吹的很有气势。",-- 训练哨

		-- 强大健身房
        MIGHTY_GYM =
        {
            GENERIC = "自强不息。",
            BURNT = "但火焰熄灭了它。",-- 烧毁
        },

        POTATOSACK = "所以土豆才是最重的?",-- 土豆袋

        DUMBBELL = "粗糙的健身工具。",               -- 哑铃
        DUMBBELL_GOLDEN = "沉重的价值。",		     -- 黄金哑铃
		DUMBBELL_MARBLE = "专业健身器材。",		     -- 大理石哑铃
        DUMBBELL_GEM = "华丽材料与粗犷构造的结合体。",-- 宝石哑铃
        DUMBBELL_HEAT = "兼顾保暖。",		         -- 热铃
        DUMBBELL_REDGEM = "营造火热的健身氛围。",	  -- 火铃
        DUMBBELL_BLUEGEM = "严酷的挑战。",		     -- 冰铃

------- 麦斯威尔
		WAXWELL =
		{
            GENERIC		= "日安，曾经的世界之王，%s。", -- 普通
            ATTACKER	= "你那扭曲的本性又不小心溢出了吗，%s。", -- 目标在攻击其他玩家
            MURDERER	= "残暴的欢愉必以残暴终，%s。", -- 目标已击杀其他玩家
            REVIVER		= "无论如何，我欠你一次……利用好这点。", -- 目标正复活其他玩家
            GHOST		= "你认为自己值得好心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "你最好能对自己的“魔术”负责，%s。", -- 目标在放火
		},

		-- 暗影秘典
		WAXWELLJOURNAL =
		{
			GENERIC = "暗影的奥秘……给他真是浪费。",
		},

		TOPHAT_MAGICIAN = "魔术师的把戏。",		-- 魔术师高礼帽
		MAGICIAN_CHEST = "用来当快递箱很方便。",-- 魔术师箱子

------- 机器人
		WX78 =
		{
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "产生认知偏差了吗，%s？", -- 目标在攻击其他玩家
            MURDERER	= "让我们打开天窗说亮话吧，%s。", -- 目标已击杀其他玩家
            REVIVER		= "感谢你的逻辑模块。", -- 目标正复活其他玩家
            GHOST		= "现在你是否渴求一颗血肉的心了呢？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "%s", -- 目标在放火
		},

        WX78_MODULEREMOVER = "他修复他自己。",		-- 电路提取器

        WX78MODULE_MAXHEALTH	= "对机器人好的东西。",		-- 强化电路
        WX78MODULE_MAXSANITY1	= "对机器人好的东西。",		-- 处理器电路
        WX78MODULE_MAXSANITY	= "对机器人好的东西。",		-- 超级处理器电路
        WX78MODULE_MOVESPEED	= "对机器人好的东西。",		-- 加速电路
        WX78MODULE_MOVESPEED2	= "对机器人好的东西。",		-- 超级加速电路
        WX78MODULE_HEAT			= "对机器人好的东西。",		-- 热能电路
        WX78MODULE_NIGHTVISION	= "对机器人好的东西。",		-- 光电电路
        WX78MODULE_COLD			= "对机器人好的东西。",		-- 制冷电路
        WX78MODULE_TASER		= "对机器人好的东西。",		-- 电气化电路
        WX78MODULE_LIGHT		= "对机器人好的东西。",		-- 照明电路
        WX78MODULE_MAXHUNGER1	= "对机器人好的东西。",		-- 胃增益电路
        WX78MODULE_MAXHUNGER	= "对机器人好的东西。",		-- 超级胃增益电路
        WX78MODULE_MUSIC		= "对机器人好的东西。",		-- 合唱盒电路
        WX78MODULE_BEE			= "对机器人好的东西。",		-- 豆增压电路
        WX78MODULE_MAXHEALTH2	= "对机器人好的东西。",		-- 超级强化电路

        -- 生物扫描分析仪
		WX78_SCANNER =
        {
            GENERIC ="一个机械制作的生物扫描仪器。",
            HUNTING = "它锁定了目标。",   -- 追踪中
            SCANNING = "它似乎有所发现。",-- 扫描中
        },

        WX78_SCANNER_ITEM = "它正在扫描周围的一切。",  -- 物品形态
        WX78_SCANNER_SUCCEEDED = "它若有所得。",      -- 扫描完毕

        SCANDATA = "只有二进制生物才读得懂这个。",		-- 生物数据

------- 薇洛，火女
		WILLOW =
		{
            GENERIC		= "日安，火焰的女儿，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "，%s。", -- 目标在放火
		},

		LIGHTER  = "那个女孩儿从不离手。",		-- 薇洛的打火机
		EMBERLIGHT = "想不到那女孩儿能办到这个。",-- 火球术

		-- 伯尼熊
		BERNIE_INACTIVE =
		{
			BROKEN = "看起来损伤惨重。",
			GENERIC = "居然有灵魂，有趣。",
		},

		BERNIE_ACTIVE = "这算什么，小女孩的奇迹？",
		BERNIE_BIG = "哦，强而有力。",

------- 温蒂
		WENDY =
		{
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "小心些，%s。", -- 目标在攻击其他玩家
            MURDERER	= "哀伤终于淹没了你吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
		},

        -- 阿比盖尔之花
		ABIGAIL_FLOWER =
        {
            GENERIC ="一个悲惨的灵魂最深的执念。",-- 默认
			LEVEL1 = "思念将她带回人间……以这种方式。",-- 阿比盖尔1级
			LEVEL2 = "她的魂体更加强大了。",-- 阿比盖尔2级
			LEVEL3 = "她已经达到了顶峰。",-- 阿比盖尔3级
			-- 阿比盖尔死亡等待复活状态
            LONG = "她需要时间来滋养受创的灵魂。",-- 长时间
            MEDIUM = "她很快就会回来的。",-- 一段时间
            SOON = "她正在跨越生死界壁归来。",-- 很快
            HAUNTED_POCKET = "一个执念物。",-- 未知
            HAUNTED_GROUND = "寄宿着一个悲惨的灵魂。",-- 未知
        },

		-- 阿比盖尔
		ABIGAIL =
		{
            LEVEL1 =
            {
                "弱小的游魂，但守护着她的姐妹。",
                "弱小的游魂，但守护着她的姐妹。",
            },
            LEVEL2 =
            {
                "她好了一些，已经能干涉黑暗了。",
                "她好了一些，已经能干涉黑暗了。",
            },
            LEVEL3 =
            {
                "看来这就是她的极限，终究无法突破死亡的囚笼。",
                "看来这就是她的极限，终究无法突破死亡的囚笼。",
            },
		},

		SPIDER_HEALER_ITEM = "能让游魂感到些许甜蜜。",	-- 治疗黏团
		GHOSTLYELIXIR_SLOWREGEN = "对灵魂起作用。",	   -- 亡者补药
		GHOSTLYELIXIR_FASTREGEN = "对灵魂起作用。",	   -- 灵魂万灵药
		GHOSTLYELIXIR_SHIELD = "对灵魂起作用。",	   -- 不屈药剂
		GHOSTLYELIXIR_ATTACK = "对灵魂起作用。",	   -- 夜影万金油
		GHOSTLYELIXIR_SPEED = "对灵魂起作用。",		   -- 强健精油
		GHOSTLYELIXIR_RETALIATION = "对灵魂起作用。",  -- 蒸馏复仇

        ELIXIR_CONTAINER = "灵魂的医药箱。",        --  精华容器(药水罐)
        GHOSTFLOWERHAT = "冥界花环。",              --  幽灵花帽
        WENDY_RESURRECTIONGRAVE = "埋葬后顾之忧。", --  温蒂的复活墓碑

		--  墓地花瓶
        GRAVEURN =
        {
            GENERIC = "空空荡荡，一如其思。", --  无花
            HAS_SPIRIT = "装点哀伤。",       --  有花
        },

		-- 姐妹骨灰罐
		SISTURN =
		{
			GENERIC = "里面只有一个人的骨灰。",
			SOME_FLOWERS = "花还不够。",
			LOTS_OF_FLOWERS = "鲜花是她们沟通的桥梁。",
		},

------- 伍迪
        WOODIE =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗不受诅咒的心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
            BEAVER		= "像是那种过时的乡村传说。",-- 变海狸人
            BEAVERGHOST	= "看来海狸人啃不穿生死界壁。",-- 海狸人灵魂
            MOOSE		= "有点俗，像是那种过时的乡村传说。",-- 变麋鹿人
            MOOSEGHOST	= "看来麋鹿在生死间迷路了。",-- 麋鹿人灵魂
            GOOSE		= "有点俗，像是那种过时的乡村传说。",-- 变加拿大鹅
            GOOSEGHOST	= "看来加拿大鹅也没法飞跃死亡。",-- 鹅的灵魂
        },

		LUCY = "你好，露西小姐。是的，我能看到你的灵魂。",		-- 露西斧

        WEREITEM_BEAVER = "看，他特意做了这个。",-- 俗气海狸像
        WEREITEM_GOOSE = "看，他特意做了这个。", -- 俗气鹅像
        WEREITEM_MOOSE = "看，他特意做了这个。", -- 俗气鹿像

		LEIF_IDOL = "我喜欢你挑衅森林的样子。",-- 树精守卫雕像
        WOODCARVEDHAT = "精致的小手工。",	  -- 硬木帽
        WALKING_STICK = "简易版拐杖。",		  -- 木手杖

---------- 薇克巴顿，老奶奶
		WICKERBOTTOM =
		{
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "小心些，%s。", -- 目标在攻击其他玩家
            MURDERER	= "那些疯狂的知识终于追上了你吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
		},

        -- 书架
		BOOKSTATION =
		{
			GENERIC = "放书的地方。",
			BURNT = "啊……纸质的书籍总是容易遇难。",
		},

		-- 书籍
        BOOK_RESEARCH_STATION		= "启迪智慧。",				-- 万物百科
		BOOK_HORTICULTURE			= "作物们，仿效在伊甸时的祖先吧！",		     -- 园艺学简编版
		BOOK_HORTICULTURE_UPGRADED	= "“遍地上一切结种子的菜蔬，作为食物。”",-- 园艺学扩展版
		BOOK_SILVICULTURE			= "让树木拔地而起吧！",		-- 应用造林学
		BOOK_GARDENING				= "“地要发生青草和接种子的菜蔬，并结果子的树木，各从其类。”",-- 应用园艺学
		BOOK_BIRDS					= "“要有雀鸟飞在地面以上，天空之中。”",-- 世界鸟类大全
		BOOK_FISH					= "“水要多多滋生有生命的物。”",		 -- 垂钓者生存指南
		BOOK_LIGHT					= "神说：要有光。",		        -- 永恒之光
		BOOK_LIGHT_UPGRADED			= "我说：要有光！",     -- 永恒之光之复兴
		BOOK_MOON					= "这能吸引“祂”的目光。",		    -- 月之魔典
        BOOK_RAIN					= "支配天像！",	            	-- 实用求雨仪式
		BOOK_TEMPERATURE			= "支配炎寒！",	    	-- 控温学
        BOOK_SLEEP					= "若沉睡地足够深入，如何分辨梦境与真实?",-- 睡前故事
		BOOK_WEB					= "应该是它们来恐惧我。",    		-- 克服蛛形纲恐惧症
		BOOK_BRIMSTONE				= "我喜欢其中的雷与火。",	-- 末日将至！
        BOOK_TENTACLES				= "让地穴深处的那家伙起床。",-- 触手的召唤
        BOOK_BEES					= "雇佣几名流浪的骑士。",		    -- 养蜂笔记
		BOOK_FIRE					= "驯服烈焰！",           		-- 意念控火术详解

        FIREPEN = "书写烈焰。",		-- 火焰笔

---------- 维斯
		WES =
		{
            GENERIC		= "日安，弄臣，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "无辜者之魂值得用心铭刻。", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
		},

        BALLOONS_EMPTY	= "小丑的看家把戏。",		-- 一堆气球
        BALLOON			= "勉强能做装饰。",			-- 气球
		BALLOONPARTY	= "营造一种虚假的热闹。",	-- 派对气球

        -- 迅捷手杖
		BALLOONSPEED =
        {
            DEFLATED	= "已经没气了。",-- 失效
            GENERIC		= "小孩子的文明杖玩具，但很轻快。",
        },

		BALLOONVEST = "不合格的救生衣。",		-- 充气背心
		BALLOONHAT 	= "哄小孩最好的把戏。",		-- 气球帽

---------- 韦伯，蜘蛛男孩
		WEBBER =
        {
            GENERIC		= "日安，%s。",						-- 普通
            ATTACKER	= "真是有够失礼的，%s。",			-- 目标在攻击其他玩家
            MURDERER	= "终于决定彻底成为野兽了吗，%s？",	-- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。",					-- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？",				-- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。",				-- 目标在放火
        },

        SPIDER_WHISTLE = "令人憎恶的音调。",		  -- 韦伯口哨
        SPIDERDEN_BEDAZZLER = "那些爬虫的外置教养。", -- 蛛巢装饰套装

        SPIDER_REPELLENT = "让爬虫离开。",		-- 驱赶盒子

        MUTATOR_WARRIOR = "让爬虫变成另一种爬虫。",		-- 战士变身涂鸦
        MUTATOR_DROPPER = "让爬虫变成另一种爬虫。",		-- 悬蛛变身涂鸦
        MUTATOR_HIDER 	= "让爬虫变成另一种爬虫。",		-- 洞穴变身涂鸦
        MUTATOR_SPITTER = "让爬虫变成另一种爬虫。",		-- 喷吐变身涂鸦
        MUTATOR_MOON 	= "让爬虫变成另一种爬虫。",		-- 破碎变身涂鸦
        MUTATOR_HEALER 	= "让爬虫变成另一种爬虫。",		-- 护士变身涂鸦
        MUTATOR_WATER 	= "让爬虫变成另一种爬虫。",		-- 海黾变身涂鸦

---------- 薇格福德，女武神
		WATHGRITHR =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "小心些，%s。", -- 目标在攻击其他玩家
            MURDERER	= "你该落幕了，%s。", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

		SPEAR_WATHGRITHR = "更像是舞台道具。",         -- 战斗长矛
		WATHGRITHRHAT = "防御性能优秀。",	           -- 战斗头盔
		WATHGRITHR_IMPROVEDHAT = "统帅着她心中的梦想。",-- 统帅头盔
		SPEAR_WATHGRITHR_LIGHTNING = "奥丁的权威。",   -- 奔雷矛
		WATHGRITHR_SHIELD = "对技巧的要求很高。",	    -- 战斗圆盾

		SADDLE_WATHGRITHR = "对骑兵很实用。",	-- 战斗鞍具

		BATTLESONG_CONTAINER = "它的实用性仅限非战斗时期储存。",-- 战斗号子罐

        BATTLESONG_DURABILITY = "她醉心于表演。",		-- 武器化的颤音
        BATTLESONG_HEALTHGAIN = "她醉心于表演。",		-- 心碎歌谣
        BATTLESONG_SANITYGAIN = "她醉心于表演。",		-- 醍醐灌顶华彩
        BATTLESONG_SANITYAURA = "她醉心于表演。",		-- 英勇美声颂
        BATTLESONG_FIRERESISTANCE = "她醉心于表演。",		-- 防火假声
        BATTLESONG_INSTANT_TAUNT = "她醉心于表演。",		-- 粗鲁插曲
        BATTLESONG_INSTANT_PANIC = "她醉心于表演。",		-- 惊心独白
		BATTLESONG_INSTANT_REVIVE = "听起来慷慨激昂。",		-- 战士重奏
		BATTLESONG_SHADOWALIGNED = "歌颂那遮蔽明月的夜。",	-- 黑暗悲歌
		BATTLESONG_LUNARALIGNED = "歌颂那照耀浓夜的月。",	-- 启迪摇篮曲

---------- 薇落娜，女工
		WINONA =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

		SEWING_TAPE = "非常万能。",   -- 可靠的胶布

		INSPECTACLESBOX = "only_used_by_winona",-- 储藏箱
		INSPECTACLESBOX2 = "only_used_by_winona",-- 高级储藏箱

		-- 检查专用镜
		INSPECTACLESHAT =
		{
			GENERIC = "所以，那家伙还能跟这里通讯？",
			MISSINGSKILL = "only_used_by_winona",	-- 没有技能
		},

		WINONA_MACHINEPARTS_1 = "only_used_by_winona",	-- 小玩意
		WINONA_MACHINEPARTS_2 = "only_used_by_winona",	-- 小机械
		WINONA_RECIPESCANNER = "only_used_by_winona",	-- 校准观察机
		WINONA_HOLOTELEPAD = "only_used_by_winona",	    -- 不稳定传输(传送基站原型)
		WINONA_HOLOTELEBRELLA = "only_used_by_winona",	-- -- 不稳定传输(传送伞原型)

		-- 玫瑰色眼镜
		ROSEGLASSESHAT =
		{
			GENERIC = "黑魔法滤镜……她要这个干什么？",
			MISSINGSKILL = "only_used_by_winona",	-- 没有技能
		},

		CHARLIERESIDUE = "only_used_by_winona",	-- 黑暗痕迹
		CHARLIEROSE = "only_used_by_winona",	-- 脆弱玫瑰

		-- 趁手遥控器
		WINONA_REMOTE =
		{
			GENERIC = "一个遥控设备。",
			OFF = "需要充电。",	-- 没电
			CHARGING = "她大概忘了把按钮装到她的机器上了。",-- 充电中
			CHARGED = "她大概忘了把按钮装到她的机器上了。",	-- 充电完毕
		},

		-- 传送伞
		WINONA_TELEBRELLA =
		{
			GENERIC = "薇诺娜正在头脑风暴。",
			MISSINGSKILL = "only_used_by_winona",-- 无天赋
			OFF = "需要充电。",	-- 没电
			CHARGING = "薇诺娜正在头脑风暴。",	-- 充电中
			CHARGED = "薇诺娜正在头脑风暴。",	-- 充电完毕
		},

		-- 传送运输站
		WINONA_TELEPORT_PAD_ITEM =
		{
			GENERIC = "一个人为锁定的空间节点，用于接受粒子传输。",
			MISSINGSKILL = "only_used_by_winona",	-- 无天赋
			OFF = "需要通电。",	-- 没电
			BURNING = "谁送来的火焰？",	-- 燃烧
			BURNT = "看来转移不了悲剧。",-- 烧毁
		},

		-- 薇器人
		WINONA_STORAGE_ROBOT =
		{
			GENERIC = "没有人盯着这东西会偷懒。",	-- 默认
			OFF = "彻底没电了。",	 -- 没电
			SLEEP = "暂时不需要它。",-- 休眠
			CHARGING = "它正在充电。",	-- 充电中
			CHARGED = "它又能工作了。",	-- 充电完毕
		},

        -- 投石机
        WINONA_CATAPULT =
        {
			GENERIC = "歌利亚的噩梦。",
			OFF = "没开机。",		-- 关闭
			BURNING = "先灭火吧。",	-- 正在燃烧
			BURNT = "烈火摧毁了它。",-- 烧毁
        },
		WINONA_CATAPULT_ITEM = "需要熟练工来重新布置。",-- 投石机(物品形态)

		-- 聚光灯
		WINONA_SPOTLIGHT =
        {
			GENERIC = "看起来像是好莱坞的设备。",
			OFF = "没开机。",		   -- 关闭
			BURNING = "现在火光冲天。",-- 正在燃烧
			BURNT = "不再有焦点了。",  -- 烧毁
        },
		WINONA_SPOTLIGHT_ITEM = "需要熟练工来重新布置。",-- 聚光灯(物品形态)

		-- 硝石发电机
		WINONA_BATTERY_LOW =
        {
			GENERIC = "效率不敢恭维。",
			LOWPOWER = "该投放燃料了。",		  -- 没电
			OFF = "它现在关上了。",		          -- 关闭
			BURNING = "最好在它烧光之前把火灭掉。",-- 正在燃烧
			BURNT = "一切都归于尘土。",		      -- 烧毁
        },
		WINONA_BATTERY_LOW_ITEM = "需要熟练工来重新布置。",-- 硝石发电机(物品形态)

		-- 宝石发电机
		WINONA_BATTERY_HIGH =
        {
			GENERIC = "能够提取宝石的力量，但有些低效。",
			LOWPOWER = "宝石已经被它挥霍一空了。",   		-- 没电
			OFF = "没开机。",		-- 关闭
		    BURNING = "最好还是在它烧光之前把火灭了。",		-- 正在燃烧
			BURNT = "有点太迟了。",		-- 烧毁
        },
		WINONA_BATTERY_HIGH_ITEM = "需要熟练工来重新布置。",-- 宝石发电机(物品形态)

---------- 沃拓克斯，小恶魔
        WORTOX =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "想知道我碾碎过多少恶魔吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "你有品尝过自己吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

		WORTOX_SOUL = "only_used_by_wortox", -- 灵魂

---------沃姆伍德，植物人
		WORMWOOD =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

		COMPOSTWRAP = "看来植物更懂植物。",	-- 肥料包
        ARMOR_BRAMBLE = "长有拒绝的刺。",	-- 荆棘外壳
		ARMOR_LUNARPLANT_HUSK = "伪装成亮茄。",-- 荆棘茄甲
        TRAP_BRAMBLE = "谁会中招？",		-- 荆棘陷阱
		IPECACSYRUP = "呃……药品。",		-- 泻根糖浆

---------沃利，大厨
		WARLY =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "屠夫的吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

        -- 便携烹饪锅
        PORTABLECOOKPOT_ITEM =
        {
            GENERIC = "专业的厨具，方便快捷。",
            DONE = "可以拿了。",
			COOKING_LONG = "还要再等等。",
			COOKING_SHORT = "很快，很快就好了。",
			EMPTY = "里面没东西了。",
        },

        PORTABLEBLENDER_ITEM = "制作调料。",-- 便携研磨器

		-- 便携调味盘
        PORTABLESPICER_ITEM =
        {
            GENERIC = "让食物换一种味道。",
            DONE = "完成了。",
        },

        SPICEPACK = "让食物保持新鲜。",-- 厨师袋

---------- 沃特，小鱼人
		WURT =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

        MERMHAT = "跟受骗者一样“鱼”蠢。",-- 聪明的伪装

		-- 蚊子科技
		MOSQUITOMUSK = "让那些害虫知难而退。",-- 小痒痒
		MOSQUITOBOMB = "让人有些手痒。",	  -- 蚊子炸弹
		MOSQUITOFERTILIZER = "植物居然喜欢它。",-- 嗡嗡肥料
		MOSQUITOMERMSALVE = "这是鱼人之间最潮的东西。",	-- 蚊血注射液

		-- 食堂海带盘
		OFFERING_POT =
		{
			GENERIC = "表明了鱼人的国库空虚。",	 -- 空的
			SOME_KELP = "看起来鱼人们经济紧张。",-- 有海带
			LOTS_OF_KELP = "海量的海带！",	    -- 装满海带
		},

		-- 高级食堂海带盘
		OFFERING_POT_UPGRADED =
		{
			GENERIC = "表明了鱼人的国库空虚。",	 -- 空的
			SOME_KELP = "看起来鱼人们经济紧张。",-- 有海带
			LOTS_OF_KELP = "海量的海带！",	    -- 装满海带
		},

		MERM_ARMORY = "都是些鱼木脑袋。",	      -- 鱼人军械库
		MERM_ARMORY_UPGRADED = "都是些鱼木脑袋。",-- 高级鱼人军械库

		MERMARMORHAT = "只能保护鱼木脑袋。",	    -- 沼泽斗士头盔
		MERMARMORUPGRADEDHAT = "只能保护鱼木脑袋。",-- 沼泽战士头盔(鱼人守卫版)

		MERM_TOOLSHED = "看起来还没走出石器时代。",	        -- 劣质工具棚
		MERM_TOOLSHED_UPGRADED = "看起来还没走出石器时代。",-- 不那么劣质的工具棚

		MERM_TOOL = "来自石器时代。",	        -- 劣质工具
		MERM_TOOL_UPGRADED = "来自新石器时代。",-- 劣质工具

		WURT_SWAMPITEM_SHADOW = "能唤起最深沉的绝望。",-- 绝望投泥带
		WURT_SWAMPITEM_LUNAR = "能接引最璀璨的辉煌。", -- 光芒投泥带

		MERM_SHADOW = "这个影子是它从前的自我。",	  -- 暗影鱼人
		MERMGUARD_SHADOW = "这个影子是它从前的自我。",-- 暗影鱼人守卫

		MERM_LUNAR = "这是鱼人进化的下一个相位。",	   -- 变异鱼人
		MERMGUARD_LUNAR = "这是鱼人进化的下一个相位。",-- 变异鱼人守卫

		-- 皇家地毯(完成)
        MERMTHRONE =
        {
            GENERIC = "需要一个皇帝。",
            BURNT = "皇帝不见了。",
        },

		-- 皇家手工套装(未完成)
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "她准备扶持一个皇帝。",
            BURNT = "她准备扶持一个皇帝。",
        },

		-- 鱼人工艺屋
        MERMHOUSE_CRAFTED =
        {
            GENERIC = "没那么“鱼”蠢了。",
            BURNT = "鱼人也不能在火海里生存。",
        },
		-- 有无鱼人王区别
        MERMWATCHTOWER_REGULAR = "大国崛起给了它们小民尊严。",-- 有鱼人王
        MERMWATCHTOWER_NOKING = "它们在哀悼驾崩的国王。",     -- 失去鱼人王

        MERM_PRINCE = "它能服众？", -- 过程中的皇室
        MERMKING = "利维坦的血裔？",-- 鱼人之王
        MERMGUARD = "王的禁卫。",	-- 忠诚鱼人守卫

---------- 沃尔特，童子军
		WALTER =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

        -- 沃比(骑乘形态)
		WOBYBIG =
        {
            "…….这只狗有主人吗？",
            "它应该还没有忘记给予它名字的人……",
        },
        -- 沃比(随从形态)
		WOBYSMALL =
        {
            "它害怕了？",
            "看来它还没有搞清楚状况……",
        },

		WALTERHAT = "小孩子的勇气支撑。",-- 松树先锋队帽子

		--  弹弓
		SLINGSHOT = "小孩子的把戏。",             --  可靠的弹弓
		SLINGSHOTMODKIT = "小孩的把戏。",         --  改装包
		SLINGSHOT_BAND_PIGSKIN = "小孩的把戏。",  --  猪皮弓带
		SLINGSHOT_BAND_TENTACLE = "小孩的把戏。", --  甩尾弓带(触手皮)
		SLINGSHOT_BAND_MIMIC = "小孩的把戏。",    --  附身弓带(宝箱怪转换版)
		SLINGSHOT_FRAME_BONE = "小孩的把戏。",    --  骨架弓架
		SLINGSHOT_FRAME_GEMS = "小孩的把戏。",    --  铥矿弓架
		SLINGSHOT_FRAME_WAGPUNK_0 = "小孩的把戏。", --  废料弓架
		SLINGSHOT_FRAME_WAGPUNK = "小孩的把戏。",   --  加量废料弓架
		SLINGSHOT_HANDLE_STICKY = "小孩的把戏。",   --  弹弓手柄缠带(蛛丝)
		SLINGSHOT_HANDLE_JELLY = "小孩的把戏。",    --  粘性弹弓手柄(格罗姆粘液)
		SLINGSHOT_HANDLE_SILK = "小孩的把戏。",     --  蜂王浆手柄
		SLINGSHOT_HANDLE_VOIDCLOTH = "小孩的把戏。", --  虚空手柄

		--  弹药
		SLINGSHOTAMMO_ROCK = "羸弱的玩具。",		         -- 鹅卵石
		SLINGSHOTAMMO_MARBLE = "杀伤力尚可。",		         -- 大理石弹
		SLINGSHOTAMMO_THULECITE = "粗浅但实用的巫术。",	     -- 诅咒弹药
        SLINGSHOTAMMO_GOLD = "我喜欢这种奢靡，但是华而不实。", -- 黄金弹药
        SLINGSHOTAMMO_SLOW = "效果不错。",		             -- 减速弹药(紫宝石弹)
        SLINGSHOTAMMO_FREEZE = "没能完全发挥宝石的魔力。",    -- 冰冻弹药
		SLINGSHOTAMMO_POOP = "恶心。",		                -- 便便弹
		SLINGSHOTAMMO_HONEY = "粘稠的甜蜜。",                -- 黏黏弹(蜂蜜弹)
		SLINGSHOTAMMO_STINGER = "废物利用。",                -- 蜂刺弹
		SLINGSHOTAMMO_MOONGLASS = "代表月亮的惩罚？",        -- 月亮玻璃弹
		SLINGSHOTAMMO_GELBLOB = "足够缠人。",                -- 恶液弹
		SLINGSHOTAMMO_SCRAPFEATHER = "居然带电？",           -- 废料弹
        SLINGSHOTAMMO_DREADSTONE = "硬的令人绝望。",         -- 绝望石弹
        SLINGSHOTAMMO_GUNPOWDER = "划时代的武器。",           -- 轰轰弹(火药爆炸弹)
        SLINGSHOTAMMO_LUNARPLANTHUSK = "它还保有微弱的生物活性。", -- 亮茄弹
        SLINGSHOTAMMO_PUREBRILLIANCE = "天光大亮。",         -- 纯粹辉煌弹
        SLINGSHOTAMMO_HORRORFUEL = "恶灵缠身。",             -- 纯粹恐惧弹

		WOBY_TREAT = "一种粗制狗粮。",          --  沃比零食
		BANDAGE_BUTTERFLYWINGS = "急性救护。", --  蝴蝶翅膀绷带
		PORTABLEFIREPIT_ITEM = "随身火堆。",   --  便携火堆。

		--  弹药袋
		SLINGSHOTAMMO_CONTAINER = "随身活力支援。",

		--  帐篷
        PORTABLETENT = "至少不能风餐露宿。", -- 宿营帐篷(放置)
        PORTABLETENT_ITEM = "收起来了。",   -- 帐篷卷(携带)

---------- 旺达
		WANDA =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

        POCKETWATCH_PARTS = "把时间拆下来做成零件。", -- 时间碎片
        POCKETWATCH_DISMANTLER = "精密的工具。",     -- 钟表匠工具

		-- 不老表
        POCKETWATCH_HEAL =
	    {
			GENERIC = "储存着青春。",
			RECHARGING = "青春易逝，不是吗。",-- 冷却中
		},

		-- 第二次机会表
        POCKETWATCH_REVIVE =
	    {
			GENERIC = "重新来过。",
			RECHARGING = "后悔药总是不够吃，不是吗",-- 冷却中
		},

		-- 倒走表
        POCKETWATCH_WARP =
	    {
			GENERIC = "悔棋的特权。",
			RECHARGING = "不能总是悔棋。",-- 冷却中
		},

		-- 溯源表
        POCKETWATCH_RECALL =
	    {
			GENERIC = "记录着某处的时光。",
			RECHARGING = "暂时只能用来回忆了。",-- 冷却中
		},

		-- 裂隙表
        POCKETWATCH_PORTAL =
	    {
			GENERIC = "打开时空隧道。",
			RECHARGING = "能量耗尽了。",-- 冷却中
		},

		-- 时间裂隙(裂隙表开的通道)
        POCKETWATCH_PORTAL_ENTRANCE =
		{
			GENERIC = "通向目的时空。",
			DIFFERENTSHARD = "跨越了某些界壁。",-- 跨世界，也即洞穴与地表
		},

        POCKETWATCH_PORTAL_EXIT = "去往何方？",-- 时间裂缝(暂时未知是什么情况下的)

		-- 警钟
        POCKETWATCH_WEAPON =
	    {
			GENERIC = "效力充足的淑女警告。",
		},

---------- 芜猴
		WONKEY =
        {
            GENERIC		= "日安，%s。", -- 普通
            ATTACKER	= "真是有够失礼的，%s。", -- 目标在攻击其他玩家
            MURDERER	= "有感到罪孽爬上你的脊梁吗，%s？", -- 目标已击杀其他玩家
            REVIVER		= "多谢援手，%s。", -- 目标正复活其他玩家
            GHOST		= "想要一颗心吗，%s？", -- 目标正处于鬼魂状态
            FIRESTARTER	= "小心玩火自焚，%s。", -- 目标在放火
        },

        -- 玩家骸骨
		SKELETON_PLAYER =
		{
			MALE = "%s 先生葬身于此。",
			FEMALE = "%s 女士葬身于此。",
			ROBOT = "%s 葬身于此。",
			DEFAULT = "%s 葬身于此。",
		},
 ------------------------------------------------------------------------------------------------------
---------- 食物(大部分常规食物，活动专属在活动部分)	----------------------------------------
		WETGOOP = "厨艺低劣的罪证。",-- 潮湿黏糊

	------ 素食------------------------------------------------
	------ 食材&烤制
		-- 种子
		SEEDS = "一般来说是杂草。",		  -- 种子
		SEEDS_COOKED = "只能用来喂鸟了。",-- 烤种子

		BERRIES = "可以视为果酱的0.5版本。", -- 浆果
		BERRIES_COOKED = "为什么要烤干？", -- 烤浆果

		BERRIES_JUICY = "更加多汁。",		    -- 多汁浆果
        BERRIES_JUICY_COOKED = "本该做成果酱。",-- 烤多汁浆果

        ROCK_AVOCADO_FRUIT_RIPE = "是一种蔬菜。",		  -- 成熟石果
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "烤熟有什么用？",-- 熟石果

    ------ 农作物
		-- 胡萝卜
		CARROT = "优秀的蔬菜食材。",        -- 胡萝卜
		CARROT_COOKED = "粗劣的加工。",    -- 烤胡萝卜
		CARROT_PLANTED = "兔子的最爱。",   -- 未拔起的胡萝卜
		CARROT_SEEDS = "胡萝卜种子",       -- 胡萝卜种子
		CARROT_OVERSIZED = "分裂出了三个。",-- 巨型胡萝卜

        -- 火龙果
		DRAGONFRUIT = "不知道为什么，它拥有炎龙的力量。",	        -- 火龙果
		DRAGONFRUIT_COOKED = "它不怕火，为什么还能烤熟？",		   -- 熟火龙果
		DRAGONFRUIT_SEEDS = "火龙果的种子……该不会需要岩浆浇灌吧？",-- 火龙果种子/球茎状种子
		DRAGONFRUIT_OVERSIZED = "有几分火龙的气派了。",		      -- 巨型火龙果

		-- 土豆
		POTATO = "我喜欢它料理之后的松软……料理之后！",-- 土豆
        POTATO_COOKED = "最简单和廉价的烹饪。",		  -- 烤土豆
        POTATO_SEEDS = "土豆的种子……完美的粮食",	  -- 土豆种子/毛茸茸的种子
		POTATO_OVERSIZED = "直观地表达出它的产量。",  -- 巨型土豆

        -- 玉米
		CORN = "优良的食材。",                  -- 玉米
		CORN_COOKED = "对我来说太粗俗了",       -- 烤玉米(爆米花)
		CORN_SEEDS = "玉米的种子……种些吧。",   -- 玉米种子/簇状种子
		CORN_OVERSIZED = "另一个维度的加农炮。",-- 巨型玉米

        -- 石榴
        POMEGRANATE = "那些贵妇喜欢这个，她们管它叫“水果女王”。",-- 石榴
        POMEGRANATE_COOKED = "我认为它烤熟后吃起来不如生吃。",  -- 切片熟石榴
        POMEGRANATE_SEEDS = "石榴的种子……需要长多久？",	   -- 石榴种子/风刮来的种子
		POMEGRANATE_OVERSIZED = "像是块巨大的红宝石。",		   -- 巨型石榴

		-- 南瓜
		PUMPKIN = "有万圣节的氛围了。",	                  -- 南瓜
        PUMPKIN_COOKED = "……南瓜饼不是直接烤南瓜就行的！",-- 烤南瓜
        PUMPKIN_SEEDS = "南瓜种子，有种植的必要。",	-- 南瓜种子/尖种子
		PUMPKIN_OVERSIZED = "杰克寻找的家。",	   -- 巨型南瓜

		-- 西瓜
		WATERMELON = "消暑的水果，我只吃冰过的。",	   -- 西瓜
		WATERMELON_COOKED = "什么脑子才能想出烤西瓜？",-- 烤西瓜
		WATERMELON_SEEDS = "西瓜种子",                -- 西瓜种子
		WATERMELON_OVERSIZED = "另一个维度的迫击炮。", -- 巨型西瓜

		-- 榴莲
		DURIAN = "……一些怪人会喜欢这种怪物水果。",		        -- 榴莲
		DURIAN_COOKED = "……它现在更臭了！",	               -- 烤榴莲/超臭榴莲
		DURIAN_SEEDS = "榴莲的种子……这东西种下去只能浪费肥力。",-- 榴莲种子/脆籽荚
		DURIAN_OVERSIZED = "一只茁壮的怪物。",		           -- 巨型榴莲

		-- 茄子
		EGGPLANT = "餐盘里永远的配料。",		-- 茄子
		EGGPLANT_COOKED = "现在还能入锅吗？",	-- 烤茄子
		EGGPLANT_SEEDS = "茄子的种子……收益不高，为什么要种？",-- 茄子种子/漩涡种子
		EGGPLANT_OVERSIZED = "它看起来很柔软。", -- 巨型茄子

		-- 番茄
		TOMATO = "酸涩难言。",		               -- 番茄
        TOMATO_COOKED = "这还这么做番茄酱？",		-- 烤番茄
        TOMATO_SEEDS = "番茄种子……可以种一些酿酒。",-- 番茄种子/带刺的种子
		TOMATO_OVERSIZED = "像个巨大的血囊。",		-- 巨型番茄

		-- 芦笋
		ASPARAGUS = "可以让汤变得鲜冷爽口。",		    -- 芦笋
        ASPARAGUS_COOKED = "我不觉得单纯烤熟能吃。",    -- 烤芦笋
        ASPARAGUS_SEEDS = "芦笋种子，需要种一些来熬汤。",-- 芦笋种子/筒状种子
		ASPARAGUS_OVERSIZED = "足够熬出一锅鲜汤。",		-- 巨型芦笋

		-- 洋葱
		ONION = "还好我没有眼泪。",		           -- 洋葱
        ONION_COOKED = "没有牛排，单煎这个干什么？",-- 烤洋葱
        ONION_SEEDS = "洋葱种子……必不可少的作料。",-- 洋葱种子/尖形种子
		ONION_OVERSIZED = "还好我没有眼泪。",		-- 巨型洋葱

		-- 大蒜
		GARLIC = "我不是德古拉，但绅士也不会吃这个！",-- 大蒜
        GARLIC_COOKED = "烤熟了更熏人了！",		    -- 烤大蒜
        GARLIC_SEEDS = "大蒜种子……种些用来调味吧。",-- 大蒜种子/种子荚
		GARLIC_OVERSIZED = "看起来确实令人避之不及。",-- 巨型大蒜

		-- 辣椒
		PEPPER = "刺激性的调料……谁会生吃调料？",		-- 辣椒
        PEPPER_COOKED = "只有辣椒怎么吃？",		       -- 烤辣椒
        PEPPER_SEEDS = "辣椒的种子，需要多种些来调味。",-- 辣椒种子/块状种子
		PEPPER_OVERSIZED = "如同一炬烈火。",		   -- 巨型辣椒

    ------ 蘑菇
		BLUE_CAP = "虽然有些药效……算了。", -- 采摘的蓝蘑菇
		BLUE_CAP_COOKED = "粗劣的加工。",   -- 熟蓝蘑菇

		RED_CAP = "我喜欢叫它小红帽。",		        -- 采摘的红蘑菇
        RED_CAP_COOKED = "烤过了就不能用于实验了！",-- 熟红蘑菇

		GREEN_CAP = "会损伤神经的野蘑菇。",		                           -- 采摘的绿蘑菇
		GREEN_CAP_COOKED = "虽然高温改变了它的有效成分，但这依旧算不上料理。",-- 熟绿蘑菇

        FIG = "巨树的贡品，甘甜的果实。",-- 无花果
        FIG_COOKED = "应该用来料理。",	-- 熟无花果

		KELP = "用来给汤增添海的味道。",-- 海带叶
		KELP_COOKED = "烤熟有什么用？",	-- 熟海带叶
		KELP_DRIED = "晒干有什么意义？",-- 干海带叶

		MANDRAKE_PLANTED = "充沛的魔力……!",	         -- 曼德拉草(种下)
		MANDRAKE_ACTIVE = "我喜欢这种魔力。",	          -- 曼德拉草(活动)
		MANDRAKE = "完美的魔力结晶！还有一个受折磨的灵魂！",-- 曼德拉草(物品)
		MANDRAKE_COOKED = "暴殄天物！",                  -- 烤曼德拉草
		COOKEDMANDRAKE = "暴殄天物！",                   -- 熟曼德拉草
		MANDRAKESOUP = "至高享受。",                     -- 曼德拉草汤

		CACTUS_FLOWER = "货真价实的沙漠之花。",        -- 仙人掌花
		CACTUS_MEAT = "尖刺是你的利齿吗？顽强的蔬菜。", -- 仙人掌肉
		CACTUS_MEAT_COOKED = "粗劣的加工。",          -- 熟仙人掌肉

		LICHEN = "我不会要吃它吧？",		-- 洞穴苔藓
		CUTLICHEN = "我真的要吃它吗？",		-- 苔藓

		CAVE_FERN = "蕨类植物……也算是食材吧。",-- 蕨类植物

		CAVE_BANANA = "优质的水果原料。",		  -- 香蕉
		CAVE_BANANA_COOKED = "我猜这是猴子秘方。",-- 熟香蕉

		-- 通用料理
		JAMMYPRESERVES = "适配酥软的白面包。",	  -- 果酱
		RATATOUILLE = "简单的素菜。",            -- 蔬菜杂烩
		SWEETTEA = "舒适的下午茶。",	          -- 舒缓茶
		WAFFLES = "完美的早晚餐。",		          -- 华夫饼
		FLOWERSALAD = "清凉爽口。",		         -- 花沙拉
		TRAILMIX = "小孩子喜欢的甜口零食。",	  -- 什锦干果
		FIGATONI = "搭配的不错。",		         -- 无花果意面
		DRAGONPIE = "能品尝出热情。",		     -- 火龙果派
		STUFFEDEGGPLANT = "茄子有点喧宾夺主。",	  -- 酿茄子
		PUMPKINCOOKIE = "酥甜可口。",	         -- 南瓜饼干
        WATERMELONICLE = "驱散暑热。",		     -- 西瓜冰棍
		MASHEDPOTATOES = "香甜润滑，入口即化。",  -- 奶油土豆泥
		POTATOTORNADO = "名俗小吃，味道不错。",	  -- 花式回旋块茎
		ASPARAGUSSOUP = "将鲜味演绎到了极致。",   -- 芦笋汤
		SALSA = "风味独特。",		             -- 生鲜萨尔萨酱
		VEGSTINGER = "酒精浓度不足，但蔬果风味非常爽口。",-- 蔬菜鸡尾酒
		BANANAPOP = "香甜的点心。",		          -- 香蕉冻
		BANANAJUICE = "低俗的水手饮品，但能让人振奋起来。",-- 香蕉奶昔
		FROZENBANANADAIQUIRI = "像是一个甜蜜但", -- 冰香蕉冻唇蜜

		POWCAKE = "这一开始就不是被当做食品制造的。",-- 芝士蛋糕

        -- 牛食
		BEEFALOFEED = "常见牛饲料。", -- 蒸树枝
		BEEFALOTREAT = "秘制牛饲料。",-- 皮弗娄牛零食

		-- 虫食
        REFINED_DUST = "大地的结晶。",-- 尘土块
        DUSTMERINGUE = "远古的土食。",-- 琥珀美食

	------ 肉食------------------------------------------------------
	------ 食材&烤制&肉干
        MEAT = "肥厚的肉。",		                   -- 大肉
		COOKEDMEAT = "粗浅的加工。",                   -- 烤大肉
        MEAT_DRIED = "更耐储存的食材……还是算不上料理。",-- 肉干

		SMALLMEAT = "食之无味，弃之可惜。",	 -- 小肉
		COOKEDSMALLMEAT = "粗劣的加工。",   -- 烤小肉
		SMALLMEAT_DRIED = "更耐储存的食材……但依旧算不上料理。",-- 小风干肉

        MONSTERMEAT = "恶心的东西。",		        -- 怪物肉
		COOKEDMONSTERMEAT = "这东西的恶心不分生熟。",-- 熟怪物肉
		MONSTERMEAT_DRIED = "还是那么恶心。",		-- 怪物肉干

		DRUMSTICK = "深受底层喜爱。",		  -- 鸟腿
		DRUMSTICK_COOKED = "庸俗的廉价快餐。",-- 炸鸟腿

		TALLBIRDEGG = "富含营养的食材。",              -- 高脚鸟蛋
		TALLBIRDEGG_COOKED = "这玩意仅仅烤熟了就能吃？",-- 烤高脚鸟蛋

        PLANTMEAT = "细胞层面属于动物。",	 -- 叶肉
        PLANTMEAT_COOKED = "看起来很恶心。",-- 熟叶肉

		TRUNK_SUMMER = "可以当食材或者原料。",		     --  象鼻
		TRUNK_WINTER = "比平时的鼻子更有用一点。但不多。",--  冬象鼻
		TRUNK_COOKED = "粗劣的加工。",		            --  象鼻排

        BARNACLE = "这些硬壳里面都是肉。", -- 藤壶
        BARNACLE_COOKED = "熟了。",		 -- 熟藤壶

		BATWING = "明明每只蝙蝠活着时候都有两根来着。",	-- 洞穴蝙蝠翅膀
        BATWING_COOKED = "什么人会尝试把这东西烤熟？",	-- 熟蝙蝠翅膀

        BATNOSE = "简而言之：恶心。",                  -- 裸露鼻孔
        BATNOSE_COOKED = "没那么黏糊糊了，但还是恶心。",-- 炭烤鼻孔

		-- 鱼
	    PONDFISH = "这些鱼长在池塘里。",		-- 淡水鱼
		FISH_COOKED = "单纯弄熟可算不上料理。",	-- 熟鱼
		FISHSTICKS = "粗劣的加工。",		   -- 炸鱼排

        FISHMEAT = "需要加工去腥。",	         -- 生鱼肉
        FISHMEAT_COOKED = "需要加工去腥。",	     -- 鱼排
        FISHMEAT_SMALL = "需要加工去腥。",       -- 小鱼块
        FISHMEAT_SMALL_COOKED = "需要加工去腥。",-- 熟小鱼块
		SPOILED_FISH = "我绝不吃这个！",		 -- 变质的鱼

		FISHMEAT_DRIED       = "没有买卖，就没有杀害。", -- 鱼肉干
		FISHMEAT_SMALL_DRIED = "没有买卖，就没有杀害。", -- 小鱼肉干

		-- 鳗鱼
		PONDEEL = "猪人的酋长很喜欢这个。",		       -- 活鳗鱼
		EEL = "跟我以前尝过的不是同一品种。",	   	    -- 鳗鱼
		EEL_COOKED = "粗劣的加工。",		           -- 熟鳗鱼
		UNAGI = "我曾经征服的一座岛国没少给我进献过这个",-- 鳗鱼料理

    ------ 海鱼
	    -- 生物形式
	    OCEANFISH_SMALL_1 = "它真的很小。",		        -- 小孔雀鱼
	    OCEANFISH_SMALL_2 = "这条鱼会像鱿鱼一样喷墨吗？",-- 针鼻喷墨鱼
	    OCEANFISH_SMALL_3 = "好小的鱼。",		        -- 小饵鱼
	    OCEANFISH_SMALL_4 = "它还是个宝宝，别钓了好吗？",-- 三文鱼苗
	    OCEANFISH_SMALL_5 = "爆米花变成鱼了！",		    -- 爆米花鱼
	    OCEANFISH_SMALL_6 = "它在水里像一片落叶。",		-- 落叶比目鱼
	    OCEANFISH_SMALL_7 = "鱼头上开出了鲜花。",		-- 花朵金枪鱼
	    OCEANFISH_SMALL_8 = "它简直是个小太阳。",		-- 炽热太阳鱼
        OCEANFISH_SMALL_9 = "它的一生都在吐水。",		-- 口水鱼
	    OCEANFISH_MEDIUM_1 = "像泥土一样的颜色。",		-- 泥鱼
	    OCEANFISH_MEDIUM_2 = "它已经被其他生物预定了。", -- 斑鱼
	    OCEANFISH_MEDIUM_3 = "看起来好扎手。",		    -- 浮夸狮子鱼
	    OCEANFISH_MEDIUM_4 = "又黑又光滑，好丑。",		-- 黑鲶鱼
	    OCEANFISH_MEDIUM_5 = "玉米也变成鱼了。",		-- 玉米鳕鱼
	    OCEANFISH_MEDIUM_6 = "它的花色很漂亮。",		-- 花锦鲤
	    OCEANFISH_MEDIUM_7 = "它的花色很漂亮。",		-- 金锦鲤
	    OCEANFISH_MEDIUM_8 = "它简直是一块寒冰。",		-- 冰鲷鱼
        OCEANFISH_MEDIUM_9 = "是甜的，但我不准备吃它。", -- 甜味鱼

		-- 物品形式
	    OCEANFISH_SMALL_1_INV = "它真的很小。",		        -- 小孔雀鱼
	    OCEANFISH_SMALL_2_INV = "这条鱼会像鱿鱼一样喷墨吗？",-- 针鼻喷墨鱼
	    OCEANFISH_SMALL_3_INV = "好小的鱼。",		        -- 小饵鱼
	    OCEANFISH_SMALL_4_INV = "它还是个宝宝，别钓了好吗？",-- 三文鱼苗
	    OCEANFISH_SMALL_5_INV = "爆米花变成鱼了！",		    -- 爆米花鱼
	    OCEANFISH_SMALL_6_INV = "它在水里像一片落叶。",		-- 落叶比目鱼
	    OCEANFISH_SMALL_7_INV = "鱼头上开出了鲜花。",		-- 花朵金枪鱼
	    OCEANFISH_SMALL_8_INV = "它简直是个小太阳。",		-- 炽热太阳鱼
        OCEANFISH_SMALL_9_INV = "它的一生都在吐水。",		-- 口水鱼
	    OCEANFISH_MEDIUM_1_INV = "像泥土一样的颜色。",		-- 泥鱼
	    OCEANFISH_MEDIUM_2_INV = "它已经被其他生物预定了。", -- 斑鱼
	    OCEANFISH_MEDIUM_3_INV = "看起来好扎手。",		    -- 浮夸狮子鱼
	    OCEANFISH_MEDIUM_4_INV = "又黑又光滑，好丑。",		-- 黑鲶鱼
	    OCEANFISH_MEDIUM_5_INV = "玉米也变成鱼了。",		-- 玉米鳕鱼
	    OCEANFISH_MEDIUM_6_INV = "它的花色很漂亮。",		-- 花锦鲤
	    OCEANFISH_MEDIUM_7_INV = "它的花色很漂亮。",		-- 金锦鲤
	    OCEANFISH_MEDIUM_8_INV = "它简直是一块寒冰。",		-- 冰鲷鱼
        OCEANFISH_MEDIUM_9_INV = "是甜的，但我不准备吃它。", -- 甜味鱼

		-- 通用料理
		MEATBALLS = "饱满，过于饱满了。",          -- 肉丸
		BONESTEW = "丰盛的一餐。",                -- 大肉汤
		KABOBS = "有些粗鲁原始，但别有风味。",		-- 肉串
		MONSTERLASAGNA = "……这是谋杀！",		  -- 怪物千层饼
		JUSTEGGS = "怎么煎出来的？",		       -- 普通煎蛋
		BACONEGGS = "简单、经典，早餐的默认选项。", -- 培根煎蛋
		VEGGIEOMLET = "早餐的完美之选。",		   -- 早餐锅
		PEROGIES = "均匀的荤素搭配带来完美的舌尖体验。",-- 波兰水饺
		TALLEGGS = "肉汁饱满。",		          -- 苏格兰高鸟蛋
		HONEYHAM = "高热量的丰盛正餐。",		   -- 蜜汁火腿
		HONEYNUGGETS = "不错，切碎成小块更加入味。",-- 蜜汁卤肉
        HOTCHILI = "热辣开胃。",		          -- 辣椒炖肉
        GUACAMOLE = "墨西哥的阿伏伽德罗。",		   -- 鳄梨酱
		FISHTACOS = "偶尔品尝民俗小吃也别有意趣。", -- 鱼肉玉米卷
		CEVICHE = "……风味独特。",	              -- 酸橘汁腌鱼
		TURKEYDINNER = "该享用些正餐了。",         -- 火鸡正餐
		BUTTERFLYMUFFIN = "嗯~酥甜可口。",         -- 蝴蝶松饼
		PEPPERPOPPER = "美味如火山般爆发。",		-- 爆炒填馅辣椒
		CALIFORNIAROLL = "里面是鱼肉对吧？",		-- 加州卷
		SEAFOODGUMBO = "浓郁的海味。",		        -- 海鲜浓汤
		SURFNTURF = "端庄的盛宴。",		            -- 海鲜牛排
        LOBSTERBISQUE = "品尝近海的波涛。",		    -- 龙虾汤
        LOBSTERDINNER = "文明人的晚宴。",		    -- 龙虾正餐
        FIGKABAB = "用无花果的甘甜化解油腻。",		 -- 无花果烤串
        KOALEFIG_TRUNK = "有点太过甜腻了……",	    -- 无花果酿象鼻
        FROGNEWTON = "无花果让它特殊了一点。",		-- 无花果蛙腿三明治
        BUNNYSTEW = "根本没用兔子。",		       -- 炖兔子
		BARNACLEPITA = "塔克的拙劣模仿者。",		-- 藤壶皮塔饼
        BARNACLESUSHI = "看起来很精致。",		    -- 藤壶握寿司
        BARNACLINGUINE = "香味浓郁。",		       -- 藤壶中细面
        BARNACLESTUFFEDFISHHEAD = "鱼头在仰望星空。",-- 酿鱼头
        LEAFLOAF = "令人精神一振。",		        -- 叶肉糕
        LEAFYMEATBURGER = "这应当是肉的口感……",	-- 素食堡
        LEAFYMEATSOUFFLE = "一种创新。",		    -- 果冻沙拉
        MEATYSALAD = "荤素失衡。",		           -- 牛肉绿叶菜
        BATNOSEHAT = "……这实在太荒谬了。",		    -- 牛奶帽

		-- 乳制品&好东西料理
		BUTTER = "在这地方居然算一种奢侈品。", -- 黄油
        ICECREAM = "享受的代名词。",		 -- 冰淇淋
		TAFFY = "甜掉牙。",		             -- 太妃糖
		JELLYBEAN = "香甜到能治愈人心。",	  -- 彩虹糖豆
		SHROOMCAKE = "蘑菇做的蛋糕是什么味？",-- 蘑菇蛋糕

        -- 调味料
		SALTROCK = "圣洁的盐，土之子所必须的元素。", -- 盐晶
		SPICE_SALT = "等等，所以之前的东西里都没有盐吗？", -- 调味盐
		SPICE_GARLIC = "德古拉不会喜欢这个的。",		   -- 蒜粉
        SPICE_SUGAR = "甜分总能使人振作。",		   -- 蜂蜜水晶
        SPICE_CHILI = "品尝烈焰。",		          -- 辣椒面

		-- 大厨特色菜
		-- 素食
		GLOWBERRYMOUSSE = "令人眼前一亮。",		 -- 发光浆果慕斯
		DRAGONCHILISALAD = "享用它的似火热辣。", -- 辣龙椒沙拉
		GAZPACHO = "清爽。",		 -- 芦笋冷汤
		NIGHTMAREPIE = "能够让精神渗透生命。",   -- 恐怖国王饼
		POTATOSOUFFLE = "值得我为它大赦天下。",	 -- 蓬松土豆蛋奶酥
		FRESHFRUITCREPES = "值得一场精心准备的烛光晚餐。", -- 鲜果可丽饼

		-- 肉食
		MONSTERTARTARE = "如此精湛的厨艺就用来行刺！？", -- 怪物鞑靼
		BONESOUP = "深入骨髓的营养与和美味。",	 -- 骨头汤
        MOQUECA = "完美的晚宴。",		       -- 海鲜杂烩
        FROGFISHBOWL = "让人如鱼得水。",	   -- 蓝带鱼排

		-- 好东西料理
        VOLTGOATJELLY = "羊角做的。",		-- 伏特羊肉冻

		-- 茶叶
		PETALS_DRIED            = "泡茶的好材料。", -- 干燥的花瓣
		PETALS_EVIL_DRIED       = "泡茶的好材料。", -- 干燥的恶魔花瓣
		FOLIAGE_DRIED           = "泡茶的好材料。", -- 干燥的叶子
		SUCCULENT_PICKED_DRIED  = "泡茶的好材料。", -- 干燥的多肉植物
		FIRENETTLES_DRIED       = "泡茶的好材料。", -- 干燥的火荨麻
		TILLWEED_DRIED          = "泡茶的好材料。", -- 干燥的犁地草
		MOON_TREE_BLOSSOM_DRIED = "泡茶的好材料。", -- 干燥的月树花
		FORGETMELOTS_DRIED      = "泡茶的好材料。", -- 干燥的必忘我

		-- 珍珠的茶
		HERMITCRABTEA_PETALS            = "有助于提神。", -- 花瓣茶(少量回san)
		HERMITCRABTEA_PETALS_EVIL       = "富坦的低语？", -- 恶魔花瓣茶(扣san)
		HERMITCRABTEA_FOLIAGE           = "镇静凝神。", -- 叶子茶(疯狂光环抵抗)
		HERMITCRABTEA_SUCCULENT_PICKED  = "清凉泄火。", -- 多肉茶(降温)
		HERMITCRABTEA_FIRENETTLES       = "一口热茶。", -- 火荨麻茶(升温)
		HERMITCRABTEA_TILLWEED          = "对健康有益的东西通常对味蕾有害。", -- 犁地草茶(少量回血)
		HERMITCRABTEA_MOON_TREE_BLOSSOM = "且试人间小团月。", -- 月树花茶(月灵中立&暗影生物恐慌)
		HERMITCRABTEA_FORGETMELOTS      = "遗忘忧思。", -- 必忘我茶(少量回san)

 ------------------------------------------------------------------------------------------------------------------------
        -- 作物-------------------------------------------------------------
		-- 食品作物---------------------------------------------------------
		-- 浆果丛
		BERRYBUSH =
		{
			BARREN = "需要施肥来恢复活力。",               -- 需要施肥
			WITHERED = "酷暑夺走了它生长的力量。",         -- 枯萎
			GENERIC = "可以视为果酱的0.1版本。",           -- 正常
			PICKED = "下次长出浆果时也可能多长一只火鸡吗？",-- 采摘完状态
		},

		DUG_BERRYBUSH = "土地会让它继续为我生长。",-- 浆果丛

        -- 多汁浆果丛
		BERRYBUSH_JUICY =
		{
			BARREN = "需要施肥来恢复活力。",   -- 需要施肥
			WITHERED = "需要肥料。",	      -- 枯萎了
			GENERIC = "富含糖分，也容易腐坏。",
			PICKED = "下次再来光顾它。",       -- 被采完了
			BURNING = "它在焰火中窒息了。",    -- 正在燃烧
		},

		DUG_BERRYBUSH_JUICY = "土地会让它继续为我生长。",-- 多汁浆果丛

		-- 红蘑菇(土地里)
		RED_MUSHROOM =
		{
			GENERIC = "可怜的小红帽。",
			INGROUND = "它有着早睡早起的规律作息。",
			PICKED = "下面还藏着一只，要赶尽杀绝吗？",
		},

		-- 绿蘑菇(土地里)
		GREEN_MUSHROOM =
		{
			GENERIC = "翠绿的小帽子。",
			INGROUND = "它喜欢黄昏的格调。",
			PICKED = "下面藏着最后的根基，要赶尽杀绝吗？",
		},

		-- 蓝蘑菇(土地里)
		BLUE_MUSHROOM =
		{
			GENERIC = "瘦蓝的蘑菇，野生的药剂。",             -- 正常检查
			INGROUND = "它只对月光致敬。",                   -- 白天和黄昏缩地状态
			PICKED = "雨水能让它再生。或者能用铲子赶尽杀绝。", -- 被采摘后
		},

		CAVE_BANANA_TREE = "我不是很信任不需要光合作用的水果。",-- 洞穴香蕉树

        -- 香蕉丛
        BANANABUSH = "丛生香蕉。",		-- 疑似通用
        DUG_BANANABUSH = "丛生香蕉。",	-- 挖出

		-- 仙人掌
		CACTUS =
		{
			GENERIC = "它用尖刺保护自己饱满的果肉。",   -- 待采摘状态
			PICKED = "它还会再一次长出果肉……和利刺。", -- 采摘完状态
		},

		-- 石果灌木丛
		-- 注：因为石果的产量远大于石头的产量，所以在此列为食物作物
        ROCK_AVOCADO_BUSH =
        {
        	BARREN = "施点肥？",
			WITHERED = "需要重新给予它一些能量。",	-- 枯萎了
			GENERIC = "它长出石头包裹的果子。",		-- 默认
			PICKED = "再次长出来还需要时间。",		-- 采摘完状态
			BURNING = "我得找点灭火的东西。",		-- 正在燃烧
		},

        ROCK_AVOCADO_FRUIT = "里面有生机的感觉……",	    -- 石果
        ROCK_AVOCADO_FRUIT_SPROUT = "新的，可以种下。",	-- 发芽的石果

---------- 农作物与杂草---------------------------------------------------------
        -- 农作物(疑似耕地版本？)
		FARM_PLANT =
		{
			GENERIC = "长吧。",
			SEED = "种子。",
			GROWING = "不错。",
			FULL = "一点点好处？",
			ROTTEN = "……",
			FULL_OVERSIZED = "长大了。",
			ROTTEN_OVERSIZED = "你不适合在这里。",
			FULL_WEED = "铲除它。",
			BURNING = "烧起来了。",
		},

		-- 农作物(疑似旧版？)
	    PLANT_NORMAL =
        {
	        GENERIC = "皇家特供。",
		    GROWING = "距离上餐桌还有很长的一段路要走。", -- 生长中
		    READY = "饱满成熟。",                      -- 成熟
		    WITHERED = "死于高温。",                   -- 枯萎
	    },

		FARM_SOIL_DEBRIS = "会影响作物的生长。",-- 农田杂物
		FIRENETTLES = "它看起来就像火焰。",		-- 火荨麻叶
		FORGETMELOTS = "艳丽的衣着隐藏着空洞的内在，这就是遗忘的理由。",-- 必忘我
		TILLWEED = "它的根会不断翻出杂物。",-- 犁地草
        WEED_IVY = "它应该被铲掉！",       -- 刺针旋花
        IVY_SNARE = "我早该铲除它的！",    -- 缠绕根须

---------- 材料作物	-----------------------------------------------------------
		-- 草
		DEPLETED_GRASS =
		{
			GENERIC = "常见的植物，和材料。",
		},

		-- 草丛
		GRASS =
		{
			BARREN = "可以收获了。",           -- 生长完成
			WITHERED = "看来高温燃尽了它的水分和生命力。",-- 枯萎
			BURNING = "正在被烈火吞噬。",		-- 正在燃烧
			GENERIC = "野外总需要这个。",
			PICKED = "还需要一段时间来生长。",	-- 采摘完
		},

		DUG_GRASS = "移植草丛的活应该交给苦力。",-- 挖下的草丛

        -- 草壁虎
		GRASSGEKKO =
		{
			GENERIC = "这个世界动植物间似乎并无太大分别……",
		},

		-- 小树苗
		SAPLING =
		{
			BURNING = "很快就会被烧成木炭了。",
			WITHERED = "需要施肥来恢复活力。",-- 枯萎
			GENERIC = "小树枝的来源。",
			PICKED = "需要时间再生。",
		},

		DUG_SAPLING = "移植树苗的活应该交给苦力。",-- 挖下的小树苗

		-- 尖刺灌木
        MARSH_BUSH =
        {
			BURNT = "完全炭化了。",		   -- 烧毁
            BURNING = "它比一般植物耐烧。",-- 正在燃烧
            GENERIC = "尖锐粗糙。",
            PICKED = "暂时不能伤人了。",   -- 采摘完状态
        },

        BURNT_MARSH_BUSH = "烧成灰烬。。",             -- 尖刺灌木(正在燃烧)
		DUG_MARSH_BUSH = "荒漠锻炼出了它对火焰的耐性。",-- 挖下的尖刺灌木

		-- 多枝树
		TWIGGYTREE =
		{
			BURNING = "熊熊烈焰吞噬了它。",	   -- 正在燃烧
			BURNT = "变成木炭了。",		      -- 烧毁
			CHOPPED = "还有一块木头没被搜刮。",-- 砍剩树桩
			GENERIC = "会掉落树枝。",
		},

		TWIGGY_NUT = "种下去才有收益。",		   -- 多枝树果
		TWIGGY_NUT_SAPLING = "还没长大。",		  -- 多枝树苗
        TWIGGY_OLD = "对于多枝树而言已经是长者了。",-- 老多枝树

		-- 芦苇
		REEDS =
		{
			BURNING = "会被烧成灰烬的。",
			GENERIC = "书籍的起源版本。",
			PICKED = "需要时间再生。",
		},

        -- 猴尾草
        MONKEYTAIL = "另一种芦苇。",	 --  疑似物品或种植
        DUG_MONKEYTAIL = "另一种芦苇。", --  挖出

        MARBLESHRUB = "再生的大理石。",		 --  大理石灌木
        MARBLEPILLAR = "经历了漫长的时光。", --  大理石柱
        MARBLETREE = "似乎是天然形成的？",	 --  大理石树

---------- 树木	--------------------------------------------------------------------------------
        -- 常青树
		EVERGREEN =
		{
			BURNING = "很快就有木炭了。",	  -- 正在燃烧
			BURNT = "已经是木炭了。",		  -- 烧毁
			CHOPPED = "还有一块木头没被搜刮。",-- 砍剩树桩
			GENERIC = "四季常青。",
		},

		-- 臃肿常青树
		EVERGREEN_SPARSE =
		{
			BURNING = "它被点燃了。",		  -- 正在燃烧
			BURNT = "收获木炭。",		      -- 烧毁
			CHOPPED = "还有一块木头没被搜刮。",-- 砍剩树桩
			GENERIC = "看起来有点臃肿。",
		},

		PINECONE = "没有松露。只能种了。",	  -- 松果
        PINECONE_SAPLING = "长吧，我等着砍。",-- 常青树苗
		LUMPY_SAPLING = "时间会令它成长。",	  -- 臃肿树苗

		-- 桦栗树
		DECIDUOUSTREE =
		{
			BURNING = "火焰会做出木炭。",	      -- 正在燃烧
			BURNT = "已经是木炭了。",		      -- 烧毁的
			CHOPPED = "还有一块木头没被搜刮。",	   -- 砍剩树桩
			POISON = "桦树之灵的反击，上门的活木。",-- 桦树精
			GENERIC = "我需要砍多少才能激怒它们的灵呢？",
		},

	    BIRCHNUTDRAKE = "桦树的灵用一根树枝做的把戏。",-- 桦栗果精

	    ACORN = "能做一种小孩子喜欢的零食。",		-- 桦栗果
	    ACORN_COOKED = "……不能种了，但还能下锅。",	-- 烤桦栗果

	    ACORN_SAPLING = "还没到摧毁它的时候。",		-- 桦栗树树苗

		-- 尖刺树
        MARSH_TREE =
        {
            BURNING = "它身上的尖刺更有利于燃烧。",		-- 正在燃烧
            BURNT = "烧完一样难看。",		-- 烧毁
            CHOPPED = "还有一块木头没被搜刮。",		-- 砍剩树桩
            GENERIC = "沼泽风格。我觉得烧了更顺眼。",
        },

	    -- 棕榈松果树
	    PALMCONETREE = "一种优质木材。",     -- 棕榈松果树
	    PALMCONE_SEED = "它在这边也能生长。",-- 棕榈松果树芽
	    PALMCONE_SAPLING = "它快长大了。",	-- 棕榈松果树苗
	    PALMCONE_SCALE = "很好用的材料。",	-- 棕榈松果树鳞片

		-- 月树
        MOON_TREE =
        {
            BURNING = "烧起来了，不太妙。",		-- 正在燃烧
            BURNT = "上面的花朵和月蛾都消失了。",-- 烧毁
            CHOPPED = "还有一块木头没被搜刮。",	 -- 砍剩树桩
            GENERIC = "它只扎根在月亮的土壤。",
        },

		MOON_TREE_BLOSSOM = "皎洁如月，清香怡人。",	-- 月树花

        MOONBUTTERFLY_SAPLING = "它会继续长大的。",	-- 月树苗

		LIVINGTREE = "树木拥有生命，这完全正常。",-- 完全正常的树

        -- 水中木
        OCEANTREENUT = "巨树的巨果。",           -- 疙瘩树果(水中木种子，重物)
        OCEANTREE = "需要额外的养分才能茁壮生长。",-- 疙瘩树(需要施肥的水中木状态)
		OCEANTREE_PILLAR = "参天蔽日！",		 -- 高出平均值的树干(长成的水中木)
        OCEANVINE = "巨树的贡品。",		         -- 苔藓藤条(无花果藤)

		-- 惊喜种子作物
		ANCIENTTREE_SEED = "世上没有惊喜，只有不全面的统计。",	-- 惊喜种子

		ANCIENTTREE_SAPLING_ITEM = "我得把它种在对的地方。",-- 萌芽石苗(物品形态)

		-- 年轻萌芽石
		ANCIENTTREE_SAPLING =
		{
			GENERIC = "它的生长真是缓慢。",
			WRONG_TILE = "它需要在岩石上生长。",  -- 地皮错误
			WRONG_SEASON = "它只在夏日的酷暑中。",-- 季节不对
		},

		-- 萌芽石
		ANCIENTTREE_GEM =
		{
			GENERIC = "它能抽取大地的精髓。",
			STUMP = "已经采摘完了。",	-- 摘完了
		},

		ANCIENTFRUIT_GEM = "高温能取出里面的宝石。",-- 晶洞果

		ANCIENTTREE_NIGHTVISION_SAPLING_ITEM = "我得把它种在沼泽地。",-- 阴郁之棘苗(物品形态)

		-- 年轻阴郁之棘
		ANCIENTTREE_NIGHTVISION_SAPLING =
		{
			GENERIC = "它的生长真是缓慢。",
			WRONG_TILE = "它需要在沼泽地生长。",      -- 地皮错误
			WRONG_SEASON = "它只在凛冬的寒风中生长。",-- 季节不对
		},

		-- 阴郁之棘
		ANCIENTTREE_NIGHTVISION =
		{
			GENERIC = "是很阴森。",
			STUMP = "下一夜还能收获。",	-- 摘完了
		},

		ANCIENTFRUIT_NIGHTVISION = "像一枚跳动的心。", -- 夜莓
		ANCIENTFRUIT_NIGHTVISION_COOKED = "它死心了。",-- 熟夜莓

 	-----------------------------------------------------------------------------------------------------------------------
	------ 材料&制作道具(远古制作站、暗影术基站、辉煌锻造台、天体科技单独分类) ------------------------------------------------
		-- 精炼	--------------------------------------------
		FLINT = "它尖锐的棱角能打磨物品。",		-- 燧石
		NITRE = "化学上的重要原料。",		   -- 硝石
		TWIGS = "可以做点东西。",              -- 树枝
		CUTGRASS = "可以搓成草绳。",		   -- 采下的草
		ROPE = "手工艺原材料。",		       -- 绳子
		-- 木头
		LOG =
		{
			BURNING = "快烧成碳了。",
			GENERIC = "基本的建筑材料。",
		},
		BOARDS = "重要的材料。",               -- 木板
		CHARCOAL = "经典的燃料。",             -- 木炭
		ROCKS = "粗糙的建筑原料。",		        -- 石头
		CUTSTONE = "普通的建筑材料。",          -- 石砖

		CUTREEDS = "它细密的纤维可以做成草纸。",-- 采下的芦苇
		PAPYRUS = "书的原料。",		           -- 莎草纸
        WAXPAPER = "具有良好的防腐性能。",		-- 蜡纸

		GOLDNUGGET = "太多了就显得庸俗。",		-- 金块
		WAGPUNK_BITS = "起码是工业钢，勉强能用。",-- 废铁
		TRANSISTOR = "科学的起点。",		-- 电子元件

		MARBLE = "坚固且有格调的石材。",		     -- 大理石
        MARBLEBEAN = "应用了炼金术原理制成。",   	 -- 大理石豌豆
        MARBLEBEAN_SAPLING = "杰克种的应该不是这种。",-- 大理石芽

		ROCK_MOON = "“月”岩，呵，他们怎么会把你当做月亮？",		-- 月岩
		MOONROCKNUGGET = "“月”岩，呵，他们怎么会把你当做月亮？",-- 月岩

		MOONROCKCRATER = "缺少点睛之笔。",-- 带孔月岩

        REDMOONEYE = "猩红凝视。",		 -- 红色月眼
        PURPLEMOONEYE = "深渊凝视。",	 -- 紫色月眼
        GREENMOONEYE = "眼中深藏奥秘。", -- 绿色月眼
        ORANGEMOONEYE = "看穿空间。",	 -- 橘色月眼
        YELLOWMOONEYE = "囚禁光明。",	 -- 黄色月眼
        BLUEMOONEYE = "高冷的眼神。",	 -- 蓝色月眼

		ICE = "优秀的鸡尾酒总需要加一块。",      -- 冰块

		NIGHTMAREFUEL = "暗影力量的浓缩。",	-- 噩梦燃料
		LIVINGLOG = "魔杖的重要材料。",		-- 活木头

		DREADSTONE = "像是令人绝望的现实一样狰狞而坚不可摧。",-- 绝望石
		HORRORFUEL = "暗影深层的力量……",		            -- 纯粹恐惧

		PUREBRILLIANCE = "如此纯粹的月光！",		   -- 纯粹辉煌
		LUNARPLANT_HUSK = "这些壳也蕴藏着月光的力量。",	-- 亮茄外壳

        -- 生物材料
		BEARDHAIR = "为什么备份自己生命的仪式会需要这个？",-- 胡须
		MALBATROSS_FEATHERED_WEAVE = "一整块羽毛。",	-- 羽毛帆布
		BONESHARD = "失败者的残骸。",                   -- 骨头碎片

        -- 工具	--------------------------------------------
		AXE = "贫民的东西……居然要我用这个当苦力？", -- 斧子
        PICKAXE = "苦工的东西！",                  -- 鹤嘴锄
		PITCHFORK = "农民才干这个！",		        -- 干草叉
		SHOVEL = "粗劣的工具……难道要我做苦工？",	 -- 铲子
		FARM_HOE = "我需要一个园丁！",		        -- 园艺锄

		HAMMER = "摧毁建筑！",		               -- 锤子
		BUGNET = "开始捉BUG吧。",                  -- 捕虫网

		GOLDENAXE = "有点格调。",		            -- 黄金斧头
		GOLDENPICKAXE = "有点格调。",		        -- 黄金鹤嘴锄
		GOLDENPITCHFORK = "现在，这个世界我说了算。",-- 黄金干草叉
		GOLDENSHOVEL = "有点格调。",		        -- 黄金铲子
		GOLDEN_FARM_HOE = "……一种金色幽默。",		-- 黄金园艺锄

		TORCH = "很好，现在有探险的氛围了。", -- 火炬
        LANTERN = "让我的管家提着它。",		  -- 提灯

        RAZOR = "我需要一个理发师……没有驴耳朵的那种。",-- 剃刀

		-- 暖石
		HEATROCK =
		{
			FROZEN = "像我的内心一样冷酷。",-- 最低温
			COLD = "冰冰凉凉的。",         -- 低温
			GENERIC = "原始便携调温设备。",-- 常温
			WARM = "带来暖意。",           -- 温暖
			HOT = "它甚至在发光。",        -- 最高温
		},

		CANE = "文明人的象征。",    -- 步行手杖

		TRAP = "能让那些可怜的小东西落入我的手中。",-- 陷阱
		BIRDTRAP = "笼中鸟中转站。",              -- 捕鸟陷阱

        BUNDLEWRAP = "里面的东西其实在另一个空间。",-- 捆绑包装
        BUNDLE = "让我想想里面打包了什么。",	   -- 捆绑物资

		FEATHERFAN = "缺一些装饰，好在材料算是珍贵。",-- 羽毛扇
        MINIFAN = "小孩子的玩具罢了。",		         -- 旋转的风扇

        STAFF_TORNADO = "狂风服从号令！",	-- 天气风向标

		SEWING_KIT = "缝补东西，甚至石头。",-- 针线包

		ONEMANBAND = "精炼披头士。",       -- 独奏乐器
        PANFLUTE = "用于演奏《宁静之廷》。",-- 排箫

		MINIFLARE = "召唤千军万马。",-- 信号弹
		MEGAFLARE = "诱敌深入。",	 -- 敌对信号弹

		BACKPACK = "贫民的东西……居然要我背着这个当苦力？",-- 背包
        PIGGYBACK = "碍手碍脚的。",		                 -- 猪皮包
		ICEPACK = "那头熊活着时候，肚子里的东西也能保鲜吗？",-- 保鲜背包

		TRIDENT = "让大海一激灵。",-- 刺耳三叉戟

		FISHINGROD = "谁要钓鱼，不会是我吧？",-- 淡水钓竿
		OCEANFISHINGROD = "钓鱼……",		-- 海钓竿

		-- 海钓配件
		OCEANFISHINGBOBBER_NONE = "只用钩子可以钓上来什么鱼？",-- 鱼钩
        OCEANFISHINGBOBBER_BALL = "浮标。",		    -- 木球浮标
        OCEANFISHINGBOBBER_OVAL = "浮标。",		    -- 硬物浮标
		OCEANFISHINGBOBBER_CROW = "浮标。",		    -- 黑羽浮标
		OCEANFISHINGBOBBER_ROBIN = "浮标。",		-- 红羽浮标
		OCEANFISHINGBOBBER_ROBIN_WINTER = "浮标。",	-- 蔚蓝羽浮标
		OCEANFISHINGBOBBER_CANARY = "浮标。",		-- 黄羽浮标
		OCEANFISHINGBOBBER_GOOSE = "浮标。",		-- 鹅羽浮标
		OCEANFISHINGBOBBER_MALBATROSS = "浮标。",	-- 邪天翁羽浮标
        -- 鱼饵(四种特殊鱼饵在布景-奶奶岛-寄居蟹隐士-瓶罐交易处)
		OCEANFISHINGLURE_SPINNER_RED = "让鱼上钩。",	-- 日出旋转亮片
		OCEANFISHINGLURE_SPINNER_GREEN = "让鱼上钩。",	-- 黄昏旋转亮片
		OCEANFISHINGLURE_SPINNER_BLUE = "让鱼上钩。",	-- 夜间旋转亮片
		OCEANFISHINGLURE_SPOON_RED = "让鱼上钩。",		-- 日出匙型假饵
		OCEANFISHINGLURE_SPOON_GREEN = "让鱼上钩。",	-- 黄昏匙型假饵
		OCEANFISHINGLURE_SPOON_BLUE = "让鱼上钩。",		-- 夜间匙型假饵

        POCKET_SCALE = "看看这条鱼有多重。",		-- 弹簧秤
		TACKLECONTAINER = "钓鱼要用的东西。",		-- 钓具箱
		SUPERTACKLECONTAINER = "可以装下全款钓具。",-- 超级钓具箱

		WAGPUNKBITS_KIT = "修理装置设计得比他的正品要好。",	-- 自动修理机

        ARCHIVE_RESONATOR_ITEM = "指引我走向正确的道路。",-- 星象探测仪(物品)

		-- 星象探测仪(正在生效)
        ARCHIVE_RESONATOR =
	    {
            GENERIC = "在那边。",-- 指出方向
            IDLE = "找到你了。", -- 闲置
        },

		WATERBALLOON = "随身消防员。",-- 水球

		COOKBOOK = "要对知识保持饥饿感。",-- 烹饪指南

		-- 指南针方向
		COMPASS =
		{
			GENERIC="我看看这是那边……",
			N = "这是北向",
			S = "这是南向",
			E = "这是东向",
			W = "这是西向",
			NE = "这是东北方",
			SE = "这是东南方",
			NW = "这是西北方",
			SW = "这是西南方",
		},

		RESKIN_TOOL = "给物品换一个模样。",-- 清洁扫把

        -- 训牛
		BRUSH = "让我的宠物皮毛柔顺一些。",-- 刷子
        SADDLEHORN = "方便拆卸鞍具。",	  -- 鞍角

		SADDLE_BASIC = "为什么不加一个减震装置？。",-- 鞍具
        SADDLE_RACE = "让坐骑如虎添翼。",		   -- 闪亮鞍具
        SADDLE_WAR = "我的移动王座。",		       -- 战争鞍具

		-- 治疗	--------------------------------------------
		HEALINGSALVE = "提供便携医疗。",		-- 治疗药膏
		BANDAGE = "甜蜜的疗法。",               -- 蜂蜜膏药
		TILLWEEDSALVE = "另一种药膏。",		    -- 犁地草膏
		HEALINGSALVE_ACID = "预防酸雨。",	    -- 黏糊糊的药膏
		BEDROLL_STRAW = "我绝对不会用这东西去演出流浪汉！",-- 草席
		BEDROLL_FURRY = "可以当个睡袋。",	     -- 毛皮铺盖

		REVIVER = "原告：爱坡伦。",	-- 告密的心
		LIFEINJECTOR = "完全康复！",-- 强心针

		-- 武器	--------------------------------------------
		SPEAR = "好粗糙的手工。",		        -- 长矛
		HAMBAT = "有点像疯狂艺术家的作品。",     -- 火腿棒
		BATBAT = "使用对吸血蝙蝠的刻板印象制成。",-- 蝙蝠棒
        NIGHTSWORD = "致命的梦魇。",		     -- 暗夜剑
		NIGHTSTICK = "挥霍雷霆之力！",		     -- 晨星锤

		BOOMERANG = "控制起来有难度。",		-- 回旋镖

		BLOWDART_PIPE = "有些粗鲁的原始武器。",-- 吹箭
		BLOWDART_FIRE = "喷吐烈焰！",         -- 火焰吹箭
		BLOWDART_SLEEP = "安眠吻。",          -- 催眠吹箭

		GUNPOWDER = "文明对野蛮的胜利。",		-- 火药
		TRAP_TEETH = "像是人造的猎犬。",		-- 犬牙陷阱
		BEEMINE = "希望它能有点用。",           -- 蜜蜂地雷

		-- 衣物	--------------------------------------------
		-- 防具
		ARMORGRASS = "作为寿衣来说也是最下品。",    -- 草甲
		ARMORMARBLE = "像是城堡，坚固但笨重。",	    -- 大理石甲
		ARMORWOOD = "迫于无奈的临时护具。",		    -- 木甲
		ARMORDRAGONFLY = "屠龙者终成恶龙。",        -- 龙鳞甲
		ARMOR_SANITY = "披夜而行，这才像样。",	    -- 暗夜甲
		FOOTBALLHAT = "……臭烘烘的，但确实坚固。",	-- 橄榄球头盔
		BEEHAT = "BEEHAT其实防御不了BEE-HEAT。",    -- 养蜂帽
		COOKIECUTTERHAT = "内部的尖刺很伤脑筋。",	-- 饼干切割机帽子
		WAGPUNKHAT = "智能装甲，但技术一般。",		-- W.A.R.B.I.S.头戴齿轮
		ARMORWAGPUNK = "智能装甲，技术不如我。",	-- W.A.R.B.I.S.盔甲

		-- 保暖&降温
		STRAWHAT = "我不打算当海贼。",		                -- 草帽
		WINTERHAT = "保暖的帽子。",                         -- 冬帽
		CATCOONHAT = "如果有耳朵，我会交给别人。",           -- 猫帽
		BEEFALOHAT = "我怎么可能会戴上这种东西！",           -- 牛角帽
		EARMUFFSHAT = "我喜欢制作过程中适当的残忍。",		 -- 兔耳罩
		SWEATERVEST = "中世纪流行过这种戎装。",		         -- 犬牙背心
		TRUNKVEST_SUMMER = "如果有的选，我不想穿着它到处跑。",-- 透气背心
		TRUNKVEST_WINTER = "象鼻制作，牛毛填充。",		     -- 松软背心
		BEARGERVEST = "皮草的蹂制水准一般……但好在材料足够名贵。",-- 熊皮背心
		REFLECTIVEVEST = "看起来很清爽。",		            -- 清凉夏装
		HAWAIIANSHIRT = "有点失礼，不过适合沙滩。",          -- 花衬衫
		ICEHAT = "……为什么会有这种傻帽？",		             -- 冰帽
		WATERMELONHAT = "字面意义的傻帽。",		             -- 西瓜帽

		-- 回SAN
		GOGGLESHAT = "有段时间，不谙世事的小姐都崇拜冒险家。",-- 时髦的护目镜
		TOPHAT = "绅士的选择。",		                    -- 高礼帽
		KELPHAT = "黏黏的帽子，谁喜欢戴它？",		         -- 海花环(只有小鱼人沃特回san，其他角色掉san)

		-- 雨具
        RAINCOAT = "触手皮缝的。",	           -- 雨衣
        RAINHAT = "阻挡一部分雨水。",           -- 雨帽
		UMBRELLA = "简单的机械零件加上生物材质。",-- 雨伞
		GRASS_UMBRELLA = "我需要男士款。",		 -- 花伞
		EYEBRELLAHAT =	"无雨望苍天。",		    -- 眼球伞

		-- 特殊功能性
		BUSHHAT = "这么蠢的把戏居然能奏效？",                -- 灌木丛帽
		FEATHERHAT = "那些愚蠢的飞禽会因此错失逃离我的良机。",-- 羽毛帽
        MINERHAT = "工人阶级的东西足够实用……但不够优雅。",	  -- 矿工帽
		MOLEHAT = "感受一下这些小东西的视野。",		         -- 鼹鼠帽
		ARMORSLURPER = "勒紧腰带不适合我这个阶层。",		 -- 饥饿腰带
        MUSHROOMHAT = "嗯……有点黏湿。",		            -- 蘑菇帽(增加颜色/moon前缀为对应的蘑菇帽)
		ANTLIONHAT = "现在，可以改写这个世界了。",	         -- 刮地皮头盔
		DESERTHAT = "在沙尘暴中能保持视野。",		         -- 沙漠护目镜
		MOONSTORM_GOGGLESHAT = "我非常怀疑一个使用土豆电池的东西。",-- 星象护目镜

		-- 建筑	--------------------------------------------
		-- 营火(临时火堆)
		CAMPFIRE =
		{
			EMBERS = "需要燃料来燃烧。",
			GENERIC = "驱散黑暗。",
			HIGH = "燃料太过充足导致的。",
			LOW = "火势已弱。",
			NORMAL = "恰到好处的温和。",
			OUT = "火光败给黑夜了。",
		},

        -- 吸热营火(临时冷火堆)
		COLDFIRE =
		{
			EMBERS = "需要燃料来燃烧……虽然它是冷的。",
			GENERIC = "驱散黑暗和灼热。",
			HIGH = "小规模的冰天雪地！",
			LOW = "冷气已经减弱了。",
			NORMAL = "恰到好处的凉爽。",
			OUT = "冷气失效。南风和太阳又一次要开始暴政了。",
		},

		-- 火坑(石头火堆)
		FIREPIT =
		{
			EMBERS = "急需一些燃料来延续那风中残烛。",-- 即将熄灭
			GENER = "有冒险者的感觉了。",
			HIGH = "比火山差在没有硫磺的味道。",-- 最大火焰
			LOW = "已是风中残烛。",		-- 最小火焰
			NORMAL = "舒适而温暖。",	-- 中火
			OUT = "黑暗涌进来了！",		-- 熄灭
		},

		-- 冷火坑(冰冷石头火堆)
		COLDFIREPIT =
		{
			EMBERS = "马上就要失去作用了。",
			GENERIC = "冰冷的火焰。",
			HIGH = "微型凛冬。",
			LOW = "冷气已经减弱了。",
			NORMAL = "舒适的冷气。",
			OUT = "冷气失效。南风和太阳又一次要开始暴政了。",
		},

        NIGHTLIGHT = "使用噩梦点燃。",-- 暗夜灯

		-- 低微咩咩雕像
		COTL_TABERNACLE_LEVEL1 =
		{
			LIT = "照亮了它的简陋。",-- 有火状态
			GENERIC = "简陋的玩意。",
		},

		-- 有所改进咩咩雕像
		COTL_TABERNACLE_LEVEL2 =
		{
			LIT = "在火光下还差点意思。",
			GENERIC = "它还能精益求精。",
		},

		-- 完美无瑕咩咩雕像
		COTL_TABERNACLE_LEVEL3 =
		{
			LIT = "看起来像个艺术品了。",
			GENERIC = "我认得那头羊！",
		},

		ROPE_BRIDGE_KIT = "凡人无法脚踏虚空的补偿。",    --  洞穴探险者的桥梁套件

		-- 箱子
		TREASURECHEST =
		{
			GEN = "储物空间不大。",
			BURNT = "烈火的罪证。",-- 烧毁
			UPGRADED_STACKSIZE = "得到了一个数量级的改进。",-- 升级后
		},

		-- 龙鳞宝箱
		DRAGONFLYCHEST =
		{
			GENERIC = "像一头火龙在守护财宝。",
			UPGRADED_STACKSIZE = "它提供的储存空间可谓是箱中之龙！",-- 升级后
		},

		-- 龙鳞火炉
		DRAGONFLYFURNACE =
		{
			HAMMERED = "已经快坏掉了。", -- 被锤了
			GENERIC = "足够炽热，可惜不够闪亮。",
			NORMAL = "我居然觉得它像一颗龙头？",
			HIGH = "火力充足！",        -- 猛火
		},

		--  石桌
        STONE_TABLE =
        {
            GENERIC = "稍显原始。",    --  没东西
            HAS_ITEM = "朴素的展台。", --  放了东西
        },

		--  石椅
        STONE_CHAIR =
        {
            GENERIC = "我更欣赏铁王座。",  -- 无人
            OCCUPIED = "我有自己的王座。", --  有人
        },

		-- 避雷针
		LIGHTNING_ROD =
		{
			CHARGED = "带有充沛的电力。",-- 充能
			GENERIC = "现在，天罚奈我何？",
		},

		-- 木牌
		HOMESIGN =
		{
			GENER = "算是一种草稿？",
            UNWRITTEN = "该写什么呢？",		-- 没有写字
			BURNT = "烈火的书法有点潦草。",	 -- 烧毁
		},

		MINISIGN_ITEM = "一小块画板。",-- 小木牌

		-- 指路木牌
		ARROWSIGN_POST =
		{
			GENERIC = "指向前方。",
            UNWRITTEN = "指向何方？",		-- 没有写字
			BURNT = "火焰不建议向那儿走。",	 -- 烧毁
		},

		-- 指路木牌
		ARROWSIGN_PANEL =
		{
			GENERIC = "指向前方。",
            UNWRITTEN = "指向何方？",		-- 没有写字
			BURNT = "火焰不建议向那儿走。",	 -- 烧毁
		},

		-- 鸟笼
		BIRDCAGE =
		{
			GENERIC = "装扮精美的囚笼。",		          -- 空笼子
			OCCUPIED = "我的囚徒正在苦中作乐。",		   -- 放入鸟正常清醒
			SLEEPING = "梦里它可能还在自由飞翔。",		   -- 鸟在睡眠
			HUNGRY = "它在忍受饥饿的折磨。",               -- 鸟开始饥饿
			STARVING = "死亡紧随饥饿正在逼近它。",		   -- 鸟快要饿死
			DEAD = "它被囚笼折断了灵魂。",		           -- 鸟饿死
			SKELETON = "一个可怜可悲的故事最后剩下的东西。",-- 鸟死后残余物
		},

        -- 这些鸟类资源基本上都是靠鸟笼的功能实现的，所以列在此处
        GUANO = "那些贵妇人热衷用这个给鲜花施肥。",-- 鸟粪
		BIRD_EGG = "蛋糕的原料。",               -- 鸟蛋
		BIRD_EGG_COOKED = "粗劣的加工。",        -- 煎蛋
		ROTTENEGG = "可以做一些土制炸药。",		  -- 腐烂鸟蛋

		ICEBOX = "使用机械制冷。",-- 冰箱
		SALTBOX = "盐分隔绝了细菌。",-- 盐盒

		-- 烹饪锅
		COOKPOT =
		{
			EMPTY = "只需要放进去食材，剩下的交给它。",-- 空的正常状态，也即对建筑物的检查对话
			-- 正在烹饪：
			COOKING_LONG = "美食佳肴需要耐心等待。",  -- 需要较长时间
			COOKING_SHORT = "看起来马上就好。",       -- 很快出锅
			DONE = "已经可以享用了。",               -- 料理已经完成
			BURNT = "这算火锅吗？",                  -- 烧毁状态
		},

		-- 灭火器
		FIRESUPPRESSOR =
		{
			ON = "开始围剿失控的火焰！",            -- 开机
			OFF = "虽然关机了，但是仍然能检测周围。",-- 关机
			LOWFUEL = "缺失让它动起来的能量。",     -- 燃料不足
		},

		-- 科学机器
		RESEARCHLAB =
		{
			GENERIC = "能够稍微地促进我的智慧。",
			BURNT = "烈火摧毁了文明。",
		},

		-- 炼金引擎
		RESEARCHLAB2 =
		{
			GENERIC = "我有个更好的引擎。",
			BURNT = "炼金术要注意火候。",
		},

		-- 暗影操控仪
		RESEARCHLAB3 =
		{
			GENERIC = "支配暗影！",
			BURNT = "火光驱散了暗影。",
		},

		-- 灵子分解器
		RESEARCHLAB4 =
		{
			GENERIC = "基本的灵子再锻工具，魔术师的把戏。",
			BURNT = "那只兔子呢？",
		},

		-- 肉块雕像
		RESURRECTIONSTATUE =
		{
			GENERIC = "生命的备份。",
			BURNT = "被火焰断了后路。",
		},

	    WALL_SCRAP = "它是用垃圾做的。",	 -- 废料墙(建筑)
		WALL_SCRAP_ITEM = "捆绑包装的垃圾。",-- 废料墙(物品)

        -- 草墙(建筑)
		WALL_HAY =
		{
			GENERIC = "我以为那三只猪已经留下前车之鉴了。",
			BURNT = "弱不禁风，更不经火。",
		},
		WALL_HAY_ITEM = "像是一个玩笑。",-- 草墙(物品形式)

	    -- 木墙(建筑)
		WALL_WOOD =
		{
			GENERIC = "简单的城防措施。",
			BURNT = "木制品的宿命。",
		},
		WALL_WOOD_ITEM = "可以当拒马，但这里好像没有骑兵。",-- 木墙(物品)

		WALL_STONE = "堡垒总由它们构成，不是吗？", -- 石墙(建筑)
		WALL_STONE_ITEM = "该寻址建造我的城堡了。",-- 石墙(物品)

		WALL_RUINS = "固若金汤。",		            -- 铥墙(建筑)
		WALL_RUINS_ITEM = "这种神奇的矿物足够坚固。",-- 铥墙(物品)

		WALL_MOONROCK = "“祂”的力量会庇护这里。",          -- 月岩墙(建筑)
		WALL_MOONROCK_ITEM = "用“祂”的外壳制成，足够坚韧。",-- 月岩墙(物品)

		-- 衣柜
		WARDROBE =
		{
			GENERIC = "换身行头。",
            BURNING = "这换装邀请太过“热情”了。",		-- 正在燃烧
			BURNT = "还好里面的服装在另一个空间。",		-- 烧毁
		},

		-- 温度计
		WINTEROMETER =
		{
			GENERIC = "测量温度。",
			BURNT = "“火热”。",
		},

		-- 雨量计
		RAINOMETER =
		{
			GENERIC = "检测降雨量。",
			BURNT = "显示为火雨。",
		},

		-- 帐篷
		TENT =
		{
			GENERIC = "至少睡眠时不能让“祂”再看着了。",
			BURNT = "已经烧没了。",
		},

		-- 遮阳棚
		SIESTAHUT =
		{
			GENERIC = "至少能遮蔽烈日。",
			BURNT = "高温在干净杀绝。",
		},


		PUNCHINGBAG = "虐待这个没什么意思。",              -- 拳击袋
		PUNCHINGBAG_LUNAR = "让我实验下月光使徒的忍耐力。",-- 明亮拳击袋
		PUNCHINGBAG_SHADOW = "让我测试下暗影的承受力。",   -- 暗影拳击袋

		-- 友善的稻草人
		SCARECROW =
		{
		 GENERIC = "会招来金丝雀。",
		 BURNING = "它的热情不敌烈焰。",-- 正在燃烧
		 BURNT = "烈火燃尽了它的身躯。",-- 烧毁
		},

        -- 陶轮
		SCULPTINGTABLE=
		{
		 EMPTY = "模仿一下米开朗基罗？",
		 BLOCK = "要雕刻什么？",		  -- 刚放好原料
		 SCULPTURE = "该找个地方布置它。",-- 雕像完成
		 BURNT = "这地方用不了了。",	  -- 烧毁
		},

		-- 制图桌
		CARTOGRAPHYDESK =
		{
			GENERIC = "来绘制我的疆土。",
			BURNING = "毁于一旦。",
			BURNT = "现在就只有灰烬了。",
		},

        -- 蜂箱
		BEEBOX =
		{
			READY = "蜜蜂们准备好祭品了。",
			NOHONEY = "什么都没有。",
			SOMEHONEY = "蜜蜂们还没准备好贡品。",  -- 有少量蜂蜜
			FULLHONEY = "蜜蜂们准备好贡品了。",    -- 当蜂蜜满了
			GENERIC = "蜜蜂们在这里向我献祭蜂蜜。", -- 默认
			BURNT = "烈火摧毁了它们。",            -- 烧毁
		},

		-- 蘑菇农场
		MUSHROOM_FARM =
		{
			STUFFED = "该收获了！",		     -- 长满了
			LOTS = "已经可以收获了。",	      -- 很多
			SOME = "现在它应该继续生长。",	   -- 有一些
			EMPTY = "需要一些真菌来开始繁殖。",-- 没有
			ROTTEN = "需要一根有生命力的木头。",-- 枯萎-- 需要活木
			BURNT = "真菌惧火。",		    -- 烧焦的
			SNOWCOVERED = "冰雪打败了菌类。",-- 被雪覆盖
		},

		-- 晾肉架
        MEATRACK =
        {
            DONE = "肉干晾好了。",		      -- 风干完
            DRYING = "正在制作肉干。",		   -- 正在风干
            DRYINGINRAIN = "雨天让这功亏一篑。",-- 雨天风干
            GENERIC = "晾肉的东西。",		   -- 空的
            BURNT = "上面的肉也没有了。",	    -- 烧毁
			-- 非肉类物品
            DONE_NOTMEAT = "已经晾制完毕。",	-- 完成风干
            DRYING_NOTMEAT = "还需要时间。",	-- 正在风干
            DRYINGINRAIN_NOTMEAT = "雨水又让它恢复湿润了。", -- 下雨期间
        },

		SALTLICK = "吸引那些愚蠢的动物。",   -- 舔盐块
		SALTLTCK_IMPROVED = "好歹是真的盐。",-- 美味舔盐块

       -- 月晷
	   MOONDIAL =
	   {
		GENERIC = "采用倒映法来观测“祂”更为保险。",
		NIGHT_NEW = "新月，“祂”还没转身。",     -- 新月
		NIGHT_WAX = "上弦月，“祂”快看过来了。",	-- 上弦月
		NIGHT_FULL = "满月，“祂”正注视着一切！",-- 满月
		NIGHT_WANE = "下弦月，“祂”移走了目光。",-- 下弦月
		CAVE = "这是“祂”不能触及的领域。",		-- 洞穴
		GLASSED = "它追逐月光的脚步。",
	   },

	   SUPPORT_PILLAR_SCAFFOLD = "这只是个轮廓。",               -- 支柱脚手架
	   SUPPORT_PILLAR = "能够支撑稳定。",  		                 -- 支柱
	   SUPPORT_PILLAR_COMPLETE = "稍微稳固一点了，但不是长久的。",-- 加固支柱
	   SUPPORT_PILLAR_BROKEN = "它倒下了，需要石头来修。",		  -- 支柱瓦砾

        -- 沙之石
	    TOWNPORTALTALISMAN =
	    {
		    GENERIC = "蚁狮的力量结晶。",
		    ACTIVE  = "在散发一种扭曲空间的波动……",-- 激活
	    },

	    -- 懒人传送塔
	    TOWNPORTAL =
	    {
		    GENERIC = "基于那只蚁狮的力量运作。",
		    ACTIVE = "需要一块沙之石来扭曲空间。",-- 激活状态
	    },

		TURFCRAFTINGSTATION = "盖亚的权柄。",-- 土地夯实器

        -- 耕种	--------------------------------------------
		-- 堆肥桶
        COMPOSTINGBIN =
        {
            GENERIC = "把食物变成食物的食物。",
            WET = "加点干草进去？",
            DRY = "可以直接放点水吗？",
            BALANCED = "现在的状态刚刚好。",
            BURNT = "作物失去了堆肥。",		-- 烧毁
        },

        COMPOST = "我不要摸这个！",		-- 堆肥

		-- 催长剂起子
        SOIL_AMENDER =
		{
			GENERIC = "细菌最有用的一次。",
			STALE = "长时间的发酵让它变得更富有养分了。",  -- 过期
			SPOILED = "长时间的发酵让它变得更富有养分了。",-- 腐烂
		},

		SOIL_AMENDER_FERMENTED = "长时间的发酵让它变得更富有养分了。",-- 超级催长剂

		-- 浇水壶
        WATERINGCAN =
        {
            GENERIC = "作物的专用饮水机。",
            EMPTY = "需要装满。",
        },

		-- 鸟嘴壶
        PREMIUMWATERINGCAN =
        {
            GENERIC = "更好的灌溉技术。",
            EMPTY = "需要装满。",
        },

		FARM_PLOW = "正在工作。",		-- 耕地机(运作)
		FARM_PLOW_ITEM = "半自动农奴。",-- 耕地机(物品)

		PLANTREGISTRYHAT = "只是记录一些植物，这不算难对吧？",-- 耕作先驱帽
		NUTRIENTSGOGGLESHAT = "现在我变成植物学家了？",		 -- 高级耕作先驱帽
		-- 高级耕作先驱帽其实是远古科技，方便起见暂时置于这里

        VEGGIE_OVERSIZED_ROTTEN = "农民的攀比舞台。",-- 农产品秤

		-- 农产品秤检查
		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "在等一个巨无霸。",
			HAS_ITEM = "重量: {weight}\n收获日: {day}\n不错的个头。",
			HAS_ITEM_HEAVY = "重量: {weight}\n收获日: {day}\n是个真正的巨头!",
            HAS_ITEM_LIGHT = "它不适合这个舞台。",
			BURNING = "火焰在进餐。",		-- 正在燃烧
			BURNT = "重量为0,收获自烈火。"		-- 烧焦的
        },

        SEEDPOUCH = "装种子的。",		-- 种子袋

        -- 航海	--------------------------------------------
		-- 智囊团
		SEAFARING_PROTOTYPER =
		{
			GENERIC = "《海权论》的忠实信徒。",
			BURNT = "看来对海的信仰不能灭火。",
		},

		OAR = "为什么不用螺旋桨？",		        -- 桨
		OAR_DRIFTWOOD = "比一般的木头轻便一些。",-- 浮木桨

		BOATPATCH = "修好一个漏洞。",-- 船补丁
		TREEGROWTHSOLUTION = "它给了树木前所未有的能量。",-- 树果酱

		BOAT_LEAK = "这不妙……",    -- 船上漏洞

        BOAT_GRASS = "权宜之计。",     -- 草筏
		WALKINGPLANK_GRASS = "如果可以我不会想用到它。",-- 草船的楼梯
		BOAT_GRASS_ITEM = "不能借炮。",-- 草筏套装

		BOAT = "是时候征服海洋了。",  -- 木船
		WALKINGPLANK = "如果可以我不会想用到它。",-- 木船的楼梯
		BOAT_ITEM = "找个港口出海。", -- 木船套装

		MASTUPGRADE_LAMP = "得用火魔杖才能添加燃料。",-- 甲板照明灯(安装)
        MASTUPGRADE_LAMP_ITEM = "装在桅杆上。",		 -- 甲板照明灯(物品)

        MASTUPGRADE_LIGHTNINGROD = "让雷暴无能狂怒。",     -- 避雷导线(安装)
        MASTUPGRADE_LIGHTNINGROD_ITEM = "让雷暴无能狂怒。",-- 避雷导线(物品)

        WATERPUMP = "随船消防员。",		-- 消防泵

		STEERINGWHEEL = "掌控航行的方向。",		-- 方向舵
        STEERINGWHEEL_ITEM = "大海航行靠舵手。",-- 方向舵套装

        ANCHOR = "让船停稳。",		-- 锚
		ANCHOR_ITEM = "海上刹车。",	-- 锚套装

        MAST = "可以扬帆远航了。",	-- 桅杆
        MAST_ITEM = "技术的进步。", -- 桅杆套装

        MAST_MALBATROSS_ITEM = "完美的利用了那些羽毛的特性。",-- 飞翼风帆套装
        MAST_MALBATROSS = "展开就像飞起来一样。",		     -- 飞翼风帆

		BOAT_ROTATOR = "能让大饼船灵活一点。就一点，",	  -- 转向舵
        BOAT_ROTATOR_KIT = "能让大饼船灵活一点。就一点，",-- 转向舵套装

        BOAT_BUMPER_KELP = "这能保护的了什么？",    -- 海带保险杠
        BOAT_BUMPER_KELP_KIT = "下一秒就该散架了。",-- 海带保险杠套装

		BOAT_BUMPER_SHELL = "希望这些生物钙质足够坚固。",	 -- 贝壳保险杠
        BOAT_BUMPER_SHELL_KIT = "希望这些生物钙质足够坚固。",-- 贝壳保险杠套装

		FISH_BOX = "里面的环境能让鱼恢复活力。",-- 锡鱼罐

		-- 夹夹绞盘
		WINCH =
		{
			GENERIC = "深入海底获取物品。",
			RETRIEVING_ITEM = "深入海底获取物品。",-- 物品形态(未安放)
			HOLDING_ITEM = "捞上来了。",
		},

        -- 大炮
        BOAT_CANNON =
	    {
            GENERIC = "我想要更强的火力。",
            AMMOLOADED = "这就是真理！",
            NOAMMO = "缺乏弹药。",		-- 没有弹药
        },

        BOAT_CANNON_KIT = "终于迈进到大航海时代了。",-- 大炮套装
        CANNONBALL_ROCK_ITEM = "老式实弹。",		-- 炮弹

		-- 海洋拖网捕鱼器
		OCEAN_TRAWLER =
	    {
            GENERIC = "至少是半自动化的。",
            LOWERED = "它在工作了。",
            CAUGHT = "已经有收获了。",
            ESCAPED = "网破鱼未死。",
            FIXED = "修好了。",
        },

        OCEAN_TRAWLER_KIT = "渔民的经典手艺。",-- 海洋拖网捕鱼器套装

		-- 自动航行仪
		BOAT_MAGNET =
        {
            GENERIC = "使用简单的电磁原理。",
            ACTIVATED = "磁力消失了。",
        },

		BOAT_MAGNET_KIT = "比想象中有用。",-- 自动航行仪套装

		-- 自动航行灯塔
		BOAT_MAGNET_BEACON =
        {
            GENERIC = "一定程度上解放自我。",
            ACTIVATED = "正在导航。",		-- 激活
        },

        DOCK_KIT = "这才叫征服海洋！",		         -- 码头套装
        DOCK_WOODPOSTS_ITEM = "总得装几个意思意思。",-- 码头桩

		-- 装饰	--------------------------------------------
		-- 注：地皮和雕像因为数量过多
		--     所以记录在杂物-玩家制作一栏
		--     Ctrl+F搜索“地皮”/“雕塑”即可
		FENCE_ROTATOR = "园丁的武器。",		-- 栅栏击剑
		PUMPKIN_LANTERN = "笑得再阴森点，杰克。",-- 南瓜灯
		FEATHERPENCIL = "感觉又回到了中世纪。",	-- 羽毛笔

		FENCE = "一种田园风格的装饰物。",	 -- 木栅栏(建筑)
        FENCE_ITEM = "它的实用性仅限装饰。", -- 木栅栏(物品)

        FENCE_GATE = "增添一下进出的仪式感。",-- 木门(建筑)
        FENCE_GATE_ITEM = "聊胜于无。",		 -- 木门

		POTTEDFERN = "带来一点地穴的空气。",	-- 蕨类盆栽
        SUCCULENT_POTTED = "在中世纪时更流行。",-- 多肉盆栽

        -- 假人
	    SEWING_MANNEQUIN =
	    {
		    GENERIC = "粗糙的模特。",
		    BURNT = "热烈的装扮是有代价的。",
	    },

		-- 蘑菇灯
		MUSHROOM_LIGHT =
		{
			ON = "想不到这张皮能让光线如此闪耀。",-- 开灯
			OFF = "基于科学……和炼金术制作。",	 -- 关灯
			BURNT = "菌子的命运。",             -- 烧毁
		},

		-- 菌伞灯
		MUSHROOM_LIGHT2 =
		{
			ON = "想不到这张皮能让光线如此闪耀。",-- 开灯
			OFF = "基于科学……和炼金术制作。",	 -- 关灯
			BURNT = "菌子的命运。",             -- 烧毁
		},

		-- 鱼类计重器
		TROPHYSCALE_FISH =
		{
			GENERIC = "放条鱼进去。",		-- 空的
			BURNING = "里面的水都快沸腾了。",-- 正在燃烧
			BURNT = "水蒸干了，鱼也没有了。",-- 烧毁
			-- 具体情况未明
			HAS_ITEM = "重量: {weight}\n捕获人: {owner}\n它不够重。",		 --
			HAS_ITEM_HEAVY = "重量: {weight}\n捕获人: {owner}\n是一条大鱼。",--
			OWNER = "重量: {weight}\n捕获人: {owner}\n一条大鱼！",		  --
			OWNER_HEAVY = "重量: {weight}\n捕获人: {owner}\n是一条大鱼。",--
		},

        -- 锯马
	    CARPENTRY_STATION =
	    {
		    GENERIC = "我需要一个木匠。",
		    BURNT = "烈火摧毁了它。",
	    },

	    -- 木椅
	    WOOD_CHAIR =
	    {
		    GENERIC = "暂时歇歇脚。",
		    OCCUPIED = "我有自己的王座。",-- 有人
		    BURNT = "再做一个吧。",
	    },

	    DECOR_CENTERPIECE = "不是什么大师之作。",-- 艺术？(名字就代问号，锯马制作的一个装饰)

	    DECOR_LAMP = "让晚餐更精致。",-- 餐桌灯

        -- 餐桌花瓶
	    DECOR_FLOWERVASE =
	    {
		    GENERIC = "放上鲜花。",
		    EMPTY = "只待鲜花。",         -- 空的
		    WILTED = "需要一朵新鲜的娇花。",-- 枯萎
		    FRESHLIGHT = "令人眼前一亮。",-- 发光(新鲜)
		    OLDLIGHT = "该换新的了。",	  -- 发光(不新鲜)
	    },

        -- 空画框
	    DECOR_PICTUREFRAME =
	    {
		    GENERIC = "画框。",
		    UNDRAWN = "我需要一副名画。",
	    },

	    DECOR_PORTRAITFRAME = "嗯……也许愉快有些过量？",-- 愉快画像

	    PHONOGRAPH = "该换碟了。",		-- 留声机

	    RECORD = "希望有些真正的音乐。", -- 唱片

	    -- 唱片
	    RECORD_CREEPYFOREST = "像是一个失散的探险队员。",-- 惊悚森林
	    RECORD_DANGER = "有人会被这个吓一跳的。",
	    RECORD_DAWN = "空的。",
	    RECORD_DRSTYLE = "我不喜欢这个风格。",-- D.R.风格
	    RECORD_DUSK = "明月的感觉。",
	    RECORD_EFS = "这个风格谁更喜欢？",-- E.F.S.
	    RECORD_END = "再见。",
	    RECORD_MAIN = "需要一些真正的艺术。",
	    RECORD_WORKTOBEDONE = "正在装裱。",

 	--------------------------------------------------------------------------------------------------------
	---------- 远古科技和宝石魔法相关---------------------------------------------
		ANCIENT_ALTAR = "一个远古文明的精粹。",		-- 远古伪科学站
        ANCIENT_ALTAR_BROKEN = "我该想办法修好它。",-- 损坏的远古伪科学站

		THULECITE_PIECES = "有些小零件可能需要这个。",		-- 铥矿碎片
		THULECITE = "一种能完美承载和传导暗影力量的神奇矿物！",-- 铥矿

		MULTITOOL_AXE_PICKAXE = "能够胜任高强度的特殊开采。",-- 多用斧镐
		RUINS_BAT = "能召唤暗影的力量鞭挞敌人。",            -- 铥矿棒
		RUINSHAT = "内置暗影结界1.14版本。",	             -- 铥矿皇冠
		ARMORRUINS = "我原本准备内置5.14版本的暗影结界来着。",-- 铥矿甲

		EYETURRET = "该说不说，配色像长颈鹿。",		-- 眼睛炮塔
		EYETURRET_ITEM = "我为它添加了镭射功能以符合对大只独眼的刻板印象。",-- 眼睛炮塔(物品)

		-- 铥矿徽章
		SLURPERPELT = "一块完整的讨厌鬼皮毛。",-- 物品
        -- 暗影暴动不同阶段的台词
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "现在是平静期",		        -- 平静
            WARN = "暗影的力量开始躁动了。",	-- 暴乱1
            WAXING = "暗影的力量在沸腾！",		-- 暴乱2
            STEADY = "现在是能量最狂暴的时刻！",-- 暴乱3
            WANING = "这种能量暴动开始衰弱了。",-- 暴乱2
            DAWN = "暗影再度平息。",		    -- 暴乱1
            NOMAGIC = "这里探测不到什么能量。",	 -- 正常
		},

        THULECITEBUGNET = "是否有点小题大做了？", --  铥矿捕虫网

	-----宝石魔法
		BLUEGEM = "凛冬的结晶。",                     -- 蓝宝石
		REDGEM = "里面闪烁着火光。",		          -- 红宝石
		PURPLEGEM = "能够承载暗影力量的深邃宝石。",		-- 紫宝石
		YELLOWGEM = "蕴有星光的美妙宝石。",		       -- 黄宝石
		ORANGEGEM = "能与空间共振的奇异宝石。",		    -- 橙宝石
		GREENGEM = "它内里的奥秘似乎能够扭曲现实……",	-- 绿宝石
        OPALPRECIOUSGEM = "绚丽而蕴藏伟力，完美珍品！",	-- 彩虹宝石

		BLUEAMULET = "随身凛冬。",                           -- 寒冰护符
		AMULET = "红宝石的生命力能打开死亡的囚笼。",	       -- 重生护符
        PURPLEAMULET = "深入噩梦。",		                 -- 梦魇护符
		YELLOWAMULET = "魔力的光辉能让人脚步轻快。",           -- 魔光护符
		ORANGEAMULET = "缺一点智能技术。奴役一个苦力似乎更妙。",-- 懒人护符
		GREENAMULET = "修改现实，由少变多。",		          -- 建造护符

		ICESTAFF = "不许“冻”。",		    -- 冰魔杖
		FIRESTAFF = "烈火听我号令！",        -- 火魔杖
		ORANGESTAFF = "舒服。",		        -- 懒人魔杖
		GREENSTAFF = "撤销制作。",		     -- 拆解魔杖
		YELLOWSTAFF = "点燃一颗星辰吧！",     -- 唤星者魔杖
        OPALSTAFF = "现在可以与皓月争辉了。", -- 唤月者魔杖

		STAFFLIGHT = "一小颗迷你星辰。",        -- 矮星
        STAFFCOLDLIGHT = "用“祂”的力量创造。",	-- 极光

		TELESTAFF = "用来把东西送走。",		    -- 传送魔杖

		-- 传送焦点
        TELEBASE =
		{
			VALID = "空间坐标已锁定。",		          -- 有紫宝石
			GEMS = "需要紫宝石的能量才能锁定空间坐标。",-- 缺少紫宝石
		},

		-- 紫宝石基座
		GEMSOCKET =
		{
			VALID = "空间坐标校准完成。",		-- 有紫宝石
			GEMS = "它要一颗紫色宝石。",		-- 缺少紫宝石
		},

	------ 暗影术基座
	    ARMORDREADSTONE = "它能吸收理智来自我修复。",-- 绝望石盔甲
		DREADSTONEHAT = "它能吸收理智来自我修复。",	 -- 绝望石头盔

		VOIDCLOTH = "有趣，这之下连通着虚空。",-- 暗影碎布

		SHADOW_FORGE = "更精密地编织暗影。",           -- 暗影术基座
		SHADOW_FORGE_KIT = "需要一个能深入暗影的地方。",-- 暗影术基座套装

		BEESWAX_SPRAY = "将植物的时光凝结。",-- 防腐喷雾
		WAXED_PLANT = "它被冻结在了恐惧中！", -- 被防腐喷雾喷过的植物

		VOIDCLOTH_KIT = "暗影补丁。",		-- 虚空修补套件
		VOIDCLOTHHAT = "感受虚空的视界……",	 -- 虚空风帽
		ARMOR_VOIDCLOTH = "享受虚空的庇护。",-- 虚空长袍

		VOIDCLOTH_UMBRELLA = "这才是配得上我的高档雨具。",-- 暗影伞
		VOIDCLOTH_SCYTHE = "它能够收割生命……所有的。",	  -- 暗影收割者

		SHADOW_BEEF_BELL = "为我的坐骑签署一份保险。",   --  暗影牛铃
		SADDLE_SHADOW = "登上我的移动王座。",            --  梦魇鞍具
		SHADOW_BATTLEAXE = "它在渴望着足够分量的头颅。", --  暗影槌
		VOIDCLOTH_BOOMERANG = "颇有意趣的追猎武器。",    --  阴郁回旋镖

        GELBLOB_BOTTLE = "看起来脱离了主体的部分攻击性有所下降。", --  恶液瓶
		GELBLOB_STORAGE_KIT = "看起来更像是垃圾桶。",             --  恶液储存箱套件
		--  恶液储物箱
        GELBLOB_STORAGE = {
            GENERIC  = "它还在无意识地蠕动……",            --  没东西
            FULL = "究竟是什么鬼才会想到用这个来储存食物？", --  有东西
        },

		WALL_DREADSTONE = "能够催生绝望以自我修复。",                   -- 绝望石墙(建筑)
		WALL_DREADSTONE_ITEM = "像是令人绝望的现实一样狰狞而坚不可摧。", -- 绝望石墙(物品)

		SUPPORT_PILLAR_DREADSTONE_SCAFFOLD = "有些奢侈，但足够坚不可摧。",-- 绝望石支柱脚手架
		SUPPORT_PILLAR_DREADSTONE = "还需要更多绝望石。",		        -- 绝望石支柱
		SUPPORT_PILLAR_DREADSTONE_COMPLETE = "堪称坚不可摧！",		    -- 强化绝望石支柱
		SUPPORT_PILLAR_DREADSTONE_BROKEN = "不可思议。",		        -- 绝望石支柱瓦砾

---------- 天体科技相关	-------------------------------------------
    ------ 天体科技
        MOONROCKSEED = "可以从中得到月的智慧。",	-- 天体宝球

        MOONGLASS = "如同凝固的月光。",	       -- 月亮碎片
        MOONGLASS_CHARGED = "月光为它注能了。",-- 注能月亮碎片

		MOONGLASSAXE = "至锐易折。",-- 月光玻璃斧
		GLASSCUTTER = "至锐易折。",-- 玻璃刀
        CARPENTRY_BLADE_MOONGLASS = "削铁如泥。为什么不拿这个做武器？", --  月光玻璃锯片

        MOONROCKIDOL = "让我体验一下凡人的人生……",	-- 月岩雕像

		-- 沐浴球
		BATHBOMB =
		{
			GLASSED = "现在已经长满了月的碎片了。",-- 温泉内是玻璃结晶
			ALREADY_BOMBED = "这个已经在沸腾了。",-- 温泉已经沸腾
		},

		SENTRYWARD = "让我想起一个患有火山恐惧症的同行。",-- 月眼守卫

    ------ 辉煌锻造台
	    LUNAR_FORGE = "随心所欲地锻造月光。",         -- 辉煌铁匠铺
	    LUNAR_FORGE_KIT = "需要一个能照耀月光的地方。",-- 辉煌铁匠铺套装

		CHESTUPGRADE_STACKSIZE = "扭曲空间的装置。",-- 弹性空间制造器

		LUNARPLANT_KIT = "修复月的力量。",	 -- 亮茄修补套件
		ARMOR_LUNARPLANT = "化身月光骑士。", -- 亮茄盔甲
		LUNARPLANTHAT = "散发着淡淡的光辉。", -- 亮茄头盔
		BOMB_LUNARPLANT = "引爆月能。",		 -- 亮茄炸弹
		STAFF_LUNARPLANT = "释放月的威能！",  -- 亮茄魔杖
		SWORD_LUNARPLANT = "这是……明月之笑?",-- 亮茄剑
		PICKAXE_LUNARPLANT = "用月光粉碎一切。",-- 亮茄粉碎者
		SHOVEL_LUNARPLANT = "高档农艺用具。",	-- 亮茄锄铲

		BROKEN_FORGEDITEM = "它破损了，但是我可以把它修好。",-- 损坏的亮茄装备


	    SECURITY_PULSE_CAGE = "一个完美的能量容器。",	-- 火花柜(未充能)
	    SECURITY_PULSE_CAGE_FULL = "闪烁着奇迹的火花。",-- 火花柜(充能)

		BEARGERFUR_SACK = "在月能的包裹下几乎时间停滞。",-- 极地熊獾桶

		HOUNDSTOOTH_BLOWPIPE = "啸月之弹。",		-- 嚎弹炮

		DEERCLOPSEYEBALL_SENTRYWARD_KIT = "位置要三思。",-- 冰眼结晶器套装

		-- 冰眼结晶器
		DEERCLOPSEYEBALL_SENTRYWARD =
		{
			GENERIC = "入目所见，皓月广寒。",
			NOEYEBALL = "正缺点睛之笔。",  -- 缺失眼球
		},

	-------- 随从与宠物------------------------------------------------------------
		CHESTER = "长腿的箱子，在这个世界还不算疯狂。", -- 切斯特
		-- 切斯特眼骨
		CHESTER_EYEBONE =
		{
			GENERIC = "居然敢凝视我，有趣。",           -- 切斯特存活时
			WAITING = "并不是所有灵魂都有资格与我对视。",-- 切斯特死亡时
		},

        HUTCH = "它会根据肚子里的东西变化形态。",		-- 哈奇

		-- 星空
		HUTCH_FISHBOWL =
        {
            GENERIC = "《警界双雄》？",
            WAITING = "它暂时不能仰望星空了。",-- 需要等待
        },

		-- 格罗姆
        GLOMMER =
        {
            GENERIC = "以这个世界的风格而言，非常具有观赏性。",
            SLEEPING = "奇怪，它在“月”圆时就不睡觉。",
        },

		-- 格罗姆花
		GLOMMERFLOWER =
        {
            GENERIC = "独特的花香会吸引那只虫子。",
            DEAD = "会欣赏它的灵魂已经不在了。",  -- 格罗姆死亡时
        },
        GLOMMERWINGS = "或许能充当神秘学的材料。",-- 格罗姆翅膀
        GLOMMERFUEL = "有非常特殊的化学成分。",	  -- 格罗姆黏液

		-- 格罗姆雕像
		STATUEGLOMMER =
		{
			GENERIC = "《大卫》的拙劣模仿者。",-- 完整
			EMPTY = "它已经贡献了所有的大理石。",-- 开采后
		},

		-- 瓦器人
		STORAGE_ROBOT =
		{
			GENERIC = "勤劳的机械奴仆。",
			BROKEN = "还没修好的机械奴仆。",-- 损坏
		},

        POLLY_ROGERSHAT = "伟大的船长总该有只鹦鹉，不是吗。",	-- 波莉·罗杰的帽子
        POLLY_ROGERS = "训练有素的二副。",						-- 波莉·罗杰

        FRIENDLYFRUITFLY = "我该叫它别西卜还是亚巴顿？", -- 友好果蝇
        FRUITFLYFRUIT = "嗯……令人联想到田园的气息。",		-- 友好果蝇果

		-- 孵化中的高脚鸟蛋
		TALLBIRDEGG_CRACKED =
		{
			COLD = "它快冻成冰块了。",		-- 过冷
			HOT = "它已经热的快熟了。",		-- 过热
			GENERIC = "正适宜的温度有助于它破壳。",
			LONG = "保持耐心……或者找个苦力代工……",-- 还需要很久
			SHORT = "小家伙快出世了。",		       -- 很快孵化完
		},

		-- 小高脚鸟
		SMALLBIRD =
		{
			GENERIC = "小东西以为我会照顾它。",	-- 跟随
			HUNGRY = "它开始饿了。",		   -- 开始饥饿
			STARVING = "饥饿即将招来它的死亡。",-- 过度饥饿
			SLEEPING = "它枕着自己的羽毛入梦。",-- 睡眠
		},

		-- 青年高脚鸟
		TEENBIRD =
		{
			GENERIC = "小东西以为我会照顾它。",	-- 跟随
			HUNGRY = "它开始饿了。",		   -- 开始饥饿
			STARVING = "饥饿即将招来它的死亡。",-- 过度饥饿
			SLEEPING = "它枕着自己的羽毛入梦。",-- 睡眠
		},

        -- 宠物相关
	    CRITTERLAB = "黑暗中有一个渴望主人的灵魂。",-- 岩石巢穴
	    CRITTER_GLOMLING = "有一双水灵灵的大眼睛。",-- 小格罗姆
	    CRITTER_DRAGONLING = "脾气没那么火爆。",   -- 小龙蝇
	    CRITTER_LAMB = "皮毛很柔软。",	           -- 小钢羊
	    CRITTER_PUPPY = "在狩猎时派不上用场。",		-- 小座狼
	    CRITTER_KITTEN = "优雅乖巧。",		       -- 浣猫崽
	    CRITTER_PERDLING = "幼崽总是更乖巧。",		-- 小火鸡
	    CRITTER_LUNARMOTHLING = "能够洒落月华。",	-- 小蛾子
        CRITTER_EYEOFTERROR = "它喜欢这个位面。",	-- 友好窥视者

		-- 超级可爱岩浆虫
		LAVAE_PET =
		{
			STARVING = "它想要吸食灰烬了。",	-- 挨饿
			HUNGRY = "它急需补充热量。",		-- 有点饿了
			CONTENT = "它看起来很快乐。",
			GENERIC = "一团移动的熔浆。",
		},

		-- 岩浆虫卵
		LAVAE_EGG =
		{
			GENERIC = "它需要充足的热量来孵化。"
		},

		-- 孵化中的岩浆虫卵
		LAVAE_EGG_CRACKED =
		{
			COLD = "它的死亡正踏着寒风靠近。",-- 冻伤
			COMFY = "它喜欢那个温度。",		 -- 舒适
		},

		LAVAE_COCOON = "未来的火山败给的极寒。",-- 冷冻虫卵

		LAVAE_TOOTH = "我没注意过它是否真的长着这种牙。",		-- 岩浆虫尖牙

	-------- 资源生物---------------------------------------------------------------------------------
        FLOWER =
		{
            GENERIC = "娇弱而绮丽。",	-- 花
            ROSE = "热烈的红蔷薇。",	-- 玫瑰
        },

		FLOWER_EVIL = "我喜欢它的邪恶。",	   -- 邪恶花
        FLOWER_WITHERED = "失去光明令它憔悴。",-- 枯萎的花

        PETALS = "绚丽依旧。",		    -- 花瓣
        PETALS_EVIL = "还能听得见哀嚎。",-- 深色花瓣

        -- 萤火虫
		FIREFLIES =
		{
			GENERIC = "不错，这些无知的生命实现了取悦我的价值。",
			HELD = "尽管到了我的掌心，它们还在尽力发光。",
		},

		LUREPLANT = "一种使用诱饵的杂食性植物。",-- 食人花
		EYEPLANT = "植质饕餮。",               -- 眼球草
		LUREPLANTBULB = "可以利用。",		   -- 食人花种子

		-- 虫洞
		WORMHOLE =
		{
			GENERIC = "诡异的生物……这东西是生物吗？",
			OPEN = "它在邀请我？",
		},

		SMALLGHOST = "容易解决的执念。",	-- 小惊吓
		GHOSTFLOWER = "蕴藏着思念的力量。",	-- 哀悼荣耀

        WOBSTER_SHELLER = "个头不错。",		-- 龙虾
        WOBSTER_DEN = "它们把卵藏在里面。",	 -- 龙虾窝
        WOBSTER_SHELLER_DEAD = "不能吃了。",-- 死龙虾
        WOBSTER_SHELLER_DEAD_COOKED = "太简单的工艺只是在浪费食材。",-- 美味的龙虾(烤龙虾)

        WOBSTER_MOONGLASS = "月光赋予它闪亮的外壳。",-- 月光龙虾
        MOONGLASS_WOBSTER_DEN = "由月亮碎片构成。", -- 月光玻璃窝

        -- 公牛海带
		BULLKELP_PLANT =
        {
            GENERIC = "海带。",
            PICKED = "没有海带可以摘了。",
        },

		BULLKELP_ROOT = "种在水里，或者拿在手上。",-- 公牛海带茎

        WATERPLANT = "脾气暴躁的海洋之花。",-- 海草
        WATERPLANT_BOMB = "天然的炮弹。",	-- 种壳
        WATERPLANT_BABY = "发芽了。。",		-- 海芽
        WATERPLANT_PLANTER = "海花的种子。",-- 海芽插穗

        -- 海星陷阱(分类为资源生物，懂的都懂)
		TRAP_STARFISH =
        {
            GENERIC = "对一切都满怀恶意的小东西。",
            CLOSED = "它需要一点时间把自己打开。",
        },

        DUG_TRAP_STARFISH = "它的恶意很值得利用！",-- 挖起的海星陷阱

	-------- 生物&掉落物&刷新点&战利品/掉落物------------------------------------------------------------------
    ------ 小动物-----------------------------------------
		-- 蝴蝶
		BUTTERFLY =
		{
			GENERIC = "恋花的飞蝶，脆弱而娇美。",           -- 自然状态
			HELD = "别害怕，你的下一段生命会灿烂如花。", -- 抓到物品栏里
		},

        BUTTERFLYWINGS = "漂亮的食材，适合做点心。",-- 蝴蝶翅膀

		-- 月蛾
        MOONBUTTERFLY =
        {
        	GENERIC = "月光给予了它美丽的翅膀。",
        	HELD = "它真漂亮啊。",
        },
		MOONBUTTERFLYWINGS = "脉络里流淌着月光。",-- 月蛾翅膀

		-- 兔子
		RABBIT =
		{
			GENERIC = "没有贵妇描述的可爱。",
			HELD = "激起了我的施虐欲。",
		},

		-- 兔子洞
		RABBITHOLE =
		{
			GENERIC = "里面还藏着瑟瑟发抖的小东西。",
			SPRING = "潮湿的空气封堵了爱丽丝的门。",-- 春天/雨天塌陷
		},

		-- 鼹鼠
		MOLE =
		{
			HELD = "它的命运在我手中。",-- 物品栏
			UNDERGROUND = "别再偷我的东西了。",-- 钻地
			ABOVEGROUND = "它又出来了，快把东西收起来！",-- 探头
		},

		MOLEHILL = "比它看起来能藏更多东西。",-- 鼹鼠丘

		-- 乌鸦
		CROW =
		{
			GENERIC = "不详的黑鸟。",
			HELD = "现在厄运掌握在我的手中。",
		},
		FEATHER_CROW = "漆黑的羽毛。",-- 黑色羽毛

		-- 红雀
		ROBIN =
		{
			GENERIC = "常见的飞鸟。",
			HELD = "它的命运在我手中。",
		},
		FEATHER_ROBIN = "赤色的羽毛。",-- 红色羽毛

		-- 雪雀
		ROBIN_WINTER =
		{
			GENERIC = "冬天，它们换了衣装。",
			HELD = "看起来很优雅。",
		},
		FEATHER_ROBIN_WINTER = "带有冬日气息的羽毛。",-- 蓝色羽毛

        -- 金丝雀
        CANARY =
		{
			GENERIC = "被稻草人诱骗到的无知生灵。",
			HELD = "完美的笼中鸟。",
		},
		FEATHER_CANARY = "金色的羽毛。",-- 黄色羽毛

		-- 中毒的金丝雀
		CANARY_POISONED = "洞穴里的气压可能会让它爆发四散",

		ROBOT_PUPPET = "It's trapped!",-- 单机遗留，雪雀

		LIGHTCRAB = "它肚子里有一些月光。",-- 发光蟹

		-- 海鹦鹉
        PUFFIN =
        {
            GENERIC = "狡猾的小东西。",
            HELD = "告诉我：你会求饶吗？",
            SLEEPING = "它不说梦话。",
        },

        LIGHTFLIER = "好奇心太重的小东西。",-- 球状光虫

		-- 胡萝卜鼠
		CARRAT =
        {
        	DEAD = "它回归了植物界。",
        	GENERIC = "这地方的动植物没有界限！",
        	HELD = "它还有细胞壁！",
        	SLEEPING = "睡着了更像胡萝卜。",
        },

    ------ 中立生物-----------------------------------------
	------ 可雇佣
		-- 皮弗娄牛
		BEEFALO =
		{
			GENERIC = "我该奴役它还是屠戮它呢？",      -- 默认状态
			NAKED = "它看起来很伤感。",                -- 被挂完毛
			SLEEPING = "它盖着自己的皮毛入梦。",       -- 睡眠
			FOLLOWER = "很好。跟着我。",              -- 跟随状态
			DOMESTICATED = "它在学会服从。",	       -- 驯化中
            ORNERY = "为我而战吧！",                   -- 战牛
            RIDER = "作为坐骑有点跌份，暂时只能将就了。",-- 行牛
            PUDGY = "没用的东西……只能当储备粮了。",    -- 胖牛
            MYPARTNER = "毛绒绒的。",		           -- 未知
		},

		BEEFALOWOOL = "有点臭烘烘的。但是足够保暖和柔软。",-- 牛毛
		HORN = "一支号角。",		                     -- 牛角

		-- 小皮弗娄牛
		BABYBEEFALO =
		{
			GENERIC = "动物幼崽往往会让自己足够可爱……\n这或许能成为我赦免它的理由?",
		    SLEEPING = "它盖着父母的皮毛入梦。",
        },

		-- 猪人
		PIGMAN =
        {
            DEAD = "它倒下了。",
            FOLLOWER = "我非常怀疑它的忠诚，但暂时可堪一用。",-- 追随者
            GENERIC = "愚蠢、丑陋、贪食且臭烘烘的生物。",-- 默认
            GUARD = "它的体内在涌出一种诅咒！",		-- 正在变身
            WEREPIG = "诅咒的力量让它疯狂！",		-- 疯猪
        },

		PIGTENT = "愚蠢、丑陋、贪食且臭烘烘的生物。",-- 猪人
		PIGSKIN = "它从哪来显而易见。",		        -- 猪皮

		-- 猪屋
		PIGHOUSE =
		{
			FULL = "里面有一头猪。",               -- 有猪
			GENERIC = "内部空间比看起来要大。",     -- 默认
			LIGHTSOUT = "以为关了灯就能摆脱我吗！？",-- 关灯
			BURNT = "看来蠢猪不懂得消防。",         -- 烧毁
		},

        BUNNYMAN = "极端素食主义暴徒。",-- 兔人
		MANRABBIT_TAIL = "柔软的绒团。",-- 兔绒

		-- 兔屋
		RABBITHOUSE=
		{
			GENERIC = "有一种卡通风格。",
			BURNT = "烧起来的时候像一根火炬。",-- 烧毁
		},

		CATCOON = "毛茸茸的小动物杀手。",             -- 浣猫
		COONTAIL = "毛茸茸的，听说有人喜欢被这个抽。", -- 猫尾

		-- 空心树桩
		CATCOONDEN =
		{
			GENERIC = "那只猫在里面打盹。",      -- 浣猫在内
			EMPTY = "主猫不在家，可以肆意洗劫。", -- 浣猫不在
		},

		ROCKY = "只需要廉价的矿物质元素的重装佣兵。",-- 石虾

		-- 一角鲸
        GNARWAIL =
        {
            GENERIC = "活泼的家伙。",
            BROKENHORN = "失去了自傲的资本。",
            FOLLOWER = "别贴太近。",		        -- 跟随状态
            BROKENHORN_FOLLOWER = "还能叫一角鲸吗？",-- 失去角
        },

        GNARWAIL_HORN = "演奏波涛。",-- 一角鲸的角

    ------ 不可雇佣
        KOALEFANT_SUMMER = "不错的猎物。",		-- 考拉象(正常)
		KOALEFANT_WINTER = "冬狩的猎物。",		-- 考拉象(冬象)
		KOALEFANT_CARCASS = "我不是秃鹫。",		-- 考拉象尸体

		OTTER = "卑鄙的掠夺者！",	-- 水獭掠夺者

		OTTERDEN =
		{
			GENERIC = "空空荡荡的。",
			HAS_LOOT = "塞得满满当当的。",	-- 有物品
		},

		OTTERDEN_DEAD = "关键结构被破坏了。",-- 拆毁的水獭掠夺者窝点

		--  电羊/伏特羊
		LIGHTNINGGOAT =
		{
			GENERIC = "它的角似乎很有用。",
			CHARGED = "它在大发雷霆。",-- 充电
		},

		LIGHTNINGGOATHORN = "这种物质能留住电力……", -- 伏特羊角
		GOATMILK = "嗯，过于膻腥。",		        -- 带电的羊奶

        PENGUIN = "模仿绅士，但很拙劣。",-- 企鸥

		PERD = "浆果是它最后的晚餐。",	-- 火鸡

        SQUID = "吵闹的东西，为什么会上岸？",-- 鱿鱼

		-- 无眼鹿
		DEER =
		{
			GENERIC = "海伦？",
			ANTLER = "没眼看。",
		},

        DEER_ANTLER = "像一把粗糙的钥匙。",-- 鹿角

		-- 沙拉蝾螈
		FRUITDRAGON =
		{
			GENERIC = "追随热量的小东西。",
			RIPE = "它的身体变成了火龙果。",
			SLEEPING = "睡着了像个水果。",
		},

        GRASSGATOR = "巨树下的草蜥蜴也巨大化了吗？",-- 草鳄鱼

        DUSTMOTH = "忠于职守的管理员。", -- 尘蛾
        DUSTMOTHDEN = "一尘不染。",		-- 整洁洞穴

    ------ 特殊NPC	-------------------------------------------
	------ 兔王
		RABBITKING_LUCKY = "看来我的藩臣有位出逃的爱丽丝。",          --  机缘兔子
        RABBITKING_PASSIVE = "我的藩臣准备向我朝贡些什么。",          --  和善兔王

        -- 兔王交易
		RABBITHAT = "我确信那些兔子是被这造型蠢到逗笑才一动不动的。", --  洞穴花环
        ARMOR_CARROTLURE = "那些兔子都被胡萝卜味给迷惑了。", --  胡萝卜外套
        RABBITKINGHORN = "召见我掌管输送的藩臣。", --  挖洞兔号角
        RABBITKINGHORN_CHEST = "临时贮藏点。",    --  便携式巢穴

		--  兔王BOSS
		RABBITKING_AGGRESSIVE = "不自量力的叛逆者，准备好受刑了吗？", --  暴戾兔王
        RABBITKINGMINION_BUNNYMAN = "有勇无谋的叛军！", --  皇家兔子警卫

        RABBITKINGSPEAR = "亡国君的信物总能对它的臣民造成威慑。",    --  兔王棍

    ------ 敌对生物	-------------------------------------------
    ------ 蜘蛛
		SPIDER =
		{
			DEAD = "已经下地狱了。",
			GENERIC = "卑贱的爬虫！",
			SLEEPING = "被梦魇困住的东西。",
		},

        -- 蜘蛛战士
		SPIDER_WARRIOR =
		{
			DEAD = "它斗不过死亡。",
			GENERIC = "想要偷袭我？",
			SLEEPING = "在梦中它也无法战胜我！",
		},

		SPIDER_HEALER = "爬虫里的护士。",	-- 护士蜘蛛

		SILK = "坚韧而柔软，不错的材料。",	 -- 蜘蛛丝
		SPIDERGLAND = "有些治疗效果。",		-- 蜘蛛腺

		SPIDERDEN = "爬虫的巢穴。",		    -- 蜘蛛巢
		SPIDEREGGSACK = "再生那些爬虫。",	-- 蜘蛛卵

		SPIDERQUEEN = "又能斩下女王的头颅了~真是愉快。",-- 蜘蛛女王
		SPIDERHAT = "女王的头颅会赦令它们臣服。",		-- 蜘蛛帽

        SPIDER_WATER = "能在水上行走？说明它们比看起来要轻。",-- 海黾
        OCEANVINE_COCOON = "海爬虫的窝点，应该用烈火净化！", -- 海黾巢穴
        OCEANVINE_COCOON_BURNT = "现在不会有爬虫了。",		-- 海黾巢穴(烧毁)

		SPIDER_DROPPER = "俯视我的那一刻就注定了它们会有一个残酷的死！",-- 穴居悬蛛
		DROPPERWEB = "有东西想埋伏我！",                              -- 穴居悬蛛网

        SPIDER_HIDER = "肮脏的爬虫！",		           -- 洞穴蜘蛛
        SPIDER_SPITTER = "它不靠近我居然不是因为恐惧。",-- 喷射蜘蛛
		SPIDERHOLE="爬虫们坚固的大本营。",              -- 蛛网岩

        -- 破碎蜘蛛
        SPIDER_MOON =
        {
        	GENERIC = "就算是月光也无法让爬虫变得美丽。",
        	SLEEPING = "爬虫的警惕放低了。",
        	DEAD = "爬虫的必然结局。",
        },

        MOONSPIDERDEN = "这其实是一只被倒立着囚禁的蜘蛛女王。",-- 破碎蜘蛛巢

    ------ 青蛙
		FROG =
		{
			DEAD = "灭绝进度+1。",
			GENERIC = "恶心的爬行生物，我该灭绝它们。",
			SLEEPING = "这东西的大脑居然也能做梦。",
		},

		POND = "青蛙的老巢。",-- 池塘
		MARSH_PLANT = "据说这是青蛙的宝贝。",-- 池塘边缘的植物

		LUNARFROG = "怪异扭曲……月光怎么会庇护这种东西？",-- 明眼青蛙

	------ 猎犬&变种猎犬&座狼
		HOUND = "低贱的野狗！",-- 猎犬

		HOUNDSTOOTH = "尖牙利齿，足够伤人。",-- 犬牙

		-- 恐怖猎犬(转变过程)
		HOUNDCORPSE =
		{
			GENERIC = "似乎没死透？",
			BURNING = "火焰的舞伴可不是好差事。",		-- 正在燃烧
			REVIVING = "“月”光的照耀让它的残骸复生了。",-- 变成骸骨猎犬
		},

		-- 恐怖猎犬(生物)
        MUTATEDHOUND =
        {
        	DEAD = "尘归尘，土归土。",
        	GENERIC = "“月”光的照耀让它的残骸复生了。",
        	SLEEPING = "梦魇的力量对骸骨也有作用。",
        },

		ICEHOUND = "凛冬为它赐福。",		        -- 蓝色猎犬
		FIREHOUND = "夏日的酷暑赋予了它火焰的力量。",-- 红色猎犬

		HOUNDBONE = "徒留些许残骸。",		-- 犬骨
		HOUNDMOUND = "猎犬的匪窝。",		-- 猎犬丘

        WARGLET = "我有点想驯服这种生物。", -- 青年座狼
		WARG = "猎犬们的王。",		       -- 座狼
		MUTATEDWARG = "它在吞吐月能？",    -- 附身座狼

        -- 座狼尸体
		WARGCORPSE =
		{
			GENERIC  = "已经是条死狗了。",
			BURNING  = "让火焰净化一切……",
			REVIVING = "看来月灵想要一头斗犬。",
		},

	------ 发条生物
		BISHOP = "你的信仰也是钢铁锻造的吗，主教？", -- 发条主教
		BISHOP_CHARGE_HIT = "我中弹了！",		   -- 主教的光炮/被击中
		ROOK = "横冲直撞，终遇南墙。",		        -- 发条战车
		KNIGHT = "然而，这并非骑士。",	     	    -- 发条骑士

		GEARS = "开始机械革命！",-- 齿轮

		GHOST = "无能的怨灵。",	-- 幽灵

		KRAMPUS = "肮脏的小偷！",		       -- 坎普斯
		KRAMPUS_SACK = "这种空间技术值得研究。",-- 坎普斯背包

		LEIF = "森林的愤怒……我的活木。",		-- 树精守卫
		LEIF_SPARSE = "森林的愤怒……我的活木。",-- 树精守卫

		BUZZARD = "敢于虎口夺食的沙漠强盗。",-- 秃鹫

		SPAT = "它的毛像钢铁般坚韧。",   -- 钢羊
		PHLEGM = "恶心！",              -- 脓鼻涕
		STEELWOOL = "钢丝……还是棉花？",-- 钢丝绵

		PIGGUARD = "比一般的猪算得上菁英了。",		-- 猪人守卫
		PIGTORCH = "那些猪人似乎有一种原始的信仰。",-- 猪火炬

		WALRUS = "它是个优秀的猎人，但在我面前依旧是猎物。", -- 海象
		LITTLE_WALRUS = "激起了我的施虐欲。",		       -- 小海象
		WALRUSHAT = "把它戴在头上。",		               -- 贝雷帽
		WALRUS_TUSK = "摩挲起来很顺手，我应该拿它做根手杖。",-- 海象牙

		-- 海象营地
		WALRUS_CAMP =
		{
			EMPTY = "我的猎物还没就位。",
			GENERIC = "不错的手艺。",
		},

		-- 蚊子
        MOSQUITO =
        {
            GENERIC = "恼人的害虫！",
            HELD = "不捏死留着干什么？",
        },

        MOSQUITOSACK = "一种古老的血疗用品。",-- 蚊子血囊

		POND_MOS = "这种潮湿的环境容易滋生蚊虫。",-- 沼泽池塘

        MERM = "“鱼”蠢的生物。",-- 鱼人

		-- 漏雨的小屋
		MERMHOUSE =
		{
			GENERIC = "四头“鱼”蠢的东西挤在里面。",
			BURNT = "现在空荡荡了。",
		},

		MOOSE = "看起来不属于这里。",		          -- 漏雨的小屋
        MOOSE_NESTING_GROUND = "那些东西倾巢而出了。",-- 漏雨的小屋(鱼人全外出)
        MOOSEEGG = "里面孵出来很多麻烦。",		      -- 漏雨的小屋

		MONKEY = "卑贱的小偷！",-- 穴居猴
        MONKEYBARREL = "烦人的猴子住在里面。我该在这周围造个屠宰场。",-- 穴居猴桶


		POWDER_MONKEY = "这些强盗的灵魂都充满了恶臭！",-- 火药猴
        PRIME_MATE = "带上你的盗贼们滚开！",		  -- 大副

		CURSED_MONKEY_TOKEN = "那些猴子是怎么学会这种巫术的！？",-- 诅咒饰品

        CUTLESS = "海盗手里是抢劫，但我来用属于征税。",-- 木头短剑
        OAR_MONKEY = "充满了海盗风格。",             -- 战桨

        MONKEY_MEDIUMHAT = "劈波斩浪！",-- 船长的三角帽
        MONKEY_SMALLHAT = "汗津津的。",	-- 海盗头巾

        PIRATE_STASH = "这是猴子窝藏赃物的地方。",-- X(宝藏地点)
        STASH_MAP = "猴子们的秘密。",		     -- 海盗地图

		-- 猴子小屋
		MONKEYHUT =
        {
            GENERIC = "烦人的强盗窝点，趁夜焚烧吧！",
            BURNT = "烈火总算干了件好事。",		-- 烧毁
        },

        SLURTLE = "这东西会偷窃我的宝石！",     -- 蛞蝓龟
		SNURTLE = "移动的炸药包。",		       -- 蜗牛龟
        SLURTLE_SHELLPIECES = "碎了一地。",    -- 外壳碎片
		ARMORSNURTLESHELL = "坚固，但是愚蠢。",-- 蜗壳护甲
        SLURTLEHAT = "可笑的东西。",	       -- 背壳头盔
		SLURTLESLIME = "化学成分近似TNT。",    -- 蛞蝓龟黏液
        SLURTLEHOLE = "那些软体动物出入这里时壳不会卡住吗？",-- 蛞蝓龟窝

		SLURPER = "卑劣的寄生虫，为什么我还没灭绝它们！？",		-- 啜食者
		SLURPER_PELT = "这块生物组织有着独特的消化结构。",		-- 啜食者皮

		BAT = "德古拉都没这么大胆！",                  -- 洞穴蝙蝠
        BATCAVE = "看来德古拉当初没少在装修上花心思。",	-- 蝙蝠洞

		MOLEBAT = "它在呼喊死亡寻来。",          -- 裸鼹蝠
        MOLEBATHILL = "孵化那种丑陋恶心的东西。",-- 裸鼹蝠丘

        SHARK = "它的出现只是为了给我贡献几块无用的鱼肉吗？",-- 岩石大白鲨

		-- 高脚鸟
		TALLBIRD = "充满攻击性的生物。",-- 高脚鸟

		-- 高脚鸟巢
        TALLBIRDNEST =
		{
			GENERIC = "食材正安稳地躺在那儿。",	-- 有蛋
			PICKED = "下一次需要多久？",		-- 蛋被拿走了
		},

        FRUITFLY = "闻着味就来了！",		  -- 果蝇
        LORDFRUITFLY = "别西卜是想开战吗！？", -- 果蝇王

		-- 触手
		TENTACLE = "它的本体还在更深处。",-- 触手

		TENTACLESPIKE = "天然的刑具。",	  -- 触手尖刺
		TENTACLESPOTS = "防水的。",		  -- 触手皮

		-- 月岩企鸥
		MUTATED_PENGUIN =
        {
			DEAD = "这扭曲的东西去得了冥府吗？",
			GENERIC = "月光的造物堪称两极分化……这是恶心的那一极。",
			SLEEPING = "它是睡着了还是石化了？",
		},

        ARCHIVE_CENTIPEDE = "它会试图阻挠我。可悲的无用功。",-- 远古哨兵蜈蚣
        ARCHIVE_CENTIPEDE_HUSK = "一种自动防卫机制。",		-- 哨兵蜈蚣壳

		GESTALT = "夺人心智的月灵！",	       -- 虚影
        GESTALT_GUARD = "“祂”用以驱逐暗影！。",-- 大虚影

		COOKIECUTTER = "会摧毁大饼船。",	   -- 饼干切割机
		COOKIECUTTERSHELL = "这外壳有什么用？",-- 饼干切割机壳

    ------ BOSS相关
        MOSSE = "暴躁的母亲。",          -- 麋鹿鹅
        MOSSLING = "等待屠戮的幼崽。",	 -- 麋鹿鹅幼崽
        GOOSE_FEATHER = "带有风的力量。",-- 麋鹿鹅羽毛

		-- 蚁狮
		ANTLION =
		{
			GENERIC = "沙漠的藩王，肆意妄为的家伙。",           -- 默认
			VERYHAPPY = "它签订了臣服的协议，但我怀疑它的信誉。",-- 喂食后高兴
			UNHAPPY = "是时候斩下它的脑袋了！",                -- 愤怒(被喂食过热/冷的暖石进入战斗形态)
		},

		SANDSPIKE = "小把戏，阻挡不了我！",-- 沙刺
		SANDBLOCK = "沙墙而已！",		  -- 沙堡
		GLASSSPIKE = "晶莹剔透。",		  -- 玻璃尖刺
		GLASSBLOCK = "艺术的堡垒。",	  -- 玻璃城堡

		DRAGONFLY = "这世界的龙没有我想象中威武。",-- 龙蝇

		DRAGON_SCALES = "圣乔治也没拿到这个！",-- 龙鳞

		-- 岩浆池？
		LAVASPIT =
		{
			HOT = "快融化了！",	       	-- 中暑
			COOL = "目前看来是安全的。",-- 龙蝇唾液
		},

		LAVA_POND = "索伦的噩梦。",   -- 岩浆池
		LAVA_POND_ROCK = "真是滚烫。",-- 岩石(岩浆池边缘的石头)

		LAVAE = "在那个方块构成的维度里，它们更大也更难缠。",-- 岩浆虫

		BEARGER = "庞大的体型最终表现为它庞大的食量。",-- 熊獾
		MUTATEDBEARGER = "在月灵的操控下更灵活了。",-- 装甲熊獾

		-- 熊獾尸体
		BEARGERCORPSE =
		{
			GENERIC  = "狩猎完毕。",
			BURNING  = "让火焰净化一切……",
			REVIVING = "看来月灵很中意这具躯体。",
		},

		BEARGER_FUR = "非常多的毛才能凑成这张皮。",-- 熊皮

		DEERCLOPS = "我该用它的尸体制造一个哨兵！",		      -- 独眼巨鹿
		MUTATEDDEERCLOPS = "皓月广寒……",                   -- 晶体独眼巨鹿

		DEERCLOPS_EYEBALL = "有的鹿没有眼睛，有的鹿只有眼睛。",-- 独眼巨鹿眼球

		-- 巨鹿尸体
		DEERCLOPSCORPSE =
		{
			GENERIC  = "它的眼睛都被我挖出来了。",
			BURNING  = "让火焰净化一切……",
			REVIVING = "月灵成了它的点睛之笔。",
		},

		-- 颗粒状传输/瓦格斯塔夫投影(NPC)
        WAGSTAFF_NPC = "人类，你到底想做什么？",		-- 月亮风暴中
        WAGSTAFF_NPC_MUTATIONS = "随你想做什么，人类的野心终会不值一提。",-- 击败天体英雄后
        WAGSTAFF_NPC_WAGPUNK = "月亮的能量投射下来了。",  -- 研究月后三王尸体、给予火花柜的那个

		-- 瓦格斯塔夫投影工具
        WAGSTAFF_TOOL_1 = "网状缓冲器……他想做什么？",         -- 网状缓冲器
        WAGSTAFF_TOOL_2 = "装置除垢器……看来他对精度要求很高。",-- 装置除垢器
        WAGSTAFF_TOOL_3 = "垫圈开槽器……常用的工具。",         -- 垫圈开槽器
        WAGSTAFF_TOOL_4 = "概念刷洗器……他涉及了位面的知识。", -- 概念刷洗器
        WAGSTAFF_TOOL_5 = "校准观察机……他想观测什么？",       -- 校准观察机

		WAGSTAFF_MACHINERY = "他有意把这些遗弃在这……",		-- 被丢弃的垃圾

		WAGSTAFF_MUTATIONS_NOTE = "他居然到这一步了？",		-- 研究笔记

		MOON_ALTAR_LINK = "它暂时不想被我掌控。",-- 神秘能量

		-- 月亮虹吸器/未完成的实验
        MOON_DEVICE =
	    {
            GENERIC = "一种窃取月光的仪器……我就知道。",
            CONSTRUCTION1 = "这东西可真麻烦。",-- 建造2阶段(下一步需要约束静电)
            CONSTRUCTION2 = "这必将引来“祂”的制裁。",-- 建造完成
        },

		ALTERGUARDIAN_CONTAINED = "原来如此，他打的是这个主意……",-- 月亮精华提取器

		-- 天体英雄(一阶段)
		ALTERGUARDIAN_PHASE1 =
	    {
            GENERIC = "区区一只哨兵，就妄想能阻止我？",
            DEAD = "序曲终了。", -- 转阶段中
        },

		-- 天体英雄(二阶段)
        ALTERGUARDIAN_PHASE2 =
	    {
            GENERIC = "它还没有完全解放！",
            DEAD = "来吧，让我们奏响终曲！", -- 转阶段中
        },

		ALTERGUARDIAN_PHASE3 = "我会把这作为征服月光的预演！",-- 天体英雄(三阶段)
		ALTERGUARDIAN_PHASE3DEADORB = "不堪一击。",-- 天体英雄(疑似正在死亡？)
        ALTERGUARDIAN_PHASE3DEAD = "“祂”的尖兵，值得回收利用。",-- 被击败的天体英雄

        ALTERGUARDIAN_PHASE2SPIKE = "真是锐利的月光。",  -- 月光玻璃尖刺
        ALTERGUARDIAN_PHASE3TRAP = "休想干扰我的意志！", -- 启迪陷阱

        ALTERGUARDIANHAT = "月之王权的光辉！",      -- 启迪之冠
        ALTERGUARDIANHATSHARD = "迷人的可能性结晶。", -- 启迪碎片

		SHARKBOI = "它的脑袋很适合作为收藏。",	  -- 大霜鲨
		BOOTLEG = "踏破铁鞋无觅处。",		     -- 出逃腿靴
		OCEANWHIRLPORTAL = "大海的秘密通道。",   -- 漩涡传送门(使用靴子召唤那个)

		MINOTAUR = "它的犀角会是我满意的战利品。", -- 远古守护者
		MINOTAURHORN = "很浓郁的暗影力量。",	  -- 守护者之角
		MINOTAURCHEST = "现在是清点战利品的环节。",-- 大号华丽箱子

		-- 盒中泰拉
        TERRARIUM =
	    {
            GENERIC = "一个跨世界信标？",
            CRIMSON = "充满了类似腐朽的气息……",
            ENABLED = "那东西收到信号了。",
			WAITING_FOR_DARK = "危险的信号。",-- 疑似放入噩梦燃料
			COOLDOWN = "还需要冷却一段时日。", -- 冷却中
			SPAWN_DISABLED = "它在拒绝。",
        },

		-- 显眼的箱子
        TERRARIUMCHEST =
		{
			GENERIC = "它的布置十分吸引人。",
			BURNT = "它自己燃起来的。",		        -- 烧毁
			SHIMMER = "它发出这样的光是在吸引人吗？",-- 发光？
		},

        EYEOFTERROR = "这家伙……从那个维度杀出来了？",           -- 恐怖之眼
        EYEOFTERROR_MINI_GROUNDED = "在它还没孵出来之前摧毁它！",-- 恐怖之蛋
        EYEOFTERROR_MINI = "碾碎它！",		                    -- 可疑窥视者

		EYEMASKHAT = "它还是活着的。",	   -- 眼面具
        MILKYWHITES = "这东西属于乳制品？",-- 乳白物

        TWINOFTERROR1 = "异星科技的改造机兵。",		-- 激光眼
        TWINOFTERROR2 = "这是另一个维度的炎龙吗？",	-- 魔焰眼

        SHIELDOFTERROR ="它还保留着活性。",-- 恐怖盾牌



        DEER_GEMMED = "撒旦的驯鹿。现在叛变到我这边还来得及",-- 克劳斯的魔法无眼鹿

        KLAUS = "贪欲滋生的恶魔，我有点想奴役它了。",		               -- 克劳斯
		KLAUSSACKKEY = "“贪婪银行VIP会员卡”……从神秘学上解读是这样翻译的。",-- 麋鹿茸
		KLAUS_SACK = "那些小偷恶魔奋斗了一辈子的积蓄。",	 	           -- 赃物袋

        MALBATROSS = "贪婪的海鸟。",		      -- 邪天翁
        MALBATROSS_FEATHER = "适合在海风中翱翔。",-- 邪天翁羽毛
		MALBATROSS_BEAK = "形状像个船桨。",		  -- 邪天翁喙

        -- 帝王蟹
        CRABKING =
        {
            GENERIC = "固守城堡的疯王，被月光折磨的愚人。",
            INERT = "它追求着闪亮而不是宝石的珍品。",
        },

		CRABKING_CLAW = "这些东西可无法阻拦我攻破你的城堡！",-- 巨钳
		CRABKING_CANNONTOWER = "我的攻城炮呢？",          -- 加农炮/螃蟹炮塔
		CRABKING_MOB = "别来送死！",                      -- 蟹卫
		CRABKING_MOB_KNIGHT = "简直有辱骑士之名！",        -- 蟹骑士
		CRABKING_ICEWALL = "这阻挡不了我太久！",           -- 冰障

		BOAT_BUMPER_CRABKING_KIT = "大海上的移动城堡！",-- 帝王蟹保险杠(物品)
		BOAT_BUMPER_CRABKING = "闪耀着王冠的光芒。",	-- 帝王蟹保险杠(安装)

		-- 蜜蜂
		BEE =
		{
			GENERIC = "嗡嗡作响的采蜜苦工。",
			HELD = "现在落到我的手里了。",
		},

		BEEHIVE = "蜜蜂的家，我建造囚笼的原料。",-- 蜂窝

		-- 杀人蜂
		KILLERBEE =
		{
			GENERIC = "“蜂”狂的东西！",
			HELD = "现在落到我的手里了。",
		},

		WASPHIVE = "“蜂狂”。",		-- 杀人蜂蜂窝

		STINGER = "很尖锐，要小心点。",	-- 蜂刺
		HONEY = "像是流动的黄金。",		-- 蜂蜜
		HONEYCOMB = "用来建造蜂箱……或者下锅。",-- 蜜脾

		BEEQUEEN = "向您致敬，女王！希望您喜欢地狱的焰火！",--  蜂后

        BEEQUEENHIVEGROWN = "蜜蜂们的女王正躲在里面。",   -- 巨大蜂窝

        BEEGUARD = "想处刑女王先得处理这些愚忠的骑士。",   -- 嗡嗡蜜蜂
        ROYAL_JELLY = "女王的贡品。",	              	 -- 蜂王浆
        HIVEHAT = "成为王的幻觉能治抚慰庸人的心。",		   -- 蜂王冠

		-- 蜂蜜地块，巨大蜂窝的蜂王死后的状态
		BEEQUEENHIVE =
		{
			GENERIC = "女王的甜蜜城堡。",                 -- 有蜂后
			GROWING = "哈……看起来有手下败将准备卷土重来。",-- 正在生长(蜂后CD中)
		},

---------- 洞穴&远古&远古档案馆&中庭	----------------------------------------------------
        CAVE_ENTRANCE = "被那家伙堵住了。",		-- 被堵住的洞穴入口

		-- 洞穴入口
		CAVE_ENTRANCE_OPEN = {
            GENERIC = "来吧，《地心游记》。",
            OPEN = "总算被疏通了。",
            FULL = "被挡道了。",
        },

		-- 楼梯(洞穴出口)
		CAVE_EXIT = {
            GENERIC = "从这能回到“祂”的注视下。",
            OPEN = "总算被疏通了。",-- 打开
            FULL = "被挡道了。",-- 被塞满(封闭)
        },

		TENTACLE_PILLAR = "它的本体还在更深处。",-- 大触手
		TENTACLE_GARDEN = "它的本体还在更深处。",-- 大触手
		TENTACLE_PILLAR_ARM = "那头怪物受伤的应激反应。",-- 小触手

        TENTACLE_PILLAR_HOLE = "一个便捷但是泥泞的通道。",-- 硕大的泥坑

		WORMLIGHT = "这种荧光的来源不是化学反应。",	-- 发光浆果
		WORMLIGHT_LESSER = "我认为这至多属于食材。",-- 小发光浆果(采摘)
        WORMLIGHT_PLANT = "下面连着根茎还是猛兽呢？",-- 神秘植物

		-- 巨石枝
		TREE_ROCK =
		{
			BURNING = "它的植物部分可受不了火焰。", -- 燃烧
			CHOPPED = "它的种子藏在这巨石里。", -- 砍倒
			GENERIC = "在模仿阿特拉斯吗？", -- 普通
		},
		TREE_ROCK_SEED    = "植物的心脏，有力的脉动。",     -- 巨石枝种子
		TREE_ROCK_SAPLING = "别急，它很快就能冲破重压了。", -- 巨石枝树苗

		-- 喷气孔
		CAVE_VENT_ROCK =
		{
			GENERIC = "留神它的喷发规律，现在没有复制人可供挥霍。", -- 未喷发
			HOT     = "呼……我该用它来建造一座温泉。", -- 热空气
			GAS     = "过量的硫化氢会加速食物腐败……", -- 瓦斯气
			MIASMA  = "异界的迷雾……虚空的味道。", -- 暗影瘴气
		},

		CAVE_FERN_WITHERED   = "显而易见，蕨类也需要光照。", -- 枯萎的洞穴蕨类
		FLOWER_CAVE_WITHERED = "不再光彩照人了。",          -- 枯萎的洞穴花

		-- 热地螨
		CAVE_VENT_MITE =
		{
			DEAD     = "最好的结局。",     -- 死亡
			GENERIC  = "我很想灭绝它们。", -- 普通
			SLEEPING = "总算不再烦人了。", -- 睡觉
			VENTING  = "真是……令人作呕。", -- 喷发
		},

		-- 钻地蠕虫
		WORM =
		{
		    PLANT = "想把狩猎打成反埋伏吗？",	-- 伪装状态
		    DIRT = "出来吧，面对你的命运。",-- 钻地
		    WORM = "我开始后悔直视这玩意了。还是碾碎吧。",-- 显形
		},

        WORM_BOSS = "来自原始时代的暴躁巨兽！", --  巨大洞穴蠕虫

        -- 损坏的发条装置
        CHESSJUNK1 = "骑士与主教同归于尽。",        -- 主教&骑士
        CHESSJUNK2 = "战车的残骸掩埋了骑士的尸骨。", -- 骑士&战车
        CHESSJUNK3 = "主教埋于巴别塔的废墟之下。",   -- 主教&战车

		BISHOP_NIGHTMARE = "是暗影在支持你的残躯，主教，不是信仰。", -- 损坏的发条主教
		ROOK_NIGHTMARE = "你还能冲锋多少次？",		               -- 损坏的发条战车
		KNIGHT_NIGHTMARE = "残破的躯体承担骑士的重任。",	   	    -- 损坏的发条骑士

		CHEST_MIMIC_REVEALED = "躁动的活性暗影。", --  暴躁箱子

		--  恶液(黑色史莱姆)
		GELBLOB =
        {
            GENERIC = "来自某人令人作呕的恶意。",  --  默认
            HAS_ITEM = "啧，这家伙还会偷窃装备。", --  里面有东西
            HAS_CHARACTER = "看看是谁失陷其中？", --  里面有玩家
        },

		--  亡者分身/被附身的尸体(玩家被面具生物击杀后生成)
        PLAYER_HOSTED =
        {
            GENERIC = "演好你的小丑，别试图假扮我的朋友。", --  别的角色
            ME = "算是惟妙惟肖，但终究不过是伪物。",        --  自己
        },

		--  面具
        MASK_SAGEHAT = "象征智慧深沉者。",    --  贤者
        MASK_HALFWITHAT = "象征滑稽无脑者。", --  愚人
        MASK_TOADYHAT = "象征趋炎附势者。",   --  马屁精

        SHADOWTHRALL_PARASITE = "欢迎，虚空的来访者，想要化装舞会吗？", --  面具生物

        -- 梦魇疯猪
	    DAYWALKER =
	    {
		    GENERIC = "他的心智迷失在了最疯狂的噩梦中。",-- 解放
		    IMPRISONED = "这种封锁……是夜里那位做的吗？",-- 被封锁
        },

	    -- 开裂的柱子(封锁疯猪的那个)
	    DAYWALKER_PILLAR =
	    {
	 	    GENERIC = "大理石外壳已经破碎了。",
		    EXPOSED = "原来是使用绝望石内核。",
	    },

		-- 拾荒疯猪
		DAYWALKER2 =
		{
			GENERIC = "疯疯癫癫的。",	       -- 中立
			BURIED = "他是怎么从下面钻上来的？",-- 被困住
			HOSTILE = "想开战吗？那就来吧！",   -- 敌对
		},

		-- 麻刺节点
		FENCE_ELECTRIC =
		{
			LINKED = "注意绝缘保护。", -- 已连接
			GENERIC = "电器，轻而易举。", -- 未连接
		},
		FENCE_ELECTRIC_ITEM = "那家伙一堆发明之中少有的实用品。", -- 麻刺节点物品形式
		SCRAP_MONOCLEHAT = "眺望远方。",-- 地平线扩展器
		SCRAPHAT = "流浪汉的装束！",	-- 拾荒尖帽

        FOSSIL_PIECE = "一种远古生物最后的痕迹。",-- 化石碎片

		-- 骨架
        FOSSIL_STALKER =
        {
			GENERIC = "我想想下一块该怎么拼。",		   -- 未拼完
			FUNNY = "显而易见，远古生物学的经典错误。",	-- 错误
			COMPLETE = "一颗有力的心脏能令它回光返照。",-- 准备好了
        },

		SHADOWHEART = "暗影的核心……拥有起死回生的力量！",-- 暗影心房

		STALKER = "暗影的力量驱动它复苏。",		          -- 复活的骨架
        STALKER_ATRIUM = "哈，失败者，你觉得你能阻止我？", -- 远古织影者
		STALKER_MINION = "可怜的亡国君最后的把戏，碾碎它们！",-- 编织暗影

		ARMORSKELETON = "曾经栖息过一名国王的灵魂。", -- 骨头盔甲
		SKELETONHAT = "让梦魇都为此臣服！",		     -- 骨头头盔
        THURIBLE = "燃烧暗影，驱使暗影！",		     -- 暗影香炉

		CHARLIE_NPC = "贵安，暗夜的女王。",		-- 查理(NPC)

		CHARLIE_HAND = "它想要五颗绝望石。",		-- 召唤之手

		-- 毒菌蟾蜍(蘑菇树)
		TOADSTOOL_CAP =
		{
			EMPTY = "空的。",		-- 空的
			INGROUND = "得把它拔出来。",		-- 在地里面
			GENERIC = "诡异的真菌。",
		},

		-- 毒菌蟾蜍(战斗状态)
		TOADSTOOL =
		{
			GENERIC = "丑陋而扭曲的怪物！",
			RAGE = "哈，无能狂怒！",-- 愤怒
		},

		MUSHROOMBOMB = "真菌强袭！",-- 炸弹蘑菇

		-- 孢子帽(蟾蜍的蘑菇树)
		MUSHROOMSPROUT =
		{
			GENERIC = "会释放腐蚀性气体！",
			BURNT = "很危险的东西！",-- 烧毁
		},

		SLEEPBOMB = "一包睡意。",	-- 睡袋(苦难蟾蜍掉落图纸，需要金丝雀制作那个)

		SHROOM_SKIN = "真是丑陋，不过很有用。",		-- 蘑菇皮

    	-------天体风暴
		-- 充能玻璃石(月亮风暴内的特殊闪电生成的矿物)
        MOONSTORM_GLASS =
	    {
            GENERIC = "充满了月光。",
            INFUSED = "充满了月光。",
        },

        MOONSTORM_STATIC = "奇迹的火花。",		-- 能量静电
        MOONSTORM_STATIC_ITEM = "尖端科学材料。",-- 约束静电

	    MOONSTORM_SPARK = "月光连电磁都能活化？",-- 月熠
        BIRD_MUTANT = "它们跟随月亮风暴降临了。",-- 月盲乌鸦
        BIRD_MUTANT_SPITTER = "诡异扭曲的造物。",-- 奇形鸟
		MUTATEDBIRD = "知道吗？科雷正在设计“亮喙鸟袭击”事件。你可以查wiki介绍。", -- 亮喙鸟

    	-------天体裂隙
	    LUNARRIFT_PORTAL = "“祂”的使徒会由此而来。",-- 裂隙(月亮)
	    LUNARRIFT_CRYSTAL = "璀璨的月光凝聚辉煌。", -- 裂隙晶体

	    LUNARTHRALL_PLANT = "月光给了它们庇护。",		       -- 致命亮茄
	    LUNARTHRALL_PLANT_VINE_END = "你怎么敢用这东西碰我！？",-- 钻地藤蔓
	    LUNAR_GRAZER = "月光赐予它们不死的力量。",  -- 牧者

		-------地下裂隙
        SHADOWRIFT_PORTAL = "通往深层的噩梦。",	-- 暗影裂隙
		DREADSTONE_STACK = "能够吸收绝望生长。",-- 绝望石矿苗

	    SHADOWTHRALL_HANDS = "虚空的先锋，代我向主宰问好。",	-- 墨荒(躁动，使用爪子翻滚那个)
	    SHADOWTHRALL_HORNS = "虚空的吞噬者，无知会令你灭亡。",	-- 墨荒(刮擦，长得像战车那个)
	    SHADOWTHRALL_WINGS = "虚空的先知，告诉我你看到了什么？",-- 墨荒(尖叫，长着独眼使用远程那个)
		SHADOWTHRALL_MOUTH = "虚空的狞笑者，猜猜你什么时候会笑不出来？", -- 蛇形墨荒/狞笑
		-- 巨荒蜈/涟漪
		SHADOWTHRALL_CENTIPEDE =
		{
			HEAD = "哪一端寄宿着它的意志呢？", -- 头部
			BODY = "有趣，其中的每一节都拥有独立的灵魂。", -- 身体
			FLIPPED = "准备好迎接倾覆之灾了吗？", -- 翻转
		},

	    FUSED_SHADELING = "从噩梦中攀出的怪物。", -- 熔合暗影
	    FUSED_SHADELING_BOMB = "这些伤不到我。", -- 绝望螨

	    -- 荧光草
	    FLOWER_CAVE = "它的光明来自化学反应。",			-- 单
		FLOWER_CAVE_DOUBLE="它的光明来自化学反应。",	-- 双
		FLOWER_CAVE_TRIPLE="它的光明来自化学反应。",	-- 三

		LIGHTBULB = "微弱的光亮……绝佳的原料。",	-- 荧光果

		-- 蘑菇树
        -- 蓝蘑菇树
        MUSHTREE_TALL =
        {
            GENERIC = "“月”光的绝佳承载体。",
            BLOOM = "它在尝试扩张领地。",
			ACIDCOVERED = "沾满了酸液。",-- 被酸雨腐蚀
        },

		MUSHTREE_TALL_WEBBED =
		{
			GENERIC = "爬虫占领了这里。",
			ACIDCOVERED = "沾满了酸液。",-- 被酸雨腐蚀
		},

		-- 红蘑菇树
        MUSHTREE_MEDIUM =
        {
            GENERIC = "大红帽。看起来不怕狼。",
            BLOOM = "它在尝试扩张领地。",
			ACIDCOVERED = "沾满了酸液。",-- 被酸雨腐蚀
        },

        -- 绿蘑菇树
        MUSHTREE_SMALL =
        {
            GENERIC = "它试图伪装成一课树。",
            BLOOM = "诡异的声音。",
			ACIDCOVERED = "沾满了酸液。",-- 被酸雨腐蚀
        },

        -- 蘑菇孢子
        -- 蓝色孢子
        SPORE_TALL =
        {
            GENERIC = "可以种植到腐朽的木桩上。",
            HELD = "里面的颗粒比我想象中要小。",
        },

		-- 红色孢子
		SPORE_MEDIUM =
        {
            GENERIC = "将来的实验材料。",
            HELD = "需要找个木桩种下去。",
        },

		-- 绿色孢子
		SPORE_SMALL =
        {
            GENERIC = "像是大一号的萤火虫。",
            HELD = "应该可以找个合适的地方种下。",
        },

---------- 自然生成布景---------------------------------------------------------------------------------
    ------ 自然资源	----------------------------------------
		SKELETON = "上一个失败者。",	  -- 骷髅
		SCORCHED_SKELETON = "它风化了。", -- 易碎骷髅

        SHALLOW_GRAVE = "浅浅的忧郁，不是吗？", --  矮坟

        -- 落石
		CAVEIN_BOULDER =
        {
            GENERIC = "从上方落下。",
            RAISED = "好像变大了？",
        },

		ROCK = "需要一个苦工开采。",-- 岩石

        -- 石化树
		PETRIFIED_TREE = "正常来说，木质石化应该是个漫长的过程。",
        ROCK_PETRIFIED_TREE = "一眨眼间就变成这样了。",
        ROCK_PETRIFIED_TREE_OLD = "全是石头了。",

		-- 石笋
		STALAGMITE				= "富有年代感的石笋。",
		STALAGMITE_FULL			= "富有年代感的石笋。",
		STALAGMITE_LOW			= "富有年代感的石笋。",
		STALAGMITE_MED			= "富有年代感的石笋。",
		STALAGMITE_TALL			= "里面应该有化石。",
		STALAGMITE_TALL_FULL	= "里面应该有化石。",
		STALAGMITE_TALL_LOW		= "里面应该有化石。",
		STALAGMITE_TALL_MED		= "里面应该有化石。",

		-- 迷你冰川
		ROCK_ICE =
		{
			GENERIC = "泰坦尼克号的墓碑。",
			MELTED = "凛冬会重塑它的。",-- 融化
		},

		ROCK_ICE_MELTED = "水中倒映着天空。",-- 融化的迷你冰川

		-- 盐堆(盐矿)
		SALTSTACK =
		{
			GENERIC = "索多玛的遗骸。",-- 完整
			MINED_OUT = "暂时挖完了。",-- 开才完
			GROWING = "盐还在再生。",  -- 再生中
		},

	    NITRE_FORMATION = "现在不缺硝石了。",-- 硝石堆

	------ 交互内容 	----------------------------------------------------------------------------------------------------------------
		MULTIPLAYER_PORTAL = "黑暗哥特风，看起来是一位女士设计的。",		       -- 绚丽之门
        MULTIPLAYER_PORTAL_MOONROCK = "坦白来说，我没想到“祂”的力量能用来干这个。",	-- 天体传送门

		TREASURECHEST_TRAP = "看起来像个陷阱。",-- 陷阱宝箱(比如里面放火魔杖和炸药的那种)

	    -- 月台
	    MOONBASE =
	    {
		    GENERIC = "一个窃取月光力量的祭坛。",-- 默认(已修复)
		    BROKEN = "需要一块月岩修复。",-- 未修复
		    STAFFED = "“祂”在注视这里！",-- 正在升级法杖
		    WRONGSTAFF = "不是这个。",-- 插入错误物品
		    MOONSTAFF = "皎洁如月。",-- 插入了唤月者法杖
	    },

		GARGOYLE_HOUND = "石化的猎犬……有趣。",		-- 可疑的月岩(猎犬)
        GARGOYLE_WEREPIG = "石化的疯猪……有趣。",	-- 可疑的月岩(疯猪)
	    MOONROCK_PIECES = "石化了？",-- 月亮石碎块(石化的花朵、鸟)

	    RESURRECTIONSTONE = "能够接引灵魂回到现世。",-- 试金石/复活石

		-- 坟墓
        MOUND =
        {
            DUG = "里面已经空了。", 	    -- 被挖了
            GENERIC = "可能有冤魂困在里面。",-- 完整
        },

        -- 湖泊(绿洲)
        OASISLAKE =
		{
			GENERIC = "绿洲的生命之源。",
			EMPTY = "现在是干涸状态。",-- 干涸
		},

		SUCCULENT_PLANT = "特殊的叶片结构，很少见。",-- 多肉植物(地面生长状态)
		SUCCULENT_PICKED = "适合作为观赏植物。",	-- 多肉植物(采摘下来的)

	-----垃圾堆
		FENCE_JUNK = "这只是垃圾，没有栅栏。",-- 垃圾栅栏
		JUNK_PILE = "文明人应该远离那个。",	  -- 垃圾堆
		JUNK_PILE_BIG = "随时可能倒塌。",	  -- 摇摇欲坠的垃圾堆

		OCEANFISHABLEFLOTSAM = "它上面全是淤泥。",-- 海洋残骸

		BOATFRAGMENT03 = "是谁的船碎掉了？",	 -- 船碎片
        BOATFRAGMENT04 = "它碎成许多块。",		 -- 船碎片
        BOATFRAGMENT05 = "某个倒霉鬼发生了海难。",-- 船碎片

        SEASTACK = "大海的艺术展品。",-- 海蚀柱

    ------ 水中木
	    WATERTREE_PILLAR = "对生长怀有近乎疯狂的渴望。", -- 大树干
	    WATERTREE_ROOT   = "对生长怀有近乎疯狂的渴望。", -- 大树根

	------ 月岛
	    -- 天体裂隙
	    MOON_FISSURE =
		{
			GENERIC = "“祂”在试图干涉这里……和我的意志。",
			NOLIGHT = "“祂”的注视令裂隙扩张了。",-- 发光谷值时间段
		},

		MOON_ALTAR_ROCK_IDOL = "里面有东西想要重见天日。",	-- 吸引人的结构/被岩石包裹的天体祭坛雕像
		MOON_ALTAR_ROCK_GLASS = "里面有东西想要重见天日。",	-- 吸引人的结构/被岩石包裹的天体祭坛底座
		MOON_ALTAR_ROCK_SEED = "里面有东西想要重见天日。",	-- 吸引人的结构/被岩石包裹的天体祭坛宝球

		MOON_ALTAR_IDOL = "它想成为冠冕。",		-- 天体祭坛雕像
		MOON_ALTAR_GLASS = "它想成为基石。",	-- 天体祭坛底座
		MOON_ALTAR_SEED = "它想成为中流砥柱。",	-- 天体祭坛宝球

		-- 天体祭坛
		MOON_ALTAR =
		{
			MOON_ALTAR_WIP = "它渴望完整。",   -- 没完成
			GENERIC = "它在向我倾诉月的智慧。",	-- 完成
		},

		MOON_ALTAR_CROWN = "我得到它的过程似乎有什么在操控……",-- 未激活天体贡品
		MOON_ALTAR_COSMIC = "它在等待。",		             -- 天体贡品

		MOON_ALTAR_ASTRAL = "原来如此……我已经知晓剧目了。",-- 天体圣殿

		MOON_ALTAR_ICON = "圣殿的象征……原来如此。",		-- 天体圣殿象征
		MOON_ALTAR_WARD = "卫戍的象征……原来如此。",		-- 天体圣殿卫戍

        -- 月岛温泉
		HOTSPRING =
		{
			GENERIC = "野外的温泉……我想卫生或许是个问题。",
			BOMBED  = "沸腾了。",
			GLASS   = "月华冻人。",
			EMPTY   = "月色会将它再次盈满。",
		},

        DEAD_SEA_BONES = "我嗅得到它在空气中溺死时的绝望。", -- 海骨

        MOONGLASS_ROCK = "低浓度的固态月华。", -- 月光玻璃(月岛的玻璃矿)

		-- 浮木(月岛)
        DRIFTWOOD_TREE =
        {
            BURNING = "扎根汪洋，却无法灭火。",	-- 正在燃烧
            BURNT   = "海上的火葬。",		   -- 烧毁
            CHOPPED = "被砍倒了。",		       -- 砍完
            GENERIC = "风雨波涛将它漂白了。",   -- 正常
        },

        DRIFTWOOD_LOG = "它是中空的，这或许是它拥有更多浮力的原因。", -- 浮木桩(材料)

	------ 奶奶岛/寄居蟹隐士岛
	---注：瓶中信和瓶罐在杂物-自然生成栏

        HERMITCRAB = "孤独的老女士。",-- 寄居蟹隐士

        HERMIT_PEARL = "哦，好浓郁的情感执念。",		     -- 珍珠的珍珠
        HERMIT_CRACKED_PEARL = "他怀着怎样的心情将它捏碎呢？",-- 开裂珍珠

        -- 隐士之家
        HERMITHOUSE =
	    {
            GENERIC = "看起来有些破旧……这或许是她不高兴的原因？",
            BUILTUP = "现在她重新拥有了一个温暖舒适的家。",
        },

        MOON_FISSURE_PLUGGED = "等会儿……就这么简单？",-- 堵住的裂隙

        SHELL_CLUSTER = "一大团贝质垃圾。",		-- 贝壳堆


		-- 隐士温泉
		HERMITHOTSPRING  =
		{
			BOMBED  = "难怪尼禄如此推崇这种享受。",          -- 沸腾
			GENERIC = "只需放一个沐浴球，就可以开始享受了。", -- 普通
			EMPTY   = "水呢？",                            -- 干涸
		},
		HERMITHOTSPRING_CONSTR = "很快开业。", -- 隐士温泉(建造中)

		-- 隐士巨型晾肉架
		MEATRACK_HERMIT_MULTI =
		{
			DONE            = "制备完成。", -- 完成
			DRYING          = "稍安勿躁。", -- 干燥中
			DRYINGINRAIN    = "雨中干燥？", -- 雨中干燥
			GENERIC         = "加量不加架。", -- 普通
			BURNT           = "有些过火了。", -- 烧焦
			DONE_NOTMEAT    = "处理好了。", -- 非肉类完成
			DRYING_NOTMEAT  = "稍安勿躁。", -- 非肉类干燥中
			DRYINGINRAIN_NOTMEAT = "雨天可不适合晾晒。", -- 非肉类雨中干燥
			DONE_SALT       = "一举多得，不是吗？", -- 落下盐晶
			ABANDONED       = "没有那位老女士的维护，很快就废弃了。", -- 废弃
		},
		HERMITHOUSE_ORNAMENT = "适合独居老人。",        -- 隐士房屋装饰
		HERMITHOUSE_LAUNDRY = "……科雷，你认真的吗？",   -- 寄居蟹隐士的内衣

		-- 隐士螃蟹茶馆
		HERMITCRAB_TEASHOP =
		{
			GENERIC = "看来还没开门。", -- 珍珠不在
			ACTIVE  = "有什么自信推荐吗？", -- 珍珠在
			BREWING = "奇怪的地区性茶艺。", -- 泡茶中
			BURNT   = "毁于一旦。", -- 烧毁
		},

		-- 寄居蟹隐士灯柱
		HERMITCRAB_LIGHTPOST =
		{
			GENERIC = "装饰性的路灯。", -- 普通
			ABANDONED = "没有那位老女士的维护，很快就废弃了。", -- 废弃
		},
		HERMITCRAB_LIGHTPOST_ITEM = "只能安装在珍珠的房子附近。", -- 隐士螃蟹灯柱物品形式

	------ 瓶罐交易
		TACKLESKETCH = "她很有商业头脑。", -- {item}广告

		CHUM = "海里的鱼会争抢它。", -- 鱼食

		OCEANFISHINGLURE_HERMIT_RAIN = "雨天为什么还要钓鱼？", -- 雨天鱼饵
		OCEANFISHINGLURE_HERMIT_SNOW = "下雪了为什么要钓鱼？", -- 雪天鱼饵
		OCEANFISHINGLURE_HERMIT_DROWSY = "让鱼头晕目眩。",	  -- 麻醉鱼饵
		OCEANFISHINGLURE_HERMIT_HEAVY = "钓更大的鱼。",		  -- 重量级鱼饵

        HERMIT_BUNDLE = "委婉的谢意。",		   -- 一包谢意
        HERMIT_BUNDLE_SHELLS = "她卖的贝壳。", -- 贝壳钟包

		-- 贝壳钟
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "发出低阶音调。",		-- 低音贝壳钟
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "吟唱中音的贝壳。", -- 中音贝壳钟
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "它极尽所能地发出高音。",-- 高音贝壳钟
        },

		-- 沉底宝箱
        SUNKENCHEST =
        {
            GENERIC = "是谁把这些巨大的贝壳放进海里的？",
            LOCKED  = "锁住它的人或许不知道贝类很脆弱。", -- 锁住状态
        },

		-- 盐晶组合机
		SHELLWEAVER = "综合了海洋巫术的氯化钠工艺台。", -- 盐晶组合机
		ICESTAFF2 	= "现在风之冬尽在掌握。", -- 闪冻魔杖
		ICESTAFF3 	= "感受宇宙深空的冰寒。", -- 深冻魔杖
		NONSLIPGRIT = "强化摩擦力。", -- 防滑粉
		NONSLIPGRITBOOSTED = "义务除冰。", -- 防滑颗粒
		DESICCANT 		 =	 "便携式干爽。", -- 小包干燥剂
		DESICCANTBOOSTED = "比之沧海，仍为一粟。", -- 大包干燥剂
		HERMITCRAB_SHELL = "呼唤回归。", 	-- 搬运海螺
		SALTY_DOGHAT 	 = "准备皇家远征。", -- 咸狗帽
		SALTY_DOG		 = "你是采用伏特加还是杜松子酒作为基底的，小家伙？", -- 咸狗

    ------ 猴岛
	    MONKEYISLAND_PORTAL = "通往一个大航海时代的猴子宇宙。", -- 非自然传送门
	    MONKEYISLAND_PORTAL_DEBRIS = "他的技术水平比我估计的还要差。", -- 损坏的机器
	    MONKEYQUEEN = "平行宇宙的维多利亚？",  -- 月亮码头女王
	    MONKEYPILLAR = "看来猴子里还有木工。", -- 猴子柱
	    PIRATE_FLAG_POLE = "猴子就喜欢占山为王。",-- 月亮码头海盗旗
	    BLACKFLAG = "扬起黑帆，散布死亡。",		-- 黑旗

    ------ 古董船
		BOAT_ANCIENT_ITEM = "很有收藏价值。",	       -- 古董船套装
		BOAT_ANCIENT_CONTAINER = "运输量很强。",	   -- 货舱
		WALKINGPLANK_ANCIENT = "就不能造一艘救生船吗？",-- 古董木板

    ------ 暗影三祺子(三基佬)相关
        -- 可疑的大理石(骑士)
	    SCULPTURE_KNIGHTHEAD = "骑士的头颅掩埋于地。",

		-- 可疑的大理石雕像(骑士)
		SCULPTURE_KNIGHTBODY =
	    {
	        COVERED = "猜猜看，麦斯威尔，这是谁的手笔？",	-- 未开采
		    UNCOVERED = "骑士丢失了它的头脑。",	 -- 开采后
		    FINISHED = "现在它可以进行一场荣耀的决斗了。",   -- 修好
		    READY = "它已经迫不及待了。",		 -- 疑似月圆/月黑时颤动
	    },

		-- 可疑的大理石(主教)
		SCULPTURE_BISHOPHEAD = "主教的冠冕蒙尘凡间。",

		-- 可疑的大理石雕像(主教)
		SCULPTURE_BISHOPBODY =
	    {
		    COVERED = "猜猜看，麦斯威尔，这是谁的手笔？", -- 未开采
		    UNCOVERED = "主教遗失了它的冠冕。",		-- 开采后
		    FINISHED = "信奉黑暗的主教……真是有趣。", -- 修好
		    READY = "它已经迫不及待了。",		     -- 疑似月圆/月黑时颤动
	    },

		-- 可疑的大理石(战车)
		SCULPTURE_ROOKNOSE = "战车的断角弃置荒野。",

		-- 可疑的大理石雕像(战车)
		SCULPTURE_ROOKBODY =
	    {
		    COVERED = "哈……这堆底料里别有玄机。", -- 未开采
		    UNCOVERED = "战车没有了它的撞角。",	  -- 开采后
		    FINISHED = "勉强能看得出是战车了。",   -- 修好
		    READY = "它已经迫不及待了。",		  -- 疑似月圆/月黑时颤动
	    },

	-----洞穴
	    POND_CAVE = "里面生活着不少鳗鱼。",  -- 洞穴池塘(鳗鱼池塘)
		POND_ALGAE = "有水的地方就有藻类。", -- 水藻

	-----远古
	    -- 远古壁画
        ATRIUM_RUBBLE =
        {
			LINE_1 = "当“祂”不再注视时，荒芜就在滋长。",			-- 第一行
			LINE_2 = "欲盖弥彰的残篇。",						   -- 第二行
			LINE_3 = "它们注意到了虚空……其实是虚空在凝视着它们。",	 -- 第三行
			LINE_4 = "一起不自量力所引发的悲剧。",				    -- 第四行
			LINE_5 = "虚假的繁荣，让它们看不见正在落下的帷幕。",     -- 第五行
		},

		-- 遗物(远古的石桌、石椅)
		RELIC =
        {
            GENERIC = "经历了漫长的时光。",
            BROKEN = "已经什么都不剩了。",
        },

        RUINS_RUBBLE = "破碎了。",	-- 损毁的废墟
        RUBBLE = "古老城市的石堆。", -- 碎石


		ANCIENT_STATUE = "暗影的信徒……",		    -- 远古雕像(未知是哪种)
		RUINS_STATUE_MAGE = "看起来它们曾盛极一时。",-- 远古雕像(可开采)
        ATRIUM_STATUE = "暗影的力量会令它致敬。",    -- 远古雕像(中庭)

		NIGHTMARELIGHT = "梦魇的巢穴，危险但迷人，不是吗？",-- 梦魇灯座

		ATRIUM_OVERGROWTH = "原来如此……",-- 远古方尖碑

		PANDORASCHEST = "冒险者最喜欢的环节。",-- 华丽箱子

		TREECLUMP = "一个谜题。",-- 远古宝箱

		-- 远古宝箱
		SACRED_CHEST =
		{
			GENERIC = "我听到低语了。它想要什么东西。",
			LOCKED = "它正在做出判断。",-- 抖动中
		},

		-- 远古灯柱
        ATRIUM_LIGHT =
        {
			ON = "暗影的力量在躁动。",		          -- 开启
			OFF = "没有暗影力量经流，只不过是跟石柱。",-- 关闭
		},


	-----月亮蘑菇林
	    GROTTO_POOL_BIG = "承接着被月光感染的海水。",-- 玻璃绿洲
        GROTTO_POOL_SMALL = "折射着月光的力量。",	 -- 小玻璃绿洲

		NIGHTMAREGROWTH = "来自虚空深处！",-- 梦魇城墙

    ------ 远古档案馆

        WALL_STONE_2 = "碍事的墙壁。",    -- 档案馆石墙
        WALL_RUINS_2 = "带有远古的气息。",-- 档案馆铥墙

		-- 知识饮水机
	    ARCHIVE_LOCKBOX_DISPENCER =
	    {
          POWEROFF = "知识像水一样涌入脑海。",
          GENERIC =  "知识像水一样涌入脑海。",
        },

	    ARCHIVE_ORCHESTRINA_MAIN = "这是远古的旋律，奇妙而拥有魔力。",-- 远古小合奏机

		ARCHIVE_LOCKBOX = "需要一种节奏令它解封。",-- 蒸馏的知识

	    MUSHGNOME = "月光塑造的活动真菌。",-- 蘑菇地精

        MOON_CAP = "会令人失去意识。",	         -- 月亮蘑菇
        MOON_CAP_COOKED = "高温破坏了它的药效。", -- 熟月亮蘑菇
        MUSHTREE_MOON = "似乎是从蓝蘑菇树转化而来的。", -- 月亮蘑菇树
		SPORE_MOON = "会破碎洒出月光。",               -- 月亮孢子

        -- 远古窑
		ARCHIVE_COOKPOT =
        {
            COOKING_LONG = "还没好呢。",
            COOKING_SHORT = "远古的石锅里面会烧出来什么？",
            DONE = "可以拿了。",
            EMPTY = "时间化作尘埃将它掩埋。",
            BURNT = "它逃过了时间，却逃不过火焰。", -- 烧毁
        },

        ARCHIVE_MOON_STATUE = "似乎记录着“祂”的一些信息。", -- 远古月亮雕像

		-- 远古月亮符文石
        ARCHIVE_RUNE_STATUE =
        {
            LINE_1 = "一种失落的语言，一段悲伤的往事……",	   -- 第一行
            LINE_2 = "也许我该使用一种悲叹的语调。",		   -- 第二行
            LINE_3 = "被暗影困扰，就以为月光高洁吗？",		   -- 第三行
            LINE_4 = "“化”……不错的形容，毕竟“祂”操弄着变化。",-- 第四行
            LINE_5 = "这里还留着那扇门？",		              -- 第五行
        },

		ARCHIVE_SECURITY_PULSE = "这是它们珍藏的月能。",-- 远古哨所脉冲

		-- 远古哨所
        ARCHIVE_SECURITY_DESK =
	    {
            POWEROFF = "它准备好了。",
            GENERIC = "它的力量还在凝聚。",
        },

		-- 华丽基座
        ARCHIVE_SWITCH =
	    {
            VALID = "重新运转了。",		         -- 有宝石
            GEMS = "需要一颗彩虹宝石来提供能量。", -- 缺宝石
        },

        -- 被封印的传送门
		ARCHIVE_PORTAL =
	    {
            POWEROFF = "怎么样才能打开？",-- 运转？
            GENERIC = "通往哪个世界？",   -- 封印的传送门
        },

	------ 远古圣殿
		OCEANWHIRLBIGPORTALEXIT = "从旋涡落下的东西都会堆积在这里。", -- 海洋漂浮物

		-- 追随者(一起踩石柱的雕像)
		ABYSSPILLAR_MINION =
		{
			GENERIC   = "我打赌它一会儿会活动起来。", -- 关闭
			ACTIVATED = "它在模仿我的轨迹……简单的谜题。", -- 激活
		},
		-- 圣殿谜题开关拉杆
		ABYSSPILLAR_TRIAL = "开始解谜吧。",

		-- 圣殿路标
		VAULT_TELEPORTER =
		{
			GENERIC   = "成熟的粒子传输技术……看来我需要重新评估那些虫豸的文明水平。", -- 普通
			BROKEN    = "时间，摧毁了一切。", -- 损坏
			UNPOWERED = "供能不足……似乎需要合成月能。", -- 无动力
		},
		VAULT_ORB        = "门钥匙。", -- 传送宝珠
		VAULT_LOBBY_EXIT = "谁不喜欢纵身跃入深渊？", -- 裂口
		VAULT_CHANDELIER_BROKEN = "一场溃灭的遗留物。", -- 破碎的宝库吊灯

		ANCIENT_HUSK = "啊，原来如此，真是一出好戏。", -- 远古遗骸

		MASK_ANCIENT_HANDMAIDHAT  = "你可曾预见自取灭亡的末路？", -- 远见者
		MASK_ANCIENT_ARCHITECTHAT = "被造物反噬的蠢物。", 		 -- 工匠
		MASK_ANCIENT_MASONHAT     = "领袖总要负担重任，不是吗？", -- 鞘翅

		-- 谜之火焰
		VAULT_TORCH =
		{
			GENERIC = "经典的益智游戏。", -- 普通
			BROKEN  = "这个的开关坏了。", -- 损坏
		},

        -- 舞台之手
		STAGEHAND =
        {
			AWAKE = "它会跟着光走。",
			HIDING = "充分的殴打会让它吐出秘密。",
        },

        -- 大理石雕像
		STATUE_MARBLE =
        {
            GENERIC = "审美有待提高。",
            TYPE1 = "勉强像模像样。",
            TYPE2 = "我很难表达赞美。",
            TYPE3 = "对真正艺术的一种模仿。",
        },

		STATUEHARP = "这种风格有点贴合我的审美。",	-- 竖琴雕像
		STATUEMAXWELL = "哈，那个蠢货这样看起来更蠢了！",-- 麦斯威尔雕像

        -- 舞台剧
        CHARLIE_STAGE_POST = "一位女士委婉的心声。",-- 舞台
        CHARLIE_LECTURN = "命运早已注定。",		    -- 剧本

        CHARLIE_HECKLER = "像我一样精益求精。",     -- 嘲鸫

        PLAYBILL_THE_DOLL = "提线木偶。",		-- 舞台剧玩偶

        STATUEHARP_HEDGESPAWNER = "象征着抗拒。",-- 荆棘密布的雕像

        HEDGEHOUND = "细嗅蔷薇。",		-- 蔷薇狼
        HEDGEHOUND_BUSH = "心有猛兽。",	-- 蔷薇丛
        MASK_DOLLHAT = "戴上面具，穿上戏服，迎接万众瞩目。",		-- 玩偶面具
        MASK_DOLLBROKENHAT = "戴上面具，穿上戏服，迎接万众瞩目。",	-- 开裂玩偶面具
        MASK_DOLLREPAIREDHAT = "戴上面具，穿上戏服，迎接万众瞩目。",-- 破碎玩偶面具
        MASK_BLACKSMITHHAT = "戴上面具，穿上戏服，迎接万众瞩目。",	-- 铁匠面具
        MASK_MIRRORHAT = "诱惑的象征。",		                  -- 镜子面具
        MASK_QUEENHAT = "令人怜惜的傀儡。",		                  -- 女王面具
        MASK_KINGHAT = "作家对他有复杂的感情。",		           -- 国王面具
        MASK_TREEHAT = "戴上面具，穿上戏服，迎接万众瞩目。",		-- 树木面具
        MASK_FOOLHAT = "戴上面具，穿上戏服，迎接万众瞩目。",		-- 小丑面具
        COSTUME_DOLL_BODY = "戴上面具，穿上戏服，迎接万众瞩目。",	-- 玩偶服
        COSTUME_QUEEN_BODY = "戴上面具，穿上戏服，迎接万众瞩目。",	-- 女王服
        COSTUME_KING_BODY = "戴上面具，穿上戏服，迎接万众瞩目。",	-- 国王服
        COSTUME_BLACKSMITH_BODY = "戴上面具，穿上戏服，迎接万众瞩目。",-- 铁匠服
        COSTUME_MIRROR_BODY = "戴上面具，穿上戏服，迎接万众瞩目。",	 -- 镜子服
        COSTUME_TREE_BODY = "戴上面具，穿上戏服，迎接万众瞩目。",	-- 树木服
        COSTUME_FOOL_BODY = "愚者，意味着可能性。",		           -- 小丑服

		-- 鱼人头
		MERMHEAD =
		{
			GENERIC = "一种野蛮的示威。",
			BURNT = "剁椒鱼头？",
		},

		-- 猪头
		PIGHEAD =
		{
			GENERIC = "一种野蛮的示威。",
			BURNT = "让我想起贞德。",
		},

		PIGKING = "肮脏、愚蠢但富有黄金的酋长。",-- 猪王

        -- 方尖碑(高理智)
		SANITYROCK =
		{
			ACTIVE = "它挡路了。",        -- 激活
			INACTIVE = "至少现在没挡路。", -- 未激活
		},

		-- 方尖碑(低理智)
		INSANITYROCK =
		{
			ACTIVE = "它挡路了。",		         -- 激活
			INACTIVE = "它还有相当一部分在地下。",-- 未激活
		},

---------- 恶意接管相关-------------------------------------------------------------
        --  幻灵捕获机
		GESTALT_CAGE =
		{
			GENERIC = "空空如也。",
			FILLED = "月神使徒也有被拘禁的一天。哈。",
		},

		--  战争瓦器人：
		WAGBOSS_ROBOT_SECRET = "这家伙保管会失控。",				-- 幕布状态
        WAGBOSS_ROBOT = "压榨月能，真是狂妄的想法。",				-- 开机
        WAGBOSS_ROBOT_POSSESSED = "……唉，狂妄之人总遭造物反噬。",	-- 开始失控
		--  战争瓦器人的腿
		WAGBOSS_ROBOT_LEG = "看起来是个合格的掩体。",
		WAGBOSS_ROBOT_CONSTRUCTIONSITE      = "一副过于经典的失控造物模样。", -- 战争瓦器人(未完工的盖着布的形态)
		WAGBOSS_ROBOT_CONSTRUCTIONSITE_KIT  = "他就学不会吸取教训吗？", -- 战争瓦器人建筑套装
		WAGBOSS_ROBOT_CREATION_PARTS        = "加工水平还算过关。", -- 战争瓦器人零件
		MOONSTORM_STATIC_CATCHER            = "亟待一位囚徒。", -- 静电约束仪
		COOLANT = "作为冷聚变的材料而言，堪称科幻。", -- 核化液

		--  天体仇灵
		ALTERGUARDIAN_PHASE1_LUNARRIFT = "卷土重来，止增笑耳。",
		--  纯粹虚影
		ALTERGUARDIAN_PHASE1_LUNARRIFT_GESTALT = "月所分行的意志，亦是精粹的能源。",
		--  天体后裔
        ALTERGUARDIAN_PHASE4_LUNARRIFT = "月之恶兽，你可知晓自己注定败亡？",
		-- 未约束的静电
        MOONSTORM_STATIC_ROAMER = "诞生自巨大时空扰动的奇迹火花。",

		--  满地爬
		WAGDRONE_ROLLING =
        {
            GENERIC = "它以为自己是什么？竖锯？",     --  敌对，活动
            INACTIVE = "它最好能当个扫地机器人。",    --  敌对，闲置
            DAMAGED = "可以修好……或者干脆回收？", --  损坏
            FRIENDLY = "工作效率底下的简单机仆。",    --  友好，活动
        },

		--  黄莺(飞行无人机)
        WAGDRONE_FLYING =
        {
            GENERIC = "烦人的铁苍蝇！",               --  敌对，活动
            INACTIVE = "它最好能当个飞行垃圾桶。",     --  敌对，闲置
            DAMAGED = "嗯，里面的核心还能回收利用。",  --  损坏
        },

		--  陀螺传导核心(修满地爬的)
		WAGDRONE_PARTS = "基础的工具核心……等等，它是什么能源？",

		--  无人机信标？存疑
		WAGDRONE_BEACON = "无形壁垒？他的技术突破的这个水平了？",

		--  概念制造器(奶奶岛的工作台)
        WAGPUNK_WORKSTATION = "那家伙又在生产垃圾山了。",

		--  杠杆选择器(战争瓦器人的拉杆)
        WAGPUNK_LEVER = "来吧，我接受挑战。",

		--  基底扩展器(老瓦给的新码头)
        WAGPUNK_FLOOR_KIT = "结实得足够在上面酣战一场……",

		--  动能场扩展器(生成能量墙的装置)
        WAGPUNK_CAGEWALL = "看起来像个陷阱……想让我做困兽之斗？",

		--  瓦格斯塔夫遗物
		WAGSTAFF_ITEM_1 = "这是实体……看来他这次是真的翻车了。", --  手套
		WAGSTAFF_ITEM_2 = "这是实体……看来“祂”这次忍无可忍了。", --  剪贴板

		--  隐士迁居套装
        HERMITCRAB_RELOCATION_KIT = "帮那位孤寡老人找一个新家。\n我也偶尔会发些善心。",

		--  流浪商人
        WANDERINGTRADER =
        {
            REVEALED = "希望你今天带了有用的东西。",    --  交易
            GENERIC = "嗯……实用主义的衣品。", --  非交易
        },

		--  敌对虚影
        GESTALT_GUARD_EVOLVED = "Keli到底在想什么？",

		--  个人漂浮装置
        FLOTATIONCUSHION = "原始但实用的海上保险。",

		--  天体宝珠
        LUNAR_SEED = "来自月神的战利品。",

		-- 生物尸体:
		-- 鸟尸体
		BIRDCORPSE =
		{
			GENERIC  = "看来没逃过死神。", -- 目睹
			BURNING  = "就让尘归尘，土归土。", -- 燃烧
			REVIVING = "可悲，甚至无法长眠。", -- 复活
		},

		-- 秃鹫尸体
		BUZZARDCORPSE =
		{
			GENERIC  = "看来没逃过死神。", -- 目睹
			BURNING  = "就让尘归尘，土归土。", -- 燃烧
			REVIVING = "唉……令人憎恶。", -- 复活
		},

		-- 变异秃鹫
		MUTATEDBUZZARD_GESTALT =
		{
			GENERIC         = "它那腐朽的身躯永不知餍足。",       -- 普通
			EATING_CORPSE   = "离开我的战利品……或者成为下一个！", -- 吃尸体
		},


		-- 企鹅尸体
		PENGUINCORPSE =
		{
			GENERIC  = "还没到尾声。", -- 目睹
			BURNING  = "划上休止符。", -- 燃烧
			REVIVING = "《还魂曲》序曲。", -- 复活
		},

		-- 蜘蛛尸体
		SPIDERCORPSE =
		{
			GENERIC = "死刑，已经执行。", -- 目睹
			BURNING = "可惜没有焚化炉。", -- 燃烧
			REVIVING = "连这个都要收为化身？真是低劣的品味。", -- 复活
		},

		-- 蜘蛛女王尸体
		SPIDERQUEENCORPSE =
		{
			GENERIC = "死罪。", -- 目睹
			BURNING = "算是我赦免了你的灵魂。", -- 燃烧
			REVIVING = "死罪可逃，活罪难免。", -- 复活
		},

		-- 鱼人尸体
		MERMCORPSE =
		{
			GENERIC  = "你会魂归何处？沼泽亦或那个遥远的祖地？", -- 目睹
			BURNING  = "我该再撒一把海盐。", -- 燃烧
			REVIVING = "印第茅斯的那些鱼木脑袋都比你安分得多。", -- 复活
		},

		-- 通用尸体
		GENERIC_CORPSE =
		{
			GENERIC  = "凡物终难逃一死，亲爱的。",  -- 目睹
			BURNING  = "就让尘归尘，土归土。",      -- 燃烧
			REVIVING = "我不记得有办尸体派对。",    -- 复活
		},

---------- 杂物	--------------------------------------------------------------------
    ------ 玩家制作&掉落物	----------------------------
		MAPSCROLL = "让我看看我未来的领土。",	-- 地图卷轴

		SPOILED_FOOD = "恶心！",-- 腐烂物

	------ 地皮
		TURF_DIRT = "平平无奇的泥土。",		-- 泥土地皮
        TURF_FOREST = "森林的缩影。",		-- 森林地皮
        TURF_GRASS = "清新的草原。",		-- 长草地皮
		TURF_MARSH = "滑腻恶心。",		    -- 沼泽地皮
		TURF_DESERTDIRT = "干燥得寸草不生。",-- 沙漠地皮
		TURF_MUD = "像是大雨磅礴之后。",	 -- 泥泞地皮
		TURF_BADLANDS = "彻底没有生命力的土壤可不多见。",	-- 恶地(？)
		TURF_DECIDUOUS = "落叶居然能渲染出这种黄昏的浪漫。",-- 落叶林地皮
		TURF_SAVANNA = "真是茂盛，让我有点想狩猎了。",	    -- 热带草原地皮
        TURF_WOODFLOOR = "不是柚木，甚至不是红杉木……",		-- 木地板
        TURF_CARPETFLOOR = "像是践踏牛的尸骨一样柔软舒适。",-- 地毯地板
		TURF_CARPETFLOOR2 = "太过柔软了，只能铺在卧室。",	-- 茂盛地毯
		TURF_DRAGONFLY = "龙与火都被我践踏于脚下！",		-- 龙鳞地板
        TURF_CHECKERFLOOR = "该布置棋子了。",		       -- 棋盘地板
		TURF_MOSAIC_GREY = "象征着灰暗的未来。",	-- 灰色马赛克地板
        TURF_MOSAIC_RED = "象征着猩红的未来。",		-- 红色马赛克地板
        TURF_MOSAIC_BLUE = "象征着蔚蓝的明天。",	-- 蓝色马赛克地板
        TURF_BEARD_RUG = "艺术家总有怪癖。",		-- 胡须地毯
		TURF_COTL_GOLD = "把金子揉碎铺在地上。",	-- 黄金地板
		TURF_COTL_BRICK = "很适合散步。",		    -- 砖地板
        TURF_METEOR = "阿姆斯特朗在这可留不下脚印。",-- 月球环形山地皮
		TURF_SHELLBEACH = "可以作为度假海滩。",		-- 贝壳海滩地皮
		TURF_SANDY = "里面有螃蟹在动？",		    -- 沙子地皮(疑似单机版海难内容)
		TURF_MONKEY_GROUND = "让我想起了那些海盗……害得我又想处刑一些了。",		-- 月亮码头海滩地皮
        TURF_PEBBLEBEACH = "没资格当我的私人海滩。",		-- 岩石海滩地皮
        TURF_ROAD = "走起来“独辟蹊径”。",		-- 卵石路
        TURF_ROCKY = "为什么不能用来当石材？",	-- 岩石地皮
		TURF_SINKHOLE= "低俗的品味。",		-- 黏滑地皮
		TURF_CAVE= "货真价实的垃圾。",		-- 鸟粪地皮
		TURF_FUNGUS= "真菌的疆土。",		-- 真菌地皮
		TURF_FUNGUS_GREEN = "这回是绿色的“菌株”在扩充领土。",-- 绿色真菌地皮
		TURF_FUNGUS_RED = "似乎暗示了小红帽的终局。",		-- 红色真菌地皮
		TURF_FUNGUS_MOON = "“祂”连这个都不放过吗？",		-- 变异真菌地皮
		TURF_UNDERROCK = "总觉得应该濒临悬崖。",               -- 洞穴岩石地皮
		TURF_RUINSBRICK = "这些纹理是传导暗影力量的回路。",		-- 远古地面
		TURF_RUINSBRICK_GLOW = "哈……看来有两个文明做了同样的事。",	-- 仿远古地面
		TURF_RUINSTILES = "黯淡无光。",	       	                 -- 远古瓷砖
		TURF_RUINSTILES_GLOW = "哈……看来有两个文明做了同样的事。",-- 仿远古瓷砖S
		TURF_RUINSTRIM = "黯淡无光。",		                     -- 远古砖雕
		TURF_RUINSTRIM_GLOW = "哈……看来有两个文明做了同样的事。", -- 仿远古砖雕
		TURF_ARCHIVE = "月岩混合铥矿……天才般的创意就用来干这个？",	-- 远古石刻(档案馆地皮)

        -- 雕塑
		CHESSPIECE_PAWN = "无名小卒。",		                  -- 卒子雕塑
	    CHESSPIECE_MUSE = "高傲的女王，我喜欢斩首她们。",		-- 女王雕塑
	    CHESSPIECE_FORMAL = "自大的国王，我不需要他们的臣服。",	-- 国王雕塑
	    CHESSPIECE_HORNUCOPIA = "丰饶富裕，永恒伴我。",		   -- 丰饶角雕塑
	    CHESSPIECE_PIPE = "泡沫里囚禁着回忆。",		           -- 泡泡烟斗雕塑
	    CHESSPIECE_BUTTERFLY = "月光最唯美的造物。",           -- 月蛾雕塑
	    CHESSPIECE_ANCHOR = "可以胜任一个真的锚。",		       -- 锚雕塑
	    CHESSPIECE_MOON = "“祂”的全貌可不是这样。",		       -- “月亮” 雕塑
		-- 三棋子雕塑/三基佬雕像
		-- 战车雕塑
		CHESSPIECE_ROOK =
		{
			GENERIC = "重量级的棋子。",
			STRUGGLE = "它已经迫不及待了！",-- 月圆与月黑时抖动
		},

		-- 骑士雕塑
		CHESSPIECE_KNIGHT =
		{
			GENERIC = "没什么荣誉可言。",
			STRUGGLE = "它已经迫不及待了！",-- 月圆与月黑时抖动
		},

		-- 主教雕塑
		CHESSPIECE_BISHOP =
		{
			GENERIC = "有着坚固的信仰。",
			STRUGGLE = "它已经迫不及待了！",-- 月圆与月黑时抖动
		},
	    -- BOSS系列
	    CHESSPIECE_MOOSEGOOSE = "很好，它没有带着它的蛋。",-- 麋鹿鹅雕塑
	    CHESSPIECE_ANTLION = "胆敢向我倨傲的狂徒不多。",   -- 蚁狮雕塑
	    CHESSPIECE_BEARGER = "秋狩的战利品。",		      -- 熊獾雕塑
	    CHESSPIECE_DEERCLOPS = "眼神不够灵动。",	      -- 独眼巨鹿雕塑
	    CHESSPIECE_DRAGONFLY = "现在它不会发火了。",      -- 龙蝇雕塑
	    CHESSPIECE_DAYWALKER = "可悲的狂徒。",		     -- 噩梦猪人雕像
	    CHESSPIECE_MINOTAUR = "它没能守护任何东西。",	  -- 远古守护者雕塑
	    CHESSPIECE_STALKER = "一名悔恨的亡国君。",		  -- 远古织影者雕塑
	    CHESSPIECE_TOADSTOOL = "……给了我点创造的灵感。", -- 毒菌蟾蜍雕塑
	    CHESSPIECE_DEERCLOPS_MUTATED = "眼神很锐利。",	 -- 晶体独眼巨鹿雕塑
	    CHESSPIECE_WARG_MUTATED = "一次斗犬胜利的留念。", -- 附身座狼雕塑
	    CHESSPIECE_BEARGER_MUTATED = "它当时很好动。",	 -- 装甲熊獾雕塑
	    CHESSPIECE_GUARDIANPHASE3 = "月的哨兵。",		 -- 天体英雄雕塑
	    CHESSPIECE_EYEOFTERROR = "充分说明了我更恐怖。",  -- 恐怖之眼雕塑
	    CHESSPIECE_TWINSOFTERROR = "异世界的使徒。",	 -- 双子魔眼雕塑
	    CHESSPIECE_MALBATROSS = "一次海猎的纪念。",	 	  -- 邪天翁雕塑
	    CHESSPIECE_CRABKING = "固守城堡的疯王，手下败将。",-- 帝王蟹雕塑
	    CHESSPIECE_KLAUS = "我更想要一个标本。",		  -- 克劳斯雕塑
	    CHESSPIECE_BEEQUEEN = "我斩杀过的女王。",		  -- 蜂王雕塑
	    -- 活动雕塑
	    CHESSPIECE_CARRAT = "看起来很惬意。",		-- 胡萝卜鼠雕塑
	    CHESSPIECE_BEEFALO = "毛发的雕刻有待精进。", -- 皮弗娄牛雕塑
	    CHESSPIECE_KITCOON = "小家伙们很喜欢这个。",		-- 小浣猫雕塑
	    CHESSPIECE_CATCOON = "没事，只是石头做的猫。",		-- 浣猫雕塑
	    CHESSPIECE_MANRABBIT = "素食主义者会喜欢这个。",    -- 兔人雕塑
	    CHESSPIECE_CLAYHOUND = "我可以塑造出更好的。",		-- 猎犬雕塑
	    CHESSPIECE_CLAYWARG = "我可以塑造出更好的。",		-- 座狼雕塑
		CHESSPIECE_YOTD = "游龙戏水。",                   -- 龙蝇年雕像
		CHESSPIECE_DEPTHWORM  = "诡异的审美。",          -- 蠕虫年雕像

    ------ 自然生成----------------------------------
		TUMBLEWEED = "荒野的礼物。",--  风滚草

		MESSAGEBOTTLE = "用深情的文字标记了一座小岛。",	-- 瓶中信
		MESSAGEBOTTLEEMPTY = "已经空了。",             -- 空瓶子

		WETPAPER = "上面写了什么？",	 -- 湿纸(未知？)
		WETPOUCH = "这是什么人丢进去的？",-- 起皱的包裹

		SCRAPBOOK_PAGE = "一些记录，",-- 丢失的图鉴页面

		BLUEPRINT = "智慧的纸质向导。",-- 蓝图

		SKETCH = "雕像的草图。",-- {item}草图

		COOKINGRECIPECARD =
		{
			GENERIC = "一张厨艺教学。",	-- {item}食谱
		},

		-- 灰烬
		ASH =
		{
			GENERIC = "对烈火最后的控诉，很快就会随风消散。",--  默认
			-- 单机版传送到冒险模式导致物品化灰专用
			REMAINS_GLOMMERFLOWER = "我可怜的花没能撑过去。",
			REMAINS_EYE_BONE = "眼骨在传送中变成了灰烬。",
			REMAINS_THINGIE = "无论什么东西，最终都会回归大地。",
		},

		COTL_TRINKET = "某位古神的信物。",-- 红眼冠
		ANTLIONTRINKET = "有些幼稚。",    -- 沙滩玩具

        -- 玩具
        TRINKET_1  = "谁会喜欢这个？",    -- 熔化的弹珠
		TRINKET_2  = "还好是假的。",      -- 假卡祖笛
		TRINKET_3  = "有趣。",            -- 戈尔迪之结
		TRINKET_4  = "我杀过活的。",      -- 地精爷爷
		TRINKET_5  = "逃脱重力的妄想。",   -- 迷你火箭
		TRINKET_6  = "报废的垃圾。",       -- 烂电线
		TRINKET_7  = "又一个无聊的玩具。", -- B杯子和球
		TRINKET_8  = "我不需要它。",       -- 硬化橡胶塞
		TRINKET_9  = "简直是累赘。",       -- 不搭的纽扣
		TRINKET_10 = "我那些满地找牙的囚犯会需要这个。",-- 二手假牙
		TRINKET_11 = "WX-78会怎么看这个?", -- 机器人玩偶
		TRINKET_12 = "它腐烂了。",         -- 干瘪的触手
		TRINKET_13 = "我还没杀过这个。",   -- 地精奶奶
		TRINKET_14 = "这东西只会让下午茶变成一场酷刑。", -- 漏水的茶杯
		TRINKET_15 = "也许它会带来一些好的征兆。", -- 白色主教
		TRINKET_16 = "不祥的征兆。",         -- 黑色主教
		TRINKET_17 = "尤里·盖勒的经典把戏。",       -- 弯曲的叉子
		TRINKET_18 = "不要浪费我的时间。",    -- 玩具木马
		TRINKET_19 = "我的时间不够了，停下来。", -- 失衡陀螺
		TRINKET_20 = "这些东西总是会干扰我的任务！", -- 痒痒挠
		TRINKET_21 = "只是一个坏掉的烹饪工具。",-- 破搅拌器
		TRINKET_22 = "这里没有裁缝。。",       -- 磨损的纱线
		TRINKET_23 = "这里没有鞋匠。",        -- 鞋拔子
		TRINKET_24 = "无聊的迷信。",         -- 幸运猫扎尔
		TRINKET_25 = "拿开！",               -- 臭气制造器
		TRINKET_26 = "两者合一？",           -- 土豆杯
		TRINKET_27 = "我的衣柜不需要衣架。",  -- 钢丝衣架
		TRINKET_28 = "我不应该走这一步的。",  -- 白色战车
        TRINKET_29 = "将军。",              -- 黑色战车
        TRINKET_30 = "保持前进。",          -- 白色骑士
        TRINKET_31 = "胜利只属于我。",      -- 黑色骑士
		-- 万圣夜玩具
        TRINKET_32 = "只是装饰品。",        -- 立方氧化锆球
        TRINKET_33 = "我不喜欢虫子。",       -- 蜘蛛指环
        TRINKET_34 = "诸多许愿机之中最无用的那款。", -- 猴爪
        TRINKET_35 = "这不像是我吃完那瓶。",   -- 空的长生不老药
        TRINKET_36 = "德古拉已经上年纪了吗？", -- 人造尖牙
        TRINKET_37 = "无聊的传说。",          -- 断桩
        TRINKET_38 = "一个筒就够了。",         -- 双筒望远镜
        TRINKET_39 = "戴上它只会让我感到麻烦。", -- 单只手套
        TRINKET_40 = "太小了。",               -- 蜗牛秤
        TRINKET_41 = "恶心。",                 -- 黏液罐
        TRINKET_42 = "虚假的威胁。",          -- 玩具眼镜蛇
        TRINKET_43 = "虚假的威胁。",          -- 鳄鱼玩具
        TRINKET_44 = "我没时间。",           -- 破碎的玻璃罐
        TRINKET_45 = "呵……它在邀请我奔向异星。", -- 奇怪的收音机
        TRINKET_46 = "没什么用。",           -- 损坏的吹风机

		-- 小惊吓丢失的道具
		LOST_TOY_1  = "别妨碍我。",		-- 遗失的玻璃球
        LOST_TOY_2  = "别妨碍我。",		-- 多愁善感的卡祖笛
        LOST_TOY_7  = "别妨碍我。",		-- 珍视的抽线陀螺
        LOST_TOY_10 = "别妨碍我。",		-- 缺少的牙齿
        LOST_TOY_11 = "别妨碍我。",		-- 珍贵的玩具机器人
        LOST_TOY_14 = "别妨碍我。",		-- 妈妈最爱的茶杯
        LOST_TOY_18 = "别妨碍我。",		-- 宝贵的玩具木马
        LOST_TOY_19 = "别妨碍我。",		-- 最爱的陀螺
        LOST_TOY_42 = "别妨碍我。",		-- 装错的玩具眼镜蛇
        LOST_TOY_43 = "别妨碍我。",		-- 宠爱的鳄鱼玩具

---------- 活动内容 ----------------------------------------------------------------------------------------------------------
        -- 暴食 -------------------------------------------------------------------------------------------------------------
		-- 残破的房子
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "他们都走了。",
            "这里曾经有人居住。",
            "这里的人都离开了。",
        },

		QUAGMIRE_RUBBLE_CARRIAGE = "无处可往。",	-- 破烂的马车
		QUAGMIRE_RUBBLE_CLOCK = "钟，被敲坏了。",	-- 砸烂的时钟
		QUAGMIRE_RUBBLE_CATHEDRAL = "再也不会有人祈“倒”了。",	-- 残破的大教堂
		QUAGMIRE_RUBBLE_PUBDOOR = "没门。",	-- 残破的门
		QUAGMIRE_RUBBLE_ROOF = "有人上房揭瓦了。",	-- 残破的屋顶
		QUAGMIRE_RUBBLE_CLOCKTOWER = "那口钟寿终正寝了。",	-- 残破的钟楼
		QUAGMIRE_RUBBLE_BIKE = "不幸。",	-- 损毁的自行车

		QUAGMIRE_RUBBLE_CHIMNEY = "那个烟囱灰飞烟灭了。",	-- 残破的烟囱1
		QUAGMIRE_RUBBLE_CHIMNEY2 = "那个烟囱灰飞烟灭了。",	-- 残破的烟囱2
		QUAGMIRE_MERMHOUSE = "这个小房子真丑啊。",	-- 鱼人屋
		QUAGMIRE_SWAMPIG_HOUSE = "以前没这么糟。",	-- 破烂的猪屋
		QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "某只猪的窝被毁了。",	-- 房子碎石

		-- 饕餮祭坛
		QUAGMIRE_ALTAR =
		{
			GENERIC = "它还在渴求更多。",
			FULL    = "它暂时满足了。",
		},

		QUAGMIRE_ALTAR_STATUE1 = "祂就是此地的君主？",	-- 饥饿之兽/饕餮

		QUAGMIRE_PARK_FOUNTAIN = "它和水连在一起很长时间了。",	-- 喷泉

		QUAGMIRE_HOE = "这是一种农具。",	-- 锄头

		QUAGMIRE_TURNIP = "是个生萝卜。",	               -- 大萝卜
		QUAGMIRE_TURNIP_COOKED = "做饭就是将科学付诸实践。",-- 烤大萝卜
		QUAGMIRE_TURNIP_SEEDS = "一把古怪的种子。",	        -- 圆形种子

		QUAGMIRE_GARLIC = "第一口气清新剂。",	    -- 大蒜
		QUAGMIRE_GARLIC_COOKED = "完美的焦黄。",	-- 烤大蒜
		QUAGMIRE_GARLIC_SEEDS = "一把古怪的种子。",	-- 种子荚

		QUAGMIRE_ONION = "看起来很脆。",	            -- 洋葱
		QUAGMIRE_ONION_COOKED = "一次成功的化学反应。",	-- 烤洋葱
		QUAGMIRE_ONION_SEEDS = "一把古怪的种子。",	    -- 尖形种子

		QUAGMIRE_POTATO = "埋在地下的苹果。",	        -- 土豆
		QUAGMIRE_POTATO_COOKED = "一次成功的温度实验。",-- 烤土豆
		QUAGMIRE_POTATO_SEEDS = "一把古怪的种子。",	    -- 毛茸茸的种子

		QUAGMIRE_TOMATO = "红色的，满满都是科学。",	            -- 番茄
		QUAGMIRE_TOMATO_COOKED = "懂化学的话做饭就非常简单了。",-- 烤番茄
		QUAGMIRE_TOMATO_SEEDS = "一把古怪的种子。",	           -- 带刺的种子

		QUAGMIRE_MEALINGSTONE = "日常差事。",	  -- 碾磨石

		QUAGMIRE_FLOUR = "可以烘焙了。",	-- 面粉

		QUAGMIRE_WHEAT = "它看起来是颗粒状的。",	-- 小麦
		QUAGMIRE_WHEAT_SEEDS = "一把古怪的种子。",	-- 蓝色种子

		QUAGMIRE_CARROT_SEEDS = "一把古怪的种子。",	-- 椭圆形种子

		QUAGMIRE_ROTTEN_CROP = "我认为这个不适合出现在祭坛上。",-- 腐烂的农作物

		QUAGMIRE_SALMON = "嗯，新鲜的鱼。",	        -- 三文鱼
		QUAGMIRE_SALMON_COOKED = "可以端上餐桌了。",-- 熟三文鱼

		QUAGMIRE_PEBBLECRAB = "那块石头是活的！",-- 石蟹
		QUAGMIRE_CRABMEAT = "没什么好模仿的。",  -- 蟹肉
		QUAGMIRE_CRABMEAT_COOKED = "在紧要关头，我可以做出一顿美餐。",-- 熟蟹肉

		-- 糖木树
		QUAGMIRE_SUGARWOODTREE =
		{
			GENERIC = "能够生产甜蜜的树糖。",
			STUMP = "为什么会砍这个？",		     -- 砍剩树桩
			TAPPED_EMPTY = "还没有汁液。",		-- 空了
			TAPPED_READY = "树糖已经溢出了。",	 -- 满了
			TAPPED_BUGS = "吸引了这些爬虫。",	 -- 有蚂蚁
			WOUNDED = "看起来不再能产生树糖了。", -- 生病了
		},

		QUAGMIRE_SAPBUCKET = "我们可以用它采集树液。",-- 树液采集工具包
		QUAGMIRE_SAP = "尝起来是甜的。",	-- 汁液

		-- 带斑点的小灌木
		QUAGMIRE_SPOTSPICE_SHRUB =
		{
			GENERIC = "紫色灌木。",
			PICKED = "都摘完了。",	-- 采摘完状态
		},

		QUAGMIRE_SPOTSPICE_SPRIG = "我可以把它磨碎了做香料。",-- 带斑点的小枝
		QUAGMIRE_SPOTSPICE_GROUND = "风味十足。",	         -- 斑点香料

		QUAGMIRE_POND_SALT = "可以提取盐分。",	-- 盐池

		QUAGMIRE_SALT_RACK_ITEM = "用来提取池塘里的盐。",	-- 盐架(物品)
		-- 盐架(建筑)
		QUAGMIRE_SALT_RACK =
		{
			READY = "现在有盐了。",		-- 满的
			GENERIC = "它还没上架呢。",
		},

		QUAGMIRE_SALTROCK = "盐。最有滋味的矿物。",-- 盐晶
		QUAGMIRE_SALT = "满满的盐。",	          -- 盐

		QUAGMIRE_KEY = "看起来适配保险箱。",	 -- 钥匙
		QUAGMIRE_KEY_PARK = "是那个铁门的钥匙。",-- 铁钥匙
		QUAGMIRE_PORTAL_KEY = "穿越位面的关键。",-- 远古钥匙

		-- 保险箱
		QUAGMIRE_SAFE =
		{
			GENERIC = "里面或许有些私人藏品。",
			LOCKED = "可以用蛮力破坏吗？",		-- 锁着
		},

		-- 蘑菇(作物)
		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "很小的蘑菇。",
			PICKED = "需要时间生长。",-- 采摘完状态
		},
		QUAGMIRE_MUSHROOMS = "这些是可以吃的蘑菇。",-- 蘑菇

		-- 沼泽猪长老
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "这只猪经受疾病的折磨。",
            SLEEPING = "它在睡觉。",
        },

		QUAGMIRE_SWAMPIG = "毛发旺盛的家伙。",-- 沼泽猪

		-- 疑似饕餮祭品
        QUAGMIRE_FOOD =
        {
        	GENERIC = "去试试吧。",
            MISMATCH = "那大嘴不想要这个。",
            MATCH = "天上的大嘴喜欢这个。",
            MATCH_BUT_SNACK = "我希望这些足够了。",
        },

		-- 铁门
        QUAGMIRE_PARK_GATE =
        {
            GENERIC = "现在任我通行了。",
            LOCKED = "表示一种拒绝。",		-- 锁着
        },

		-- 鸽子
        QUAGMIRE_PIGEON =
        {
            DEAD = "它失去了活力。",		-- 死了
            GENERIC = "它有什么用？",		-- 默认
            SLEEPING = "或许现在可以抓住它。",		-- 睡着了
        },

		QUAGMIRE_LAMP_POST = "嗯，让我想起了家。",	-- 街灯

		QUAGMIRE_BEEFALO = "科学说它应该死透了。",	-- 老皮弗娄牛
		QUAGMIRE_SLAUGHTERTOOL = "用于牲畜的外科工具。",	-- 屠宰工具

		QUAGMIRE_SAPLING = "我从中弄不到其他东西。",	-- 树苗
		QUAGMIRE_BERRYBUSH = "浆果全没了。",	-- 浆果丛

		QUAGMIRE_ALTAR_STATUE2 = "看什么看？",	-- 饥饿之兽
		QUAGMIRE_ALTAR_QUEEN = "一座有纪念意义的纪念碑。",	-- 女王野兽
		QUAGMIRE_ALTAR_BOLLARD = "就柱子而言, 这根足够了。",	-- 柱子
		QUAGMIRE_ALTAR_IVY = "有点粘人。",	-- 常春藤

		QUAGMIRE_LAMP_SHORT = "亮起来。.",	-- 小街灯

		QUAGMIRE_FERN = "可能富含维生素。",	-- 蕨类植物
		QUAGMIRE_FOLIAGE_COOKED = "我们煮了树叶。",	-- 熟叶子
		QUAGMIRE_COIN1 = "我的想法可值不止这点钱。",	-- 旧硬币
		QUAGMIRE_COIN2 = "不少硬币呢。",	-- 蓝宝石徽章
		QUAGMIRE_COIN3 = "似乎很有价值。",	-- 红色马克硬币
		QUAGMIRE_COIN4 = "可以用它们重新打开大门。",	-- 饕餮的惠赠
		QUAGMIRE_GOATMILK = "挺好的，只要你别去想它的来源。",	-- 羊奶
		QUAGMIRE_SYRUP = "加一点甜味。",	-- 糖浆
		QUAGMIRE_SAP_SPOILED = "还不如把它扔进火里。",	-- 毁掉的汁液
		QUAGMIRE_SEEDPACKET = "播什么种？",	-- 种子包

		QUAGMIRE_POT = "这个能装更多配料。",	-- 大锅
		QUAGMIRE_POT_SMALL = "我们来做饭吧！",	-- 锅
		QUAGMIRE_POT_SYRUP = "我需要给这锅东西增加甜味。",	-- 糖浆锅
		QUAGMIRE_POT_HANGER = "它带有挂钩。",	-- 挂锅装置
		QUAGMIRE_POT_HANGER_ITEM = "用来悬挂炊具。",	-- 挂锅装置
		QUAGMIRE_GRILL = "我现在就差一个摆放它的后院了。",	-- 大烤架
		QUAGMIRE_GRILL_ITEM = "“烤”问利器。",	-- 大烤架
		QUAGMIRE_GRILL_SMALL = "烤出好味道。",	-- 小烤架
		QUAGMIRE_GRILL_SMALL_ITEM = "用来烤小块肉。",	-- 小烤架
		QUAGMIRE_OVEN = "需要加些材料才会有化学反应。",	-- 烤箱
		QUAGMIRE_OVEN_ITEM = "科学燃烧用品。",	-- 烤箱
		QUAGMIRE_CASSEROLEDISH = "一道加了各种调料的菜。",	-- 大法国砂锅
		QUAGMIRE_CASSEROLEDISH_SMALL = "可以做各种杂七杂八的小菜。",	-- 小法国砂锅
		QUAGMIRE_PLATE_SILVER = "镀银的盘子。",	-- 银盘
		QUAGMIRE_BOWL_SILVER = "一只明亮的碗。",	-- 银碗
		QUAGMIRE_CRATE = "厨房用具。",	-- 大型烤架套装、烤架套装、烤箱套装、锅具套装

		QUAGMIRE_MERM_CART1 = "里面有什么科学原理吗？", -- 萨米的货车
		QUAGMIRE_MERM_CART2 = "有些东西我能用得上。", -- 皮普顿的马车
		QUAGMIRE_PARK_ANGEL = "接招！",	-- 饕餮敬拜者
		QUAGMIRE_PARK_ANGEL2 = "真是栩栩如生。",	-- 饕餮敬拜者
		QUAGMIRE_PARK_URN = "尘归尘。",	-- 骨灰瓮
		QUAGMIRE_PARK_OBELISK = "一座有纪念意义的纪念碑。",	-- 石柱

		QUAGMIRE_PARKSPIKE = "它的学名应该是“锋利、尖锐的东西”。",	-- 铁栅栏
		QUAGMIRE_CRABTRAP = "螃蟹陷阱。",	-- 螃蟹陷阱
		QUAGMIRE_TRADER_MERM = "也许他们愿意交换。",	-- 萨米\n头脑清晰的泥沼鱼人
		QUAGMIRE_TRADER_MERM2 = "也许他们愿意交换。",	-- 皮普顿\n清醒的泥沼鱼人

		QUAGMIRE_GOATMUM = "让我想起了我的老保姆。",	-- 玛姆茜
		QUAGMIRE_GOATKID = "这只山羊小得多。",	-- 比利

		-- 熔炉 -------------------------------------------------------------------------------------------------------------
		-- 远古大门
		LAVAARENA_PORTAL =
        {
            ON = "通往一个火热的世界。",     -- 开启
            GENERIC = "他们躲在门后的世界。",
        },

		LAVAARENA_BOARLORD = "他就是这儿的首领。",-- 战斗大师普格纳(NPC)

        -- 怪物
        BOARON = "无名小卒。",		       -- 战猪
        PEGHOOK = "阴险的毒物。",		    -- 蝎子
        TRAILS = "I'm stronger than you!",-- 野猪猩
        TURTILLUS = "缩头乌龟。",		    -- 坦克龟
        SNAPPER = "拙劣的督军，我会先将你斩首！",-- 鳄鱼指挥官
		BOARRIOR = "精悍的战士。",		               -- 大熔炉猪战士
		RHINODRILL = "别担心，你们会一起灭亡！",		-- 后扣帽犀牛兄弟
		BEETLETAUR = "强壮的地狱武士，我有点想奴役它。",-- 地狱独眼巨猪

		-- 武器
		LAVAARENA_LUCY = "哈！唱唱女士的愤怒！",-- 暴怒的露西
        HEALINGSTAFF = "起死回生。",		-- 生命魔杖
        FIREBALLSTAFF = "让烈火焚烧！",		-- 地狱魔杖
        HAMMER_MJOLNIR = "有人比我更适合它。",		-- 锻锤
        SPEAR_GUNGNIR = "不适合我，但可以将就。",	-- 尖齿矛
        BLOWDART_LAVA = "如果有的选，我不想用它。",	-- 吹箭
        BLOWDART_LAVA2 = "这不是我的武器。",	   -- 熔化吹箭
        WEBBER_SPIDER_MINION = "它能做到什么？",   -- 蜘蛛宝宝
		LAVAARENA_BERNIE = "或许能利用他进行干扰。",-- 伯尼
		LAVAARENA_ELEMENTAL = "它没有心，但很热情！",-- 岩浆傀儡
        BOOK_FOSSIL = "索多玛的灾罚，而今将重现！",	-- 石化之书
		SPEAR_LANCE = "来自残火的余烬吗？",		   -- 螺旋矛
		BOOK_ELEMENTAL = "沟通异世界的生命。",	   -- 召唤之书

		-- 护甲
		LAVAARENA_ARMORLIGHT = "轻巧，但不算很耐用。",	-- 芦苇束腰外衣
		LAVAARENA_ARMORLIGHTSPEED = "轻巧，方便走动。",	-- 羽饰芦苇外衣
		LAVAARENA_ARMORMEDIUM = "它的保护力还不错。",	-- 木质护甲
		LAVAARENA_ARMORMEDIUMDAMAGER = "有了它我能攻击得猛烈一点。",	-- 锯齿木甲
		LAVAARENA_ARMORMEDIUMRECHARGER = "穿上它，我就有能量多耍几招。",	-- 丝带木甲
		LAVAARENA_ARMORHEAVY = "这真是极好的。",	-- 石头板甲
		LAVAARENA_ARMOREXTRAHEAVY = "这副盔甲已经石化，提供最大程度的保护。",	-- 坚固的石质护甲
		LAVAARENA_ARMOR_HP = "它应该能保护我的安全。",	-- 华丽巨齿铠甲、华丽坚固盔甲、华丽低语盔甲、华丽丝带盔甲

		-- 头盔
		LAVAARENA_FEATHERCROWNHAT = "我一看见那些蓬松的羽毛就想跑！",	-- 羽毛头环
		LAVAARENA_HEALINGFLOWERHAT = "这花朵和治愈魔法很合拍。",	-- 花饰头带
		LAVAARENA_LIGHTDAMAGERHAT = "能加点攻击。",	-- 带刺头盔
		LAVAARENA_STRONGDAMAGERHAT = "好像能加很多攻击。",	-- 司夜女神头盔
		LAVAARENA_TIARAFLOWERPETALSHAT = "似乎能增强治愈力。",	-- 编织花环
		LAVAARENA_EYECIRCLETHAT = "饱含科学的凝视。",	-- 洞察皇冠
		LAVAARENA_RECHARGERHAT = "那些水晶的力量加速了我的能力。",	-- 水晶头饰
		LAVAARENA_HEALINGGARLANDHAT = "这花环能给我回点血。",	-- 绽放花环
		LAVAARENA_CROWNDAMAGERHAT = "那家伙能造成巨大破坏。",	-- 华丽的司夜女神头盔

		LAVAARENA_FIREBOMB = "闻起来像硫磺。",	-- 炉火晶石
		LAVAARENA_HEAVYBLADE = "看起来很锋利的工具。",	-- 铁匠的刀刃

		-- 鸦年华 	-----------------------------------------------------------------------------------------------------------
		CARNIVAL_HOST = "他的咏叹调有点浮夸。",-- 良羽鸦
		CARNIVAL_CROWKID = "好动的小家伙。",   -- 小乌鸦

		CARNIVAL_GAMETOKEN = "嘉年华的代币。",-- 鸦年华代币

		-- 奖票
		CARNIVAL_PRIZETICKET =
		{
			GENERIC = "胜者之证。",             -- 一张
			GENERIC_SMALLSTACK = "小赢一笔。",  -- 一小笔
			GENERIC_LARGESTACK = "不错的一笔。",-- 一大笔
		},

		CARNIVALGAME_FEEDCHICKS_KIT = "要安装这个？",		-- 鸟鸟吃虫虫套装
		CARNIVALGAME_FEEDCHICKS_STATION =
		{
			GENERIC = "……有些无聊的游戏。",
			PLAYING = "好了好了，一个个来。",
		},
		CARNIVALGAME_FEEDCHICKS_NEST = "它饿坏了。",        -- 饥饿乌鸦
		CARNIVALGAME_FEEDCHICKS_FOOD = "那些鸟喜欢吃这个……",-- 蛴螬

		CARNIVALGAME_MEMORY_KIT = "小鸟们的游戏。",		-- 篮中蛋套装
		-- 篮中蛋
		CARNIVALGAME_MEMORY_STATION =
		{
			GENERIC = "这个真的好玩吗？",
			PLAYING = "这对我来说太简单了。",
		},
		-- 蛋篮
		CARNIVALGAME_MEMORY_CARD =
		{
			GENERIC = "缩回去了。",
			PLAYING = "那里面会是什么？",
		},

		CARNIVALGAME_HERDING_KIT = "跟小鸟玩的游戏。",-- 追蛋套装
		-- 追蛋
		CARNIVALGAME_HERDING_STATION =
		{
			GENERIC = "这个真的好玩吗?",
			PLAYING = "我想我在浪费时间……",
		},
		CARNIVALGAME_HERDING_CHICK = "我在做什么啊……",	-- 追蛋

		CARNIVALGAME_SHOOTING_KIT = "又一个无聊的游戏……",-- 保卫鸟巢套装
		-- 保卫鸟巢游戏
		CARNIVALGAME_SHOOTING_STATION =
		{
			GENERIC = "为什么无聊的游戏可以这么多？",
			PLAYING = "开始了，要保护这些蛋。",
		},

		-- 射击靶
		CARNIVALGAME_SHOOTING_TARGET =
		{
			GENERIC = "藏好了？",
			PLAYING = "我的处决弹呢？",
		},
		-- 开火按钮
		CARNIVALGAME_SHOOTING_BUTTON =
		{
			GENERIC = "我甚至可以一直按这个。",
			PLAYING = "开火了。",
		},

		CARNIVALGAME_WHEELSPIN_KIT = "真是无聊……",-- 布谷鸟转盘套装
		-- 布谷鸟转盘
		CARNIVALGAME_WHEELSPIN_STATION =
		{
			GENERIC = "我们还在浪费时间……",
			PLAYING = "转起来了。",
		},

		CARNIVALGAME_PUCKDROP_KIT = "这实在太幼稚了。",-- 鸟房落球套装
		-- 鸟房落球游戏
		CARNIVALGAME_PUCKDROP_STATION =
		{
			GENERIC = "啊……无聊的游戏……",
			PLAYING = "或许正在消耗的是我的意志……",
		},

		CARNIVAL_PRIZEBOOTH_KIT = "战利品展示柜，但还是很无聊……",-- 奖品摊位套装
		-- 奖品摊位(建筑)
		CARNIVAL_PRIZEBOOTH =
		{
			GENERIC = "我不明白这些的意义是什么……",
		},

		-- 暂时未知
		CARNIVALCANNON_KIT = "还需要时间准备。",
		CARNIVALCANNON =
		{
			GENERIC = "不是玻璃制品，",
			COOLDOWN = "没有电火花，不好玩。",
		},

		CARNIVAL_PLAZA_KIT = "那只大鸟心心念念的树。",-- 鸦年华树苗

		-- 鸦年华树(种植)
		CARNIVAL_PLAZA =
		{
			GENERIC = "有点光秃秃的。",
			LEVEL_2 = "它还可以更绚丽。",
			LEVEL_3 = "很有热闹的感觉。",
		},

		CARNIVALDECOR_EGGRIDE_KIT = "战利品展。", -- 鸦年华树(套装)
		CARNIVALDECOR_EGGRIDE = "现在树立起来了。",-- 鸦年华树(建筑)

		CARNIVALDECOR_LAMP_KIT = "来自仲夏夜的梦。",-- 盛夏夜灯套装
		CARNIVALDECOR_LAMP = "于夜间闪耀。",	   -- 盛夏夜灯

		CARNIVALDECOR_PLANT_KIT = "要放哪？",-- 微型树套装
		CARNIVALDECOR_PLANT = "确实很微型。",-- 微型树

		CARNIVALDECOR_BANNER_KIT = "奖品。",		 -- 光线捕捉器套装
		CARNIVALDECOR_BANNER = "可以用来做激光陷阱。",-- 光线捕捉器

		-- 神秘盒子
		CARNIVALDECOR_FIGURE =
		{
			RARE = "有什么神秘的？",
			UNCOMMON = "感觉一般。",
			GENERIC = "开始表演了。",
		},
		CARNIVALDECOR_FIGURE_KIT = "里面是什么？",		  -- 绿色神秘盒子
		CARNIVALDECOR_FIGURE_KIT_SEASON2 = "里面是什么？",-- 金色神秘盒子

        CARNIVAL_BALL = "喜欢乱跑。", -- 发光红球

		CARNIVAL_SEEDPACKET = "一包种子。",-- 种子包(鸦年华)

		CARNIVALFOOD_CORNTEA = "像是鸟的小吃。",		-- 玉米泥

        CARNIVAL_VEST_A = "吵闹的围巾。",-- 叽啾啾喳围巾
        CARNIVAL_VEST_B = "感觉很蠢。",	 -- 叽啾啾喳斗篷
        CARNIVAL_VEST_C = "入场仪式？",	 -- 叽啾啾喳小披肩

		-- 万圣节 ------------------------------------------------------------------------------------------------------------
		MADSCIENCE_LAB = "对庸人而言太过疯狂，但对天才来说不过寻常。",-- 疯狂科学家实验室

		HALLOWEENPOTION_BRAVERY_SMALL = "新手只能提取这么点了。",-- 减轻恐惧的药液
		HALLOWEENPOTION_BRAVERY_LARGE = "终止战栗的一生。",     -- 终止恐惧的药液

		HALLOWEENPOTION_HEALTH_SMALL = "新手只能提取这么点了。",-- 瓶装乐观混合剂
		HALLOWEENPOTION_HEALTH_LARGE = "让局面乐观起来。",     -- 壶装乐观混合剂

		HALLOWEENPOTION_SANITY_SMALL = "新手只能提取这么点了。",-- 少许刚毅勇气
		HALLOWEENPOTION_SANITY_LARGE = "令人英勇无畏。",       -- 杯装刚毅勇气

		HALLOWEENPOTION_EMBERS = "诡异的色泽。",-- 石灰硫化晶体
		HALLOWEENPOTION_SPARKS = "奇妙的色泽。",-- 硝化硫酸晶体

		HALLOWEENPOTION_MOON = "受月光启迪。",-- 月亮精华液

		LIVINGTREE_ROOT = "需要土地让它茁壮生长。",	  -- 完全正常的树根
		LIVINGTREE_SAPLING = "我的预备役受刑者。",-- 完全正常的树苗

		-- 南瓜帽
		PUMPKINHAT =
		{
			GENERIC  = "笑得再阴森些，杰克。", -- 已雕刻
			UNCARVED = "亟待有人为它带来笑容。", -- 未雕刻
		},

        CANDYBAG = "装无聊的糖果的袋子。",		-- 糖果袋

        -- 糖果
		HALLOWEENCANDY_1 = "小孩子才喜欢这种幼稚的糖果。",  -- 糖果苹果
        HALLOWEENCANDY_2 = "小孩子才喜欢这种幼稚的糖果。",	-- 糖果玉米
        HALLOWEENCANDY_3 = "小孩子才喜欢这种幼稚的糖果。",	-- 不太甜的玉米
        HALLOWEENCANDY_4 = "小孩子才喜欢这种幼稚的糖果。",	-- 粘液蜘蛛
        HALLOWEENCANDY_5 = "小孩子才喜欢这种幼稚的糖果。",	-- 浣猫糖果
        HALLOWEENCANDY_6 = "小孩子才喜欢这种幼稚的糖果。",	-- \"葡萄干\"
        HALLOWEENCANDY_7 = "小孩子才喜欢这种幼稚的糖果。",	-- 葡萄干
        HALLOWEENCANDY_8 = "小孩子才喜欢这种幼稚的糖果。",	-- 鬼魂棒棒糖
        HALLOWEENCANDY_9 = "小孩子才喜欢这种幼稚的糖果。",	-- 果冻虫
        HALLOWEENCANDY_10 = "小孩子才喜欢这种幼稚的糖果。",	-- 触手棒棒糖
        HALLOWEENCANDY_11 = "小孩子才喜欢这种幼稚的糖果。",	-- 巧克力猪
        HALLOWEENCANDY_12 = "小孩子才喜欢这种幼稚的糖果。", -- 糖果虱
        HALLOWEENCANDY_13 = "小孩子才喜欢这种幼稚的糖果。", -- 无敌硬糖
        HALLOWEENCANDY_14 = "小孩子才喜欢这种幼稚的糖果。", -- 熔岩椒

		HALLOWEENPOTION_FIRE_FX = "有些华丽。",-- 远古宝箱

        -- 万圣节饰品
		HALLOWEEN_ORNAMENT_1 = "这能吓到谁？",-- 幽灵装饰
		HALLOWEEN_ORNAMENT_2 = "这能吓到谁？",-- 蝙蝠装饰
		HALLOWEEN_ORNAMENT_3 = "这能吓到谁？",-- 蜘蛛装饰
		HALLOWEEN_ORNAMENT_4 = "这能吓到谁？",-- 触手装饰
		HALLOWEEN_ORNAMENT_5 = "这能吓到谁？",-- 穴居悬蛛装饰
		HALLOWEEN_ORNAMENT_6 = "这能吓到谁？",-- 乌鸦装饰

        PUMPKINCARVER = "在植物上作画", --  南瓜雕刻器
		-- 冬季盛宴 	-----------------------------------------------------------------------------------------------------------
		-- 圣诞树
		WINTER_TREE =
        {
            BURNT = "谁还看得出它本来是不同寻常的树？",
            BURNING = "谁会选火焰作饰品？",
            CANDECORATE = "冬日盛宴的标志。",
            YOUNG = "它还在成长。",
        },

		-- 圣诞树盆
		WINTER_TREESTAND =
		{
			GENERIC = "需要一棵足够高大的树。",
            BURNT = "它还没开始就结束了。",
		},

        WINTER_ORNAMENT = "有一棵树在等着它。",		-- 圣诞小玩意
        WINTER_ORNAMENTLIGHT = "适当装点。",		-- 圣诞灯
        WINTER_ORNAMENTBOSS = "它应该俯视群雄。",	-- 华丽的装饰
		WINTER_ORNAMENTFORGE = "手下败将们。",		-- 熔炉装饰
		WINTER_ORNAMENTGORGE = "令人食指大动。",	-- 暴食装饰

		GIFT = "这……不像是贡品？",		-- 礼物
        GIFTWRAP = "至少算个容器。",    -- 礼物包装

		WINTER_FOOD1 = "没有灵魂的东西。",   -- 小姜饼
        WINTER_FOOD2 = "一块小饼干。",       -- 糖曲奇饼
        WINTER_FOOD3 = "小孩才喜欢的东西。", -- 拐杖糖
        WINTER_FOOD4 = "精致的模具……但也只是模具！", -- 永远的水果蛋糕
        WINTER_FOOD5 = "很有创意。", -- 巧克力原木蛋糕
        WINTER_FOOD6 = "水果点心。", -- 李子布丁
        WINTER_FOOD7 = "小孩儿喜欢的果汁饮品。", -- 苹果酒
        WINTER_FOOD8 = "我喜欢这个。", -- 热可可
        WINTER_FOOD9 = "滑稽的配方，幽默的口感。", -- 美味的蛋酒

		-- 砖砌烤炉
		WINTERSFEASTOVEN =
		{
			GENERIC = "经典壁炉，适配冬日雪景。",
			COOKING = "正在烤制。",		     -- 刚开始烤制
			ALMOST_DONE_COOKING = "得等等。",-- 正在烤制
			DISH_READY = "新鲜出炉。",       -- 出炉
		},

		BERRYSAUCE = "它试图让我快乐……它尽力了。",-- 快乐浆果酱
		BIBINGKA = "口感有点奇怪……",	-- 比宾卡米糕
		CABBAGEROLLS = "是白菜卷。",	-- 白菜卷
		FESTIVEFISH = "色香味俱全。",	-- 节庆鱼料理
		GRAVY = "味道不错。",		    -- 好肉汁
		LATKES = "薄脆一些会更香。",	-- 土豆饼
		LUTEFISK = "呃……富有创意。",	-- 苏打鱼
		MULLEDDRINK = "还需要再冰一冰。",-- 香料潘趣酒
		PANETTONE = "酥软香甜。",		-- 托尼甜面包
		PAVLOVA = "有点太甜了。",		-- 巴甫洛娃蛋糕
		PICKLEDHERRING = "难以评价的品位。",	-- 腌鲱鱼
		POLISHCOOKIE = "波兰人的食品都很不错。",-- 波兰饼干
		PUMPKINPIE = "南瓜香。",           -- 南瓜派
		ROASTTURKEY = "里面塞了什么？",	   -- 烤火鸡
		STUFFING = "看着寒酸，实际上还行。",-- 烤火鸡面包馅
		SWEETPOTATO = "有点甜了。",		-- 红薯焗饭
		TAMALES = "看起来还不错。",		-- 塔马利
		TOURTIERE = "份量充足。",		-- 饕餮馅饼

		-- 冬季盛宴餐桌
		TABLE_WINTERS_FEAST =
		{
			GENERIC = "吃饭的餐桌。",
			HAS_FOOD = "现在可以就餐了。",
			WRONG_TYPE = "为什么不行？",
			BURNT = "是谁把餐桌烧毁了？",
		},

		GINGERBREADWARG = "它的糖霜和奶油都快流出来了。",-- 姜饼座狼

		GINGERBREADHOUSE = "我找到它的老家了。",	    -- 姜饼猪屋
		GINGERBREADPIG = "我想碾碎它，追上去！",	    -- 姜饼猪
		CRUMBS = "它妄图用这些东西来引诱我。",		     -- 饼干屑

		WINTERSFEASTFUEL = "古怪的……情绪？",	        -- 节日欢愉

		--  雪人
		SNOWMAN =
		{
			GENERIC = "跟米开朗基罗还有些差距。",  --  已经堆好的
			SNOWBALL = "我已经有了大致的想法……", --  正在堆
		},

		--  雪球(物品)
        SNOWBALL_ITEM = "雪的战争，即将召开。",
		-- 年活动 ------------------------------------------------------------------------------------------------------------
		LUCKY_GOLDNUGGET = "通用货币。",-- 幸运黄金
		REDPOUCH = "拆开看看。",		-- 红包

		REDLANTERN = "民俗文化中代表喜庆的色彩。",-- 红灯笼
		MINIBOATLANTERN = "灯笼。",		        -- 漂浮灯笼
        FIRECRACKERS = "能够恐吓野兽。",-- 红鞭炮
		PERDFAN = "我不相信运气。",		-- 幸运扇

		DRAGONHEADHAT = "年兽？",       -- 幸运兽脑袋
        DRAGONBODYHAT = "有点怪异。",	-- 幸运兽躯体
        DRAGONTAILHAT = "需要有人配合。",-- 幸运兽尾巴

        -- 火鸡之年活动 -----------------------------------------------------------------------------------------------------
		-- 火鸡神龛
        PERDSHRINE =
        {
            GENERIC = "能让那些火鸡有教养一点。",
            EMPTY = "它向我乞求浆果。",		-- 空的
            BURNT = "“火”鸡神龛。",
        },

		-- 座狼之年活动 ------------------------------------------------------------------------------------------------------
        -- 座狼神龛
        WARGSHRINE =
        {
            GENERIC = "我不想供奉这些平庸之物。",
            EMPTY = "它向我乞求一根火炬。",	-- 空的
            BURNT = "玩火自焚。",
        },

		-- 陶土座狼
		CLAYWARG =
        {
			GENERIC = "露出本来面目了？",
			STATUE = "看上去还挺威武的。",-- 雕像状态
        },

		-- 陶土猎犬
		CLAYHOUND =
        {
			GENERIC = "雕狼小技。",
			STATUE = "我可以塑造出更好的。", -- 雕像状态
        },

		HOUNDWHISTLE = "能够驯服那些野兽。", -- 幸运哨子

		-- 猪王之年活动 ------------------------------------------------------------------------------------------------------
		-- 猪人神龛
		PIGSHRINE =
		{
            GENERIC = "为什么要在这些愚蠢的生物上浪费时间？供奉我吧！",
            EMPTY = "它向我乞求一块肉。",
            BURNT = "场面太火爆了。",
		},

		PIG_TOKEN = "冠军腰带。", -- 金腰带
		PIG_COIN = "本地酋长提供的武力凭证。", -- 猪鼻铸币

		YOTP_FOOD1 = "确实适合向我上贡。",		    -- 贡品烤肉
		YOTP_FOOD2 = "唯有那些偶蹄目半人能够下咽。", -- 八宝泥馅饼
		YOTP_FOOD3 = "唯有那些偶蹄目半人能够下咽。", -- 鱼头串

		-- 精英猪人/四大猪人护法(抢黄金比赛)
		PIGELITE1 = "你应该知晓，你阻挡不了我。",  -- 韦德(蓝色猪人)
		PIGELITE2 = "这道战纹！？",               -- 伊格内修斯(红色猪人)
		PIGELITE3 = "希望你能理解：向我宣战只代表毁灭。", -- 德米特里(白色猪人)
		PIGELITE4 = "莽撞的家伙。",                -- 索耶(绿色猪人)
        -- 精英猪人/四大猪人护法(召唤物)
		PIGELITEFIGHTER1 = "武艺精湛。",      -- 韦德(蓝色猪人)
		PIGELITEFIGHTER2 = "这道战纹！？",        -- 伊格内修斯(红色猪人)
		PIGELITEFIGHTER3 = "拳法不错。",      -- 德米特里(白色猪人)
		PIGELITEFIGHTER4 = "我欣赏它的重拳。", -- 索耶(绿色猪人)

		-- 胡萝卜鼠之年活动 	---------------------------------------------------------------------------------------------------
		-- 胡萝卜鼠神龛
		YOTC_CARRATSHRINE =
        {
            GENERIC = "很精致，是一只老鼠。",
            EMPTY = "它向我乞求胡萝卜种子。",-- 空的
            BURNT = "它被火焰捕食了。",      -- 烧毁
        },

		CARRAT_GHOSTRACER = "夜女士派来的选手。",	-- 查理的胡萝卜鼠

		YOTC_CARRAT_RACE_START_ITEM = "奔跑起点。",	-- 起点套装
		YOTC_CARRAT_RACE_START = "奔跑起点。",		-- 起点

		YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "给予指引。",-- 检查点套装
		YOTC_CARRAT_RACE_CHECKPOINT = "给予指引。",		-- 检查点

		YOTC_CARRAT_RACE_FINISH_ITEM = "胜负点。",-- 终点线套装
		-- 终点线
		YOTC_CARRAT_RACE_FINISH =
        {
            GENERIC = "胜负点。",
            BURNT = "赛况太焦灼了。",
            I_WON = "胜利早就注定了。",-- 赢了
            SOMEONE_ELSE_WON = "{winner} 夺走了胜利……",-- 输了
        },

		YOTC_SEEDPACKET = "有一些种子。",		    -- 种子包
		YOTC_SEEDPACKET_RARE = "有不少有用的种子。",-- 高级种子包

		YOTC_CARRAT_GYM_DIRECTION_ITEM = "让橙黄色老鼠的头脑变得清晰。",-- 方向健身房套装
        -- 方向健身房
        YOTC_CARRAT_GYM_DIRECTION =
        {
            GENERIC = "训练橙黄色老鼠的判断力。",
            RAT = "希望它的反应力再快点。",
            BURNT = "烧了……",
        },

		YOTC_CARRAT_GYM_SPEED_ITEM = "训练老鼠的东西。",-- 速度健身房套装
		-- 速度健身房
		YOTC_CARRAT_GYM_SPEED =
        {
            GENERIC = "训练橙黄色老鼠的东西。",
            RAT = "它的四只爪子已经达到最大转速。",
            BURNT = "没有了……",
        },

		YOTC_CARRAT_GYM_REACTION_ITEM = "哈哈，训练老鼠。",-- 反应健身房套装
		-- 反应健身房
		YOTC_CARRAT_GYM_REACTION =
        {
            GENERIC = "橙黄色老鼠的训练房。",
            RAT = "它在努力了。",
            BURNT = "哎……",
        },

		YOTC_CARRAT_GYM_STAMINA_ITEM = "看看这只橙黄色老鼠能坚持多久。",-- 耐力健身房套装
		-- 耐力健身房
		YOTC_CARRAT_GYM_STAMINA =
        {
            GENERIC = "对橙黄色老鼠有用。",
            RAT = "正在接受训练。",
            BURNT = "烧毁了。",
        },

        YOTC_CARRAT_SCALE_ITEM = "给橙黄色老鼠称重。",-- 胡萝卜鼠秤套装
		-- 胡萝卜鼠称
		YOTC_CARRAT_SCALE =
        {
            GENERIC = "看看橙黄色老鼠有多重。",
            CARRAT = "橙黄色老鼠。",
            CARRAT_GOOD = "一只优秀的橙黄色老鼠。",
            BURNT = "火焰摧毁了它。",
        },

		-- 皮弗娄牛之年活动 	---------------------------------------------------------------------------------------------------
        -- 皮弗娄牛神龛
		YOTB_BEEFALOSHRINE =
        {
            GENERIC = "那上面是一只牛。",
            EMPTY = "它向我乞求一块牛毛。",
            BURNT = "烧毁了。",
        },

		-- 皮弗娄牛美妆台
		BEEFALO_GROOMER =
        {
            GENERIC = "给牛换个发型。",
            OCCUPIED = "已经有牛了。",
            BURNT = "过于热门了。",
        },

        BEEFALO_GROOMER_ITEM = "用来打扮牛。",-- 美妆台套装

        WAR_BLUEPRINT = "独属于战士的优雅。",   -- 战士礼服款式
        DOLL_BLUEPRINT = "有点过于幼稚。",	    -- 娃娃礼服款式
        FESTIVE_BLUEPRINT = "华丽的装饰。",		-- 节日盛装款式
        ROBOT_BLUEPRINT = "像头钢铁巨兽。",		-- 铁甲礼服款式
        NATURE_BLUEPRINT = "穿上整个春天。",	-- 花朵礼服款式
        FORMAL_BLUEPRINT = "这是正装出席。",	-- 正式礼服款式
		ICE_BLUEPRINT = "它看起来就冷。",		-- 寒霜礼服款式
        BEAST_BLUEPRINT = "我不认为这代表幸运。",-- 幸运兽礼服款式
        VICTORIAN_BLUEPRINT = "繁复的花纹，符合旧时代的审美。",-- 维多利亚礼服款式

        BEEF_BELL = "跟牛建立起一道无法阻挡的羁绊。",-- 皮弗娄牛铃

        YOTB_SEWINGMACHINE = "我知道这个，但我从不需要。",-- 缝纫机
        YOTB_SEWINGMACHINE_ITEM = "对我来说有点多余了。",-- 缝纫机套装

        YOTB_STAGE = "我才应该是审判者！",-- 裁判席
        YOTB_STAGE_ITEM = "挑个好位置。", -- 裁判席套装

		YOTB_POST =  "看来不止一个主角。",-- 皮弗娄牛舞台
        YOTB_POST_ITEM =  "美妆的舞台。",-- 皮弗娄牛舞台套装

        YOTB_PATTERN_FRAGMENT_1 = "残缺的恐惧。",-- 恐怖款式碎片
        YOTB_PATTERN_FRAGMENT_2 = "残缺的优雅。",-- 正式款式碎片
        YOTB_PATTERN_FRAGMENT_3 = "残缺的幽默。",-- 喜庆款式碎片

		-- 牛玩偶
		-- 战士皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_WAR =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 娃娃皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_DOLL =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 喜庆皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_FESTIVE =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 花朵皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_NATURE =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 铁甲皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_ROBOT =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 寒霜皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_ICE =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 正式皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_FORMAL =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 维多利亚皮弗娄牛玩偶
        YOTB_BEEFALO_DOLL_VICTORIAN =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },
		-- 幸运兽弗娄牛玩偶
        YOTB_BEEFALO_DOLL_BEAST =
	    {
            GENERIC = "幼稚的收藏品。",
            YOTB = "或许有人会喜欢？",
        },

		-- 浣猫年活动 	--------------------------------------------------------------------------------------------------------
		-- 浣猫年神龛
		YOT_CATCOONSHRINE =
        {
            GENERIC = "带来一些小猫。",
            EMPTY = "它向我祈求一根羽毛。",
            BURNT = "烈火摧毁了它。",-- 烧毁
        },

		KITCOONDEN_KIT = "寄养那些小毛球。",-- 小浣猫托儿所套装
		-- 小浣猫托儿所
		KITCOONDEN =
		{
			GENERIC = "毛茸茸的小家伙都住在这。",
            BURNT = "希望那些小东西安然无恙。",-- 烧毁
			PLAYING_HIDEANDSEEK = "它们躲起来了。",                    -- 开始躲猫猫
			PLAYING_HIDEANDSEEK_TIME_ALMOST_UP = "游戏已经步入尾声了。",-- 躲猫猫快要结束了
		},

		-- 大虎
		TICOON =
		{
			GENERIC = "看得出来，它在尽力让自己仪态威武。",
			ABANDONED = "暂时不需要你了，先回去睡觉吧。",-- 遗弃大虎
			SUCCESS = "它找到了！",                    -- 找到小猫
			LOST_TRACK = "那只小猫已经被人抓住了。",    -- 失去目标
			NEARBY = "大虎的意思是就在附近！",          -- 小猫在附近
			TRACKING = "它想让我跟着它。",              -- 导航
			TRACKING_NOT_MINE = "继续找另一只小猫。",   -- 找到的不是我的？
			NOTHING_TO_TRACK = "已经找到了全部的小猫。",-- 找全了小猫仍然试图雇佣大虎
			TARGET_TOO_FAR_AWAY = "太远了，靠近点。",   -- 距离大虎太远
		},

		KITCOON_NAMETAG = "这代表我奴役和庇护着这个可怜的小东西。",-- 小浣猫项圈

		-- 小浣猫
		KITCOON_FOREST = "是森林的花色。",-- 森林猫
		KITCOON_SAVANNA = "它有非常显眼的花纹。",-- 绿地猫
		KITCOON_MARSH = "它看起来湿漉漉的",-- 沼泽猫
		KITCOON_DECIDUOUS = "非常迷你。",-- 桦树林猫
		KITCOON_GRASS = "它像一只小熊。",-- 草原猫
		KITCOON_ROCKY = "像是一只石猫。",-- 混合地形猫
		KITCOON_DESERT = "它就像一只猎豹。",-- 沙漠猫
		KITCOON_MOON = "看来它很喜欢月亮。",-- 月岛猫
		KITCOON_YOT = "最会躲藏的小家伙。",-- 年之猫

        CATTOY_MOUSE = "猫科动物都拒绝不了这个。",-- 发条鼠玩具

		KITCOONDECOR1_KIT = "只是逗猫的玩具。",-- 火鸡不倒翁套装
		-- 火鸡不倒翁
		KITCOONDECOR1 =
        {
            GENERIC = "只是逗猫的玩具。",
            BURNT = "火鸡被火焰击倒了。",
        },

		KITCOONDECOR2_KIT = "只是逗猫的玩具。",-- 逗猫小鱼套装
		-- 逗猫小鱼
		KITCOONDECOR2 =
        {
            GENERIC = "只是逗猫的玩具。",
            BURNT = "这不是烤鱼。",
        },

        -- 兔人年活动 ---------------------------------------------------------------------------------------------------------
		-- 兔人神龛
        YOTR_RABBITSHRINE =
        {
            GENERIC = "这是素食主义教堂吗？",
            EMPTY = "它向我乞求一根胡萝卜。",
            BURNT = "高处不胜寒的反义词。",
        },

		COZY_BUNNYMAN = "它现在没那么暴力。",-- 舒适的兔人
		HAREBALL = "恶心。",		        -- 兔毛球
        YOTR_TOKEN = "这是贵族间的决斗原则。",-- 挑战手套
		NIGHTCAPHAT = "爱丽丝牌？",          -- 睡帽

        YOTR_FIGHTRING_KIT = "幼稚的派对。",-- 枕头大战坑套装

		-- 枕头大战钟
		YOTR_FIGHTRING_BELL =
        {
            GENERIC = "这算是战斗吗？",
            PLAYING = "无聊，还以为会更有趣呢。",
        },

        YOTR_FOOD1 = "里面有兔子？",		-- 兔子卷
        YOTR_FOOD2 = "消费陷阱。",		-- 月饼
        YOTR_FOOD3 = "高雅的点心。",		-- 月冻
        YOTR_FOOD4 = "有点太甜了。",		-- 泡芙串

        HANDPILLOW_BEEFALOWOOL = "柔软舒适。",	-- 皮弗娄牛毛枕头
        HANDPILLOW_KELP = "从鱼人那儿拿的吗？",	-- 海带枕头
        HANDPILLOW_PETALS = "这就是绣花枕头。",	-- 花朵枕头
        HANDPILLOW_STEELWOOL = "最强的枕头。",	-- 钢丝绵枕头
        BODYPILLOW_BEEFALOWOOL = "像是小孩子的玩具。",	  -- 皮弗娄牛枕头盔甲
        BODYPILLOW_KELP = "湿漉漉的！",		             -- 海带枕头盔甲
        BODYPILLOW_PETALS = "玫瑰骑士。",		         -- 花朵枕头盔甲
        BODYPILLOW_STEELWOOL = "为什么不做副真正的铠甲？",-- 钢丝绵枕头盔甲

		-- 矮兔灯
		YOTR_DECOR_1 =
	    {
            GENERAL = "明亮的，很好。",
            OUT = "晚安，兔子们。",		-- 熄灭
        },

		YOTR_DECOR_1_ITEM = "啊……放在哪能照亮这里呢？",		-- 矮兔灯(物品)

		-- 高兔灯
		YOTR_DECOR_2 =
	    {
            GENERAL = "明亮的，很好。",
            OUT = "晚安，兔子们。",		-- 熄灭
        },

		YOTR_DECOR_2_ITEM = "啊……放在哪能照亮这里呢？",		-- 高兔灯(物品)

        -- 龙蝇年活动(未注释完) 	-----------------------------------------------------------------------------------------------
		-- 龙蝇年神龛
        YOTD_DRAGONSHRINE =
        {
            GENERIC = "老实说，有点牵强附会。",
            EMPTY = "它向我乞求木炭。",
            BURNT = "火龙的象征也会败于火焰？",
        },


        BOATRACE_PRIMEMATE = "夜女士派来的选手。",-- 暗影大副

        BOATRACE_SPECTATOR_DRAGONLING = "这小东西会一直旁观。",-- 小龙蝇观众

		BOATRACE_START = "预备？",                      -- 起点
        BOATRACE_START_THROWABLE_DEPLOYKIT = "开始了？",-- 起点套装

        BOATRACE_CHECKPOINT = "它看起来像一个检查点。",            -- 检查赛点
        BOATRACE_CHECKPOINT_THROWABLE_DEPLOYKIT = "啊……麻烦了。",-- 检查赛点套装

		DRAGONBOAT_BODY = "我还不知道冠名为龙意味着它更小一些。",-- 龙蝇船
		WALKINGPLANK_YOTD = "龙吐长舌。",                     -- 龙蝇年浮木板(船自带的楼梯)
        DRAGONBOAT_KIT = "更小，更灵活的船。",                 -- 龙蝇船套装
        DRAGONBOAT_PACK = "配置齐全。",                       -- 豪华龙蝇船套装

        YOTD_OAR = "节日装扮的浮木桨。",  -- 龙蝇年船桨(利爪船桨)

        YOTD_ANCHOR = "值得一用。",       -- 龙蝇年船锚(巨爪船锚)
        YOTD_ANCHOR_ITEM = "让巨爪抓稳。",-- 龙蝇年船锚(巨爪船锚)套装

        YOTD_STEERINGWHEEL = "大海航行靠舵手。",-- 龙蝇年方向舵
        YOTD_STEERINGWHEEL_ITEM = "明辨方向。",-- 龙蝇年方向舵套装

        MAST_YOTD = "展翅翱翔。",         -- 龙蝇年船帆(龙翼桅杆)
        MAST_YOTD_ITEM = "是时候展翅了。",-- 龙蝇年船帆(龙翼桅杆)套装

		MASTUPGRADE_LAMP_YOTD = "方便多了。",     -- 龙蝇甲板照明灯(安装上去)
        MASTUPGRADE_LAMP_ITEM_YOTD = "安一盏灯。",-- 龙蝇甲板照明灯(物品)

        BOAT_BUMPER_YOTD = "咬碎礁石。",        -- 獠牙保险杠(安装上去)
        BOAT_BUMPER_YOTD_KIT = "给船买个保险。",-- 獠牙保险杠(物品)

		-- 浮标(投掷出去阻挡船的障碍物)
		-- 玩家使用的黄金浮标
        BOATRACE_SEASTACK = "这个能阻挡它一会！",               -- 黄金浮标(已放置)
        BOATRACE_SEASTACK_THROWABLE_DEPLOYKIT = "快点，快点！",-- 黄金浮标(未放置)
        -- 暗影大副扔的荆棘浮标
        BOATRACE_SEASTACK_MONKEY = "这东西在挡路！",                  -- 荆棘浮标(已放置)
        BOATRACE_SEASTACK_MONKEY_THROWABLE_DEPLOYKIT = "快点，快点！",-- 荆棘浮标(未放置) 疑似暂时不存在此物品

		-- 蠕虫蛇年 -----------------------------------------------------------------------------------------------------
        -- 蠕虫神龛
		YOTS_SNAKESHRINE =
        {
            GENERIC = "真是吞象巨口。",      --  正常
            EMPTY = "它向我祈求一块怪物肉。", --  空的
            BURNT = "正在熊熊燃烧。",        --  燃烧
        },

		--  镀金蠕虫
        YOTS_WORM = "比之平常顺眼不少。",

		--  喜庆灯笼柱
        YOTS_LANTERN_POST =
        {
            GENERIC = "张灯结彩，倒是很有节日氛围。", -- 正常
            BURNT = "真是“红红火火”。",              --  燃烧
        },
		--  喜庆灯笼柱套装(物品栏)
        YOTS_LANTERN_POST_ITEM = "长蛇由此起！",

		-- 发条骑士之年 -----------------------------------------------------------------------------------------------------
		-- 骑士神龛
		YOTH_KNIGHTSHRINE =
		{
			GENERIC = "看起来又到了骑士道流行的年份。", -- 有供品
			EMPTY = "它在向我祈求齿轮。", -- 无供品
			BURNT = "骑士亡于战火。", -- 烧毁
		},

		MASK_PRINCESSHAT        = "象征着娇蛮任性。",            -- 公主帽
		COSTUME_PRINCESS_BODY   = "看起来真正的小马反而穿不上。", -- 公主服装

		PLAYBILL_THE_PRINCESS_YOTH = "和我在小玛利亚观赏的似乎不是同一幕？", -- 《我的四骑士与我》剧本

		-- 骑士
		KNIGHT_YOTH =
		{
			GENERIC = "梦该醒了，唐吉坷德！", -- 普通(敌对)
			FOLLOWING = "向我献上忠诚，我自会赐尔荣耀。", -- 跟随
			FOLLOWING_OTHER = "你所效忠的，是此刻的主人还是心中的公主呢，骑士？", -- 跟随他人
		},

		YOTH_KNIGHTHAT = "好吧，我偶尔也会亲历战火。", -- 骑士帽
		ARMOR_YOTH_KNIGHT = "玫瑰的徽记……呵。", -- 骑士盔甲
		HORSESHOE = "有趣的凡尘造物。不过我本就是命运的主人。", -- 马蹄铁
		YOTH_LANCE = "横枪立马，一骑当千。", -- 骑士长枪

		-- 浮动灯笼
		FLOATINGLANTERN =
		{
			DEFLATED = "喜庆的气氛总是如此短暂。", -- 放气
			HELD     = "它终将升入群星。", -- 持有
			GENERIC  = "可惜不具有查打一体。", -- 漂浮
		},

		YOTH_KNIGHTSTICK = "准备一骑绝尘。", -- 骑士手杖
		YOTH_CHAIR_ROCKING_ITEM = "好吧，姑且视之为童趣好了。", -- 摇椅物品
---------联动内容 ------------------------------------------------------------------------------------------------------
        -- 小丑牌
		DECK_OF_CARDS 	= "杀时间的利器。", --  纸牌堆
        PLAYING_CARD 	= "猜猜看，它是什么？", --  单张纸牌
        BALATRO_MACHINE = "荒郊野岭的游戏厅。", --  小丑牌机器

---------暂时未知与留待未来更新区域 --------------------------------------------------------------------------------------
		DEVTOOL = "It smells of bacon!",-- 未知
		DEVTOOL_NODEV = "I'm not strong enough to wield it.",-- 未知

---------单机版遗留 ------------------------------------------------------------------------------------------------------
		ACCOMPLISHMENT_SHRINE = "I want to use it, and I want the world to know what I did.",-- 单机版遗留，奖杯
		BELL_BLUEPRINT = "It's scientific!",-- 钟蓝图，单机版巨人国内容
		BELL = "Dingalingaling.",           -- 远古铃铛，单机版巨人国遗留
		BIGFOOT = "That is one biiig foot.",-- 大脚怪，单机版巨人国内容
        CAVE_ENTRANCE_RUINS = "此路不通。",	 -- 单机遗留，被堵住的远古(洞穴二层)入口

        -- 单机版遗留，农田
		FARMPLOT =
		{
			GENERIC = "I should try planting some crops.",
			GROWING = "Go plants go!",
			NEEDSFERTILIZER = "I think it needs to be fertilized.",
			BURNT = "I don't think anything will grow in a pile of ash.",
		},

		WEBBERSKULL = "我可以用这个唤醒他的灵魂。",-- 单机版遗留，韦伯的头骨

		MALE_PUPPET = "现在可以加工了。", -- 单机版遗留，木头

		-- 熔岩坑，疑似单机版海难遗留
        ROCK_LIGHT =
        {
            GENERIC = "这块熔岩干涸了。",-- removed		-- 熔岩坑
            OUT = "它看起来像要碎掉一样。",-- removed		-- 熔岩坑/出去？外面？
            LOW = "没有那么舒适了。",-- removed		-- 熔岩坑/低？
            NORMAL = "好舒适！",-- removed		-- 熔岩坑/普通
        },

		BASALT = "玄武岩在这个世界几乎坚不可摧！",-- 玄武岩，单机版遗留废案

		FEM_PUPPET = "被关起来了。", -- 单机版遗留，未知

        -- 冒险模式相关
		ADVENTURE_PORTAL = "你居然敢对我开门？我会登门拜访，教会你什么叫后悔。",--  单机版遗留废案，麦斯威尔之门
		TRAP_TEETH_MAXWELL = "以为能埋伏我吗？", -- 单机版遗留废案，麦斯威尔的犬牙陷阱
		-- 单机版遗留，木质传送台
		TELEPORTATO_BASE =
		{
			ACTIVE = "我们可以用这个来探索新世界！", -- 激活
			GENERIC = "我可以听到另一个世界的声音！", -- 默认
			LOCKED = "还是没法用！", -- 上锁
			PARTIAL = "我觉得我们还没有完成！", -- 已经有部分了
		},

		TELEPORTATO_BOX = "这盒子里的力量不可思议。", -- 单机版遗留废案，盒状装置
		TELEPORTATO_CRANK = "经得起任何粗野对待的曲柄零件。", -- 单机版遗留废案，曲柄装置
		TELEPORTATO_POTATO = "似乎这个东西要和其他东西配合使用……", -- 单机版遗留废案，金属土豆状装置
		TELEPORTATO_RING = "我觉得不止这一个零件。", -- 单机版遗留废案，环状装置

		MAXWELL = "你的本体藏在哪里？接受你的命运吧。",-- 单机版遗留，麦斯威尔(NPC)
		MAXWELLPHONOGRAPH = "他喜欢这样的单曲循环吗？",-- 单机版遗留废案，麦斯威尔的留声机
        MAXWELLHEAD = "不敢想象你的审美退化到了这种程度。",-- 单机版遗留废案，麦斯威尔的头
        MAXWELLLIGHT = "有点用，但不多。",-- 单机版遗留，麦斯威尔的灯
        MAXWELLLOCK = "锁不住你的噩梦。",-- 单机版遗留，麦斯威尔的噩梦锁
        MAXWELLTHRONE = "梦魇的王座留与真正的恐怖，很显然，那不是你。",-- 单机版遗留，麦斯威尔的噩梦王座
		ANNOUNCE_FREEDOM = "自由！终于——",      -- 重获自由(疑似单机版从梦魇王座上解放)
		DEADLYFEAST = "浓郁的死亡。",-- 单机版遗留，致命盛宴

		-- 占卜杖/探测仪台词，单机版遗留内容
		DIVININGROD =
		{
			COLD = "The signal is very faint.",
			GENERIC = "It's some kind of homing device.",
			HOT = "This thing's going crazy!",
			WARM = "I'm headed in the right direction.",
			WARMER = "I must be getting pretty close.",
		},

		-- 探测杖基座，单机版遗留内容
		DIVININGRODBASE =
		{
			GENERIC = "I wonder what it does.",
			READY = "It looks like it needs a large key.",
			UNLOCKED = "Now my machine can work!",
		},

		DIVININGRODSTART = "That rod looks useful!",-- 占卜杖/探测杖，单机版遗留内容

---------废案 ------------------------------------------------------------------------------------------------------------
		-- 疑似废案友谊传送门
        MIGRATION_PORTAL = {
            GENERIC = "If I had any friends, this could take me to them.",
            OPEN = "If I step through, will I still be me?",
            FULL = "It seems to be popular over there.",
        },

		ANNOUNCE_NO_TRAP = "Well, that was easy.",-- (疑似未使用？)

		ANNOUNCE_LOWRESEARCH = "……我居然忘了那个！？",-- (疑似遗忘科技，为过去科技点版本废案)

		ANNOUNCE_ACCOMPLISHMENT = "I feel so accomplished!",-- (疑似废案)
		ANNOUNCE_ACCOMPLISHMENT_DONE = "If only my friends could see me now……",-- (疑似废案)
		ANNOUNCE_RESEARCH = "这是什么？",-- (疑似发现未知科技，废案)
		ANNOUNCE_UNIMPLEMENTED = "还没到时候",-- (疑似检查物品未到可以互动状态，废案)

		FISHINGNET = "捕鱼总比钓鱼好。", -- 废案，渔网
        ANTCHOVIES = "？奇怪的名字。", -- 废案，蚁头凤尾鱼

        -- 人肉，废案
		HUMANMEAT = "这可不在我的食谱上。",
		HUMANMEAT_COOKED = "我对汉尼拔教授的学说不太感兴趣。",
		HUMANMEAT_DRIED = "我对汉尼拔教授的学说不太感兴趣。",

		HOME = "Someone must live here.",-- 暖石，废案
		SKULLCHEST = "天晓得那里面藏着什么东西！", -- 单机版遗留废案，骷髅箱
		ANNOUNCE_HIGHRESEARCH = "我领悟了更多奥秘……",-- 新的知识(疑似单机版聪明帽或者以前的研发点制度残留)

	},

}