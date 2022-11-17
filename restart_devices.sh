cd appium_android
docker build . -f gen_compose.Dockerfile -t gen_image
docker run --env-file ../.env gen_image > docker-compose.yml
cd ..
sudo docker-compose -f appium_android/docker-compose.yml up -d --build --remove-orphans