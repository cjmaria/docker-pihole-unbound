# Pi-Hole + Unbound on Docker

## Modifications
This fork contains modifications to the one-container unbound resolver configuration designed to create a long-lived local DNS cache. Most use-cases for unbound involve recursive DNS to get the authoritative response to a DNS query. However, this configuration has been modified so that unbound keeps a large cache with a min-ttl of 3 days (259200 seconds). When a DNS query needs to be resolved outside of the cache, unbound forwards the query to public non-authoritatuive DNS servers. (In my case, my ISP's DNS and Cloudflare DNS as a fallback). 

With authoritative DNS, cached responses return in <1ms and un-cached in ~100-300ms
With forwarded DNS, cached responses return in <1ms and un-cached in ~25ms

Note that this configuration is not ideal for most use cases because the min-ttl is extrtemely high. Consider lowering the min-ttl and allowing prefetches to happen more frequently to keep more fresh records.

### Use Docker to run [Pi-Hole](https://pi-hole.net) with an upstream [Unbound](https://nlnetlabs.nl/projects/unbound/about/) resolver.

This repo has 2 different `docker-compose` configs-- choose your favorite. The `two-container` config may work better on Synology due to usage of `macvlan` networking which helps prevent port conflicts with the host.

- [`one-container`](one-container/) (new) - Install Unbound directly into the Pi-Hole container
  - This configuration contacts the DNS root servers directly, please read the Pi-Hole docs on [Pi-hole as All-Around DNS Solution](https://docs.pi-hole.net/guides/unbound/) to understand what this means.
  - With this approach, we can also simplify our Docker networking since `macvlan` is no longer necessary.
- [`two-container`](two-container/) (legacy) - Use separate containers for Pi-Hole and Unbound
  - This configuration uses MatthewVance's [unbound-docker](https://github.com/MatthewVance/unbound-docker) container to implement encrypted DNS to third party DNS resolvers (eg Cloudflare). This is arguably less privacy-friendly since you're handing your DNS queries to those 3rd party providers.

