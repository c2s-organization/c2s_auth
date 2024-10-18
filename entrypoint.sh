#!/bin/bash
set -e

# Criar o banco de dados, se não existir
bundle exec rails db:create

# Executar as migrações
bundle exec rails db:migrate

# Remover PID antigo do servidor (se necessário)
rm -f /app/tmp/pids/server.pid

# Iniciar o servidor Rails
exec bundle exec rails s -b '0.0.0.0'
