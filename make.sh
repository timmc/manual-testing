#!/bin/bash
# Hacky script to build one md file as html

title_html="Manual software testing toolkit"
src=toolkit.md
build_dir=target
dest=$build_dir/toolkit.html

rm -rf $build_dir
mkdir -p $build_dir

header_tpl="$(cat html/header.html)"
header_val="${header_tpl/__TITLE__/$title_html}"
echo -n "$header_val" >> $dest
markdown $src >> $dest
cat html/footer.html >> $dest
