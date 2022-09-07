# Rubyの2.7を使用
FROM ruby:2.7.5

# 環境変数設定
ENV RAILS_ENV=test

# 必要なライブラリをインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  # nodejsとyarnをインストールするために必要なライブラリのアップデート関連
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  # nodejsとyarnをインストールしている
  && apt-get install -y nodejs yarn

# 今回は作業ディレクトリを/appとする
WORKDIR /app

# ローカルの./src（railsのソースコードを入れる場所）以下のソースコードを/app配下にコピー
COPY ./src /app

# RubyのGemfileを一括インストール
RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

# ローカルのstart.shをDocker側にコピー
COPY start.sh /start.sh
# 実行権限を付与
RUN chmod 744 /start.sh
# start.shを実行
CMD ["sh", "/start.sh"]
