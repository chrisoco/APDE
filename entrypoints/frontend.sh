#!/usr/bin/env sh
set -e

cd /app

# ensure .env exists
[ -f ".env" ] || ( [ -f ".env.example" ] && cp .env.example .env )

# Always install deps because of the anonymous volume override
npm ci

# build the app using npx
npx --yes @react-router/dev build

# serve the built app
npx --yes serve build/client -p 3000 -s
