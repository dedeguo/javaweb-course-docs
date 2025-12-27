---
title: 附录 A2. 简单的 RAG 实现 (让 AI 读懂你的教材)
---
# 附录 A2. 简单的 RAG 实现 (让 AI 读懂你的教材)

!!! quote "📖 本节目标：给 AI 搞一场“开卷考试”"
    普通的 AI 对话就像 **“闭卷考试”**：AI 只能靠训练时的记忆回答，问它“陈老师这学期教什么课？”，它肯定不知道。
    **RAG (Retrieval-Augmented Generation)** 就是 **“开卷考试”**：  
    我们把《课程教学大纲》塞给 AI，当用户提问时，AI 先去翻书（检索），找到答案后再回复。  

    今天，我们用 Spring AI 快速实现一个 **“课程助教”**。

---

## 🧩 第一步：RAG 核心概念图解

Spring AI 把 RAG 的流程标准化为 **ETL** 三部曲：

1. **Read (读)**：读取你的 PDF/Word/TXT 文件。
2. **Transform (变)**：把长文章切成小段 (TokenSplitter)。
3. **Write (存)**：把文字变成**向量 (Vector)**，存入向量数据库。

当用户提问时，Spring AI 会自动去向量库里“搜”出最相关的段落，拼到 Prompt 里发给 AI。

---

## 📦 第二步：准备“知识库”

为了简单起见，我们不安装复杂的向量数据库（如 Chroma/Milvus），而是使用 Spring AI 内置的 **`SimpleVectorStore`**（基于内存，像 HashMap 一样简单）。

### 1. 准备数据文件

在 `src/main/resources` 下新建一个 `syllabus.txt` (教学大纲)：

```text title="src/main/resources/syllabus.txt"
【课程信息】
课程名称：Java 企业级开发
授课老师：陈老师
适用班级：24级计科5班
核心内容：Spring Boot 3、MyBatis、Spring AI、信创国产化适配。
期末考核：平时成绩 40% + 期末大作业 60%。

```

### 2. 编写配置类 (构建知识库)

我们需要写一个 `@Configuration`，在项目启动时把这个文件读进去，变成向量存起来。

```java title="RagConfiguration.java"
@Configuration
public class RagConfiguration {

    @Value("classpath:syllabus.txt")
    private Resource syllabusResource;

    /**
     * 定义一个基于内存的简单向量库
     * EmbeddingModel: 负责把文字变成 [0.1, 0.5, ...] 的数学模型 (Spring AI 自动注入)
     */
    @Bean
    public VectorStore vectorStore(EmbeddingModel embeddingModel) {
        SimpleVectorStore vectorStore = new SimpleVectorStore(embeddingModel);
        
        // 1. 读取文档
        TextReader textReader = new TextReader(syllabusResource);
        List<Document> documents = textReader.get();

        // 2. 切分文档 (TokenTextSplitter)
        // 就像把一整只烤鸭切成片，方便 AI 一口口吃
        TokenTextSplitter splitter = new TokenTextSplitter();
        List<Document> splitDocuments = splitter.apply(documents);

        // 3. 存入向量库 (这一步会调用 AI 接口生成向量)
        vectorStore.add(splitDocuments);
        
        System.out.println("✅ 知识库加载完毕！已存入 " + splitDocuments.size() + " 个片段。");
        return vectorStore;
    }
}

```

---

## ⚡ 第三步：魔法时刻 (QuestionAnswerAdvisor)

在第 5 章，我们需要手动把搜到的资料拼接到 Prompt 里。
在 Spring AI 中，我们只需要在 `ChatClient` 上挂载一个 **Advisor (顾问)**。

```java title="RagController.java"
@RestController
@RequestMapping("/ai")
public class RagController {

    private final ChatClient chatClient;

    // 注入刚才配置好的向量库
    public RagController(ChatClient.Builder builder, VectorStore vectorStore) {
        this.chatClient = builder
                // 🪄 核心魔法：挂载“问答顾问”
                // 它会自动拦截用户的问题，去向量库里搜答案，然后塞给 AI
                .defaultAdvisors(new QuestionAnswerAdvisor(vectorStore, SearchRequest.defaults()))
                .build();
    }

    @GetMapping("/ask-syllabus")
    public String askSyllabus(@RequestParam String question) {
        // 你看，代码里完全不用提“RAG”或者“向量”，像普通聊天一样写就行！
        return chatClient.prompt()
                .user(question)
                .call()
                .content();
    }
}

```

---

## 🧪 第四步：见证奇迹

启动项目，你会看到控制台打印 `✅ 知识库加载完毕！`。

### 场景 1：不带 RAG (AI 瞎编)

如果不加 Advisor，你问：“陈老师这学期教什么？”，DeepSeek 会回答：“抱歉，我不认识陈老师。”或者瞎编一个“陈老师教语文”。

### 场景 2：带 RAG (AI 开卷)

访问接口：
`http://localhost:8080/ai/ask-syllabus?question=这门课期末怎么算分？`

**AI 回复：**

> “根据教学大纲，这门课的期末考核方式是：平时成绩占 40%，期末大作业占 60%。”

**AI 甚至能推理：**
`http://localhost:8080/ai/ask-syllabus?question=我平时分拿满，期末考多少分能及格？`

**AI 回复：**

> “如果平时成绩满分（40分），你需要总分达到 60 分及格。那么期末大作业至少需要获得 (60 - 40) = 20 分。”

---

## 📝 总结

通过 **Spring AI**，我们实现 RAG 只需要两步：

1. **启动时**：把文本塞进 `VectorStore`（Spring AI 帮我们切分、向量化）。
2. **调用时**：加上 `.defaultAdvisors(new QuestionAnswerAdvisor(...))`。

这就是框架的魅力。它把 **“搜索 -> 拼接 -> 提问”** 这一套复杂的 RAG 流程，变成了一个简单的**拦截器配置**。

!!! tip "课后作业"
    试着把 `syllabus.txt` 换成你的 **PDF 格式** 电子书，然后引入 `spring-ai-pdf-document-reader` 依赖。  
    你会发现，只需要改一行代码 (`new PagePdfDocumentReader(...)`)，你就能拥有一个可以对话的 PDF 阅读器了！

---

