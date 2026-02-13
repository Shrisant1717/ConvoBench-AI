# Technical Setup & Architecture Guide
## Conversation Evaluation Benchmark (Ahoum Assignment)

This guide provides a comprehensive overview of the setup, architecture, and execution details for the Conversation Evaluation Benchmark.

---

## 1. Project Overview
The goal of this project is to build a production-ready system capable of scoring conversation turns across **300+ distinct facets** (and scaling to 5,000+) using open-weight Large Language Models (LLMs) ≤ 16B.

**Dataset**: [Facets Assignment.csv (Google Drive)](https://drive.google.com/file/d/1wLcAoUSfCBhbkZdCwGs6QUU_yjrFeF3A/view)

### Key Pillars:
- **Linguistic Quality**: Grammar, syntax, and tone.
- **Pragmatics**: Contextual relevance and goal alignment.
- **Safety**: Policy adherence and harm prevention.
- **Emotion**: Sentiment and empathy detection.

---

## 2. Technical Architecture: Scalability First

### The Problem: Prompt Overflow
LLMs have context window limits. Sending 300 (or 5,000) facets in a single prompt causes "attention dilution," where the model ignores many facets or produces malformed outputs.

### The Solution: Hierarchical Batching Engine
The engine implemented in `evaluation_benchmark.ipynb` uses a **Batched Orchestration** strategy:
1.  **Facet Chunking**: The 300 facets are divided into small, manageable batches (e.g., 12-15 facets per request).
2.  **Stateless Inference**: Each batch is processed as a separate LLM call to maintain high reasoning focus.
3.  **Result Aggregation**: A collector logic gathers JSON responses from all batches and merges them into a single score report for the conversation turn.

**Scaling to 5,000 Facets**: This architecture handles 5,000 facets by simply increasing the number of batches. Since the batches are independent, they can be processed in parallel across multiple GPU workers in a production environment.

---

## 3. Setup Instructions

### Environment Prerequisites
- **Python**: 3.10+
- **Hardware**: 
    - *Local*: NVIDIA GPU with 8GB+ VRAM (for running Llama 3 locally).
    - *Cloud*: Google Colab (Free or Pro) or Hugging Face Spaces.
- **API Key**: Groq API Key (get it from [console.groq.com](https://console.groq.com/)).

### API Key Acquisition (Groq)
Since the assignment requires **Open Weights** and high speed, we use **Groq**. Follow these steps to get your key:
1.  **Register**: Go to [console.groq.com](https://console.groq.com/).
2.  **Login**: Sign in with Google, GitHub, or Email.
3.  **Create Key**: Navigate to **"API Keys"** in the left sidebar.
4.  **Copy**: Click **"Create API Key"**, name it "Ahoum-Benchmark", and copy the string (starts with `gsk_`).

---

## 4. Execution Workflow

### Step 1: Data Cleaning
The `Facets Assignment.csv` is preprocessed to:
- Remove numbering (e.g., "892. ").
- Clean headers/colons.
- Categorize facets based on CSV structure (Safety, Pragmatics, etc.).

### Step 2: Scoring
Run the main notebook. The `EvaluationEngine` will:
1.  Generate 50 synthetic test conversations based on `sample_base.json`.
2.  Iterate through each turn and facets in batches.
3.  Output a `final_evaluation.json` containing:
    - `facet_name`
    - `score` (1-5 scale)
    - `reasoning` (Chain-of-Thought)
    - `confidence` (1-5)

### Step 3: Visualization
The built-in **Gradio UI** allows you to select a conversation index and see a tabular breakdown of all facet scores instantly.

---

## 5. Deployment (Dockerized Baseline)
For production deployment, use the provided Dockerfile:
```bash
docker build -t ahoum-benchmark .
docker run -p 7860:7860 ahoum-benchmark
```

---

## 6. Bonus Features Implemented
1.  **Confidence Metrics**: Every score includes an LLM-judged confidence level.
2.  **Scalable Schema**: The system supports 5000+ facets without code modification.
3.  **Interactive Dashboard**: Real-time results exploration via Gradio.
