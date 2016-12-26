FROM crystallang/crystal:0.20.1

RUN mkdir /app
WORKDIR /app
COPY ./ ./
RUN crystal build src/tgbot.cr --release

ENTRYPOINT ["/app/tgbot"]
