#!/bin/bash

# SentinalAI - Run both backend and frontend

echo "🚀 Starting SentinalAI..."

# Kill any existing processes on ports 8000 and 3000
echo "📌 Cleaning up ports..."
lsof -iTCP:8000 -sTCP:LISTEN -n -P | awk 'NR>1 {print $2}' | xargs -r kill -9 2>/dev/null
lsof -iTCP:3000 -sTCP:LISTEN -n -P | awk 'NR>1 {print $2}' | xargs -r kill -9 2>/dev/null

# Start backend
echo "🔧 Starting backend..."
cd "$(dirname "$0")"
.venv/bin/python -m uvicorn app:app --reload --port 8000 > /tmp/sentinalai-backend.log 2>&1 &
BACKEND_PID=$!
echo "✅ Backend started (PID: $BACKEND_PID) - http://127.0.0.1:8000"

# Start frontend
echo "🎨 Starting frontend..."
cd frontend
npm run dev > /tmp/sentinalai-frontend.log 2>&1 &
FRONTEND_PID=$!
echo "✅ Frontend started (PID: $FRONTEND_PID) - http://localhost:3000"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 SentinalAI is running!"
echo "📱 Frontend: http://localhost:3000"
echo "⚙️  Backend:  http://127.0.0.1:8000"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Press Ctrl+C to stop all services"
echo "Backend log: tail -f /tmp/sentinalai-backend.log"
echo "Frontend log: tail -f /tmp/sentinalai-frontend.log"
echo ""

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
