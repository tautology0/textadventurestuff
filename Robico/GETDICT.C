#include <stdio.h>

int main (void)
{
   FILE *infile;
   char array[255][30], temp[30];
   unsigned char byte, byte2;
   int i=0,size=0,ptr=0,lower=0,bracket;
   int count=0;

   infile=fopen("$.RICK3","rb");

   do
   {
      byte=fgetc(infile);
      if ( byte != 0x40 && !feof(infile) )
      {
         array[i][ptr++]=byte;
      }
      else if (!feof(infile))
      {
       array[i][ptr++]='\0';
       ptr=0;
         ++i;
      }
   } while (!feof(infile));
   size=i;

   fclose(infile);

   /* Now open the main file */
   infile=fopen("$.RICK4","rb");

   fseek(infile,0x21c0,SEEK_SET);
   //printf("%4x %2x: ", ftell(infile),count);

   do
   {
      byte=fgetc(infile);
      if (byte < size)
      {
         /* look up in dictionary */
         if (lower==1)
         {
            printf("%c",array[byte][0]);
         }
         for (i=lower;i<strlen(array[byte]);i++)
         {
            printf("%c",tolower(array[byte][i]));
         }
         lower=0;
      }
      else
      {
        /* look it up */
        if (byte == size)
        {
            count++;
            printf("\n");
            //printf("\n%4x %2x: ", ftell(infile),count);
        }
        else if ((byte - size) < 27)
        {
          byte2=(byte-size);
          byte2+=(lower==1)?64:96;
          printf("%c",byte2);
          lower=0;
        }
        else
        {
         switch (byte-size)
         {
            case 36: printf("\""); break;
            case 35:
               if (bracket == 0) { printf("("); bracket=1; }
               else { printf(")"); bracket=0; } break;
            case 34: lower=1; break;
            case 33: printf("'"); break;
            case 32: printf(" "); break;
            case 31: printf(": "); break;
            case 30: printf(", "); break;
            case 29: printf("! "); lower=1; break;
            case 28: printf("? "); lower=1; break;
            case 27: printf(". "); lower=1; break;
            default: printf("!!!!!!%x!!!!!!!",(byte-size)); break;
          }
        }
      }
   } while (!feof(infile));

   fclose(infile);
   return 0;
}
