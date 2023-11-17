# Base image
FROM node:19.6.0 AS build

WORKDIR /app

# Copy package.json and package-lock.json to /app
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy app source code to /app
COPY . .

# Build the app for production
RUN npm run build --prod

# Stage 2: Setup Nginx to serve Angular application
FROM nginx:1.23.4
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/workshop /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
