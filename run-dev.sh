docker run --rm -p 1313:1313 -v ${PWD}:/src \
  docker.io/hugomods/hugo@sha256:cf1a2009a1edf807d0880af344c4dd13b40b308c340501128fb54e5aab17b009 \
  hugo server --bind 0.0.0.0 -p 1313
