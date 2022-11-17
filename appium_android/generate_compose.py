import requests
import os
from dotenv import load_dotenv
import pathlib

folder = str(pathlib.Path(__file__).parent.resolve())

load_dotenv()

PUBLIC_IP = os.getenv('PUBLIC_IP')
STF_TOKEN = os.getenv('STF_TOKEN')

headers = {'Authorization': f'Bearer {STF_TOKEN}'}
devices = requests.get(f'http://{PUBLIC_IP}/api/v1/devices', headers=headers).json()

docker_compose = """
version: '2'

services:
  # Selenium hub
  selenium_hub:
    image: selenium/hub:3.14.0-curium
    ports:
      - 4444:4444
"""

device_template = """
  device_{udid}:
    image: dmtrbrlkv/appium_android:1
    restart: unless-stopped
    depends_on:
      - selenium_hub
    ports:
      - {port}:4723
    privileged: true
    volumes:
      - ~/.android:/root/.android
    environment:
      - PUBLIC_IP={PUBLIC_IP}
      - STF_TOKEN={STF_TOKEN}
      - CONNECT_TO_GRID=true
      - SELENIUM_HOST=selenium_hub
      - REMOTE_ADB=true
      - ANDROID_DEVICES={udid}
      - REMOTE_ADB_POLLING_SEC=60
      - RELAXED_SECURITY=true
      - APPIUM=true
"""
port = 4723
for device in devices['devices']:
    if not device['ready']:
        continue
    udid = device['serial']
    docker_compose += device_template.format(udid=udid, PUBLIC_IP=PUBLIC_IP, STF_TOKEN=STF_TOKEN, port=port)
    port += 1

with open(folder + '/docker-compose.yml', mode='w') as f:
    f.write(docker_compose)
