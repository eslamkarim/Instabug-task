FROM cypress/included:3.8.1

RUN npm install -g yarn
# make the 'app' folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./
COPY yarn* ./
# install project dependencies
RUN yarn install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

EXPOSE 8080
ENTRYPOINT ["yarn"]
CMD ["serve"]