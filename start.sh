#!/bin/bash
set -e

echo "Starting APDE services..."
docker compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."

# Wait for backend (port 8000) 
echo "   Waiting for backend..."
until curl -s http://localhost:8000 > /dev/null 2>&1; do
  sleep 2
done

# Wait for frontend (port 3000)
echo "   Waiting for frontend..."
until curl -s http://localhost:3000 > /dev/null 2>&1; do
  sleep 2
done

echo ""
echo "✅ All services are ready!"
echo ""
echo "🌐 Access APDE application:"
echo "   Frontend:  http://localhost:3000"
echo "   Backend:   http://localhost:8000/up"
echo "   API Docs:  http://localhost:8000/api/docs/openapi"
echo "   MongoDB:   mongodb://localhost:27017"
echo ""
echo "🛑 To stop: docker compose down"
echo ""