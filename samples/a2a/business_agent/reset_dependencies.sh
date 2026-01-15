#!/bin/bash
# Reset dependencies to use public PyPI for common packages

set -e

echo "🔧 Resetting dependencies to use public PyPI..."

# Remove the lock file to force regeneration
if [ -f "uv.lock" ]; then
    echo "📦 Removing old uv.lock file..."
    rm uv.lock
fi

# Remove virtual environment to start fresh
if [ -d ".venv" ]; then
    echo "🗑️  Removing old virtual environment..."
    rm -rf .venv
fi

echo "✨ Running uv sync to regenerate with PyPI defaults..."
uv sync

echo "✅ Done! Dependencies now use public PyPI with fallback to Google's registry for google-adk"
echo ""
echo "Next steps:"
echo "1. Create .env file with your API key:"
echo "   echo 'OPENAI_API_KEY=your_key_here' > .env"
echo "2. Start the agent:"
echo "   uv run business_agent"
