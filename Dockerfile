FROM ruby:3.2.2

RUN apt update -qq && apt install -y postgresql-client
RUN mkdir /Portfolio
WORKDIR /Portfolio
COPY Gemfile /Portfolio/Gemfile
COPY Gemfile.lock /Portfolio/Gemfile.lock
RUN bundle install
COPY . /Portfolio

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]