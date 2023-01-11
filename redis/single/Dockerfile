FROM redis:latest
COPY ["redis.conf","/data/redis.conf"]
EXPOSE 6379
ENTRYPOINT ["redis-server","/data/redis.conf"]