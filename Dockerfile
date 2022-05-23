FROM python:3.7.4-alpine3.10

ADD django-polls/requirements.txt /app/requirements.txt

RUN set -ex \
    && apk add --no-cache --virtual .build-deps postgresql-dev build-base \
    && python -m venv /env \
    && /env/bin/pip install --upgrade pip \
    && /env/bin/pip install --no-cache-dir -r /app/requirements.txt \
    && runDeps="$(scanelf --needed --nobanner --recursive /env \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps \
    && find / -xdev -perm /6000 -type f -exec chmod a-s {} \; || true

ADD django-polls /app
WORKDIR /app
RUN adduser \
    --disabled-password \
    django
USER django

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH
ENV DJANGO_SECRET_KEY="djangosjb%(cz9^om(el0)73af-$&4t&m66x-j!l%bdg1u!($94i2nwx222"
ENV DEBUG=True
ENV DJANGO_ALLOWED_HOSTS=*
ENV DATABASE_ENGINE=postgresql_psycopg2
ENV DATABASE_NAME=postgres
ENV DATABASE_USERNAME=postgres
ENV DATABASE_PASSWORD=postgres
ENV DATABASE_HOST=djangoencryptlatest.cjrsj6mnlkwt.us-east-2.rds.amazonaws.com
ENV DATABASE_PORT=5432
ENV STATIC_ACCESS_KEY_ID=AKIA3S624GTTUIRHEY6J
ENV STATIC_SECRET_KEY=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
ENV STATIC_BUCKET_NAME=django-test98239487
ENV STATIC_ENDPOINT_URL=https://django-test98239487.s3.amazonaws.com
ENV DJANGO_LOGLEVEL=info


EXPOSE 8000

CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "mysite.wsgi"]
