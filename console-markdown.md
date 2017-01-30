# How to get markdown in console

* found at http://unix.stackexchange.com/questions/4140/markdown-viewer

```
$ wget http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip
$ unzip Markdown_1.0.1.zip
$ cd Markdown_1.0.1/
$ ./Markdown.pl ~/testfile.markdown | html2text
html2text is one of many tools you can use to view html formatted text from the command line. Another option, if you want slightly nicer output would be to use lynx:

$ ./Markdown.pl ~/testfile.markdown | lynx -stdin
```
