docker run --env-file ../.env dmtrbrlkv/gen_devices_compose > appium_android/docker-compose.yml
sudo docker-compose -f appium_android/docker-compose.yml up -d --build --remove-orphans