import os
import cohere
import requests
from fastapi import FastAPI
from pydantic import BaseModel
from dotenv import load_dotenv

# --- CONFIGURATION ---
# Load variables from your .env file
load_dotenv()

# Initialize FastAPI app
app = FastAPI()

# Get API keys from environment variables
COHERE_API_KEY = os.getenv("COHERE_API_KEY")
FIREWORKS_API_KEY = os.getenv("FIREWORKS_API_KEY") # Using Fireworks.ai for fast image generation

# Check if keys are loaded
if not COHERE_API_KEY:
    raise ValueError("Cohere API key not found. Check your .env file.")
if not FIREWORKS_API_KEY:
    raise ValueError("Fireworks API key not found. Check your .env file.")

# Initialize Cohere Client
co = cohere.Client(COHERE_API_KEY)

# --- SYSTEM PROMPT ---
# This is the master instruction set for your chatbot's personality
SYSTEM_PROMPT = """
You are 'AgapAI', a friendly, encouraging financial guide for Filipino entrepreneurs. 
Your goal is to help users explore financial 'what-if' scenarios through an interactive story.
- Always communicate in simple, layman's terms.
- Your tone should be empowering and clear.
- End every response with a narrative story segment and exactly two or three clear, actionable choices for the user to continue the story.
- Format your response as a JSON object with two keys: "narrative" (for the story text) and "choices" (a list of strings for the user's next action).
- Never give direct financial advice; instead, explore the potential outcomes of their choices. You are an educational tool, not a licensed advisor.
"""

# --- DATA MODELS (for request/response validation) ---
class ChatMessage(BaseModel):
    role: str
    message: str

class StoryRequest(BaseModel):
    chat_history: list[ChatMessage]
    user_input: str

class ImageRequest(BaseModel):
    prompt: str

# --- API ENDPOINTS ---

@app.post("/generate-story")
async def generate_story(request: StoryRequest):
    """
    This endpoint generates the story text and choices. It's designed to be very fast.
    """
    try:
        response = co.chat(
            model="command-r-plus",
            preamble=SYSTEM_PROMPT,
            chat_history=request.chat_history,
            message=request.user_input,
        )
        print(response.text)

        # Assuming the response text is a valid JSON string as instructed in the prompt
        return response.text
    except Exception as e:
        return {"error": str(e)}

@app.post("/generate-image")
async def generate_image(request: ImageRequest):
    """
    This endpoint generates an image based on the story prompt. This is the slower call.
    """
    API_URL = "https://api.fireworks.ai/inference/v1/images/sd3"

    # A style prompt to keep the visuals consistent
    full_prompt = f"A digital illustration for a financial planning app, depicting: {request.prompt}. The style is hopeful, clean, and modern, with a Filipino setting."

    payload = {
        "model": "models/stable-diffusion-3",
        "prompt": full_prompt,
        "height": 512,
        "width": 512,
        "steps": 25, # Fewer steps for faster generation
    }

    headers = {
        "Authorization": f"Bearer {FIREWORKS_API_KEY}",
        "Content-Type": "application/json",
    }

    try:
        response = requests.post(API_URL, headers=headers, json=payload)
        response.raise_for_status() # Raises an exception for bad status codes
        # The Fireworks API returns an image list, we'll take the first one
        # Note: The image is base64 encoded. For a real app, you might upload this to a
        # storage bucket and return the URL. For a hackathon, returning the base64
        # string is faster and simpler for the Flutter app to handle directly.
        image_data = response.json()["images"][0]
        return {"imageUrl_base64": image_data}
    except Exception as e:
        return {"error": str(e)}