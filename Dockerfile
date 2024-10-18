# Usar uma imagem base oficial do Ruby
FROM ruby:2.7.5

RUN apt-get update -qq && apt-get install -y curl build-essential libxml2-dev libxslt1-dev
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install yarn -y

# Configurar o diretório de trabalho dentro do container
WORKDIR /app

# Copiar o Gemfile e Gemfile.lock para o container
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Instalar as gems necessárias
RUN bundle install

# Copiar o código da aplicação
COPY . /app

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

# Expor a porta que o Rails utilizará
EXPOSE 3001

# Comando padrão para iniciar o servidor do Rails
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
