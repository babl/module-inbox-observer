FROM mhart/alpine-node:latest
RUN wget -O- "http://s3.amazonaws.com/babl/babl-server_linux_amd64.gz" | gunzip > /bin/babl-server && chmod +x /bin/babl-server
ADD app package.json knexfile.js /data/
ADD migrations /data/migrations/
RUN ln -s /data/app /bin/app
RUN chmod +x /bin/app
WORKDIR /data
RUN npm install
ENV NODE_ENV production
CMD ["babl-server"]
