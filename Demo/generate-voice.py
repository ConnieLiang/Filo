"""
Generate Filo Talk demo voice audio using OpenAI TTS API.
Usage: OPENAI_API_KEY=sk-... python generate-voice.py
"""
import os
import sys
from openai import OpenAI

client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))

VOICE = "nova"
MODEL = "tts-1"
SPEED = 1.0
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "audio")

LINES = {
    "conv-ai-1": "Morning, Adam. You have 3 emails that need a reply.",
    "conv-ai-2": "Sarah from HR says the benefits deadline is tomorrow. Mike wants to confirm the project timeline. And your manager asked about the Q4 report.",
    "onboarding-greeting": "Hi Adam, I'm your Fillo A I assistant. I can help you manage emails and tasks by voice. Try asking me something like:",
    "onboarding-pills": "Archive read emails. Any new emails? Write a new email.",
    "onboarding-reply": "You have 5 new emails since this morning. 2 from your team, 1 from HR about benefits enrollment, and 2 newsletters.",
    "conv-ai-3": "Done. I've drafted a reply to Sarah.",
    "conv-ai-4": "Want me to send it?",
    "error-archiving": "Archiving your newsletters...",
    "error-card": "Something went wrong. I couldn't archive those emails.",
}

IDLE_GREETINGS = [
    "Hi Adam, how can I help you today?",
    "Hey Adam, what's on your mind?",
    "Good to have you, Adam. What do you need?",
    "Talk to me, Adam. I'm all yours.",
    "Ready when you are, Adam. Take your time.",
    "Adam, what can I help you with?",
    "Go ahead Adam, I'm listening.",
    "Hey Adam, what are we working on?",
    "Welcome back, Adam. What's first?",
    "Alright Adam, let's get into it.",
    "Adam, I'm right here. What do you need?",
    "Hi Adam, good to see you. What's up?",
    "Hey Adam, tell me what you need.",
    "Adam, what's on the agenda?",
    "I'm all ears, Adam. Go ahead.",
    "Hi Adam, ready to help. Just say the word.",
    "Hey Adam, let's take care of it.",
    "Adam, what do you want to tackle first?",
    "Good timing, Adam. What can I do?",
    "Hi Adam, I've been expecting you.",
]


ADAM_VOICE = "echo"
ADAM_LINES = {
    "adam-conv-1": "Read me the important ones.",
    "adam-conv-2": "Reply to Sarah. Tell her I'll submit by the end of the day.",
    "adam-onboarding": "Any new emails?",
    "adam-error": "Archive all newsletters.",
}


def generate(name, text, voice=VOICE):
    path = os.path.join(OUTPUT_DIR, f"{name}.mp3")
    if os.path.exists(path):
        print(f"  skip {name} (exists)")
        return
    print(f"  generating {name} ({voice})...")
    response = client.audio.speech.create(model=MODEL, voice=voice, input=text, speed=SPEED)
    response.stream_to_file(path)
    print(f"  saved {path}")


def main():
    if not client.api_key:
        print("Set OPENAI_API_KEY environment variable")
        sys.exit(1)

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print("Generating Filo lines...")
    for name, text in LINES.items():
        generate(name, text)

    print("Generating idle greetings...")
    for i, text in enumerate(IDLE_GREETINGS):
        generate(f"greeting-{i}", text)

    print("Generating Adam lines...")
    for name, text in ADAM_LINES.items():
        generate(name, text, voice=ADAM_VOICE)

    print("Done!")


if __name__ == "__main__":
    main()
