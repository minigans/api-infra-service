#!/bin/bash -e

grpcurl -v -d '{"greeting": "Kong Hello world using grcpbin ingress!"}' \
  -insecure \
  grcpbin.mini.ping-fuji.com:443 hello.HelloService.SayHello

grpcurl -v -d '{"greeting": "Kong Hello world using multi-protocol ingress!"}' \
  -insecure \
  all.mini.ping-fuji.com:443 hello.HelloService.SayHello

##
## Expected response from service:
##

#  Resolved method descriptor:
#  rpc SayHello ( .hello.HelloRequest ) returns ( .hello.HelloResponse );
#
#  Request metadata to send:
#  (empty)
#
#  Response headers received:
#  content-type: application/grpc
#  date: Sun, 11 Dec 2022 19:01:13 GMT
#  server: openresty
#  trailer: Grpc-Status
#  trailer: Grpc-Message
#  trailer: Grpc-Status-Details-Bin
#  via: kong/3.0.1
#  x-kong-proxy-latency: 0
#  x-kong-upstream-latency: 7
#
#  Response contents:
#  {
#    "reply": "hello Kong Hello world using grcpbin ingress!"
#  }
#
#  Response trailers received:
#  (empty)
#  Sent 1 request and received 1 response