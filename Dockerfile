FROM node

COPY . /src
RUN cd /src; npm install; npm install -g grunt-cli
RUN cd /src; grunt
EXPOSE 80

CMD cd /src; npm start
