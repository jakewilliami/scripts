#include <unistd.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define BGREEN         "\e[1;38;5;2m"
#define ULINE          "\e[1;4m"
#define IT             "\e[0;3m"
#define DULL           "\e[1;2m"
#define FLASHING       "\e[1;5m"
#define BWHITE         "\e[1;38m"
#define ITWHITE        "\e[0;3;38m"
#define BYELLOW        "\e[1;33m"
#define ITYELLOW       "\e[0;3;33m"
#define BRED           "\e[1;31m"
#define ITRED          "\e[0;3;31m"
#define BBLUE          "\e[1;34m"
#define DARKBBLUE      "\e[1;38;5;26m"
#define NORM           "\e[0;38m"
#define JULIA          "\e[1;38;5;133m"
#define PYTHON         "\e[1;38;5;26m"
#define JAVA           "\e[1;38;5;130m"
#define RUST           "\e[1;38;5;180m"
#define HASKELL        "\e[1;38;5;60m"
#define SHELL          "\e[1;38;5;113m"
#define PERL           "\e[1;38;5;32m"
#define RUBY           "\e[1;38;5;52m"
#define ELIXIR         "\e[1;38;5;60m"
#define COMMONLISP     "\e[1;38;5;72m"
#define LISP           "\e[1;38;5;72m"
#define EMACSLISP      "\e[1;38;5;134m"
#define LUA            "\e[1;38;5;18m"
#define C              "\e[1;38;5;59m"
#define CPP            "\e[1;38;5;204m"
#define CSHARP         "\e[1;38;5;28m"
#define R              "\e[1;38;5;32m"
#define JAVASCRIPT     "\e[1;38;5;221m"
#define BATCHFILE      "\e[1;38;5;154m"
#define TEX            "\e[1;38;5;22m"
#define TEXT           "\e[0;38m"
#define MARKDOWN       "\e[1;38;5;249m"
#define OBJECTIVEC     "\e[1;38;5;69m"
#define ASSEMBLY       "\e[1;38;5;58m"
#define ROFF           "\e[1;38;5;223m"
#define MAKEFILE       "\e[1;38;5;64m"
#define SWIFT          "\e[1;38;5;215m"
#define YACC           "\e[1;38;5;107m"
#define AWK            "\e[1;38;5;188m"
#define SMPL           "\e[1;38;5;197m"
#define SED            "\e[1;38;5;71m"
#define LEX            "\e[1;38;5;184m"
#define D              "\e[1;38;5;131m"
#define COFFEESCRIPT   "\e[1;38;5;24m"
#define ERLANG         "\e[1;38;5;132m"
#define HTML           "\e[1;38;5;166m"
#define GO             "\e[1;38;5;38m"
#define SCHEME         "\e[1;38;5;27m"
#define TYPESCRIPT     "\e[1;38;5;30m"
#define POWERSHELL     "\e[1;38;5;17m"
#define PHP            "\e[1;38;5;60m"
#define DTRACE         "\e[1;38;5;188m"
#define CSS            "\e[1;38;5;60m"
#define FSHARP         "\e[1;38;5;135m"
#define MATLAB         "\e[1;38;5;167m"
#define CUDA           "\e[1;38;5;101m"
#define OCAML          "\e[1;38;5;77m"
#define OBJECTIVECPP   "\e[1;38;5;63m"
#define APPLESCRIPT    "\e[1;38;5;16m"

#define RESET			NORM

char *string_repeat(const char *s, int n) {
  size_t slen = strlen(s);
  char * dest = malloc(n * slen + 1);
 
  int i; char * p;
  for (i=0, p = dest; i < n; ++i, p += slen) {
    memcpy(p, s, slen);
  }
  *p = '\0';
  
  return dest;
}

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

