#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
   int description;
   int north;
   int south;
   int east;
   int west;
   int northeast;
   int northwest;
   int southeast;
   int southwest;
   int up;
   int down;
} room_struct;

int main (void)
{
   FILE *infile;
   char tokens[512][30], temp[30];
   char messages[512][512];
   room_struct rooms[512];
   
   unsigned char byte, byte2;
   int i=0,size=0,ptr=0,lower=0,bracket;
   int endtok=0,lowtok=0,token=0;
   int msgcount=0, roomcount=0;

   infile = fopen("XAAN","rb");
   if (infile == NULL)
   {
      printf("Failed to open file\n");
      exit(1);
   }
   fseek(infile,0x66e5,SEEK_SET);

   do
   {
      byte=fgetc(infile);
      if ( (byte != 0x40) && !feof(infile) )
      {
         tokens[i][ptr++]=byte;
      }
      else if (!feof(infile))
      {
         tokens[i][ptr++]='\0';
         ptr=0;
         ++i;
      }
   } while (!feof(infile));
   size=i;

   fseek(infile,0x3100,SEEK_SET);
   //printf("%4x %2x: ", ftell(infile),count);
   endtok=0x0d;
   
   do
   {
      byte=fgetc(infile);
      
      if (byte == endtok)
      {
         msgcount++;
         bracket=0;
         lower=0;
      }
      else if (byte < 0x20 || byte > 0x5a)
      {
         if (byte < 0x0e) token = byte + 0xa5;
         else if (byte < 0x20) token = byte + 0xa4;
         else token = byte - 0x5b;
         /* look up in dictionary */
         if (lower==1)
         {
            sprintf(messages[msgcount],"%s%c",messages[msgcount],tokens[token][0]);
         }
         for (i=lower;i<strlen(tokens[token]);i++)
         {
            sprintf(messages[msgcount],"%s%c",messages[msgcount],tolower(tokens[token][i]));
         }
         lower=0;
      }
      else if (byte == 0x2e || byte == 0x3f || byte == 0x21 || byte == 0x2c ||
               byte == 0x3b || byte == 0x3a)
      {
         sprintf(messages[msgcount],"%s%c ",messages[msgcount],byte);
         if (byte == 0x2e || byte == 0x3f || byte == 0x21) lower=1;
      }
      else if (byte > 0x40 && byte < 0x5b)
      {
         if (lower == 1)
         {
            token=byte;
            lower=0;
         }
         else
         {
            token=tolower(byte);
         }
         sprintf(messages[msgcount],"%s%c",messages[msgcount],token);
      }
      else if (byte == 0x23)
      {
         lower=1;
      }
      else if (byte == 0x2b)
      {
         sprintf(messages[msgcount],"%s\\n",messages[msgcount]);
      }
      else
      {
         sprintf(messages[msgcount],"%s%c",messages[msgcount],byte);
      }
   } while (ftell(infile) < 0x5c57);

   printf("Enumerating rooms\n");
   fseek(infile,0x6354,SEEK_SET);
   
   do
   {
      byte = fgetc(infile);
      token = byte + 172;
      rooms[roomcount].description=token;
      roomcount++;
   } while (ftell(infile) < 0x6400);
   roomcount--;
  
   printf("Gathering exits\n");
   fseek(infile, 0x5c5c, SEEK_SET);
   i=0;
   do
   {
      unsigned char byte2;
      byte=fgetc(infile);
      byte2=fgetc(infile);
   
      if (byte & 0x80)
      {
         i++;
      }
      
      switch(byte & 0xf)
      {
         case 0:
         {
            rooms[i].north=(byte2 - 0x34);
            break;
         }   
         case 1:
         {
            rooms[i].south=(byte2 - 0x34);
            break;
         }   
         case 2:
         {
            rooms[i].east=(byte2 - 0x34);
            break;
         }   
         case 3:
         {
            rooms[i].west=(byte2 - 0x34);
            break;
         }   
         case 4:
         {
            rooms[i].northeast=(byte2 - 0x34);
            break;
         }   
         case 5:
         {
            rooms[i].northwest=(byte2 - 0x34);
            break;
         }   
         case 6:
         {
            rooms[i].southeast=(byte2 - 0x34);
            break;
         }   
         case 7:
         {
            rooms[i].southwest=(byte2 - 0x34);
            break;
         }   
         case 8:
         {
            rooms[i].up=(byte2 - 0x34);
            break;
         }   
         case 9:
         {
            rooms[i].down=(byte2 - 0x34);
            break;
         }
         default:
         {
            printf("Unknown exit type (%d) at %lx\n",byte & 0xf, ftell(infile)-2);
         }
      }
   } while (i < roomcount);
   printf("%lx\n",ftell(infile));
   
   // Display messages
   for (i=0; i<=msgcount; i++)
   {
      printf("Message %d: %s\n", i, messages[i]);
   }
   // Display rooms
   for (i=0; i<=roomcount; i++)
   {
      printf("\nRoom %d: %s\n", i, messages[rooms[i].description]);
      printf("Exits\n");
      if (rooms[i].north > 0) printf("N to room %d (%s)\n", rooms[i].north, messages[rooms[rooms[i].north].description]);
      if (rooms[i].south > 0) printf("S to room %d (%s)\n", rooms[i].south, messages[rooms[rooms[i].south].description]);
      if (rooms[i].east > 0) printf("E to room %d (%s)\n", rooms[i].east, messages[rooms[rooms[i].east].description]);
      if (rooms[i].west > 0) printf("W to room %d (%s)\n", rooms[i].west, messages[rooms[rooms[i].west].description]);
      if (rooms[i].northeast > 0) printf("NE to room %d (%s)\n", rooms[i].northeast, messages[rooms[rooms[i].northeast].description]);
      if (rooms[i].northwest > 0) printf("NW to room %d (%s)\n", rooms[i].northwest, messages[rooms[rooms[i].northwest].description]);
      if (rooms[i].southeast > 0) printf("SE to room %d (%s)\n", rooms[i].southeast, messages[rooms[rooms[i].southeast].description]);
      if (rooms[i].southwest > 0) printf("SW to room %d (%s)\n", rooms[i].southwest, messages[rooms[rooms[i].southwest].description]);
      if (rooms[i].up > 0) printf("U to room %d (%s)\n", rooms[i].up, messages[rooms[rooms[i].up].description]);
      if (rooms[i].down > 0) printf("D to room %d (%s)\n", rooms[i].down, messages[rooms[rooms[i].down].description]);
   }
   
         
   fclose(infile);
   return 0;
}
