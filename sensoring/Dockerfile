FROM docker pull arm32v7/python:3.9.5

WORKDIR /root/

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./main.py" ]