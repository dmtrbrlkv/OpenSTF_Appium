FROM python:3.10-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app
RUN pip install --upgrade pip
RUN pip3 install requests python-dotenv
COPY generate_compose.py ./

CMD ["python", "generate_compose.py"]