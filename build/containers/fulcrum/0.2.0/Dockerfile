FROM java:8-alpine

LABEL maintainer="Ian Johnson (johnsoni@mskcc.org)" \
      version.image="0.0.0" \
      version.fulcum="0.2.0" \
      version.alpine="3.4.6" \
      source.fulcrum="https://github.com/fulcrumgenomics/fgbio"

ENV FULCRUM_VERSION 0.2.0

COPY marianas-${FULCRUM_VERSION}.jar /usr/bin/fulcrum-0.2.0.jar

ENTRYPOINT ["java", "-jar", "/usr/bin/fulcrum-0.2.0.jar"]
# CMD ["--help"]
