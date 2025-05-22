FROM node:18.17.0
WORKDIR /app
COPY package*.json ./
# COPY yarn.lock ./
 
ENV NEXT_PUBLIC_GRAPHQL_URL=https://dev-cms.mineramax.green-apex.com/graphql
ENV NEXT_PUBLIC_GRAPHQL_IMG_URL=https://dev-cms.mineramax.green-apex.com
ENV NEXT_PUBLIC_API_BASE_URL=https://dev-api.mineramax.green-apex.com/minera-max/api
 
ARG NEXT_PUBLIC_GRAPHQL_URL=https://dev-cms.mineramax.green-apex.com/graphql
ARG NEXT_PUBLIC_GRAPHQL_IMG_URL=https://dev-cms.mineramax.green-apex.com
ARG NEXT_PUBLIC_API_BASE_URL=https://dev-api.mineramax.green-apex.com/minera-max/api
 
RUN npm install
 
COPY . .
 
RUN node openapi-ts-generator.js
 
RUN npm run build
 
EXPOSE 3000
 
CMD ["npm", "start"]
