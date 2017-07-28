auth requisite pam_succeed_if.so uid >= 500 quiet
<#if service.auth = "kerberos">
auth required pam_krb5.so
account required pam_krb5.so
<#else>
auth required pam_unix.so nodelay
account required pam_unix.so
</#if>