pipeline.batch.size: ${service['logstash.batch_size']}
pipeline.batch.delay: 1000
pipeline.workers: ${service['logstash.worker_num']}
pipeline.output.workers: ${service['logstash.worker_num']}
http.host: 0.0.0.0

queue.type: persisted
path.queue: /var/run/${service.sid}/logstash/queue
queue.page_capacity: 250mb
queue.max_events: 40960
queue.max_bytes: 1gb
queue.checkpoint.acks: 4096
queue.checkpoint.writes: 1

dead_letter_queue.enable: true
path.dead_letter_queue: /var/run/${service.sid}/logstash/dlq