const char *get_file_print_modifier(const char *ext) {
    // char* print_colour;
    if (!strcmp(ext, "jl")) {
        // char* print_colour = JULIA;
        return JULIA;
    }
    else if (!strcmp(ext, "rs")) {
        // char* print_colour = RUST;
        return RUST;
    }
    else if ((!strcmp(ext, "c")) || (!strcmp(ext, "h")) || (!strcmp(ext, "h1")) || (!strcmp(ext, "h2")) || (!strcmp(ext, "1")) || (!strcmp(ext, "3")) || (!strcmp(ext, "8")) || (!strcmp(ext, "in"))) {
        // char* print_colour = C;
        return C;
    }
    else if ((!strcmp(ext, "")) || (!strcmp(ext, "sh")) || (!strcmp(ext, "ahk")) || (!strcmp(ext, "script")) || (!strcmp(ext, "scpt"))) {
        // char* print_colour = SHELL;
        return SHELL;
    }
    else if ((!strcmp(ext, "tex")) || (!strcmp(ext, "sty")) || (!strcmp(ext, "cls"))) {
        // char* print_colour = TEX;
        return TEX;
    }
    else if ((!strcmp(ext, "json")) || (!strcmp(ext, "js"))) {
        // char* print_colour = JAVASCRIPT;
        return JAVASCRIPT;
    }
    else if (!strcmp(ext, "pl")) {
        // char* print_colour = PERL;
        return PERL;
    }
    else if ((!strcmp(ext, "py")) || (!strcmp(ext, "pyc")) || (!strcmp(ext, "pytxcode"))) {
        // char* print_colour = PERL;
        return PYTHON;
    }
    else if (!strcmp(ext, "go")) {
        // char* print_colour = PERL;
        return GO;
    }
    else if (!strcmp(ext, "java")) {
        // char* print_colour = PERL;
        return JAVA;
    }
    else if (!strcmp(ext, "rb")) {
        // char* print_colour = RUBY;
        return RUBY;
    }
    else if (!strcmp(ext, "lua")) {
        // char* print_colour = LUA;
        return LUA;
    }
    else if ((!strcmp(ext, "cpp")) || (!strcmp(ext, "cc")) || (!strcmp(ext, "dox")) || (!strcmp(ext, "cmake")) || (!strcmp(ext, "template")) || (!strcmp(ext, "dtd"))) {
        // char* print_colour = CPP;
        return CPP;
    }
    else if (!strcmp(ext, "lisp")) {
        // char* print_colour = LISP;
        return LISP;
    }
    else if (!strcmp(ext, "clisp")) {
        // char* print_colour = COMMONLISP;
        return COMMONLISP;
    }
    else if (!strcmp(ext, "elisp")) {
        // char* print_colour = EMACSLISP;
        return EMACSLISP;
    }
    else if ((!strcmp(ext, "r")) || (!strcmp(ext, "rscript"))) {
        // char* print_colour = R;
        return R;
    }
    else if (!strcmp(ext, "ex")) {
        // char* print_colour = ELIXIR;
        return ELIXIR;
    }
    else if ((!strcmp(ext, "md")) || (!strcmp(ext, "sgml"))) {
        // char* print_colour = MARKDOWN;
        return MARKDOWN;
    }
    else if (!strcmp(ext, "sed")) {
        // char* print_colour = SED;
        return SED;
    }
    else if (!strcmp(ext, "awk")) {
        // char* print_colour = AWK;
        return AWK;
    }
    else if ((!strcmp(ext, "htm")) || (!strcmp(ext, "html")) || (!strcmp(ext, "h5")) || (!strcmp(ext, "ipynb"))) {
        // char* print_colour = HTML;
        return HTML;
    }
    else if (!strcmp(ext, "m")) {
        return MATLAB;
    }
    else if (!strcmp(ext, "css")) {
        return CSS;
    }
    else if (!strcmp(ext, "hs")) {
        return HASKELL;
    }
    else if (!strcmp(ext, "bat")) {
        return BATCHFILE;
    }
    else if ((!strcmp(ext, "plist")) || (!strcmp(ext, "xml"))) {
        return MARKDOWN;
    }
    else if (!strcmp(ext, "applescript")) {
        return APPLESCRIPT;
    }
    // else if ((!strcmp(ext, "pdf")) || (!strcmp(ext, "txt")) || (!strcmp(ext, "png")) || (!strcmp(ext, "dvi")) || (!strcmp(ext, "zip")) || (!strcmp(ext, "xls")) || (!strcmp(ext, "xlsx")) || (!strcmp(ext, "csv")) || (!strcmp(ext, "doc")) || (!strcmp(ext, "docx")) || (!strcmp(ext, "dot")) || (!strcmp(ext, "eml")) || (!strcmp(ext, "flv")) || (!strcmp(ext, "gif")) || (!strcmp(ext, "iso")) || (!strcmp(ext, "jpg")) || (!strcmp(ext, "jpeg")) || (!strcmp(ext, "m4a")) || (!strcmp(ext, "mov")) || (!strcmp(ext, "mp3")) || (!strcmp(ext, "mkv")) || (!strcmp(ext, "mp4")) || (!strcmp(ext, "ppt")) || (!strcmp(ext, "pptx")) || (!strcmp(ext, "rar")) || (!strcmp(ext, "gz")) || (!strcmp(ext, "tar")) || (!strcmp(ext, "rtf")) || (!strcmp(ext, "tif")) || (!strcmp(ext, "tiff")) || (!strcmp(ext, "wav")) || (!strcmp(ext, "xls")) || (!strcmp(ext, "mid")) || (!strcmp(ext, "midi")) || (!strcmp(ext, "cda")) || (!strcmp(ext, "aif")) || (!strcmp(ext, "mpa")) || (!strcmp(ext, "ogg")) || (!strcmp(ext, "wma")) || (!strcmp(ext, "wpl")) || (!strcmp(ext, "pgm")) || (!strcmp(ext, "aux")) || (!strcmp(ext, "log")) || (!strcmp(ext, "fls")) || (!strcmp(ext, "fdb_latexmk")) || (!strcmp(ext, "hd")) || (!strcmp(ext, "out")) || (!strcmp(ext, "bbl")) || (!strcmp(ext, "bib")) || (!strcmp(ext, "blb")) || (!strcmp(ext, "avi")) || (!strcmp(ext, "crt")) || (!strcmp(ext, "cer")) || (!strcmp(ext, "svg")) || (!strcmp(ext, "epub")) || (!strcmp(ext, "djvu")) || (!strcmp(ext, "blg")) || (!strcmp(ext, "numbers")) || (!strcmp(ext, "pages"))|| (!strcmp(ext, "key")) || (!strcmp(ext, "toc")) || (!strcmp(ext, "textclipping")) || (!strcmp(ext, "synctex")) || (!strcmp(ext, "synctex(busy)")) || (!strcmp(ext, "xwm")) || (!strcmp(ext, "pytxcode")) || (!strcmp(ext, "ps")) || (!strcmp(ext, "ent")) || (!strcmp(ext, "dat")) || (!strcmp(ext, "ocw")) || (!strcmp(ext, "thm")) || (!strcmp(ext, "mol")) || (!strcmp(ext, "eps")) || (!strcmp(ext, "xref")) || (!strcmp(ext, "idv")) || (!strcmp(ext, "tmp")) || (!strcmp(ext, "lg")) || (!strcmp(ext, "4ct")) || (!strcmp(ext, "rmd")) || (!strcmp(ext, "download")) || (!strcmp(ext, "enl")) || (!strcmp(ext, "frm")) || (!strcmp(ext, "myd")) || (!strcmp(ext, "opt")) || (!strcmp(ext, "myi")) || (!strcmp(ext, "pdb")) || (!strcmp(ext, "webp")) || (!strcmp(ext, "inp")) || (!strcmp(ext, "sav")) || (!strcmp(ext, "dgm")) || (!strcmp(ext, "bcf")) || (!strcmp(ext, "jasp")) || (!strcmp(ext, "aspx")) || (!strcmp(ext, "jdx")) || (!strcmp(ext, "ent")) || (!strcmp(ext, "idx")) || (!strcmp(ext, "xlsb")) || (!strcmp(ext, "icns")) || (!strcmp(ext, "chm")) || (!strcmp(ext, "x86")) || (!strcmp(ext, "nib")) || (!strcmp(ext, "strings")) || (!strcmp(ext, "pbxproj")) || (!strcmp(ext, "ppc")) || (!strcmp(ext, "pbxuser")) || (!strcmp(ext, "patch")) || (!strcmp(ext, "pyw")) || (!strcmp(ext, "d11")) || (!strcmp(ext, "sylib")) || (!strcmp(ext, "so")) || (!strcmp(ext, "k4i")) || (!strcmp(ext, "rsrc"))) {
    //     return TEXT;
    // }
    else if ((!strcmp(ext, "toml")) || (!strcmp(ext, "efi"))) {
        return MARKDOWN;
    }
    else {
        // char* print_colour = SHELL;
        return TEXT;
    }
    
    return TEXT; // should never get here
        
    /* char* print_colour = !strcmp(ext, "jl") ? JULIA : !strcmp(ext, "rs") ? RUST : !strcmp(ext, "c") ? C : !strcmp(ext, "sh") ? SHELL : !strcmp(ext, "tex") ? TEX : !strcmp(ext, "sty") ? TEX : !strcmp(ext, "cls") ? TEX : !strcmp(ext, "json") ? JAVASCRIPT : !strcmp(ext, "pl") ? PERL : !strcmp(ext, "rb") ? RUBY : !strcmp(ext, "lua") ? LUA : !strcmp(ext, "cpp") ? CPP : !strcmp(ext, "lisp") ? LISP : !strcmp(ext, "clisp") ? COMMONLISP : !strcmp(ext, "ex") ? ELIXIR : !strcmp(ext, "md") ? MARKDOWN : !strcmp(ext, "txt") ? TEXT : !strcmp(ext, "cl") ? COMMONLISP : !strcmp(ext, "r") ? R : !strcmp(ext, "py") ? PYTHON : !strcmp(ext, "h") ? C : !strcmp(ext, "h1") ? C : !strcmp(ext, "h2") ? C : !strcmp(ext, "1") ? C : !strcmp(ext, "3") ? C : !strcmp(ext, "sed") ? SED : !strcmp(ext, "pdf") ? RESET : !strcmp(ext, "png") ? RESET : !strcmp(ext, "dvi") ? RESET: !strcmp(ext, "toml") ? RESET : SHELL; */
}

