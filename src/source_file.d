module source_file;

import std.stdio;
import std.string;
import std.path;

import token;

class SourceFile {
private:
    string contents;
    string location;
    int length; // we need a way to check the source length

    // we have not defined our Token yet, but this 
    // is the files token stream that is produced
    Token[] tokens; 

    // helper function for reading files
    // you can make this static and move
    // into a global scope, or into some
    // util class if you wish
    string read_file(string location) {
        string result = "";
        File file = File(location, "r");
        while (!file.eof()) {
            string line = chomp(file.readln());
            result ~= line; // ~ is concatentation/append in D!
        }
        return result;
    }
public:
    this(string location) {
        this.location = location;
        this.contents = read_file(location);
        this.length = cast(int) this.contents.length;
    }

    void push_token(Token t) {
        tokens ~= t; // here's that weird operator again
    }

    string get_location() {
        return location;
    }

    string get_contents() {
        return contents;
    }

    Token[] get_tokens() {
        return tokens;
    }    

    int get_length() {
        return length;
    }
};