#include <stdio.h>
#include <string.h>

int main (void)
{
   FILE *infile;
   char array[255][255], temp[255];
   unsigned char byte, byte2;
   int i=0,size=0,ptr=0,upper=0,bracket,index;
   int count=0,d,dest,room,lines=0,submess=0;
   char exits[][255]={"north", "south", "west", "east","ne","nw","se","sw","up","down","in","out"};

   infile=fopen("CASTLE1","rb");
   fseek(infile,0x3109,SEEK_SET);
   index=0;
   do
   {
      byte=fgetc(infile);
      if (byte != 0x00)
      {
         if (byte != 0x0d)
         {
            array[index][ptr++]=byte;
         }
         else
         {
            array[index][ptr++]='\0';
            ptr=0;
            printf("%x %s\n",index + 0x80,array[index]);
            index++;
         }
      }
   } while (!feof(infile) && byte != 0x00);

   fseek(infile,0x35fb,SEEK_SET);
   //printf("%4x %2x: ", ftell(infile),count);

   count=1;
   do
   {
      byte=fgetc(infile);
      // number of lines
      lines=byte & 0xf;
      submess=(byte & 0xf0) >> 4;

      printf("%d: ",count);
      if (byte != 0xff)
      {
         for (i=0; i < lines; i++)
         {
            do
            {
               byte=fgetc(infile);

               if (byte < 128 && byte > 31)
               {
                  // print direct
                  printf("%c",byte);
               }
               else if (byte != 0x0d)
               {
                  // dictionary
                  printf("%s", array[byte-128]);
               }
            } while(byte != 0x0d);
            printf("\n");
         }
         if (lines==0) { byte=fgetc(infile); }
         for (i=0; i < submess; i++)
         {
            byte=fgetc(infile);
            byte2=fgetc(infile);
            printf(" <message%d> ",byte+byte2*256);
         }
         printf("\n");
         count++;
      }
   } while (byte != 0xff && !feof(infile));

   exit(0);
   
   fseek(infile,0xa01,SEEK_SET);
   //printf("%4x %2x: ", ftell(infile),count);

   do
   {
      // message number
      byte=fgetc(infile);
      if (byte != 0xff)
      {
         printf("%d: ",byte);
         room=byte;
         do
         {
            byte=fgetc(infile);
            upper=0;
            if (byte == 0x7f)
            {
               // capitalise first letter
               upper=1;
               byte=fgetc(infile);
            }
            if (byte == 0x60 || byte==0x0d)
            {
               printf("\n");
            }
            else if (strlen(array[byte])==0)
            {
               // print direct
               if (!upper) byte |= 0x20;
               printf("%c",byte);
            }
            else
            {
               // dictionary
               strcpy(temp,array[byte]);
               for (i=upper;i<strlen(temp);i++)
               {
                  if (temp[i] == 0x7f)
                  {
                     strcpy(temp+i, temp+i+1);

                  }
                  temp[i]|=0x20;
               }

               printf("%s",temp);
            }
         } while(byte != 0x0d);
         // next 4 bytes are exits
         printf("\n");
         printf("Exits: ");
         do
         {
            ptr=fgetc(infile);
            if (ptr != 0xff)
            {
               // Direction = 0xxxx000
               d=(ptr & 0x78) >> 3;
               printf("%s: ",exits[d]);
               if (ptr>127) dest=ptr|0x78; else dest=ptr&7;
               dest=(dest+room)%256;
               printf("%d ",dest);
            }

         } while (ptr != 0xff);
         printf("\n");
      }
   } while (byte !=0xff && !feof(infile) && room != 0x0d);


   fclose(infile);
   return 0;
}
