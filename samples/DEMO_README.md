# UCP Shopping Agent Demo

An AI shopping assistant demo using the Universal Commerce Protocol (UCP).

## Prerequisites

Install these before running:

| Tool | Install Command | Verify |
|------|-----------------|--------|
| **uv** | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | `uv --version` |
| **Node.js** | [nodejs.org](https://nodejs.org/) or `brew install node` | `node --version` |
| **npm** | Comes with Node.js | `npm --version` |

## Setup

### 1. Get an OpenAI API Key


### 2. Run the Demo

```bash
./setup_demo.sh YOUR_OPENAI_API_KEY
```

That's it! The script will:
- Install all dependencies
- Configure your API key
- Start the backend agent (port 10999)
- Start the chat client (port 3000)

### 3. Open the Chat

Go to **http://localhost:3000** and start chatting!

## Try These Queries

- "What TVs do you have?"
- "Show me Samsung TVs under €1000"
- "I want to buy the 55 inch TV"
- "Add it to my cart"
- "Checkout"

## Stopping

Press `Ctrl+C` in the terminal to stop both services.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `uv: command not found` | Install uv: `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| `npm: command not found` | Install Node.js from [nodejs.org](https://nodejs.org/) |
| Agent won't start | Check your OpenAI API key is valid |
| Port already in use | Kill existing processes: `lsof -ti:10999 \| xargs kill` |

## Project Structure

```
samples/
├── setup_demo.sh          ← Run this!
├── DEMO_README.md         ← You are here
└── a2a/
    ├── business_agent/    ← AI shopping agent (Python)
    │   └── .env           ← Your API key goes here
    └── chat-client/       ← Web chat interface (React)
```
