# bind-doh

Bind 9 Recursive with DoH

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-conf
  annotations:
    ves.io/sites: system/coleman-azure,system/coleman-cluster-100,system/colemantest
data:
  nginx.conf: |
    user nginx;
    worker_processes  3;
    error_log  /var/log/nginx/error.log;
    events {
      worker_connections  10240;
    }
    http {
      log_format  main
              'remote_addr:$remote_addr\t'
              'time_local:$time_local\t'
              'method:$request_method\t'
              'uri:$request_uri\t'
              'host:$host\t'
              'status:$status\t'
              'bytes_sent:$body_bytes_sent\t'
              'referer:$http_referer\t'
              'useragent:$http_user_agent\t'
              'forwardedfor:$http_x_forwarded_for\t'
              'request_time:$request_time';
      access_log /var/log/nginx/access.log main;

      upstream http2-doh {
        server 127.0.0.1:80;
      }

      server {
          listen  8080      default_server; 
          listen  4443      ssl http2;

          server_name  _;

          # TLS certificate chain and corresponding private key
          ssl_certificate     /etc/ssl/certs/dns.pem;
          ssl_certificate_key /etc/ssl/private/dns.key;

          location / {
              grpc_pass grpc://http2-doh;
          }
          location /health-check {
            add_header Content-Type text/plain;
            return 200 'what is up buttercup?!';
          }
      }
    }
  dns.key: |
    -----BEGIN PRIVATE KEY-----
    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
    50FMN92ye85Kt83SVxnbasdCqamVXHi1
    -----END PRIVATE KEY-----
  dns.pem: |
    -----BEGIN CERTIFICATE-----
    MIIEqDCCApACCQD7kZz9duEMOTANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAti
    aW5kOS5sb2NhbDAeFw0yMjEwMDUxMjU2NDRaFw0zMjEwMDIxMjU2NDRaMBYxFDAS
    BgNVBAMMC2JpbmQ5LmxvY2FsMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
    AgEAzpLA3Se2VNOVA27hLSLNccwcDPYW3v9jKWX4xh4fuJ6wCml3aeSdL3F046KH
    y4mJhBkr8v+TvT2FrdxPChrPpgjWy9HiMwWAWSFZH+/K7DBypWwK1GsmGthpcIjL
    IU3s9D32zfjrsTIxSfLp0q6wPSXdl2NPVv8NohJTRf9Umbw4xLUBbcRYUi7Fwtbf
    JTe994uIftfNVmrrHGOy1bb6wLLSPbPIiv6UH+CmwFHstaCci2Xu1NjugmWIbv2d
    hbNt3ik7u0/QNgOvP4LPOZ02ZwSkKAXhysf+bgz7vG0RsWyAW5He9t2B4WPQhFZ3
    gkWp/5nLDDpH4SkA1g6YY1EWn+kH28jou/NGxVO5cVAxjUKnZakEmca2mj29bRY7
    WGRacotHxH8zRgHnyxVs9W7ZkvmqLoTfJ0T3jJzqbJJfNM3hhR+cLZAaY4IEIDnb
    IPLP9ZkjVB5A8JkOwauLR4pkP/PAcaGoT12ltBCyKPQtI5wpLyWkIZ0hrxwR3CV2
    CUoDXCiV+6syTA3/xnJ8zuEUHGZ5qf2sbp/uv6Ewuxto/QTsI0mKYJ7GP33gV6xN
    MFHdr2LskAJTA6xZ505wXvQUbse4aXgiHHGATGIE/0CNgVfG0VBuDLsNjkeNaT4h
    fuoGxf31NPHY+TuJzaai55+4w4yQcQSnj3wyebixayUHiikCAwEAATANBgkqhkiG
    9w0BAQsFAAOCAgEAvfKcFAniVMPxEV4CnWN/uSLNyD0AogiuTOTD6aTwY7vqFk9k
    r9eHqZpCCWM2NdsgumNGoCNm1SRqJTmTJ8+MggVFrcxAMs/9QHBRjoO489uFAyP4
    8sab2dGXx2L5v+JWtC7rHdgCD/fKEJwk2J40YreetW7zWviBcPMtBl8IUmTFeQ/r
    dVHirTjVJ4Pg4xOMdJ6v8QMM0RwOhjWr5Lm2YciMHiw2xVcBCksPe9P901l/Fj4J
    bm6W/oRHmIQKjShzmkXR+Y+0TknEs1tnGev88Vt5c2KxLWNt+iYqYHo5B2VFHlFp
    5t5kloMB2LqJG4EeS6Dv+uAYZrisi9xAatRzq8wn2Zz1jI7jJhd0HQifjs0zFx8r
    2sKnW8RISmFItMzrO4Sdgxvs2aja954qKcFwBGpr7sUCgMmGlm3W1TbiK26JXha+
    i9uvvCMiQlFXwk3BK0iZ2c75ENSxBc90yRTo3nPAIh2tLuj3tIg+WYzin4zY/vCJ
    4lDDlvzC8JSHnQeXYUMcCr3KnLpR2rZWNWEqkKwkbg560KdQp3zBfZ8190acmdht
    OU11/JBJYv6cfwog872fZVSqJ61i6fKpPw6zTjKUqshaPoPUSjiqqj86rMeFEXxZ
    4AB4gqx+QsZsfndxCxuLZ8SFUTDpTbjYN2KcxFjJpG7zo3NxZ5Htm0AlvGI=
    -----END CERTIFICATE-----

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bind-doh-dep
  labels:
    app: bind
  annotations:
    ves.io/sites: system/coleman-azure,system/coleman-cluster-100,system/colemantest
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bind
  template:
    metadata:
      labels:
        app: bind
    spec:
      containers:
      - name: bind
        image: mcoleman81/bind-doh
        env:
        - name: DOCKER_LOGS
          value: "1"
        - name: ALLOW_QUERY
          value: "any"
        - name: ALLOW_RECURSION
          value: "any"
        - name: DNS_FORWARDER
          value: "8.8.8.8, 8.8.4.4"
        - name: DNS_A
          value: domain1.com=68.183.126.197,domain2.com=68.183.126.197
        ports:
        - containerPort: 5553
      - name: nginx
        image: nginx
        ports:
        - containerPort: 8080
        volumeMounts:
        - mountPath: /etc/nginx
          readOnly: true
          name: nginx-conf
        - mountPath: /var/log/nginx
          name: log
        - mountPath: /etc/ssl/certs
          name: nginx-cert
        - mountPath: /etc/ssl/private
          name: nginx-key
      volumes:
      - name: nginx-conf
        configMap:
          name: nginx-conf
          items:
            - key: nginx.conf
              path: nginx.conf
      - name: nginx-cert
        configMap:
          name: nginx-conf
          items:
            - key: dns.pem
              path: dns.pem
      - name: nginx-key
        configMap:
          name: nginx-conf
          items:
            - key: dns.key
              path: dns.key
      - name: log
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: bind-services
  annotations:
    ves.io/sites: system/coleman-azure
spec:
  type: ClusterIP
  selector:
    app: bind
  ports:
    - name: dns-udp
      port: 53
      targetPort: 5553
      protocol: UDP
    - name: dns-tcp
      port: 53
      targetPort: 5353
      protocol: TCP
    - name: dns-http
      port: 80
      targetPort: 8888
      protocol: TCP
    - name: nginx-http-listener
      port: 8080
      targetPort: 8080
      protocol: TCP
    - name: nginx-https-listener
      port: 4443
      targetPort: 4443
      protocol: TCP

```
