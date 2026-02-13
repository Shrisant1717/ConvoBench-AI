FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose port for Gradio/Streamlit
EXPOSE 7860

# Default command to run the notebook as a script or launch the UI
# In a real scenario, we might use papermill to run the notebook
CMD ["python", "-m", "gradio", "app.py"] 
