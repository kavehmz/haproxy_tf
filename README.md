# haproxy_tf

Create a HaProxy to route PG connections.
Parameterized for an existing env.


# usage

```
export AWS_ACCESS_KEY_ID=<YOUR KEY ID>
export AWS_SECRET_ACCESS_KEY=<YOUR SECRET>
terraform apply

curl $(terraform output -raw lb_master_cr_public_ip)
```
