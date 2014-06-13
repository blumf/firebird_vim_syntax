firebird_vim_syntax
===================

Vim FirebirdSQL syntax file

Requirements
------------

* make (tested: GNU Make)
* lua (tested: Lua 5.2)

firebird_sql_keywords.csv
-------------------------

A simple CSV file mapping Firebird's SQL keywords to their type.

Current types are:
* `key` = Any misc. keyword
* `op` = Operators (AND, OR, =, etc.)
* `type` = Data types (BIGINT, CHAR, etc.)
* `func` = Functions
* `const` = Constants (NULL)
* `state` = Statments (INSERT, SELECT, etc.)
* `type_mod` = Type modifiers (DEFAULT, SUB_TYPE, etc.)
* `object` = Database objects (TABLE, VIEW, etc.)
* `group_op` = Aggregate functions on group selects (MIN, COUNT, etc.)

