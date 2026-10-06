# Redis lab (Docker only)

Everything runs in containers: the Redis server and `redis-cli`. Nothing is installed on your host.
Works on Windows (Docker Desktop, PowerShell or WSL) and macOS (Docker Desktop, OrbStack, Colima).

## Files

| File | Purpose |
|---|---|
| `docker-compose.yml` | Redis server, one-shot CLI container, optional RedisInsight GUI |
| `.env` | Password and port (edit as you like) |
| `lab/01-basics.redis` | A script of commands to replay |

Images: `redis` (Docker Official Image) and `redis/redisinsight` (Redis's own GUI). Check Docker Hub for the current tag; the compose file pins the major version.

## 1. Start the instance

```
docker compose up -d
docker compose ps          # STATUS should become "healthy"
docker compose logs redis  # look for "Ready to accept connections"
```

## 2. Connect with redis-cli

```
docker compose run --rm redis-cli
```

You get a prompt like `redis:6379>`. Password is passed automatically via `REDISCLI_AUTH`.
Run a single command without the shell:

```
docker compose run --rm redis-cli PING
```

Alternative: `docker exec -it redis-lab redis-cli -a lab-password-change-me`.

## 3. "Create a database"

Redis has no `CREATE DATABASE`. An instance has a fixed number of numbered logical databases (0..15 by default, set with `--databases`). They already exist; you just pick one:

```
SELECT 1
```

The prompt changes to `redis:6379[1]>`. Also possible at connect time: `docker compose run --rm redis-cli -n 1`.

## 4. Write and read

```
SET user:1:name "Alice"
GET user:1:name
SET session:abc123 "payload" EX 60     # expires in 60s
TTL session:abc123
HSET user:1 name Alice age 30
HGETALL user:1
KEYS *            # fine in a lab, never in production
SCAN 0 MATCH user:* COUNT 100   # the production-safe way
DEL user:1:name
```

Replay the whole script:

```
# macOS / Linux / WSL
docker compose run --rm -T redis-cli < lab/01-basics.redis
# PowerShell
Get-Content lab/01-basics.redis | docker compose run --rm -T redis-cli
```

## 5. Check persistence

```
docker compose restart redis
docker compose run --rm redis-cli GET user:1:name   # still there (AOF + volume)
```

Wipe everything: `docker compose down -v`.

## 6. Optional GUI

```
docker compose --profile gui up -d
```

Open http://localhost:5540, add a database with host `redis`, port `6379`, and your password.

## Core concepts

**What Redis is.** An in-memory data structure server. All data lives in RAM, which is why it is very fast (typically sub-millisecond). Disk is only used for persistence, not for serving reads.

**Instance vs database.** One Redis server process = one instance. Inside it are numbered logical databases (0-15 by default). They are just separate keyspaces: the same key name can exist in db 0 and db 1 independently. They share the same memory, the same config, the same password, and the same process. There are no per-database users, names, or quotas. Consequences:
- `FLUSHDB` clears the current one, `FLUSHALL` clears all of them.
- Redis Cluster supports only db 0. Many teams therefore use prefixes in db 0 or separate instances instead of multiple numbered DBs.
- If you need real isolation (different apps, different passwords), run separate instances (separate containers are cheap).

**Keys.** Binary-safe strings, up to 512 MB (keep them short). Convention is namespacing with colons: `user:1:name`, `cache:product:42`. There are no tables or schemas; the key naming scheme is your schema.

**Values are typed data structures**, not just strings:

| Type | Commands | Typical use |
|---|---|---|
| String | `SET/GET/INCR` | cache blobs, counters |
| Hash | `HSET/HGETALL` | objects (user profile) |
| List | `LPUSH/RPOP/LRANGE` | simple queues, recent items |
| Set | `SADD/SMEMBERS` | tags, unique visitors |
| Sorted set | `ZADD/ZRANGE` | leaderboards, scheduling |
| Stream | `XADD/XREAD/XREADGROUP` | durable event log, consumer groups |
| Pub/Sub | `PUBLISH/SUBSCRIBE` | fire-and-forget messaging |

Commands are type-checked: `LPUSH` on a string key gives `WRONGTYPE`. Use `TYPE key` to check.

**Expiry (TTL).** Any key can expire (`EXPIRE`, `SET ... EX`). This is what makes Redis a natural cache. Without a TTL, keys live until deleted or evicted.

**Eviction.** With `maxmemory` set, Redis evicts keys according to `maxmemory-policy` (e.g. `allkeys-lru` for a pure cache). Without `maxmemory`, it grows until the OS or Docker kills it. Worth setting in the lab: add `--maxmemory 256mb --maxmemory-policy allkeys-lru` to the `command`.

**Execution model.** Commands run on a single main thread, one at a time, so every single command is atomic. Multi-step atomicity: `MULTI/EXEC` or Lua scripts.

**Persistence.** Two mechanisms, can be combined:
- RDB: periodic snapshots (`dump.rdb`); compact, may lose the last minutes.
- AOF: log of every write (`appendonly yes`); safer, bigger. This lab uses AOF.
Both write into `/data`, which is the Docker volume.

**Not a database replacement by default.** Treat it as a cache or fast secondary store unless you design persistence and replication on purpose.

## Extending the lab

**Pub/Sub** (two terminals):

```
# terminal 1
docker compose run --rm redis-cli SUBSCRIBE news
# terminal 2
docker compose run --rm redis-cli PUBLISH news "hello"
```

Pub/Sub is at-most-once: a subscriber that is offline misses messages. For a real queue use Streams:

```
XADD orders * item book qty 1
XGROUP CREATE orders workers $ MKSTREAM
XREADGROUP GROUP workers w1 COUNT 1 STREAMS orders >
XACK orders workers <id>
```

**Other ideas** that fit this compose file:
- Use from Python/Django: add a `python` service on the same network and `django-redis` / `redis-py`, connecting to host `redis`.
- Cache pattern: cache-aside with TTL.
- Replication: add a second service with `--replicaof redis 6379 --masterauth <pw>`.
- Monitoring: `MONITOR`, `INFO`, `SLOWLOG GET`, `redis-cli --latency`.
- JSON, search, time series, probabilistic structures are included in recent Redis 8 images; try `JSON.SET doc $ '{"a":1}'`.
- Valkey (the Linux Foundation fork) is a drop-in alternative image if you want to compare.

## Cleanup

```
docker compose down        # stop, keep data
docker compose down -v     # stop and delete data
```

## Troubleshooting

- `NOAUTH Authentication required`: you bypassed the compose CLI; pass `-a <password>` or set `REDISCLI_AUTH`.
- Port 6379 in use: change `REDIS_PORT` in `.env`.
- Windows: if scripts fail with line-ending errors, make sure `.redis` files use LF (VS Code: bottom-right "CRLF" -> "LF").
- Windows with `-T` and piping in `cmd.exe` is unreliable; use PowerShell or WSL.
