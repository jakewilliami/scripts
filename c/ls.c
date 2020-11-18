#include <unistd.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int starts_with(const char *a, const char *b)
{
    if(!strncmp(a, b, strlen(b))) {
        return 1;
    }
    return 0;
}

// when return 1, scandir will put this dirent to the list
// int parse_ext(const struct dirent *dir, const char* ext_name) {
//     if(!dir) {
//         return 0;
//     }
//
//     if(dir->d_type == DT_REG) { // only deal with regular file
//         const char *ext = strrchr(dir->d_name,'.');
//         if((!ext) || (ext == dir->d_name)) {
//             return 0;
//         }
//         else {
//             if(!strcmp(ext, ext_name)) {
//                 return 1;
//             }
//         }
//     }
//     return 0;
// }

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
    int i = 0;
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
        if (starts_with(entry->d_name, ".") == 1) {
            continue;
        }
        if (entry->d_type == DT_DIR) {
            char path[1024];
            if (i == 3) {
                return;
            }
            snprintf(path, sizeof(path), "%s/%s", name, entry->d_name);
            printf("%*s%s\n", indent, "", entry->d_name);
            recurse_dirs(path, depth, indent + indent_modifier);
            i ++;
        } else {
            printf("%*s%s\n", indent, "", entry->d_name);
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
