DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'awx.main.db.profiled_pg',
        'NAME': "{{ .Values.pg_database }}",
        'USER': "{{ .Values.pg_username }}",
        'PASSWORD': "{{ .Values.pg_password }}",
        'HOST': "{{ .Release.Name }}-postgresql",
        'PORT': "{{ .Values.pg_port }}",
    }
}
BROKER_URL = 'amqp://{}:{}@{}:{}/{}'.format(
    "{{ .Values.rabbitmq_user }}",
    "{{ .Values.rabbitmq_password }}",
    "localhost",
    "5672",
    "awx")
CHANNEL_LAYERS = {
    'default': {'BACKEND': 'asgi_amqp.AMQPChannelLayer',
                'ROUTING': 'awx.main.routing.channel_routing',
                'CONFIG': {'url': BROKER_URL}}
}
