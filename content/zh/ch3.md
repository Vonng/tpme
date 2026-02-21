---
title: "3. 错误与警告"
weight: 201
breadcrumbs: false
---

<a id="ch03_errors"></a>

> “PC Load Letter?” 这他 @#$! 到底是什么意思？
>
> — Michael Bolton

1999 年电影 *Office Space* 里的 Michael Bolton<a id="id471"></a> 盯着一台故障打印机，说出这句台词，狠狠讽刺了科技行业糟糕的错误消息。客观说，HP 早期 LaserJet 打印机的屏幕可显示字符数确实有限。如今我们早已走出石器时代，屏幕分辨率高到可以显示大量文本。你完全可以塞进很多有帮助的词！

消费者经常面对自己看不懂的诊断错误和警告，而专业人士也会把好几个小时浪费在理解含混消息上，而不是完成手头工作。用户往往是“高流失风险”的，只要遇到一点摩擦，就可能对我们的产品失去兴趣。

然而，我们工程师常把错误和错误消息当成只是要尽快补齐的“边缘情况”，而不是当成工艺质量的关键部分，或者产品差异化的机会。

再看一个更偏编程领域、也很有趣的例子：文本标记系统 LaTeX。LaTeX 是一种文档排版语言与系统，常用于高质量排版数学和科学论文。

在 LaTeX 里，如果你输入如下内容，其中 `\\` 记号表示换行：

```latex
This is some text. \\
This is at the end of a block of text. \\

This is the start of a new paragraph
```

你会收到这样一条“宝石级”警告：

`Underfull \hbox (badness 10000) in paragraph on line 2.`

想试着猜猜这是什么意思吗？其实，LaTeX 想让你删除第 2 行空行前那个多余的换行符（\\）。

这条消息虽然晦涩，但如果我们从抛错位置的代码“自底向上”看，它很可能完全说得通。由于代码组织方式，修起来也可能并不容易。等我先讲完两个技能后，会回到这个例子：

- 你如何弥合“实现者觉得合理”和“用户觉得合理”之间的鸿沟？
- 你如何有效组织代码来做到这一点？

这很重要：LaTeX 虽然目前只排在最流行编程语言的第 40 位，但 tex.stackexchange.com 上最热门的 “underfull hbox” 问题仍有超过 35 万次浏览。粗略估算每次浏览都伴随读者花 3 分钟搞清状况，那么 LaTeX 作者仅靠一条更好的警告消息（或者干脆对这个多余换行不报错）就可能为人类节省约两万小时（而且还在继续增长）。

诊断信息也可以很讨喜。经典案例是 Google 搜索里的 “did you mean” 功能。假设用户把单词拼成 “compture”，Google 会在结果顶部显示搜索词并给出便捷链接：

> compture.
>
> Did you mean: *computer*?

这条消息完成了两件关键事情。

- 它告诉用户自己做了什么：他们搜索了 “compture”。
- 它通过一个便捷链接提示下一步：最常见的拼写纠正是什么。

第一个功能实现起来很简单（但很贴心），适配的是用户被打断后返回浏览器标签页的场景。我猜第二个功能让 Google 花了数千万美元去构建和维护，背后很可能依赖巨型数据库，以及某种可能具有“意识”的人工智能来推断用户本意。他们竟然为一个边缘情况投入了这么多！

### 诊断信息的价值 {#id194}

构建<a id="id472"></a><a id="id473"></a>结构良好且消息有用的诊断信息，是一件价值极高、杠杆率极大的事。对于许多输入复杂且开放的平台和应用，诊断信息就是主界面，用户绝大多数时间都花在处理一个又一个错误上。

填写电子表单，本质上就是不断被告知你漏填了什么、填错了什么。我的编码时间至少有一半花在处理错误和 lint 规则上。就连写文档，也变成了不断看下划线提示、被要求校对或改写句子的过程。

但在我们设计软件时，错误经常不会出现在截图、营销材料或 API 方法清单里，所以它们常常“看不见，也想不起”。

自主智能体把这个问题照得很亮。它们现在会持续收到由自己操作触发的错误消息，并被要求据此修正行为。消息若不够有帮助，它们就会任务失败。反复试错既慢又贵。由于智能体按使用量计费，成本会被直接量化。

> [!NOTE]
> 诊断信息可能是你产品里最重要的界面。

### 诊断场景 {#id38}

在<a id="id474"></a><a id="id475"></a><a id="id476"></a>考虑错误、警告及其消息时，必须覆盖足够广的场景：从识别边缘情况，到理解开发者如何自动化响应，再到终端用户如何理解并采取行动。你越能理解用户认知、编写用户故事并模拟用户交互，诊断信息就会越好。对用户，我们提供有上下文且<a id="id477"></a>可操作的错误；对开发者，我们谨慎选择错误类型、错误码和元数据，以便接收方能够优雅恢复。

在本章剩余部分，你将学习如何写出真正有用、令人耳目一新的警告和错误。我们将探索如何：

- 理解场景：受益于该错误的人物画像及其处境
- 提供足够上下文，让用户理解错误
- 提供可操作的错误消息，明确建议该如何处理问题
- 谨慎选择错误码和错误类型，让上游开发者能服务 *他们的* 用户
- 在 API 或 UI 层抛出错误，以便消息能带上用户意图的完整上下文
- *左移（shift left）*：也就是<a id="id478"></a>尽可能早地触发错误，既加速用户任务，又在坏事发生前拦截

