docker run --rm -p 1313:1313 -v ${PWD}:/src \
  docker.io/hugomods/hugo:0.165.0 \
  hugo server --bind 0.0.0.0 -p 1313
