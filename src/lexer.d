module lexer;

import std.string;
import std.stdio;

import token;
import source_file;

class Lexer {  
private:  
    SourceFile file;
    int position;
    int initial_position;
    bool running;
    char current_char;

    void push_token(int type) {
	    // push a new Token, where the contents is cut from initial_position to position
	    // (basically a substring if your language doesn't have this fancy sugar)
	    // and we set the type to the one passed
	    // this is pushed to the file being lexed
	    file.push_token(new Token(file, file.get_contents()[initial_position .. position], type));
	}

	void recognize_identifier() {
	    while (is_identifier(current_char)) {
	        consume();
	    }
	    push_token(Token.IDENTIFIER);
	}

	void recognize_digit() {
	    while (is_digit(current_char)) {
	        consume();
	    }

	    if (current_char == '.') {
	    	consume();
	        while (is_digit(current_char)) {
	            consume();
	        }
	    }

	    push_token(Token.NUMBER);
	}

	void recognize_symbol() {
		consume();
		push_token(Token.SYMBOL);
	}

	void recognize_character() {
		consume();
		while (current_char != '\'') {
			consume();
		}
		push_token(Token.CHARACTER);
	}

	void recognize_string() {
		consume();
		while (current_char != '"') {
			consume();
		}
		push_token(Token.CHARACTER);		
	}

	void eat_layout() {
	    // in the ASCII table, any char below 32 (' ') is
	    // pretty much junk, like tabs, backspaces, etc
	    // though we want to make sure we don't eat the EOF
	    while (current_char <= 32 && current_char != 0) {
	        consume();
	    }
	}

	void consume() {
	    // this looks confusing, but we check if 
	    // on the next consume it is the end of the file
	    // if it is, we increment the position, but we
	    // set the character to the null terminator '\0'
	    // so when we get the tokens, we can check if it's '\0'
	    // and stop the lexer
	    if (position + 1 >= file.get_length()) {
	        position++;
	        current_char = '\0';
	        return;
	    }
	    
	    // otherwise we just set the current char to
	    // the character at {position} in the source file
	    // note we increment position BEFORE, not AFTER!!
	    current_char = file.get_contents()[++position];
	}

	bool is_digit(char c) {
	    return (c >= '0' && c <= '9');
	}

	bool is_letter(char c) {
	    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
	}

	bool is_letter_or_digit(char c) {
	    return is_letter(c) || is_digit(c);
	}

	bool is_identifier(char c) {
	    return is_letter_or_digit(c) || c == '_';
	}

public:  
    this(SourceFile file) {
        this.file = file;

        // these will be explained later on
        this.position = 0;
        this.initial_position = 0;
        this.running = true;

        // set character to first character in file
        this.current_char = file.get_contents()[0];
    }

	void get_next_token() {
	    eat_layout();
	    initial_position = position;

        if (current_char == '\0') {
		    running = false;
		    return; // exit out of this function
		}
		else if (is_letter(current_char)) {
	        recognize_identifier();
	    }
	    else if (is_digit(current_char)) {
	        recognize_digit();
	    }
	    else {
	        switch (current_char) {
	            case '-': case '+': case '/': case '*':
	            case '=': case '(': case ')': case '[':
	            case ']': case ',': case '{': case '}':
	            case ';': case '.':
	                recognize_symbol();
	                break;
	            case '\'':
	                recognize_character();
	                break;
	            case '"':
	                recognize_string();
	                break;
                default:
	                writeln("unrecognised character `", current_char, "`");
	                break;
	        }
	    }
	}

    bool is_running() {
    	return running;
    }
};