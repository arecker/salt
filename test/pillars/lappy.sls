directories:
  /home/alex/bin:
    user: alex
    group: alex

git:
  blog:
    user: alex
    target: /home/alex/git/blog
    url: https://github.com/arecker/blog.git
    depth: 1
  emacs:
    user: alex
    target: /home/alex/git/emacs
    url: git://git.sv.gnu.org/emacs.git
    depth: 1
  emacs.d:
    user: alex
    target: /home/alex/.emacs.d
    url: https://github.com/arecker/emacs.d.git
    depth: 1
