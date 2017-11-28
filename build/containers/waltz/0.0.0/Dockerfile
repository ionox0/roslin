FROM java:8-alpine

LABEL maintainer="Ian Johnson (johnsoni@mskcc.org)" \
      version.image="0.0.0" \
      version.gatk="0.0.0" \
      version.alpine="3.4.6" \
      source.marianas="https://github.com/juberpatel/Waltz"

ENV WALTZ_VERSION 0.0.0

COPY waltz-${WALTZ_VERSION}.jar /usr/bin/waltz-0.0.0.jar

RUN chmod 777 /usr/bin/waltz-0.0.0.jar

ENTRYPOINT ["java", "-jar", "/usr/bin/waltz-0.0.0.jar"]
# CMD ["--help"]
