#include <stdio.h>

int main(void)
{
    int a, b;
    FILE *in; // use for handling input file
    FILE *out; // use for handling output file

    // Open raw.txt for reading
	in = fopen("sumeachline.txt", "r");
	if (in == NULL) {
		printf("Error opening input file");
		/* error(EXIT_FAILURE); */
	}

    // Open processed.txt for writing
    out = fopen("out.txt", "w");
	if (out == NULL) {
		printf("Error opening output file");
		/* error(EXIT_FAILURE); */
	}

    // Go thru raw.txt file and generate processed.txt file accordingly
	while (fscanf(in, "%d %d\n", &a, &b) != EOF) {
		int sum = a + b;
    	fprintf(out, "%d %d %d\n", a, b, sum);
	}



	/* while(!feof(in)){ */
        /* num = fgetc(in); */
        /* printf("%c\n",num); */
    /* } */

    /* fscanf(in, "%d %d", &a, &b); */
	// fscanf(in, "%d", &b);
	// while ((read = getline(&line, &len, fp)) != -1)	
	/* fgetc(in); */
	/* fputc(out); */
	
	/* char line[256]; */
	
	/* while (fgets(line, sizeof(line), in)) { */
        /* note that fgets don't strip the terminating \n, checking its
           presence would allow to handle lines longer that sizeof(line) */
        /* printf("%s", line);  */
		/* f */
    /* } */
    /* may check feof here to make a difference between eof and io failure -- network
       timeout for instance */

    /* fclose(file); */

	/* while ((c = fgetc(in)) != EOF) { */
		/* fscanf(in, "%d %d", &a, &b); */
		/* int sum = a + b; */
		/* fputf(sum, out); */
		/* int a = ; */
		/* int b = ; */
		/* int sum = a + b; */
		/* fput(a b sum, out); */
	/* } */

	// write to out
	// fflush(out);

	// close files
	fclose(in);
	fclose(out);

    return 0;
}

