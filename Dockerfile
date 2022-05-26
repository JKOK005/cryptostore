FROM python:3.9-slim-bullseye
ARG CRYPTO_FEED_HASH='872d64c556a34ffcb3f4e11566e83b23d8f86c0c'

ENV workdir /app
WORKDIR ${workdir}

RUN apt update
RUN apt install gcc git -y

# Clone and install cryptofeed dependency
RUN git clone https://github.com/bmoscon/cryptofeed.git
WORKDIR ${workdir}/cryptofeed
RUN git checkout ${CRYPTO_FEED_HASH}
RUN pip install -r requirements.txt
RUN python3 setup.py install

RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir aioredis
RUN pip install --no-cache-dir pymongo[srv]
RUN pip install --no-cache-dir motor
RUN pip install --no-cache-dir asyncpg

COPY cryptostore.py /cryptostore.py

CMD ["/cryptostore.py"]
ENTRYPOINT ["python"]
