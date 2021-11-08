# TODO list application written in Closure

For the sake of learning Closure.

**Status: Work in Progress! Do not expect the app to work!
Both backend and frontend are not implemented yet!**

## How to build and run

I recommend to use [Nix](https://nixos.org/guides/install-nix.html).

Technically, if you have Clojure installed you could just run:

``` sh
clojure -M backend/src/main.clj --help
```

### Using Nix

To build and run the app you can just do:

``` sh
nix-build
result/bin/clojure-todo-app-run-backend --help
```

#### Build the environment

You can build the development environment and make a GC root so its stays in
the Nix Store and doesn’t get garbage collected.

``` sh
nix-build -A env -o result-env
```

#### Update deps.nix file

`default.nix` provides `clj2nix` attribute
so you can just build it first and then run:

``` sh
nix-build -A clj2nix -o result-clj2nix
result-clj2nix/bin/clj2nix deps.edn deps.nix
```

## Development

### vim-lsp

When you enter a Nix Shell (`nix-shell`) you get `clojure-lsp` (you can also
install it manually if you don’t use Nix) in your `PATH` environment variable.
In case you are using (Neo)Vim and `vim-lsp` plugin then you can register the
LSP server like this:

``` viml
if executable('clojure-lsp')
  aug ClosureLsp
  au! User lsp_setup cal lsp#register_server({
    \ 'name': 'clojure-lsp',
    \ 'cmd': {server_info->['clojure-lsp']},
    \ 'allowlist': ['clojure'],
    \ })
  aug END
en
```

If you have `clojure-lsp` executable in your `PATH` the server should start
automagically when you open a `*.clj` file (make sure your Vim recognizes those
files as `clojure` file type).

Then you could try to run some commands like `:LspReferences`.

## Author

Viacheslav Lotsmanov
