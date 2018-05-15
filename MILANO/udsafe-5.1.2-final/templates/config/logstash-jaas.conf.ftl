KafkaClient {
    com.sun.security.auth.module.Krb5LoginModule required
    useKeyTab=true
    storeKey=true
    useTicketCache=false
    keyTab="/etc/${service.sid}/conf/milano.keytab"
    principal="kafka/${localhostname}@${service.realm}";
};
