#include <stdio.h>
#include <stdlib.h>

char words[512][512];
typedef struct
{
   unsigned char n,s,e,w;
   unsigned char u,d,i,o;
   unsigned char se,sw,ne,nw;
} roomexits;

int main(void)
{
   FILE *messages;
   FILE *infile;
   FILE *exitsptr, *exitsptr2;
   FILE *roomptr;
   char strings[512][512];
   unsigned char descriptions[512];
   unsigned char extradesc[512];
   roomexits exits[2048];
   int numexits[512];
   int objects[512];
   int objectlocs[512];
   //need to malloc
   //char words;
   int numobjects, numwords;
   int i=0, j=0, count=0, loc=0, k=0, ptr=0;
   unsigned char blank=255;


   messages=fopen("thesius.txt","r");
   if (messages == NULL)
   {
      fprintf(stderr,"Could not open messages file\n");
      exit(1);
   }
   infile=fopen("$.ADCODE1","rb");
   if (infile == NULL)
   {
      fprintf(stderr,"Could not open data file\n");
      exit(1);
   }
   // Open exitsptr so we can look at the same file twice!
   exitsptr=fopen("$.ADCODE1","rb");
   if (exitsptr == NULL)
   {
      fprintf(stderr,"Could not open data file\n");
      exit(1);
   }
   exitsptr2=fopen("$.RICK4","rb");
   if (exitsptr2 == NULL)
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
   for (i=0; i<255;i++)
   {
      exits[i].n=blank; exits[i].s=blank; exits[i].e=blank; exits[i].w=blank;
      exits[i].u=blank; exits[i].d=blank; exits[i].i=blank; exits[i].o=blank;
      exits[i].se=blank; exits[i].sw=blank; exits[i].ne=blank; exits[i].nw=blank;
   }

   // Check extra descriptions
   fseek(infile,0x300,SEEK_SET);
   for (i=0; i<256; i++)
   {
      j=fgetc(infile);
      if (j != 0) extradesc[i]=j+descriptions[i];
   }
   // Now to work out the exits - first the easy ones: news
   fseek(infile,0x0,SEEK_SET);
   fseek(exitsptr,0x1f3c,SEEK_SET);
   fseek(exitsptr2,0x100,SEEK_SET);
   for (i=0; i<256; i++)
   {
      j=fgetc(infile);
      // Get number of exits
      numexits[i]=j & 0xf;
      k=j & 0xf;

      // Get exits
      if ((j & 0x10) != 0) exits[i].n=fgetc(exitsptr);
      if ((j & 0x20) != 0) exits[i].s=fgetc(exitsptr);
      if ((j & 0x40) != 0) exits[i].e=fgetc(exitsptr);
      if ((j & 0x80) != 0) exits[i].w=fgetc(exitsptr);

      // Get other exits
      j=fgetc(exitsptr2);
      if ((j & 0x10) != 0) exits[i].u=fgetc(exitsptr);
      if ((j & 0x20) != 0) exits[i].d=fgetc(exitsptr);
      if ((j & 0x40) != 0) exits[i].i=fgetc(exitsptr);
      if ((j & 0x80) != 0) exits[i].o=fgetc(exitsptr);
      if ((j & 0x01) != 0) exits[i].se=fgetc(exitsptr);
      if ((j & 0x02) != 0) exits[i].sw=fgetc(exitsptr);
      if ((j & 0x04) != 0) exits[i].ne=fgetc(exitsptr);
      if ((j & 0x08) != 0) exits[i].nw=fgetc(exitsptr);
   }
   fclose(exitsptr);
   fclose(exitsptr2);

   // Get objects
   // Get number of objects
   fseek(infile,0x3e5,SEEK_SET);
   numobjects=fgetc(infile)+1;
   fseek(infile,0x44c,SEEK_SET);
   for (i=0;i<numobjects;i++)
   {
      j=fgetc(infile);
      objects[i]=j+0xdc;
   }
   fseek(infile,0x42e,SEEK_SET);
   for (i=0;i<numobjects;i++)
   {
      j=fgetc(infile);
      objectlocs[i]=j;
   }

   // Now get words
   fseek(infile,0x1c9e,SEEK_SET);
   i=0; ptr=0;
   do
   {
      j=fgetc(infile);
      // Check for high bit set
      if ((j & 0x80) == 0x80)
      { // end of word
         words[i][ptr++]=j & 0x7f;
         i++;
         ptr=0;
      }
      else if (j != 0xff)
      {
         if (j > 0x50 )
         { // It's a number
            j-=0x50;
            words[i][ptr++]=(((j / 4)+1)*4) - ((j % 4) + 1) + 48;
         }
         else
         { // It's a letter
            words[i][ptr++]=(((j / 4)+1)*4) - ((j % 4) + 1) + 96;
         }
      }
   } while (j != 0xff && i < 255);
   numwords=i-1;

   // Print descriptions
   for (i=0; i<250; i++)
   {
      printf("Room %d\n",i);
      printf("Description text:\n");
      j=1;
      printf("%s%s", strings[j], strings[descriptions[i]]);
      if (extradesc[i] != 0) printf("%s",strings[extradesc[i]]);
      printf(".\n");
      printf("Exits: %d\n",numexits[i]);
      if (exits[i].n < 255) printf("North to %d (%s)\n",exits[i].n,strings[descriptions[exits[i].n]]);
      if (exits[i].s < 255) printf("South to %d (%s)\n",exits[i].s,strings[descriptions[exits[i].s]]);
      if (exits[i].e < 255) printf("East to %d (%s)\n",exits[i].e,strings[descriptions[exits[i].e]]);
      if (exits[i].w < 255) printf("West to %d (%s)\n",exits[i].w,strings[descriptions[exits[i].w]]);
      if (exits[i].i < 255) printf("In to %d (%s)\n",exits[i].i,strings[descriptions[exits[i].i]]);
      if (exits[i].o < 255) printf("Out to %d (%s)\n",exits[i].o,strings[descriptions[exits[i].o]]);
      if (exits[i].u < 255) printf("Up to %d (%s)\n",exits[i].u,strings[descriptions[exits[i].u]]);
      if (exits[i].d < 255) printf("Down to %d (%s)\n",exits[i].d,strings[descriptions[exits[i].d]]);
      if (exits[i].se < 255) printf("Southeast to %d (%s)\n",exits[i].se,strings[descriptions[exits[i].se]]);
      if (exits[i].sw < 255) printf("Southwest to %d (%s)\n",exits[i].sw,strings[descriptions[exits[i].sw]]);
      if (exits[i].ne < 255) printf("Northeast to %d (%s)\n",exits[i].ne,strings[descriptions[exits[i].ne]]);
      if (exits[i].nw < 255) printf("Northwest to %d (%s)\n",exits[i].nw,strings[descriptions[exits[i].nw]]);
      printf("\n");
   }

   for (i=0;i<numobjects; i++)
   {
      printf("Object %d: %s\n",i,strings[objects[i]]);
      printf("Description: %s\n",strings[objects[i]+1]);
      printf("Starts in %d (%s)\n",objectlocs[i],strings[descriptions[objectlocs[i]]]);
      printf("\n");
   }

   for (i=0;i<numwords;i++)
   {
      printf("Word %d: %s\n",i,words[i]);
   }

   fclose(infile);
   return 0;
}
