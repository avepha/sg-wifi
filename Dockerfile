#https://github.com/balena-io-library/base-images/blob/master/balena-base-images/node/raspberry-pi/debian/buster/10.16.0/build/Dockerfile
FROM balenalib/raspberry-pi-debian:buster-build

ENV NODE_VERSION 10.16.0
ENV YARN_VERSION 1.15.2

RUN for key in \
	6A010C5166006599AA17F08146C2130DFD2497F5 \
	; do \
		gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
		gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
		gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
	done \
	&& curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-armv6l.tar.gz" \
	&& echo "3ae88931bf286fc3b7abe6a914b3af099072116cb9c5dbce5371df8fcf211f78  node-v$NODE_VERSION-linux-armv6l.tar.gz" | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-armv6l.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-armv6l.tar.gz" \
	&& curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
	&& curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
	&& gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
	&& mkdir -p /opt/yarn \
	&& tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
	&& ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
	&& ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
	&& rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
	&& npm config set unsafe-perm true -g --unsafe-perm \
	&& rm -rf /tmp/*

WORKDIR /app

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: https://balena.io/docs"]