我会在[第 8 章](/en/ch8#ch08_interaction_design)讲如何系统列举边缘情况，从而确定一开始该检查哪些错误。这里我们先聚焦：当你已经知道有哪些错误时，如何把它们写好。

### 错误场景分类 {#id39}

当<a id="Serror03"></a><a id="escen03"></a><a id="EWMcat03"></a><a id="id479"></a>你写错误时，需要做几个核心选择。

先看面向用户的选择：

- 错误消息写什么？

另外还有面向开发者的选择，方便他们捕获错误并自动化处理：

- 错误的类或错误码是什么？
- 需要哪些元数据才能精确定位问题？

所以，在几乎任何应用或平台里设计错误时，你都要同时考虑两类用户场景：人类用户场景与程序员场景。

开发者场景还要进一步细分：你是在和同一代码库内的团队成员沟通，还是在和其他团队或其他公司的开发者沟通？如果你在构建 API 或服务，上游开发者会捕获你的错误并据此行动，这一点尤其重要。

因此第一步是：把消息投递给“正确的人”与“正确的情境”。我们都见过一些明显不是写给自己看的错误，比如网站把代码堆栈直接展示给终端用户。要确定受众，先确定错误类别。就本书而言，[表 3-1](/en/ch3#error_categories) 中这五类覆盖了大多数情况。

###### 表 3-1. 错误类别 {#error_categories}

| 错误类型 | 示例场景 |
| --- | --- |
| 系统错误 | 支付处理器宕机。超时。高负载下的瞬时错误。 |
| 断言 | 这个局部变量绝不应该是 null。 |
| 开发者参数无效 | 预期是字符串却收到了整数。 |
| 用户参数无效 | 用户输入了错误的信用卡号。 |
| 前置条件不满足 | 用户无权访问某资源，或尚未登录。 |

先在脑中给你写下的每个错误做分类。这会给出一个巨大线索：你在和谁说话（自己团队、其他开发者、或用户），以及问题应该在何时修复（运行时还是开发时）。这会帮助你使用正确词汇<a id="id480"></a>，并给出更有帮助的建议动作（见[表 3-2](/en/ch3#error_categories_details)）。

###### 表 3-2. 错误场景类别的“何时修复”与“谁来修复” {#error_categories_details}

| 错误类型 | 修复时机 | 常见修复方式 |
| --- | --- | --- |
| 系统 | 运行时 | 终端用户应稍后重试。 |
| 用户参数无效 | 运行时 | 终端用户修正输入后可重试。 |
| 前置条件不满足 | 运行时 | 终端用户先去修复其他问题。 |
| 断言 | 你的开发阶段 | 你团队内工程师会收到告警。 |
| 开发者参数无效 | 他们的开发阶段 | 调用你函数的开发者需要修代码。 |

这五类场景对应的策略差异非常大。比如断言若在生产触发，通常是灾难性的。代码进入作者未预见的状态时，会导致不可预测行为，最常见是崩溃或糟糕报错；偶尔更糟，比如数据损坏。有些语言会在生产环境去除断言以优化执行，所以你不该把断言用于任何承重逻辑。无论如何，终端用户都不应该被期望去正确处理断言错误。

有些应用里的终端用户也并非同一类人，此时消息应按不同人物画像定制。经典例子是“前置条件不满足”：用户没有必要权限。这个用户是管理员还是普通用户？这决定了我们是直接给出操作步骤，还是提示他们联系管理员。

了解人物画像有助于你用用户本体来表达。（“本体”在[第 2 章](/en/ch2#ch02_naming)定义为“已知概念构成的结构化图谱”。）回想 “PC Load Letter”，它本来是想让用户重新装纸。它有可操作性，确实告诉了用户“去装纸”，但它失败了，因为它在对错误人物画像说话。“PC” 指 “paper cassette（纸盒）”，“Letter” 指 8.5"x11" 纸张规格。更好的做法也许是把纸盒标成 A、B、C，再提示“请重新装载 B 纸盒”。

#### 在实践中分类错误 {#id40}

我们来<a id="id481"></a>看一个例子，演示如何用产品思维给错误分类。

“除以零”属于这五类里的哪一类？在 Python 中它是 `ZeroDivisionError`。

假设你在写一个方法，用于计算某在线指标在时间窗口内的平均值。

```python
# metric_name: e.g. 'channelz.api_calls.count'
def recent_average_for_metric(metric_name: str, timespan: str = '1h'):
  metrics = MyMetrics.get_data(metric_name).withinLast(timespan)
  return sum(metrics)/len(metrics)
```

看 `return` 语句。如果当 `metrics` 为空时它抛出 `ZeroDivisionError`，调用方会很困惑，因为他们必须理解你函数内部实现才能看懂这个错误。

> [!TIP]
> 用户和开发者都不应为理解错误而先理解你的实现细节。

所以，除非你的代码本来就是个计算器，否则“除以零”错误<a id="id482"></a>应被视作断言：它应该在测试阶段暴露，并提示你团队改进代码。做法是避免它，在真正相除前先做前置校验。

那么我们确实会加校验，但这个校验本身属于哪类场景？导致 `len(metrics)==0` 的原因，可能是[表 3-3](/en/ch3#divide_by_zero_error_categories)中的任意一种。

###### 表 3-3. 除零错误类别 {#divide_by_zero_error_categories}

| 边缘情况 | 类别 |
| --- | --- |
| `metric_name` 是否有效？ | 开发者参数无效 |
| `MyMetrics` 提供方是否宕机？ | 系统 |
| 最近是否没有数据？ | 前置条件不满足 |
| `timespan` 是否太短？ | 开发者参数无效 |

正如我将在下一节“消息”里讨论的：这些情况对应的建议动作不同，因此代码里也需要可区分的检查。此外，你还需要在拥有必要上下文的时刻执行这些校验。

本节我们把诊断信息分为面向开发者与面向终端用户两类，也区分了<a id="id483"></a>哪些场景可在运行时处理、哪些只能在开发时处理。接下来我们在此基础上，来写出<a id="id484"></a><a id="id485"></a><a id="id486"></a>真正优秀的消息。

### 警告与错误消息 {#id195}

编写诊断消息<a id="EWMwrite03"></a><a id="Dwrite03"></a>需要<a id="id487"></a>把系统思维与用户思维结合起来。你要精确知道系统里发生了什么，同时换位到用户视角，用他们理解的术语解释他们该知道的内容。否则就会出现 “underfull hbox (badness 10000)” 这样的警告。

用户看到诊断信息时，通常想知道两件事：

- 到底发生了什么，导致了这个错误？请用产品本体里的术语来描述。这应帮助他们理解影响范围，并提供修复线索。
- 他们能做什么（如果有的话）？可操作的诊断信息会直接帮助他们完成任务。

我们逐个解决这两个目标。先引入一个例子，后面几节都会围绕它展开。

#### 案例介绍 {#id196}

Channelz<a id="id488"></a> 是一家虚构的 SaaS 公司，做的是类似 Slack、Microsoft Teams 或 Discord 的职场沟通工具。

Elise 在 API 团队工作，她的同事 Deng 是技术负责人。

在 Channelz 中，你可以给同事发私信，也可以发到“频道（channel）”，即围绕某个主题组织起来的员工群组；比如 API 工程团队可能有个频道 `#team-api-eng`。Elise 的用户句柄是 `@elisek`，Deng 的是 `@deng`。

Channelz 正在构建一个 API，让机器人（bot）能够发消息，既可以直发给用户，也可以发到频道。客户希望用它发送各种通知。

在编码前，Elise 先草拟了一个开发者接口设计给 Deng 看。Channelz 的消息可以发给一组个人，也可以发到频道，用于提醒员工系统故障或任务完成。

他们交付给客户的 Python SDK 中，这个方法大概是这样的：

```python
class ChannelzBot:
    def __init__(self, bot_handle: str):
        # ...

    # One of channel, users is required
    def send_message(
        message: str, channel: Optional[str], users: Optional[List[str]])
```

她还给 Deng 列了几种用法：

```python
bot = ChannelzBot('@bippity_bot')
# Example: Send to a channel
bot.send_message(channel='#some-channel', message="Hello world!")
# Example: send separate messages to a list of people with an emoji
bot.send_message(users=['@drew', '@gabriel'], message="Hello :world:!")
```

Deng 看完设计后让她也列一下失败场景。Elise 现在只展示了“调用方已经知道怎么做时”的成功路径，但之前呢？如果把用户编码会话看成一段旅程，Elise 只给出了终点，就像有人问在线地图路线，她只回了一个目的地图钉。

Elise 想出了几个场景。（如何系统挖掘边缘情况我会在[第 7 章](/en/ch7#ch07_product_discovery_sim)讲；本章先跳过。）其中有一个关键场景，是本章重点：如果传入 API 的用户或频道无效怎么办？

#### 提供上下文 {#id197}

你<a id="Cdimess03"></a>可能会想：用户当然知道自己做了什么才触发错误，毕竟刚刚就是他们做的！但很多时候并非如此，所以你有责任重述上下文与细节。

回到例子，看看这段调用：

```python
bot.send_message(users=['@dneg', '@elise'], message="Hello :world:!")
```

说明：为简洁起见，本节后续会省略 *bot* 这一部分，因为它不相关。

在单元测试里，`user does not exist` 这条消息通常勉强够用，人们大概率扫一眼测试代码就能看出 `@deng` 拼错了。

为了给出完整上下文，我们应当：

- 回显相关数据
- 给出详细原因
- 提醒用户他们做了什么

下面逐条来看。

##### 回显相关数据 {#id282}

真实世界场景比单元测试复杂得多。更常见的用户故事是：数据来自外部输入。

```python
bot.send_message(users=input.users, message=input.message)
```

如果你草率地只说 `user does not exist`，开发者无法立刻知道你在说哪个人，也不知道句柄为什么错了。更好的写法是：`user '@dneg' does not exist`，他们很可能马上看出拼写错误，这就足够解决问题了。

> [!TIP]
> 把错误数据回显给用户，除非该信息因隐私或安全原因必须脱敏。

Deng 在代码评审里指出了这一点，Elise 于是发布了更好的消息。

##### 给出详细原因 {#id283}

API 团队的设计合作伙伴是客户公司 ChickenLittle。Deng 和 Elise 请他们反馈任何“卡顿点”。他们报告看到过这样一条错误：

`Error: User '@buckcluck' does not exist.`

他们非常困惑，因为 Buck Cluck 明明是 ChickenLittle 的员工，对吧？他们认为 Channelz API 有 bug。

Elise 让他们去公司目录再核对一次，结果发现 `@buckcluck` 账号其实是 inactive。也许 Buck 刚离职。

Elise 想在未来避免用户困惑，以及（更自私一点）避免由此产生的支持成本。她可以在 API 定义里把这一点说清楚：

```python
def on_missing_user(channelz_user: str):
    if is_inactive_employee(
        Employees.get_employee_from_channelz_user(channelz_user)):
        message = f"User {channelz_user} has been deactivated."
    else:
        message = f"User {channelz_user} does not exist."
    raise RuntimeError(message)

def send_message(users: Optional[List[str]], ...):
    for user in users:
        if not channelz_user_exists(user):
            on_missing_user(user)
    # ...
```

如果客户看到的是：

`Error: User '@buckcluck' has been deactivated.`

他们就会获得一个非常关键的行动线索。

##### 提醒用户他们做了什么 {#id41}

在单元测试里，通常很容易看出是哪个函数调用导致了问题。但在真实场景中，很多情况下错误报告与触发动作是分离的：

- 错误可能只会作为日志里的一行出现，无法直接看出是哪个动作生成的。
- 错误可能是长流程（比如在线下单）中延后出现的一步，用户需要被提醒自己当时下了什么单。
- 你的产品（也许背后接了 AI）会按某种方式解释用户指令。报错前你应先回显你的解释。

在这些以及其他场景中，最佳实践是：不仅回显错误输入，还要回显当前操作在做什么。

回到 Channelz。再过一个月，Elise 收到了 ChickenLittle 可观测性团队的反馈。他们用 Channelz 消息 API 给员工发送“重要但不紧急”的生产问题告警。（非常关键的问题他们用 pager 服务。）

他们向 Channelz API 小队反馈说，自己告警服务里记录的一些错误让他们很困惑：

`Error: User ‘@foxyloxy’ has been deactivated.`

起初他们没意识到这条消息很重要。他们觉得大概不重要，因为 `@foxyloxy` 都已经离开了。

但*后来*他们发现，一些重要告警根本没人看到，某个问题持续了两天才被发现。

原因是：Foxy Loxy 虽然离职了，却仍在值班轮值中。他们通过把 Foxy 从值班轮值中移除解决了问题。（他们也采用了标准实践：配置后备联系人做升级通知，比如原消息投递失败时可升级到该联系人。）

Elise 之前邀请他们“只要困惑就来吐槽”，所以他们确实来了。她吸收了这条反馈，并给错误消息补充上下文。

她把消息改写为复盘式表达：

`Error: Cannot deliver a Channelz message to '[@foxyloxy, @buckcluck]' because '@foxyloxy' has been deactivated.`

> [!TIP]
> 告诉用户：他们刚才试图做什么。

如果方法更好、用户共情更多一点，Elise 原本一开始就可以写出这条错误消息，从而避免后续所有迭代。

更清晰的沟通还暴露了一个关键事实：当 *一个* 用户不存在时，他们会导致 *所有* 消息都没发出去。Deng 和 Elise 讨论这是不是“设计如此”，最终认为不是，这是个 bug；既然这些消息可能是重要告警，就应该尽可能多地发出去。

本节回顾：你为错误补充的上下文，通常应回答三个问题：在尝试什么操作？作用到谁或什么对象？为什么失败？这样就能补齐用户可能需要<a id="id489"></a>知道的信息。

#### 让错误与警告消息可操作 {#id42}

遗憾的是，在<a id="id490"></a>很多情况下，知道“发生了什么”只完成了一半。用户往往还需要建议，或明确告知下一步该做什么。对于读取类操作，以及越来越多 AI 场景，你甚至可以替用户直接纠错，就像 Google 的 “Showing results for: [correction]”，以及会自动修复代码或语言的编码/写作助手。

我们每个人都花过无数小时和错误消息斗争，琢磨该怎么办，常常经过大量调查后才发现修复其实很简单。

本节你会看到如何系统性提升诊断信息质量。要做到这一点，你需要对受众产生共情，并从前面做过的场景分类出发。

回到 Channelz 例子。假设你调用 API：

`bot.send_message(message="The sky is falling!", channel="@barnyard-friends")`

结果收到错误消息：

`Cannot deliver a Channelz message to channel '@barnyard-friends': channel does not exist.`

你能立刻看出哪里错了吗？可能要花点时间。如果你不熟悉 Channelz 术语，还可能意识不到频道前缀应是 `#`，不是 `@`。

更好的做法是，给用户几个可选动作：

`Cannot deliver a Channelz message to channel '@barnyard-friends': it is prefixed with @. Did you mean to pass it into 'users'? Or did you mean '#barnyard-friends'?`

Channelz 甚至可以查询账号系统，检查 `#barnyard-friends` 是否存在且对该用户可见，并显示：

`Channel @barnyard-friends is prefixed with @, but we found a channel, #barnyard-friends. Is that what you meant?`

通过替用户删减一大块“搜索空间”，行动建议可以节省数小时，甚至防止他们放弃并流失。哪怕只是系统错误后一句简单的“请一分钟后重试”，也能提高流程完成率。

有时建议会比较复杂。你可能需要先给用户介绍一些概念（如 channel），或引导他们做一连串决策。合适时应链接到专门解释该错误的文档。比如如果这个场景更复杂，你<a id="id491"></a><a id="id492"></a>可以写：

`See https://channelz.io/docs/errors/invalid_channel to learn how to resolve this error.`

### 在接口层抛出错误 {#id43}

如果<a id="EWMraise03"></a><a id="Iraise03"></a>写好错误消息很容易，工程师早就更常做了。现实中不常做的主要原因之一，是这通常需要非常仔细的代码组织。

要写出最好的错误消息，你需要两类信息：系统里发生了什么？用户试图做什么？问题在于，真实系统里这两类信息往往分散在不同代码位置。

靠近 API 或 UI 边界的代码知道“用户是谁、正在做什么”。它最适合告诉用户下一步该做什么，且无需暴露用户看不懂的实现细节。

而问题本身通常发生在处理逻辑深处。

这在我们做错误分类时就出现过。做除法时，Python 的除法运算知道违反了哪条数学法则，但并不知道这次除法在业务里被怎么使用，因此无法给出高质量错误。

通常最好的抛错位置，是系统与用户的接口边界：在那里我们能把自底向上与自顶向下的知识合并。（另一种方案是把所有用户上下文一路向下传递，我会在后文讨论。）

一般来说，人们在接口层抛错有两种方式：

- 主动抛错：在 API 边界做<a id="id493"></a><a id="id494"></a>前置校验。
- 错误拦截：捕获底层错误后，重新封装成更合适的形式。

下面回到 Channelz，分别看这两种方式。

#### 前置校验 {#id284}

ChickenLittle 的可观测性团队又遇到了一个问题。

驱动他们值班告警的函数叫 `alert_team`：

```python
def alert_team(bot: ChannelzBot, team: Team, message: str):
    team_metadata = get_team_metadata(team)
    bot.send_message(users=[team_metadata['on_call_user']], message=message)
```

`get_team_metadata` 会读取 ChickenLittle 在 [*https://corp.chickenlittle.io/oncalls/*](https://corp.chickenlittle.io/oncalls/) 这个界面里维护的值班轮值数据库。

如果 `team_metadata[on_call_user]` 无效会怎样？回忆一下，`send_message` 会抛出这个错误：

`Error: Cannot deliver a Channelz message to '[@gooseyloosey]' because '@gooseyloosey' has been deactivated.`

这条消息是准确的，但当 Goosey Loosey 离职后，用户仍然不知道该如何修复。于是可观测性团队在前面加了一层校验，直接告诉用户下一步：

```python
def alert_team(bot: ChannelzBot, team: Team, message: str):
    team_metadata = get_team_metadata(team)
    if not channelz_user_exists(team_metadata['on_call_user']):
        error_message =
            f"Cannot send alert '{message}' to team {team}'s on-call: " +
            f"On-call employee {team_metadata['on_call_user']} doesn't exist. " +
            f"Update the team's on-call rotation at {ON_CALL_BASE_URL}/{team}."
        raise ValueError(error_message)
    bot.send_message(users=[team_metadata['on_call_user']], message=message)
```

用户缺失时，这个方法给出的消息是：

`Cannot send a Channelz alert to team 'barnyard-friends'. On-call user '@gooseyloosey' doesn't exist. Update your on-call rotation at https://corp.chickenlittle.io/oncalls/barnyard-friends.`

这个更上层的 API `alert_team` 比 `send_message` 更完整地捕捉了调用者意图，这是产出优秀错误消息的强大基础。

> [!NOTE]
> 在 API 或应用代码的最外层抛错，这样你才能捕捉用户场景。

这里“前置校验”确实有效，但并不完美。你能看出问题吗？

我们再看另一种技术：重新封装依赖抛出的错误，看看是否更好。

#### 重新封装错误 {#id44}

前置校验有两个问题<a id="id495"></a>。第一，它成本高：要多一次与 Channelz API 的往返。第二，也是本章更关心的：它会重复 Channelz API 内部已有的边缘情况检查逻辑，比如 `@gooseyloosey` 是否被停用。那类信息依然是可操作的，比如该员工只是改名导致 Channelz 句柄变化，这就需要另一种修复路径。

鉴于 Elise 过去给过很好的支持，可观测性团队再次向她反馈。他们更希望写成这样：

```python
def alert_team(bot: ChannelzBot, team: Team, message: str):
    team_metadata = get_team_metadata(team)
    try:
        bot.send_message(users=team_metadata['on_call_users'], message=message)
    except ChannelzUserNotFoundError as error:
        error_message =
            f"Cannot send a Channelz alert to team {team}'s on-call: " +
            f"On-call employee {team_metadata['on_call_user']} doesn't exist. " +
            f"Update the team's on-call rotation at {ON_CALL_BASE_URL}/{team}."
        raise ValueError(error_message) from error
```

注意最后一行的 `from error` 子句。这是 Python 表达“链式异常（chained exceptions）”的方式，可保留内部错误。很多编程语言都有类似机制。输出会是：

```
ChannelzUserNotFoundError: User @looseygoosey's account has been deactivated.

The above exception was the direct cause of the following exception:

ValueError: Cannot send a Channelz alert to team ‘barnyard-friends’.
On-call employee ‘@looseygoosey' doesn't exist.
Update your on-call rotation at
https://corp.chickenlittle.io/on-calls/barnyard-friends.
```

这条消息更长，但包含了用户可能想知道的一切。

可观测性团队于是请求 Elise 在 Channelz SDK 里提供更具体的错误类型，以便他们这样做。

ChickenLittle 这边员工频繁离职，Elise 只能希望她这个最喜欢的设计合作伙伴那边不是“天塌了”。随后她与 Deng 开始研究如何让异常更具*可编程性*。

既然我们已经深入到可编程性，这里就结束“可操作性”以及“在接口层抛诊断信息”的讨论，转向另一个重点：让错误对开发者及其<a id="id496"></a><a id="id497"></a>用户都可操作。

### 抛出可编程错误 {#id198}

有时候，在你的错误与终端用户之间<a id="EWMprog03"></a>还隔着一层开发者。这些开发者也遵循“在接口层处理错误”的同一原则，因此他们需要通过程序化方式拦截你的错误并采取不同动作。

而这一切只有在错误设计良好时才可能发生。要让运行时错误（系统错误、前置条件不满足、用户参数无效）对开发者可操作，你主要有三种技术：

- 抛出具体错误
- 对异常分组
- 添加元数据

注意：断言和开发者参数无效这两类异常可以共用同一种异常类型，因为它们发生在开发阶段，不应围绕它们构建运行时自动化。

#### 抛出具体错误 {#id285}

通用错误类型（例如 Python 的 `ValueError`）会让你的客户端无法定制自动化逻辑，也无法更好地告知其用户该做什么。

在任何运行时错误场景类别中构建异常时，你都应该抛出具体错误，就像上文 Channelz 新建 `ChannelzUserNotFoundError` 那样。

顺带说一句，我们刚强调要用更具体错误，可观测性团队却抛了 `ValueError`，你可能会觉得有点别扭。

```python
    if not channelz_user_exists(team_metadata['on_call_user']):
        error_message = # ...
        raise ValueError(error_message)
```

可观测性团队虽然不是平台团队，但他们组件外层随时可能再套一层 UI 或中间件，因此最好养成习惯，定义具体运行时错误。比如可以叫 `OncallNotFoundError`。

通过对处理器做几处小改动，Channelz 的 API 就比朴素实现更强大、可嵌套性也高得多。

> [!TIP]
> 把运行时错误（系统错误、前置条件不满足、用户参数无效）设计成可嵌套形式，便于上层代码构建。

#### 按场景类别分组错误 {#id199}

使用你 API 的<a id="id498"></a><a id="id499"></a>开发者，可能希望写一个通用处理器来统一处理某类错误。比如遇到系统错误时统一给终端用户显示“出问题了，请稍后重试”；而遇到用户参数无效时，则把消息直接回显给用户并期待其修正。

在大多数语言里，你可以用继承层级把相近错误分组。我倾向于为每种场景类别单独建一个基类。

你也可以部分借助内建类型。以 Python 为例，任意参数无效错误可用 `ValueError`，系统错误可用 `RuntimeError`。

但内建类型往往表达力不足。`ValueError` 无法区分“用户参数无效”和“开发者参数无效”，而两者后果完全不同。如果是*程序员*写错了，用户需要做的往往是联系支持，而不是自己修输入。所以我会为两者各建一个类，必要时继承 `ValueError`。

在非面向对象环境中，你可以用错误码表达类别，再用子码标识具体失败。标准往往做得不够好，所以你可能要补自定义。例如 HTTP 协议把错误按 4xx 归为“客户端错误”。和 Python 的 `ValueError` 一样，它无法表达“是用户导致还是开发者导致”。不过对某些前置条件错误（如鉴权失败）仍然有有用的标准码。

#### 为诊断保留信息 {#id45}

为了<a id="Dinfo03"></a><a id="infchain03"></a>写出好错误消息，我们需要保留大量信息。这要求工程纪律与良好代码组织，因为只要链路上第一个开发者没把信息传下去，整条信息链就断了。下面给出三种信息链示例。

##### 传递高层抽象 {#id286}

与其传递大量零散信息，不如传递把信息打包在一起的高层抽象。这样更容易产出丰富诊断。

例如，与其为了诊断而在各处传员工姓名、职位、句柄等字段，不如直接传一个包含所需信息的 `Employee` 对象。

像下面这种调用点会把链路断掉：

```python
def foo(bot: ChannelzBot, employee: Employee):
    bot.send_message(users=[employee.channelz_handle])
```

这样一来，维护者若想改进 `send_message` 的诊断，必须先重构；很多时候他们就懒得做了。

而下面这种方式能把信息链保住，给实现者更大空间：

```python
def foo(bot: ChannelzBot, employee: Employee):
    bot.send_message(employees=[employee])
```

当然，这会牺牲调用方灵活性：如果调用方拿不到 `Employee` 对象怎么办？我们真的该为了“诊断”限制接口访问吗？

这时场景分析可以帮你裁决。真的需要给非员工发消息吗？大概率不需要。代码库里是否有拿不到 `Employee` 对象的遗留路径？可能有。

如果是这样，可以额外提供一个接收原始用户句柄的 legacy 版本 `send_message`。这样手里有 `Employee` 对象的用户可以获得更好诊断，其他人也有过渡通道，直到完成重构。

保留更“厚”的信息链，意味着你只需很小额外成本就能写好诊断，或填充下一节要说的诊断元数据。

##### 添加结构化元数据 {#id46}

你<a id="id500"></a>还应在异常上提供元数据字段，这会显著提升其可编程性。不要逼别人从错误消息里解析数据！

永远假设调用方可能想自定义错误消息，所以你用于生成消息的数据也应同时放进元数据。比如可观测性团队可能想提取缺失的 Channelz 用户，那么 Channelz 就应在 `ChannelzUserNotFoundError` 上加一个 `user` 属性。

这样做能保证你的信息链不断裂。

##### 持久化额外上下文 {#id47}

在编译器这类分阶段数据转换架构中，我们往往到了后面几阶段才识别出错误，因此保留原始上下文非常关键。

回到开头的 LaTeX 例子：用户输入了多余的 `\\`，但错误却在谈 `underfull hboxes`。

词法分析器（lexer）是编译器第一步。它把 `\\` 这样的输入记号转成抽象 token，供下一阶段语法分析器（parser）读取。parser 不需要空白符或行号，所以 lexer 往往会把它们剔除。

但它不该这么做。

我猜那条警告很可能是在编译器后续某个阶段抛出的。此时 lexer 已把源码读完并吐出了 `hbox` token，原始源码上下文丢失了，于是任何“写出有用消息”的努力都会被掣肘。

这在旧式编译器里很常见。如今 lexer 通常会在输出中保留足够信息，使后续阶段能给出更现代的体验：

```
This is at the end of a block of text. \\
                                       ^^
Unnecessary \\ to end a paragraph on line 2.
```

上面“传递抽象、添加结构化元数据、持久化额外上下文”三点共享的核心教训是：

> [!TIP]
> 让信息链足够健壮，把对诊断有用的信息留住。

当你把系统信息和用户场景信息尽可能聚合在代码中的同一点时，才能写出最好的错误。这正是“错误可编程化”的意义。

而可编程性，来自一套严格实践：持续维护信息链，把结构化信息打包进错误对象。

还有一个剩余问题我还没讲：时机。我们何时触发诊断信息，会对用户产生巨大影响<a id="id501"></a><a id="id502"></a><a id="id503"></a>。

### 尽早诊断 {#id48}

尽早给出<a id="EWMearly03"></a><a id="Dearly03"></a>诊断，常被称为<a id="id504"></a>*左移（shifting left）*，这对系统和用户都大有裨益。

> [!TIP]
> 左移。尽可能早地把诊断信息给到用户。

对系统而言，左移通过尽早剪断无意义代码路径来减少资源消耗。例如，它能帮助抵御拒绝服务攻击。它也能保护相关代码不去处理不可预期输入，从而避免数据丢失等 bug。

用户获益更大。越早报错越省时间，想想在 IDE 里立刻报错和部署到生产后才报错的差异。并且，反馈越快，用户越容易记住自己刚做了什么，也越容易确信下一步动作。

以下是四种常见的左移技术：

- 做静态校验
- 做前置校验
- 让用户先测试
- 请求用户确认

工程师普遍会做前两项，但可惜后两项经常被忽略。我来这里就是想“布道”这四项都要做。

#### 做静态校验 {#id49}

在<a id="id505"></a><a id="id506"></a>校验任何输入时，静态校验通常便宜，不需要深度检查或网络调用；动态校验则需要更多成本或上下文。

> [!TIP]
> 把低成本检查和高成本检查分开，低成本检查要尽早做、频繁做。

很多程序员熟悉静态类型检查和 lint 的乐趣，但这件事也同样适用于产品。

例如在应用表单收集用户输入时，要尽量用低成本方式尽早拦截最常见错误，并给出内联提示告诉用户该改哪里。邮编可以先校验是否符合所在国家长度；信用卡号、UPC 码、ISBN 码都带有校验位，可防止常见错误如手误或数字调位。这些技术既实现左移，也提高了诊断确定性。若号码校验位失败，我们就知道它不只是数据库里“没录入”，而是号码本身就错了。

#### 前置校验 {#id50}

前面提到在应用或 API 表层构造错误时<a id="id507"></a><a id="id508"></a>，前置校验是写出更可操作、更易理解错误消息的重要工具。它同时也是左移工具。

想象你去自助洗衣店洗衣，洗完才发现只有一台烘干机在运行，而且排队好几个小时。要是门口早点贴个告示，你就不会得到一堆又湿又发霉的衣服。

同理，转账场景里，必须先确认收款账户有效，再从付款账户扣款。

像洗衣、资金转移、以及洗钱这样的多步骤流程，通常都受益于前置校验。

#### 让他们先测试 {#id51}

如果说有哪类用户场景最常被平台工程师忽略，那就是测试<a id="id509"></a>。他们只盯着客户在生产环境成功使用产品，却忽略客户在到达那一步前经历的反复试验。

如果你在构建开发者服务，只要提供一个 *fake*，客户会非常喜欢你，而且产品采用会更快。fake 是高保真的生产系统替身：尽量复用生产路径代码，同时对数据库、在线服务等脆弱运行时依赖做必要简化，以避免测试变慢和不稳定。

Channelz 应为其消息 API 构建一个 fake 服务。理想情况下它应：

- 以内存模式或轻量本地进程运行，便于用户在测试环境与本地开发机上测试
- 允许用户注入一批用户和频道，从而测试所有依赖该 API 的代码路径
- 在尽可能多场景下与生产服务行为一致

真实世界例子是 Stripe（支付与计费 API/UI 提供商）提供的流行“测试模式”：你可以做逼真交易而不真正转钱。比如客户可传入特殊信用卡号，触发不同“用户参数无效”与“前置条件”错误。信用卡号 `4000 0000 0000 9995` 就会模拟 `card_declined` 错误及其 `insufficient_funds` 子码。

Stripe 用户在测试模式上花的时间远多于生产环境：他们用它写集成测试、测用户界面。比如商家想测试自己的信用卡输入表单时，可以手工填这些“魔法号码”观察网站行为。

fake 是把错误*大幅*左移到<a id="id510"></a>最前面的优秀手段，甚至可以左移到“开发者还没完成认证或提交生产请求”之前。

#### 请求用户确认 {#id52}

确认步骤<a id="id511"></a><a id="id512"></a>是你在应用或平台里设置的“路障”，帮助用户确认自己是否做对了。它比警告更醒目，但又没有错误那样强干预。

当启发式算法发现用户输入有异常时，这类确认经常出现在 UI 或开发者工具里。它会解释为什么输入可能不符合预期或存在风险，并给用户机会去纠正或确认继续。

Google 的 “Did you mean” 就是好例子。用户搜索 “compture” 时，也许他真的是在找乐队 Compture。所以 Google 不能直接报错，但它可以提前告诉用户自己的怀疑，而不是让用户在翻了很多搜索结果后才自己发现。

或者在你刚让用户填完多页表单后，先展示一页提交摘要，让他们检查错误。

确认步骤让你在“无法在完整跑完系统前百分百确定用户出错”的场景中也能左移：你虽然不能完全确定，但可以给出高质量猜测。

一种<a id="id513"></a>常见的前置测试方法是“dry run + 确认”。在股票交易 App 里，这可以简单到：把计划购买股数乘以当前股价，先展示预计花费。

再看 Channelz 里的复杂 dry run。假设 Elise 想给 API 增加重试策略，使用方式如下：

```python
ChannelzBot('@bippity_bot')
    .with_retry_policy(
	    backoff_coefficient=2.0,
	    initial_interval_seconds=10, max_interval_seconds=600)
    .send_message(...)
```

如果 ChickenLittle 配了一个极其“刷屏”的<a id="id514"></a>重试策略：每秒重试一次，且永不停止，会怎样？这可能对 Channelz 造成一次意外的 DoS（拒绝服务）式攻击，随后 ChickenLittle 的流量几乎必然会被限流。

```python
# Too spammy!
.with_retry_policy(backoff_coefficient=1.0, initial_interval_seconds=1)
```

Elise 可以通过模拟重试策略并标记异常行为，给出启发式警告，把问题左移：

`Your retry_policy (currently initial_interval_seconds=1, backoff_coefficient=1.0, max_attempts=Infinite) will result in 601 attempts in 600 seconds. This exceeds our limit of 50. You may ignore this by adding .ignore(Errors::RetryPolicySpamminess) to your policy.`

Elise 对具体启发式并非百分百确定，但她可以先快速上线这类确认，及时帮到用户并暂时阻断开发。如果启发式过严或过松，用户会反馈，她再上调或调整即可。

在开发者工具中，`--force` 标志通常可覆盖确认。

确认不是万无一失的，用户可能想都不想就确认，或直接复制粘贴 `--force`。因此，对那些你绝对不能接受的输入，不要只靠确认。但我认识的大多数开发者习惯“二元绝对”：输入要么合法，要么不合法。若你愿意考虑中间地带，即输入*大概率*有问题，你会解锁界面表达力与交互丰富性的巨大空间。

本节我们讨论了左移的价值，也覆盖了许多能从左移中受益的用户场景。

由于左移有时意味着我们无法做完整、完美的校验，我介绍了服务 fake、启发式确认、以及校验位这类静态校验等技术，来尽可能早地处理最常见的用户错误<a id="id515"></a><a id="id516"></a>。

### 本章小结 {#id200}

当<a id="id517"></a>你开始写接下来的几个诊断信息时，请先把注意力切到用户体验：他们已经知道什么、还需要知道什么、应该做什么。如果你在写错误，把它先归入场景类别：系统错误、用户参数无效、前置条件、开发者参数无效，或断言。这样你更容易推导消息与元数据应如何构造。

在消息编写上：

- 给出上下文。大多数情况下，回显正在执行的操作与传入的错误数据。
- 使用产品面向用户本体中的概念。
- 给出行动建议；如果不止一个方案，要愿意给出备选。

如果你能在接口边界抛错并展示给用户，你更可能把这些事做好。对于开发者，请让错误携带足够的上下文和结构化信息，以便其他开发者能完成他们的工作。把错误组织成层级结构，让开发者既能通用处理，也能精细处理，从而更好服务其用户。

最后，针对常见或关键场景，创造性地做左移，比如通过确认机制、静态检查和 fake 服务。

### 练习 {#id201}

1. 搜索<a id="Eerror03"></a>“Windows Blue Screen of Death Evolution”，观看 Windows 团队几十年改进错误消息的过程。 (a) 判断这些消息分别在服务哪些人物画像。 (b) 视频后段会看到 Windows 11 蓝屏，请按你选定的人物画像分析其消息。
2. 接下来几题假设你在做一个电商 App。用户可以填购物车并结账。应用通过 `submit_order` API 完成下单，字段包括：用户 ID、购物车 ID、信用卡 CVV（用于验证信用卡的三位或四位安全码）。你的移动端客户端具备在上送数据到 API 前做静态校验的能力。
   无效用户 ID 和无效购物车 ID 属于哪类错误场景？
3. 无效 CVV 码属于哪类错误场景？
4. 空 CVV 码又属于哪类？
5. 请为“CVV 缺失”写一条面向终端用户、可操作的错误消息。
6. 购物车 24 小时后过期并会被系统自动删除。用户尝试恢复会话并向已删除购物车加购时，抛出的错误属于哪类场景？
7. 你能想到一种把“购物车过期”错误左移的方法，让用户不必重新找回每个商品吗？

### 参考答案 {#id53}

1. 在写作本章时，Windows 11 的消息是：“Your device ran into a problem and needs to restart. We’re just collecting some error info, and then we’ll restart for you. For more information about this issue and possible fixes, visit [*https://www.windows.com/stopcode*](https://www.windows.com/stopcode). If you call a support person, give them this info: Stop Code: SOME_ERROR_CODE.”
   这条消息主要面向终端用户，并给出了清晰动作。它使用 URL 是个很强的技巧，因为该 URL 可以持续更新并提供细粒度指导。最后提到 stop code，明确暗示这部分与 IT 专业人士相关，说明这条消息有两个不同受众。不过它并没有特别努力去帮助这类专业人士，或许是因为作者假设这类人会自行上网检索，比如如何在本机查 crash dump。
2. 无效用户 ID 与无效购物车 ID 属于“开发者参数无效”错误。但如果用户未登录导致用户 ID 为空，则是“前置条件”问题，用户可自行处理。
3. 无效 CVV 码属于“用户参数无效”。
4. 空 CVV 码表面上也属于“用户参数无效”。但设计良好的客户端应先静态检查空字段并提示用户补全，再去请求服务器。因此 API 也可以把它视为“开发者问题”，从而更明确地把“字段缺失”暴露为 bug（例如客户端忘了上传该字段）。
5. 我会设想一个红色错误框高亮无效 CVV，并用提示文案解释：“请输入信用卡安全码。Visa、Mastercard、Discover 通常为卡背面三位数字；American Express 通常为卡正面四位数字。”
6. 购物车过期属于“前置条件”错误，且用户可操作。因此，购物车过期实现应允许 API 区分“ID 无效（开发者问题）”与“购物车过期”。例如过期购物车可做软删除，而不是从数据库彻底移除。（这有时称为 tombstoning。）
7. 你可以在购物车过期前通过邮件或推送提醒用户尽快完成<a id="id518"></a>订单。
