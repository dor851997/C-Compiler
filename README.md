# C-Compiler  

A compiler for a simple language similar to c language. Written in Lex, Yacc, C. 

Compiller has 1 step:  

1. Lexical analysis reuslt will be a Abstract syntax tree for Syntax analysis.  

In order to run the application:  

1.clone this repository.  
2.open Linux command.  
3.download bison lex and yacc: sudo apt-get install bison.  
4.go to project location.  
5.change codeTest.txt by language rules or leave the template code.  
6.run command: yacc -d parser.y  
7.run command: lex scanner.l  
8.run command: cc -o test y.tab.c -ll  
9.run command: ./test < projectPath/codeTest.txt  

Please let me know if you find bugs or something that needs to be fixed.  
