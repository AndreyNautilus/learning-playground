# Docker images used on CI

Docker images used on CI.
Published from local machine to docker hub (no CI publishing):
- [clang image](https://hub.docker.com/r/andreynautilus/clang/tags)
- [gcc image](https://hub.docker.com/r/andreynautilus/gcc)

For now uses base versioning and don't support updating. Need to add versioning (CalVer?).

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

```bash
$ docker push andreynautilus/clang:17-YYYY-MM-DD andreynautilus/gcc:15-YYYY-MM-DD
```
