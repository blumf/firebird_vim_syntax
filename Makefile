DATESTAMP=$(shell date)

all:
	env lua build_fb_sql.lua
	cat sqlfirebird_head \
	    sqlfirebird_body \
            sqlfirebird_tail > sqlfirebird.vim
	sed -i "s/###DATESTAMP###/$(DATESTAMP)/" sqlfirebird.vim

clean:
	rm -f sqlfirebird_body sqlfirebird.vim

install:
	mkdir -p ~/.vim/syntax
	cp sqlfirebird.vim ~/.vim/syntax

