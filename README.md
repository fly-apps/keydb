# KeyDB on Fly

KeyDB is a multithreaded fork of Redis designed for high performance on multi-core servers.

KeyDB also supports a _multimaster_ mode which is uniquely suited to deployment on Fly. This mode
does not currently enforce strong consistency, but it's useful for a few scenarios today.

## Performant global cache

[We've written about](https://fly.io/blog/last-mile-redis/) using standard Redis
replicas that can accept writes both from clients *and* their primary.

Keydb multimaster provides a similar last-write-wins guarantee. So it's useful for caching
and does not require targeting a specific instance to invalidate a cache item.

## Distributed pub/sub

This setup also supports broadcasting pub/sub events to clients connected to other KeyDB peers
using the standard [Redis Pub/Sub commands](https://fly.io/blog/last-mile-redis/).

KeyDB offers no additional guarantees on deliverability nor ordering of messages.
Otherwise, any existing software using Redis pub/sub should work in a multimaster setup.

## Deployment

Get the [Fly CLI](https://fly.io/blog/last-mile-redis/) and a Fly account.

Then, clone this repo and run `fly launch`. Don't deploy yet - we need to do a bit more setup.

By default, this configuration enables authentication on KeyDB. So let's set a password:

```
fly secrets set KEYDB_PASSWORD=password
```

Now let's add storage volumes in Chicago and Amsterdam for KeyDB persistent storage.

```
fly volumes create keydb_server --region ord
fly volumes create keydb_server --region ams
```

Now we're ready to deploy!

```
fly deploy
```

We can keep track of what's going on with `fly logs`.

Finally, we'll want to deploy an application in the same regions and connect to the region-local KeyDB.

That can be done by building the instance hostname using the region and application name. For example,
the Chicago instance is available at `redis://password:password@ord.multimaster-keydb-example.internal`.

Check out our [example Rails app using Anycable](https://github.com/superfly/anycable-rails) to broadcast websocket messages globally.
