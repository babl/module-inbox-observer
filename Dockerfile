FROM mhart/alpine-node:latest
RUN wget -O- "http://s3.amazonaws.com/babl/babl-server_linux_amd64.gz" | gunzip > /bin/babl-server && chmod +x /bin/babl-server
ADD app package.json knexfile.js /data/
RUN ln -s /data/app /bin/app
RUN chmod +x /bin/app
WORKDIR /data
RUN npm install
ENV NODE_ENV production
ENV DATABASE_URL postgres://xdkztqvlevuogd:bta8M0IAS5pNNsqMecZDUVLl9U@ec2-54-243-208-3.compute-1.amazonaws.com:5432/dbhinhr1e85oau?ssl=true
CMD ["babl-server"]
