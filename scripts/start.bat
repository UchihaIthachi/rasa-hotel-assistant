::cd ..
:: Build the Rasa and Action server Docker images

docker build -t rasa_custom:2.0 -f .\docker\Dockerfile.rasa .
docker build -t rasa_action:2.0 -f .\docker\Dockerfile.action .

:: Start the Docker containers using docker-compose
docker-compose -f .\docker\docker-compose.yml up -d
