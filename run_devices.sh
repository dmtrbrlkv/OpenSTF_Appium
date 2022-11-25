docker run --env-file .env dmtrbrlkv/gen_devices_compose:2 > appium_android/docker-compose.yml
sudo docker-compose -f appium_android/docker-compose.yml up -d --build --remove-orphans
