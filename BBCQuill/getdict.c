#include <stdio.h>
#include <string.h>

int main (int argc, char **argv)
{
   FILE *infile;
   char array[255][255], temp[255];
   unsigned char byte, byte2;
   unsigned char tokens1[32],tokens2[32];
   int i=0,size=0,ptr=0,upper=0,bracket,index;
   int count=0,d,dest,room;
   char exits[][255]={"north", "south", "west", "east","ne","nw","se","sw","up","down","in","out"};

   int msgstart=0, roomend=0;
   infile=fopen(argv[1],"rb");
   fseek(infile,0x2fa,SEEK_SET);
   for(i=0; i < 32; i++)
   {
      tokens1[i]=fgetc(infile);
   }
   for(i=0; i < 32; i++)
   {
      tokens2[i]=fgetc(infile);
   }
   for (i=0; i<32; i++)
   {
      array[i][0]=tokens1[i];
      array[i][1]=tokens2[i];
      array[i][2]=0;
   }

   fseek(infile,0xc02,SEEK_SET);
   msgstart=(fgetc(infile)+(fgetc(infile)*256))-0x2900;
   fseek(infile,0xc08,SEEK_SET);
   roomend=(fgetc(infile)+(fgetc(infile)*256))-0x2900;

   
   // read messages
   fseek(infile,msgstart,SEEK_SET);
   count=0;
   do
   {
      index=fgetc(infile);
      // size of string;
      printf("Message %d %d\n",count,index);
      for (i=1;i < index;i++)
      {
         byte = fgetc(infile);
         if ((byte & 0x7f) < 32)
         {
            // Print token
            printf("%s",array[byte & 0x7f]);
         }
         else if ((byte & 0x7f) == 0x3e)
         {
            printf("\n");
         }
         else 
         {
            printf("%c",byte & 0x7f);
         }
         
         if (byte & 0x80)
         {
            printf(" ");
         }
      }
      printf("\n");
      count++;
   } while (ftell(infile) < roomend);
   exit(0);

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
