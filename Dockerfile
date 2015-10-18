FROM node

COPY . /src
RUN cd /src; npm install
run cd /src; npm install -g grunt-cli
RUN cd /src; grunt
RUN cd /src; bower install
EXPOSE 80

CMD cd /src; npm start
