FROM node

WORKDIR /app
ADD . /app

RUN npm install

EXPOSE 3000

ENV HOSTNAME arbeitsblaetter.deutschkursinderbox.de
ENV PORT 3000

CMD ["npm", "run", "frontend"]
