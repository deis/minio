### v2.0.0-beta2 -> v2.0.0-beta3

#### Maintenance

 - [`ab4e628`](https://github.com/deis/minio/commit/ab4e62874733d68a946c83fb751e7958fb6e2a54) .travis.yml: Deep six the travis -> jenkins webhooks

### v2.0.0-beta1 -> v2.0.0-beta2

#### Features

 - [`98c3647`](https://github.com/deis/minio/commit/98c364764bc058fd3ad018b7799e0cc6e2a7d268) _scripts: add CHANGELOG.md and generator script

#### Fixes

 - [`0c71217`](https://github.com/deis/minio/commit/0c712173fead2785ee99fdba98830772819d71ee) (all): resolve build and container start issues


#### Maintenance

 - [`e7f7ca1`](https://github.com/deis/minio/commit/e7f7ca102b4b8944ceb7c4de61d95c07e2a142ad) Makefile: update to go-dev:0.9.1

### 2.0.0-alpha -> v2.0.0-beta1

#### Features

 - [`3f3f0f1`](https://github.com/deis/minio/commit/3f3f0f114527bb4491852e2c16e49969639fd713) mutable: add support for mutable image build
 - [`a378431`](https://github.com/deis/minio/commit/a37843169486d3f1eee2b157ecc97473303a706d) boot: allow minio host/port information to be configurable
 - [`ebe442d`](https://github.com/deis/minio/commit/ebe442d6bf0073af61f9576911f8ab8389a6a288) .travis.yml: have this job notify its sister job in Jenkins

#### Fixes

 - [`f931225`](https://github.com/deis/minio/commit/f93122593c873ce1b45826146039a3b8c0d8f855) .travis.yml: run docker build on PRs as well
 - [`addf8e6`](https://github.com/deis/minio/commit/addf8e6225cab434b546795a532284fa8db16f73) boot.go: check previously-unchecked error
 - [`97e5f40`](https://github.com/deis/minio/commit/97e5f40ed0abdded82e712da0459a30975afdd82) rootfs/bin: remove the miniostarter binary
 - [`465ad45`](https://github.com/deis/minio/commit/465ad45be7762117c639410d6b52a54311876ef9) manifests/deis-minio-rc.yaml: fix container port to match the health server port
 - [`8a743ba`](https://github.com/deis/minio/commit/8a743baf793be6ef361b922fb49b3e0f18de128b) boot.go,src/healthsrv: add readiness and liveness probes
 - [`20633be`](https://github.com/deis/minio/commit/20633bee15b90fe0b7eb8ee0bbf1dca78064a170) Makefile: add a glideup build target
 - [`7d4cd3f`](https://github.com/deis/minio/commit/7d4cd3f8ae7f562384707778ebdbf3968e0614da) Makefile: remove docker-build dependency from docker-push
 - [`26f2efa`](https://github.com/deis/minio/commit/26f2efa312756bc6ba8a9f2df967fcbcb9df1785) rootfs/Dockerfile: move from ubuntu-debootstrap to ubuntu
 - [`feb91e4`](https://github.com/deis/minio/commit/feb91e4ff2ad518fa3bd1649c54fe4c74dec998d) Makefile: upgrade to v0.4.0 of the dev image
 - [`9cf830e`](https://github.com/deis/minio/commit/9cf830ede83f725aa70110948a3f72a4f57b9616) mc/Dockerfile: make the mc image use alpine:3.3
 - [`b73960d`](https://github.com/deis/minio/commit/b73960d51164644e2921e413b30abd81d413c49e) Dockerfile: run the server without alpine support
 - [`1bb5971`](https://github.com/deis/minio/commit/1bb5971277473b90590a28b2023b0274a4ec25f9) rootfs/Dockerfile,mc/Dockerfile: set DOCKERIMAGE environment variables

#### Maintenance

 - [`cafaace`](https://github.com/deis/minio/commit/cafaaceb18bc190aca19cccedebf5e9a8a8d3ab3) Makefile,glide.yaml,glide.lock: use quay.io/deis/go-dev:0.5.0
 - [`fbb0289`](https://github.com/deis/minio/commit/fbb0289e3bb006950e72972a7fd87bf9d172622f) Dockerfile: remove top level dockerfile, as it's not used
 - [`dca27fe`](https://github.com/deis/minio/commit/dca27febece6a6e38d23d8b0fee7b541b0cea2a8) release: bump version to v2-beta

### 2.0.0-alpha

#### Features

 - [`b2a6281`](https://github.com/deis/minio/commit/b2a6281efc6abf859599d2f86bbd51b8fad34b36) (all): add to travis
 - [`d8eafd7`](https://github.com/deis/minio/commit/d8eafd788fff1200dd01c24991f6739077f8e39e) Makefile,install.sh: build the minio server outside of docker build
 - [`8c03dc4`](https://github.com/deis/minio/commit/8c03dc44e231c3aecc9cf6b0220c42db3a08bd58) (all): configuring minio with SSL certs
 - [`41a9e75`](https://github.com/deis/minio/commit/41a9e75bcfa9ab7016da66643d1f326a75c9fa8f) (all): build mc from master, push, make pod available for testing
 - [`6a08d26`](https://github.com/deis/minio/commit/6a08d26cf1e9a56f2c8313846ece1e5e9cd51974) Makefile, genssl/gen.sh: add script and makefile target for generating SSL certs

#### Fixes

 - [`e45ea61`](https://github.com/deis/minio/commit/e45ea61bbb74cd250fc937932f14c453ec133c1b) glide.lock,glide.yaml: revert to old version of pkg/aboutme
 - [`e65fcbf`](https://github.com/deis/minio/commit/e65fcbfb70da2ce4007ebad33021d34725901c8f) deploy.sh: build the binary before build/push container
 - [`036b8f3`](https://github.com/deis/minio/commit/036b8f3fb5b8cbfc932b2ebd2024b58b1c53fce7) (all): run minio server without ssl
 - [`f9410bc`](https://github.com/deis/minio/commit/f9410bc3f25f65516a235cb6f4614ed239969c77) (all): fix travis build
 - [`b43ff60`](https://github.com/deis/minio/commit/b43ff60bace5a7449b45ea43651554fb6fe0e998) Makefile: replace only deis images in mc and mc-integration manifests
 - [`239a694`](https://github.com/deis/minio/commit/239a694beda662791fb47431aa150ee44f23021c) Makefile: use git sha for VERSION
 - [`66360fe`](https://github.com/deis/minio/commit/66360fec1c7719efe3fd402d3840bcd138f02521) Makefile: enumerate both the admin and user secrets
 - [`a8a4aba`](https://github.com/deis/minio/commit/a8a4abafeefd2e35fd385352b892cb605ade81b2) Makefile: adding image prefix
 - [`29015fa`](https://github.com/deis/minio/commit/29015fa5405302cf819df9991d5feeb0099a356e) boot.go: running with minio-user credentials for now
 - [`c5695c4`](https://github.com/deis/minio/commit/c5695c433f1a9956654c18fe6b66e7f4435454a0) deis-mc-pod: fixing merge errors
 - [`2476a69`](https://github.com/deis/minio/commit/2476a69ebf6e2ae57a0abb32db2058fb223223cd) (all): vendoring packages
 - [`ae1030c`](https://github.com/deis/minio/commit/ae1030c4b40b4de753db6ee13ede00292fd27533) makefile: fix missing separator error
 - [`435b2d8`](https://github.com/deis/minio/commit/435b2d8fcf85cea8ec7c19bd8d9dfdf5f31de863) Makefile: fixing left over merge conflict

#### Documentation

 - [`8552483`](https://github.com/deis/minio/commit/8552483429a58c3ffe152a70843775b2d70d8699) README.md: add more docs to the readme, to match other repos
 - [`8d18ede`](https://github.com/deis/minio/commit/8d18ede868a8b1ca23f64cd25dd4d323e3f6babc) README.md,_docs/README.md: add install and usage instructions

#### Maintenance

 - [`6ba2830`](https://github.com/deis/minio/commit/6ba28302367478cab4c6a63f41dae473b352447c) release: set version and lock to deis registry
 - [`e72fb05`](https://github.com/deis/minio/commit/e72fb059900cc03c58e553bab7743708c635b295) glide: add lockfile, use glide 0.8
 - [`1a7a9a2`](https://github.com/deis/minio/commit/1a7a9a205f14cabd622b7accd72963de5f5a872e) Dockerfile: add DEIS_VERSION
