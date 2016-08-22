#include <stdio.h>
#include <string.h>

int main (void)
{
   FILE *infile;
   char array[255][255], temp[255];
   unsigned char byte, byte2;
   int i=0,size=0,ptr=0,upper=0,bracket,index;
   int count=0,d,dest,room;
   char exits[][255]={"north", "south", "west", "east","ne","nw","se","sw","up","down","in","out"};

   infile=fopen("star2","rb");
   fseek(infile,0x200,SEEK_SET);
   do
   {
      byte=fgetc(infile);
      if (byte != 0x7f)
      {
         // index number
         printf("%x: ",byte);
         index=byte;
         do
         {
            byte=fgetc(infile);
            if (byte != 0x0d)
            {
               array[index][ptr++]=byte;
            }
            else
            {
               array[index][ptr++]='\0';
               ptr=0;
               ++i;
            }
         } while (byte != 0x0d);
         printf("%s\n",array[index]);
      }
   } while (!feof(infile) && byte != 0x7f);
   size=i;

   fseek(infile,0x222f,SEEK_SET);
   //printf("%4x %2x: ", ftell(infile),count);

   do
   {
      // message number
      byte=fgetc(infile);
      if (byte != 0)
      {
         printf("%d: ",byte);
         do
         {
            byte=fgetc(infile);
            upper=0;
            if (byte == 0x7f)
            {
               // capitalise first letter
               upper=1;
               do
               {
                  byte=fgetc(infile);
               } while (byte == 0x7f);
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
                  else
                  {
                     temp[i]|=0x20;
                  }
               }
               printf("%s", temp);
            }
         } while(byte != 0x0d);
         printf("\n");
      }
   } while (byte !=0 && !feof(infile));

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
