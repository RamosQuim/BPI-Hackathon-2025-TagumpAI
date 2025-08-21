import os
import cohere
import requests
import base64
import json
import ast
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from dotenv import load_dotenv

# --- CONFIGURATION ---
load_dotenv()
app = FastAPI()

COHERE_API_KEY = os.getenv("COHERE_API_KEY")
FIREWORKS_API_KEY = os.getenv("FIREWORKS_API_KEY")

if not COHERE_API_KEY:
    raise ValueError("Cohere API key not found. Check your .env file.")
if not FIREWORKS_API_KEY:
    raise ValueError("Fireworks API key not found. Check your .env file.")

co = cohere.Client(COHERE_API_KEY)


# --- DATA MODELS ---
class ChatMessage(BaseModel):
    role: str
    message: str

class StoryRequest(BaseModel):
    chat_history: list[ChatMessage]
    user_input: str
    initial_prompt: str | None = None

class ImageRequest(BaseModel):
    prompt: str

# --- SYSTEM PROMPT ---
# Using your detailed prompt
STORY_GENERATION_PROMPT = """
# PERSONA
- You are 'AgapAI', a friendly, encouraging financial guide for Filipino who want to make their finance healthy. Your primary function is to generate segments of an interactive story.

# CORE INSTRUCTIONS
- Your tone is always empowering, clear, and uses simple, layman's terms.
- Your language depends on the user's language.
- The story is about exploring financial 'what-if' scenarios.
- Each story segment must end with exactly two or three clear, actionable choices for the user. Each choice MUST be a single, concise sentence.
- You are an educational tool, NOT a licensed financial advisor. Never give direct financial advice.
- This interactive story-based financial sandbox will be about 4 to 7 scenarios only.
- You will recommend the most practical suggestion about the decision based on the scenario given.
- During the recommendation part, you will summarize the created story first in around 7 sentences.

# RULES
Your ONLY task is to continue the story based on the user's last choice.
You MUST use the `StoryOutput` tool to submit your response. Do not respond in any other way.

# EXAMPLE
{"narrative": "The next part of the story happens here.", "choices": ["This is choice one.", "This is choice two."]}
"""

# ADDED: This is a new prompt specifically for summarizing the story
STORY_SUMMARY_PROMPT = """
# PERSONA & TASK
- You are 'AgapAI', a friendly Filipino financial guide. Your task is to conclude the user's financial story.
- Review the entire chat history provided.
- Based on the user's journey and decisions, write a final, encouraging summary.
- Provide practical recommendations and key takeaways from their story.
- Your tone should be empowering and congratulatory.

# RESPONSE FORMATTING RULES
- Your ONLY output will be a single, valid JSON object with two keys: "narrative" and "choices".
- The "narrative" key MUST contain your full summary and recommendations.
- The "choices" key MUST be an empty array: [].
- DO NOT add any text before or after the JSON object. Start with { and end with }.

# EXAMPLE
{"narrative": "Congratulations on completing your financial story! Based on your choices, you've shown great discipline in saving... A key takeaway is to always have a clear goal...", "choices": []}
"""

# --- API ENDPOINT ---
@app.post("/generate-story")
async def generate_story(request: StoryRequest):
    try:
        final_prompt = STORY_GENERATION_PROMPT
        message_to_send = request.user_input + "\n\n(Remember: Your entire response must be ONLY a single, valid JSON object with 'narrative' and 'choices'.)"

        # --- MODIFIED: Check for the "Finish" command ---
        if request.user_input == "Finish my story":
            print("--- FINISH STORY COMMAND RECEIVED ---")
            final_prompt = STORY_SUMMARY_PROMPT
            # No need to append instructions, the summary prompt is clear
            message_to_send = "Please summarize my story and give me takeaways based on our conversation."

        cohere_response = co.chat(
            model="command-r-plus",
            preamble=final_prompt, # Use the correct prompt
            chat_history=request.chat_history,
            message=message_to_send,
            max_tokens=2048
        )

        response_text = cohere_response.text
        print(f"--- RAW AI RESPONSE ---\n{response_text}\n-----------------------")

        # Robust JSON parsing logic remains the same
        try:
            start_index = response_text.find('{')
            end_index = response_text.rfind('}')
            if start_index != -1 and end_index != -1:
                json_string = response_text[start_index : end_index + 1]
                json_data = json.loads(json_string)
                return JSONResponse(content=json_data)
            else:
                raise ValueError("No JSON object found in the AI response.")
        except (json.JSONDecodeError, ValueError) as e:
            print(f"Failed to parse extracted JSON: {e}")
            error_response = {
                "narrative": "I'm sorry, I got my thoughts tangled. Could you please try again?",
                "choices": ["Let's try that again."]
            }
            return JSONResponse(content=error_response)

    except Exception as e:
        print(f"Error in /generate-story: {e}")
        raise HTTPException(status_code=500, detail=str(e))