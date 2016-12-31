#include <stdio.h>

int main(void)
{
   FILE *messages;
   FILE *infile;
   FILE *exitsptr;
   FILE *roomptr;
   char strings[512][512];
   char descriptions[512];
   char extradesc[512];
   int i=0, j=0, count=0, loc=0;

   messages=fopen("messages.txt","r");
   if (messages == NULL)
   {
      fprintf(stderr,"Could not open messages file\n");
      exit(1);
   }
   infile=fopen("$.RICK4","rb");
   if (infile == NULL)
   {
      fprintf(stderr,"Could not open data file\n");
      exit(1);
   }

   while (!feof(messages))
   {
      fscanf(messages,"%[^\n]",strings[i]);
      fgetc(messages);
      i++;
   }
   fclose(messages);

   fseek(infile,0x200,SEEK_SET);
   for (i=0; i<256; i++)
   {
      descriptions[i]=fgetc(infile);
   }

   // Check extra descriptions
   fseek(infile,0x300,SEEK_SET);
   for (i=0; i<256; i++)
   {
      j=fgetc(infile);
      if (j != 0) extradesc[i]=j+descriptions[i];
   }
   // Now to work out the exits - first the easy ones: news

   // Print descriptions
   for (i=0; i<250; i++)
   {
      printf("Room %d\n",i);
      printf("Description text:\n");
      j=1;
      printf("%s%s", strings[j], strings[descriptions[i]]);
      if (extradesc[i] != 0) printf("%s",strings[extradesc[i]]);
      printf(".\n");
   }

   fclose(infile);
   return 0;
}