void recurse_dirs(char *name, int depth, int indent)
{
    // define the indentation value
    int indent_modifier = 4;
    // define a pointer to directory
    DIR *dir;
    struct dirent *entry;
    
    // cannot list a depth of zero
    if (depth == 0) {
        return;
    }
    
    // if directory depth is negative, go up a level
    if (depth < 0) {
        int abs_depth = depth * -1;
        char* parental_dirs = string_repeat("../", abs_depth);
        // append ch to str
        char* new_name;
        if((new_name = malloc(strlen(parental_dirs)+strlen(name)+1)) != NULL){
            new_name[0] = '\0';   // ensures the memory is an empty string
            strcat(new_name, parental_dirs);
            strcat(new_name, name);
        } else {
            return;
        }
        // printf("%s", new_name);
        char* name = new_name;
    }
    
    // don't open the directory if it isn't a directory
    if (!(dir = opendir(name))) {
        return;
    }
    
    // recursively read directories
    while ((entry = readdir(dir)) != NULL) {
        char* ext = get_filename_ext(entry->d_name);
        // for ( ; *r_ext; ++r_ext) *r_ext = tolower(*r_ext);
        // lowercase the extension
        for (int i = 0; ext[i]; i++) {
            ext[i] = tolower(ext[i]);
        }
        const char* print_colour = get_file_print_modifier(ext);
        
        if (starts_with(entry->d_name, ".") == 1 || !strcmp(entry->d_name, "README.md") || starts_with(entry->d_name, "dev-") || !strcmp(entry->d_name, "build") || !strcmp(entry->d_name, "target") || !strcmp(entry->d_name, "textcolours.txt") || !strcmp(entry->d_name, "init_notes.md")) {
            continue;
        }
        if (entry->d_type == DT_DIR) {
            char path[1024];
            // don't go too deep!
            if (indent / indent_modifier == depth) {
                return;
            }
            snprintf(path, sizeof(path), "%s/%s", name, entry->d_name);
            printf("%s%*s%s%s/\n", BBLUE, indent, "", entry->d_name, RESET);
            if (depth != 1) {
                recurse_dirs(path, depth, indent + indent_modifier);
            }
        } else {
            printf("%s%*s%s%s\n", print_colour, indent, "", entry->d_name, RESET);
        }
    }
    closedir(dir);
}

int main(int argc, char** argv) {
    int depth;
    
    // default depth should be 1 if not given
    // if (!strcmp(argv[2], "")) {
        // convert second argument (depth) to an integer
        sscanf(argv[2], "%d", &depth);
    // }
    // else {
    //     int depth = 1;
    // }
    
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
