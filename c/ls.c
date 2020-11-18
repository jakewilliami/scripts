#include <unistd.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BGREEN       "\x1b[1;38;5;2m"
#define ULINE        "\x1b[1;4m"
#define IT           "\x1b[0;3m"
#define DULL         "\x1b[1;2m"
#define FLASHING     "\x1b[1;5m"
#define BWHITE       "\x1b[1;38m"
#define ITWHITE      "\x1b[0;3;38m"
#define BYELLOW      "\x1b[1;33m"
#define ITYELLOW     "\x1b[0;3;33m"
#define BRED         "\x1b[1;31m"
#define ITRED        "\x1b[0;3;31m"
#define BBLUE        "\x1b[1;34m"
#define DARKBLUE     "\x1b[1;38;5;26m"
#define RESET        "\x1b[0;38m"
#define JULIA        "\x1b[1;38;5;133m"
#define PYTHON       "\x1b[1;38;5;26m"
#define JAVA         "\x1b[1;38;5;94m"
#define RUST         "\x1b[1;38;5;5m"
#define SHELL        "\x1b[1;38;5;28m"
#define PERL         "\x1b[1;38;5;111m"
#define RUBY         "\x1b[1;38;5;88m"
#define ELIXIR       "\x1b[1;38;5;54m"
#define COMMONLISP   "\x1b[1;38;5;29m"
#define LISP         "\x1b[1;38;5;29m"
#define LUA          "\x1b[1;38;5;17m"
#define C            "\x1b[1;38;5;234m"
#define CPP          "\x1b[1;38;5;198m"
#define R            "\x1b[1;38;5;32m"
#define JAVASCRIPT   "\x1b[1;38;5;185m"
#define BATCHFILE    "\x1b[1;38;5;154m"
#define TEX          "\x1b[1;38;5;22m"
#define TEXT         "\x1b[0;38m"
#define MARKDOWN     "\x1b[1;38;5;249m"
#define OBJECTIVEC   "\x1b[1;38;5;33m"
#define ASSEMBLY     "\x1b[1;38;5;94m"
#define ROFF         "\x1b[1;38;5;180m"
#define MAKEFILE     "\x1b[1;38;5;22m"
#define SWIFT        "\x1b[1;38;5;208m"
#define YACC         "\x1b[1;38;5;29m"
#define DTRACE       "\x1b[1;38;5;250m"
#define AWK          "\x1b[1;38;5;249m"
#define SMPL         "\x1b[1;38;5;197m"
#define SED          "\x1b[1;38;5;35m"
#define LEX          "\x1b[1;38;5;142m"
#define D            "\x1b[1;38;5;125m"
#define COFFEESCRIPT "\x1b[1;38;5;4m"
#define CSS          "\x1b[1;38;5;55m"


int starts_with(const char *a, const char *b)
{
    if(!strncmp(a, b, strlen(b))) {
        return 1;
    }
    return 0;
}

const char *get_filename_ext(const char *filename) {
    const char *dot = strrchr(filename, '.');
    
    if (!dot || dot == filename) {
        return "";
    }
    
    return dot + 1;
}

void recurse_dirs(const char *name, int depth, int indent)
{
    // define the indentation value
    int indent_modifier = 4;
    // define a pointer to directory
    DIR *dir;
    struct dirent *entry;
    
    // don't open the directory if it isn't a directory
    if (!(dir = opendir(name))) {
        return;
    }

    // !strcmp(ext, "jl")

    // recursively read directories
    while ((entry = readdir(dir)) != NULL) {
        const char* ext = get_filename_ext(entry->d_name);
        const char* print_colour = !strcmp(ext, "jl") ? JULIA : !strcmp(ext, "rs") ? RUST : !strcmp(ext, "c") ? C : !strcmp(ext, "sh") ? SHELL : !strcmp(ext, "tex") ? TEX : !strcmp(ext, "sty") ? TEX : !strcmp(ext, "cls") ? TEX : !strcmp(ext, "json") ? JAVASCRIPT : !strcmp(ext, "pl") ? PERL : !strcmp(ext, "rb") ? RUBY : !strcmp(ext, "lua") ? LUA : !strcmp(ext, "cpp") ? CPP : !strcmp(ext, "lisp") ? LISP : !strcmp(ext, "clisp") ? COMMONLISP : !strcmp(ext, "ex") ? ELIXIR : !strcmp(ext, "md") ? MARKDOWN : !strcmp(ext, "txt") ? TEXT : !strcmp(ext, "cl") ? COMMONLISP : !strcmp(ext, "r") ? R : !strcmp(ext, "py") ? PYTHON : !strcmp(ext, "h") ? C : !strcmp(ext, "h1") ? C : !strcmp(ext, "h2") ? C : !strcmp(ext, "1") ? C : !strcmp(ext, "3") ? C : !strcmp(ext, "sed") ? SED : !strcmp(ext, "pdf") ? RESET : !strcmp(ext, "png") ? RESET : !strcmp(ext, "dvi") ? RESET: !strcmp(ext, "toml") ? RESET : SHELL;
        if (starts_with(entry->d_name, ".") == 1 || !strcmp(entry->d_name, "README.md") || starts_with(entry->d_name, "dev-") || !strcmp(entry->d_name, "dep") || !strcmp(entry->d_name, "build") || !strcmp(entry->d_name, "target") || !strcmp(entry->d_name, "textcolours.txt") || !strcmp(entry->d_name, "init_notes.md")) {
            continue;
        }
        if (entry->d_type == DT_DIR) {
            char path[1024];
            // don't go too deep!
            if (indent / indent_modifier == depth) {
                return;
            }
            snprintf(path, sizeof(path), "%s/%s", name, entry->d_name);
            printf("%s%*s%s%s\n", BBLUE, indent, "", entry->d_name, RESET);
            recurse_dirs(path, depth, indent + indent_modifier);
        } else {
            printf("%s%*s%s%s\n", print_colour, indent, "", entry->d_name, RESET);
        }
    }
    closedir(dir);
}

int main(int argc, char** argv) {
    // convert second argument (depth) to an integer
    int depth;
    sscanf(argv[2], "%d", &depth);
    
    recurse_dirs(argv[1], depth, 0);
    return 0;
}

// #include <stdio.h>
// #include <dirent.h>
//
// int recurse_dir(char* path) {
// 	DIR * dirp;
// 	struct dirent * entry;
//
//     dirp = opendir(path);
// 	while ((entry = readdir(dirp)) != NULL) {
// 		printf("%s\n", entry->d_name);
// 	}
// 	closedir(dirp);
//
// 	return 0;
// }
//
// int main(int argc, char** argv) {
// 	recurse_dir(argv[1]);
//
// 	return 0;
// }
