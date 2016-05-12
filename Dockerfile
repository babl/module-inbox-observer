FROM mhart/alpine-node:latest
RUN wget -O- "http://s3.amazonaws.com/babl/babl-server_linux_amd64.gz" | gunzip > /bin/babl-server && chmod +x /bin/babl-server
ADD app package.json knexfile.js /data/
ADD migrations /data/migrations/
RUN ln -s /data/app /bin/app
RUN chmod +x /bin/app
WORKDIR /data
RUN npm install
ENV NODE_ENV production
ENV DATABASE_URL postgres://rhdqnulbntvjnb:jXJe9v_C9GZV0cpycMqdAxu3_w@ec2-54-243-210-223.compute-1.amazonaws.com:5432/d1lt0vq3rb6tf6?ssl=true
CMD ["babl-server"]
