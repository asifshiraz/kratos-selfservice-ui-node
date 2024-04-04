making docker
docker stop kratos-selfservice-ui
docker run -d -p 3000:3000 --name kratos-selfservice-ui asifshiraz/kratos-selfservice-ui-node:latest