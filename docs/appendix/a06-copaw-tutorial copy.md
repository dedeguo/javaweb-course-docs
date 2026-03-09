---
title: 附录 A06：零成本体验专属 AI 助理 CoPaw
---

# 附录 A06：无需购买 API 与云主机，也能体验“养虾”的快乐 (CoPaw 零成本教程)

!!! quote "🦐 什么是“养虾”？"
    **CoPaw** (Copilot Paw) 是由 AgentScope 团队开源的一款超可爱的个人 AI 助理。它的标志性 Mascot 是一只活蹦乱跳的“赛博大虾”，因此在开发者圈子里，使用 CoPaw 通常被称为**“养虾”**。
    
    通常，部署一个全功能的 AI Agent 需要云服务器和昂贵的 API Key。但今天，我们将利用**魔搭社区 (ModelScope) 的创空间**和**免费模型 API**，一键“白嫖”属于你的 AI 助理！

---

## 🎯 课前准备

在开始“养虾”之前，请确保你已经拥有了**魔搭社区 (ModelScope)** 的账号和 API Key。

* 如果你还没有，请出门左转查看：[👉 附录 A：开发者账号申请指南](a01-account-guide.md)。
* 请准备好你的魔搭 Access Token（以 `sk-` 开头）。

---

## 🚀 第一步：魔搭创空间一键部署 (无需安装)

传统的开源项目需要你在本地执行 `git clone`，安装一堆 Python 依赖环境，非常容易报错。而魔搭的**“创空间 (Spaces)”**提供了一键克隆运行的魔法。

1. **访问官方创空间**：
   打开浏览器，访问 CoPaw 在魔搭的官方空间：
   [🔗 https://www.modelscope.cn/studios/AgentScope/CoPaw](https://www.modelscope.cn/studios/AgentScope/CoPaw)

2. **复制空间 (Clone Space)**：
   在页面右上角，找到并点击 **“复制空间”** 按钮。

3. **配置你的私有空间**：
   * **空间名称**：随意起个名字，比如 `My-Smart-CoPaw`。
   * **空间可见性**：建议选择 **“私有”**。
   * 点击 **“确认”**。

4. **等待环境构建**：
   系统会自动为你分配免费的云端 CPU 算力，并拉取代码构建环境。这个过程大概需要 1-3 分钟。当状态变为 **“运行中 (Running)”** 时，你的专属“赛博大虾”就部署成功了！

---

## ⚙️ 第二步：配置大模型 (零成本 API)

此时你应该能看到 CoPaw 的操作界面了。但是，现在的“大虾”还没有大脑，我们需要把魔搭的免费大模型接入进去。

CoPaw模型提供商已经有ModelScope, 所以我们只需可以在ModelScope 中配置API Key。

1. 在 CoPaw 界面的左侧的**设置**面板中，找到 **“模型 (Model Settings)”** 。
2. 模型提供商选择平台为 **ModelScope**。
3. 点击设置输入你的魔塔社区API Key，保存配置。
![CoPaw API Key 配置](../assets/imgs/copaw/copaw_model_config.png){ width="70%" .shadow }
4. 模型配置，点击模型，点击添加模型，输入模型ID(例如：moonshotai/Kimi-K2.5）。
![CoPaw 添加模型](../assets/imgs/copaw/model_add.png){ width="70%" .shadow }
*(提示：如果你更喜欢用 DeepSeek或其它模型，只要魔搭平台支持且免费，你也可以添加 `deepseek-ai/DeepSeek-R1-0528` 等模型名称。)*
5. CoPaw LLM大模型配置: 提供商选择**ModelScope**, 模型选择你刚配置的模型，例如**moonshotai/Kimi-K2.5**，点击保存。
![ LLM大模型](../assets/imgs/copaw/LLM_config.png){ width="70%" .shadow }

---

## 🦐 第三步：开始体验“养虾”的快乐

配置完成后，回到 CoPaw 的主对话界面，你可以开始使唤你的专属 AI 助理了！

### 💬 玩法建议：

1. **首次对话完成引导**：
   > “嘿，大虾，让我们开启一段新的旅程吧！”。 根据大虾的提示，提供相关信息，对 AI 助理 CoPaw进行预设。这样AI助理更懂你！   
   ![CoPaw 引导](../assets/imgs/copaw/copaw_bootstrap.png){ width="70%" .shadow }
2. **智能体扩展CoPaw的能力**：
   CoPaw 左侧**智能体**配置栏可以配置**MCP**，**技能Skills**。  
   例如可以配置第五章学过的高德地图MCP、12306MCP，你的专属CoPaw就拥有了地图查询，火车票查询等功能。   
3. **频道接入**：
   接入飞书频道，你就可以通过手机飞书APP，向你的CoPaw发送指令了。  
   具体配置教程参考： [🔗 https://copaw.agentscope.io/docs/channels#飞书](https://copaw.agentscope.io/docs/channels#%E9%A3%9E%E4%B9%A6)。  
   下图是与通过手机飞书APP与CoPaw对话：“当前系统界面截图发我一下”。  
   ![飞书 对话](../assets/imgs/copaw/feishu_chat.png){ width="70%" .shadow }

---

## ✅ 总结与自查

通过这个实验，你不仅零成本获得了一个高颜值的个人 AI 助理，更重要的是，你亲自体验了：

* **Serverless 部署**：理解了什么是“创空间 / ModelScope Spaces”。
* **协议兼容的魅力**：再次验证了“只要兼容 OpenAI 接口，就能无缝接入任何通用 AI 客户端”的行业标准。

**遇到问题？**

* 如果提示 `401 Unauthorized`：请检查你的魔搭 Token 是否复制完整，中间不要有空格。
* 如果一直无响应：可能是魔搭的免费并发接口比较拥挤，稍微等一下或重试即可。

快去调教你的“赛博大虾”吧！🎉

