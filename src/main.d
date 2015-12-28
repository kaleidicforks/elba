import std.stdio;
import std.string;

import lexer;
import source_file;

int main() {
	auto file = new SourceFile("tests/test.foo");
	auto lexer = new Lexer(file);	
	while (lexer.is_running()) {
		lexer.get_next_token();
	}
	foreach (token; file.get_tokens()) {
		writeln("contents: ", token.get_contents());
	}
	
	return 0;
}