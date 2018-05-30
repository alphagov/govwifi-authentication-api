# GovWifi Authentication API

Ruby rewrite of authentication for GovWifi and FreeRadius

## Gotchas

### Extra API parameters

```ruby
let(:url) { "/authorize/user/#{username}/mac/#{client_mac}/ap/#{ap_mac}/site/#{ap_ip_address}/apg/#{ap_aruba_name}/mdn/#{ap_meraki_name}" }
```

Currently we do not use any of the above parameters after username
within any part of the API code. However having these parameters in the CloudWatch logs is useful for linking up matching requests between the /authorize and /post-auth calls while debugging.
