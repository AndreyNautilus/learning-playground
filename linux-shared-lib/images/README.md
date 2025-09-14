# Docker images used on CI

Docker images used on CI.
Published from local machine to docker hub (no CI publishing):
- [clang image](https://hub.docker.com/r/andreynautilus/clang/tags)
- [gcc image](https://hub.docker.com/r/andreynautilus/gcc)

Images use [CalVer](https://calver.org/) prefixed with original image version:
`MAJOR-YYYY-MM-DD[-INDEX]`.

## Build

Login first:

```bash
docker login  # for browser-based authentication
```

Using [docker bake](https://docs.docker.com/build/bake/):

```powershell
$env:CALVER_VERSION="2025-09-14"; docker buildx bake
```
or
```bash
CALVER_VERSION="2025-09-14" docker buildx bake
```

Or build individual images (not preferred, adjust tags and versions):

```bash
clang$ docker build -t andreynautilus/clang:17 --build-arg VERSION=17 .
gcc$ docker build -t andreynautilus/gcc:15 --build-arg VERSION=15 .
```

## Publish

Add `--push` parameter to `bake` command:
```bash
CALVER_VERSION="2025-09-14" docker buildx bake --push
```

or push individual images:

```bash
$ docker push andreynautilus/clang:17-YYYY-MM-DD andreynautilus/gcc:15-YYYY-MM-DD
```
