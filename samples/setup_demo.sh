#!/bin/bash
# UCP A2A Demo Setup Script
# This script sets up and starts the Business Agent and Chat Client

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 UCP A2A Demo Setup"
echo "===================="

# Check for OpenAI API key
if [ -z "$1" ]; then
  echo "❌ Error: OpenAI API key required"
  echo "Usage: ./setup_demo.sh YOUR_OPENAI_API_KEY"
  exit 1
fi

OPENAI_KEY="$1"

echo ""
echo "📦 Step 1/4: Installing Business Agent dependencies..."
cd "$SCRIPT_DIR/a2a/business_agent"

# Reset lock file to use public PyPI
if [ -f "uv.lock" ]; then
  echo "Removing old lock file to use public PyPI..."
  rm uv.lock
fi

uv sync
echo "✅ Business Agent dependencies installed"

echo ""
echo "📦 Step 2/4: Installing Chat Client dependencies..."
cd "$SCRIPT_DIR/a2a/chat-client"
npm install
echo "✅ Chat Client dependencies installed"

echo ""
echo "🔑 Step 3/4: Configuring API keys..."
cd "$SCRIPT_DIR/a2a/business_agent"
cat > .env <<EOF
OPENAI_API_KEY=$OPENAI_KEY
EOF
echo "✅ API key configured"

echo ""
echo "🎬 Step 4/4: Starting services..."
echo ""

# Function to cleanup on exit
cleanup() {
  echo ""
  echo "🛑 Stopping services..."
  if [ ! -z "$AGENT_PID" ]; then
    kill $AGENT_PID 2>/dev/null || true
  fi
  if [ ! -z "$CLIENT_PID" ]; then
    kill $CLIENT_PID 2>/dev/null || true
  fi
  exit 0
}
trap cleanup INT TERM

# Start business agent in background (show output)
echo "Starting Business Agent..."
cd "$SCRIPT_DIR/a2a/business_agent"
uv run business_agent &
AGENT_PID=$!

# Wait for agent to start and verify it's running
echo "Waiting for Business Agent to start..."
MAX_WAIT=30
COUNTER=0
while [ $COUNTER -lt $MAX_WAIT ]; do
  sleep 1
  COUNTER=$((COUNTER + 1))
  
  # Check if process is still running
  if ! kill -0 $AGENT_PID 2>/dev/null; then
    echo ""
    echo "❌ Business Agent failed to start!"
    echo "Check if your API key is valid and try running manually:"
    echo "  cd a2a/business_agent && uv run business_agent"
    exit 1
  fi
  
  # Check if agent is responding
  if curl -s http://localhost:10999/.well-known/agent-card.json > /dev/null 2>&1; then
    echo "✅ Business Agent is running on http://localhost:10999"
    break
  fi
  
  echo -n "."
done

if [ $COUNTER -eq $MAX_WAIT ]; then
  echo ""
  echo "⚠️  Business Agent may still be starting. Continuing anyway..."
fi

echo ""
echo "Starting Chat Client..."
cd "$SCRIPT_DIR/a2a/chat-client"
npm run dev &
CLIENT_PID=$!

# Wait a moment for client to start
sleep 3

echo ""
echo "============================================"
echo "✨ Demo is ready!"
echo "============================================"
echo ""
echo "🌐 Chat Client: http://localhost:3000"
echo "📝 Agent Card:  http://localhost:10999/.well-known/agent-card.json"
echo "🔍 UCP Profile: http://localhost:10999/.well-known/ucp"
echo ""
echo "💡 Try these queries:"
echo "   - 'What TVs do you have?'"
echo "   - 'Show me Samsung TVs under €1000'"
echo "   - 'I want to buy the 55 inch TV'"
echo ""
echo "Press Ctrl+C to stop both services"
echo "============================================"
echo ""

# Wait for both processes - keep script running
wait $AGENT_PID $CLIENT_PID