# Conversation Evaluation Benchmark

This project implements a production-ready benchmark for scoring conversation turns on 300+ distinct facets using open-weight LLMs (<= 16B).

## Features
- **Scalable Architecture**: Uses a hierarchical batching engine to process 300+ facets without prompt overflow.
- **Open Weights Support**: Optimized for Llama 3, Qwen 2, and Mixtral via `litellm`.
- **Confidence Scoring**: Every score includes a self-reported confidence level.
- **Interactive Dashboard**: Built-in Gradio UI for score visualization.

## Quick Start (Google Colab)
1.  **Get a Key**: Register at [console.groq.com](https://console.groq.com/) and create a free API Key.
2.  **Download Dataset**: Obtain `Facets Assignment.csv` from [Google Drive](https://drive.google.com/file/d/1wLcAoUSfCBhbkZdCwGs6QUU_yjrFeF3A/view).
3.  **Upload**: Upload [evaluation_benchmark.ipynb](./evaluation_benchmark.ipynb) and `Facets Assignment.csv` to Google Colab.
3.  **Run**: Execute the cells. When prompted, paste your `GROQ_API_KEY`.
4.  **Visualize**: Once finished, the Gradio dashboard will appear at the bottom of the notebook.

## Project Structure
- `evaluation_benchmark.ipynb`: Main implementation, data cleaning, and evaluation loop.
- `Facets Assignment.csv`: The facet definitions repository.
- `Dockerfile`: Baseline for containerized deployment.
- `requirements.txt`: Python dependencies.

## Architecture
The system avoids "one-shot" prompts by:
1.  **Preprocessing**: Cleaning facet names and categorizing them.
2.  **Batching**: Dividing 300 facets into small chunks (10-15) to maintain high reasoning quality.
3.  **Parallel Execution**: (In production) Batches can be sent to LLM instances concurrently.
4.  **Confidence Logic**: LLMs are prompted to justify scores and rate their own certainty.

## Scalability
By using a batched `EvaluationEngine`, scaling to 5000 facets is simply a matter of processing ~330 batches per turn, which can be easily horizontalized using message queues (e.g., Celery/RabbitMQ) in a full production system.
