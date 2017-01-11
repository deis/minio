FROM quay.io/deis/base:v0.3.6

RUN adduser --system \
	--shell /bin/bash \
	--disabled-password \
	--home /home/minio \
	--group \
	minio

COPY . /

RUN curl -f -SL https://dl.minio.io/client/mc/release/linux-amd64/archive/mc.OFFICIAL.2015-09-05T23-43-46Z -o /usr/bin/mc \
	&& chmod 755 /usr/bin/mc \
	&& mkdir /home/minio/.minio \
	&& chown minio:minio /home/minio/.minio
ADD https://storage.googleapis.com/minio-mirror/linux-amd64/minio-2016-06-03T19-32-05Z /bin/minio
RUN chmod 755 /bin/minio

USER minio

CMD ["/bin/boot"]
