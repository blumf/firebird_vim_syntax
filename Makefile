DATESTAMP=$(shell date)

all:
	env lua build_fb_sql.lua
	cat sqlfirebird_head \
	    firebird_sql_keywords.vim \
            sqlfirebird_tail > sqlfirebird.tmp
	sed "s/###DATESTAMP###/$(DATESTAMP)/" sqlfirebird.tmp > sqlfirebird.vim

clean:
	rm firebird_sql_keywords.vim sqlfirebird.tmp sqlfirebird.vim

