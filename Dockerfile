FROM jekyll/jekyll:latest

WORKDIR /blog

COPY . .

RUN bundle install

EXPOSE 4000

CMD ["jekyll", "serve", "--force_polling", "--drafts"]
