module token;

import source_file;

class Token {  
private:  
    SourceFile owner;
    string lexeme;
    int type;    

public:  
    static enum {
        IDENTIFIER,
        NUMBER,
        STRING,
        CHARACTER,
        SYMBOL
    }

    this(SourceFile owner, string lexeme, int type) {
        this.owner = owner;
        this.lexeme = lexeme;
        this.type = type;
    }

    string get_contents() {
        return lexeme;
    }

    int get_type() {
        return type;
    }

};