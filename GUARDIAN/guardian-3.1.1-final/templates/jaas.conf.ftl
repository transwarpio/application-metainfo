// Zookeeper client authentication
Client {
com.sun.security.auth.module.Krb5LoginModule required
useKeyTab=true
storeKey=true
useTicketCache=false
keyTab="${service.keytab}"
principal="guardian/guardian@${service.realm}";
};