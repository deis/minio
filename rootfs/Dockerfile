FROM quay.io/deis/base:0.2.0

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

USER minio

CMD ["/bin/boot"]

ENV WORKFLOW_RELEASE=2.0.0
