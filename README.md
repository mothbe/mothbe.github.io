# mothbe.github.io

## Create new post:

1. Clone repository:
```
git clone git@github.com:mothbe/mothbe.github.io.git
cd mothbe/mothbe.github.io
git submodule init
git submodule update
```

2. Execute following command:
```
hugo new posts/second-post.md
```

3. Edit new file `content/posts/second-post.md`
4. Start development server:
```
hugo serve -D
```

5. Set in new post `draft: false`
6, Build html files:
```
hugo
```

7. Start HTTP server and verify posts:
```
python3 -m http.server -d public
```
