#!/usr/bin/env sh
set -e

cd /var/www/html

# ensure .env exists
[ -f ".env" ] || ( [ -f ".env.example" ] && cp .env.example .env )

# install PHP deps if vendor missing
if [ ! -d "vendor" ]; then
  composer install --no-interaction --prefer-dist
fi

# app key
php artisan key:generate --force || true

# wait for mongo (nc from netcat-openbsd package)
echo "waiting for mongo at mongo:27017..."
until nc -z mongo 27017; do
  sleep 2
done
echo "mongo is up."

# migrate & seed Database
php artisan migrate:fresh --seed || echo "Seeding failed, continuing anyway..."

# optimize Laravel
php artisan optimize
php artisan config:cache
php artisan event:cache
php artisan route:cache
php artisan view:cache

# start laravel dev server
php artisan serve --host=0.0.0.0 --port=8000
