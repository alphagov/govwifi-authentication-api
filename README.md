# GovWifi Authentication API

This API is used by the frontend to authenticate GovWifi requests.

The private GovWifi [build repository][build-repo] contains instructions on how to build GovWifi end-to-end - the sites, services and infrastructure.

[build-repo]:https://github.com/alphagov/govwifi-build

## Overview

GovWifi exposes FreeRADIUS servers on public IP addresses, which are configured
to communicate with this private API via its REST plugin.

### Sinatra routes

* `GET /authorize/user/:user_name`  - FreeRADIUS authorisation route

### Dependencies

* MySQL database - user details generated by the [user signup API][user-signup-api]
  are fetched by this API.

[user-signup-api]: https://github.com/alphagov/govwifi-user-signup-api/pull/33

## Developing

### Running the tests

```shell
make test
```

### Using the linter

```shell
make lint
```

### Serving the app locally

```shell
make serve
```

### Deploying changes

Once you have merged your changes into the master branch, deploying them is made up of
two steps:

* Pushing a built image to the docker registry from Jenkins.

* Restarting the running tasks so it picks up the latest image.

## Gotchas

### Extra API parameters

```ruby
let(:url) { "/authorize/user/#{username}/mac/#{client_mac}/ap/#{ap_mac}/site/#{ap_ip_address}/apg/#{ap_aruba_name}/mdn/#{ap_meraki_name}" }
```

Currently we do not use any of the above parameters after username
within any part of the API code. However having these parameters in the
CloudWatch logs is useful for linking up matching requests between the
/authorize and /post-auth calls while debugging.

## Licence

This codebase is released under [the MIT License][mit].

[mit]: LICENCE
