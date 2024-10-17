# Usar uma imagem base oficial do Ruby
FROM ruby:2.7.5

# Instalar dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Configurar o diretório de trabalho dentro do container
WORKDIR /app

# Copiar o Gemfile e Gemfile.lock para o container
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Instalar as gems necessárias
RUN bundle install

# Copiar o código da aplicação
COPY . /app

# Expor a porta que o Rails utilizará
EXPOSE 3001

# Comando padrão para iniciar o servidor do Rails
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
