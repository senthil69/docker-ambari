. setEnv.sh

set -x 
curl -H "X-Requested-By:ambari" -u admin:admin -i -X POST http://$HOST_FQDN:8080/api/v1/clusters/c1/services/KERBEROS

curl -H "X-Requested-By:ambari" -u admin:admin -i -X POST http://$HOST_FQDN:8080/api/v1/clusters/c1/services/KERBEROS/components/KERBEROS_CLIENT

cat <<EOF  > /tmp/krb5conf.json 

[
  {
    "Clusters": {
      "desired_config": {
        "type": "krb5-conf",
        "tag": "version1",
        "properties": {
          "domains":"",
          "manage_krb5_conf": "true",
          "conf_dir":"/etc",
          "content" : "[libdefaults]\n  renew_lifetime = 7d\n  forwardable= true\n  default_realm = {{realm|upper()}}\n  ticket_lifetime = 24h\n  dns_lookup_realm = false\n  dns_lookup_kdc = false\n  #default_tgs_enctypes = {{encryption_types}}\n  #default_tkt_enctypes ={{encryption_types}}\n\n{% if domains %}\n[domain_realm]\n{% for domain in domains.split(',') %}\n  {{domain}} = {{realm|upper()}}\n{% endfor %}\n{%endif %}\n\n[logging]\n  default = FILE:/var/log/krb5kdc.log\nadmin_server = FILE:/var/log/kadmind.log\n  kdc = FILE:/var/log/krb5kdc.log\n\n[realms]\n  {{realm}} = {\n    admin_server = {{admin_server_host|default(kdc_host, True)}}\n    kdc = {{kdc_host}}\n }\n\n{# Append additional realm declarations below #}\n"
        }
      }
    }
  },
  {
    "Clusters": {
      "desired_config": {
        "type": "kerberos-env",
        "tag": "version1",
        "properties": {
          "kdc_type": "mit-kdc",
          "manage_identities": "true",
          "install_packages": "true",
          "encryption_types": "aes des3-cbc-sha1 rc4 des-cbc-md5",
          "realm" : "$KRB5_DOMAIN",
          "kdc_host" : "$HOST_KRB5",
          "admin_server_host" : "$HOST_KRB5",
          "executable_search_paths" : "/usr/bin, /usr/kerberos/bin, /usr/sbin, /usr/lib/mit/bin, /usr/lib/mit/sbin",
          "password_length": "20",
          "password_min_lowercase_letters": "1",
          "password_min_uppercase_letters": "1",
          "password_min_digits": "1",
          "password_min_punctuation": "1",
          "password_min_whitespace": "0",
          "service_check_principal_name" : "test/admin",
          "case_insensitive_username_rules" : "false"
        }
      }
    }
  }
]

EOF
curl -H "X-Requested-By:ambari" -u admin:admin -i -X PUT -d @/tmp/krb5conf.json http://$HOST_FQDN:8080/api/v1/clusters/c1

# Run this command for each host in cluster
curl -H "X-Requested-By:ambari" -u admin:admin -i -X POST -d '{"host_components" : [{"HostRoles" : {"component_name":"KERBEROS_CLIENT"}}]}' http://$HOST_FQDN:8080/api/v1/clusters/c1/hosts?Hosts/host_name=$HOST_FQDN


#Install Kerbeos packages
