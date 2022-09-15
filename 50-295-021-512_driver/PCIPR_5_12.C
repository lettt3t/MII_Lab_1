// created by Doronkin.A.N
// 28.04.22 Revision: 6040
//------------------------------------------------------------------------------
#pragma option -a4
#pragma option -w-pch
#pragma option -w-pck
//------------------------------------------------------------------------------
#include <windows.h>
#include <math.h>
#include <stdio.h>

#include "language.c"
#include "Pilpxi.h"
#define max_channel 4
#define min_channel 0
#define max_board 16
#define min_board 0
//------------------------------------------------------------------------------
typedef struct
{
    DWORD   hModule;
    CHAR*   link_name;
    void*   init_proc;
    void*   serv_proc;
} PLUGIN_CLASS;

PLUGIN_CLASS pClass;

#define  DEVICE_NAME           "PCIPR_5_12"

HMODULE hDll;

int IsActive[16];
unsigned long cardNum[16];

//------------------------------------------------------------------------------
char* StrHeapCopy(char * str, int len)
{
  int size = strlen(str)+1;
  char * adr;
  if (len)
    {
      adr = (char*)HeapAlloc(GetProcessHeap(),0,size+4);
      *(int*)adr=size;
      strcpy(adr+4, str);
    }
  else
    {
      adr = (char*)HeapAlloc(GetProcessHeap(),0,size);
      strcpy(adr, str);
    }
    return adr;
}
//------------------------------------------------------------------------------
void GetParam(char* dst,char* str,int index)
{
  int i;
  char * p;
  if (index==0) return;

  if (--index==0) p=str;
  else
  {
      for (i=0; *str; ++str)
      {
          if (*str=='|')
          {
              if (++i==index) {p=++str;  break;}
          }
          if (*str=='-' && str[-1]!='|')
          {
              if (++i==index) {p=++str; break;}
          }
      }
  }
  for (str++; *str && *str!='|' && *str!='-'; ++str);
  memcpy(dst,p,str-p);
  dst[str-p]=0;
}

//------------------------------------------------------------------------------
void * _stdcall init_proc()
{
    const char *ini=".\\hard.ini";
    int bus,slot,board,i;
    char sec[16], key[16],dest[255],lized[255];

    unsigned long data[1];

    for (board=min_board; board<max_board; ++board)
    {
        IsActive[board]=FALSE;
        wsprintf(sec,"PCIPR_5_12-%d",board+1);
        if (GetPrivateProfileInt(sec,"Base",0,ini)==0) continue;

        if (!hDll)
        {
          dest[0]=0;
          strcat(dest,DEVICE_NAME);
          str_localize(PCIPR_CANT_LOAD_DLL,lized,sizeof(lized));
          strcat(dest,lized);
          return StrHeapCopy(dest, FALSE);
        }
        bus=(int)GetPrivateProfileInt(sec,"Bus",0,ini);
        slot=(int)GetPrivateProfileInt(sec,"Slot",0,ini);
        if (PIL_OpenSpecifiedCard (bus, slot, &cardNum[board])!=0)
        {
          dest[0]=0;
          strcat(dest,DEVICE_NAME);
          str_localize(PCIPR_CANT_INIT_BOARD,lized,sizeof(lized));
          strcat(dest,lized);
          return StrHeapCopy(dest, FALSE);
        }
        IsActive[board]=TRUE;
    }
    return NULL;
}

//---------------------------------------------------------------------------
void * _stdcall serv_proc(CHAR* inbuff, DWORD insize)
{
    const char *ini=".\\hard.ini";
    char sec[16], key[16],dest[255],lized[255];
    char buf[256];
    int board, bus,slot;
    unsigned long data[1],port,tmp;
    GetParam(buf,inbuff+4,2);
    board=atof(buf);
    if ((board<1) || (board>16))
    {
      dest[0]=0;
      strcat(dest,"e");
      strcat(dest,DEVICE_NAME);
      str_localize(PCIPR_WRONG_BOARD,lized,sizeof(lized));
      strcat(dest,lized);
      return StrHeapCopy(dest, TRUE);
    }    
    board=board-1;
    if (!IsActive[board])
    {
      dest[0]=0;
      strcat(dest,"e");
      strcat(dest,DEVICE_NAME);
      str_localize(PCIPR_WRONG_BOARD,lized,sizeof(lized));
      strcat(dest,lized);
      return StrHeapCopy(dest, TRUE);
    }

    GetParam(buf,inbuff+4,3);
    port=atof(buf);
    if ((port<min_channel) || (port>max_channel))
    {
      dest[0]=0;
      strcat(dest,"e");
      strcat(dest,DEVICE_NAME);
      str_localize(PCIPR_WRONG_CHAN,lized,sizeof(lized));
      strcat(dest,lized);
      return StrHeapCopy(dest, TRUE);
    }

   port=port+1; 
   GetParam(buf,inbuff+4,4);
   tmp=atof(buf);
   if ((tmp<1) || (tmp>4000))
   {
      dest[0]=0;
      strcat(dest,"e");
      strcat(dest,DEVICE_NAME);
      str_localize(PCIPR_INVALID_PARAMETERS,lized,sizeof(lized));
      strcat(dest,lized);
      return StrHeapCopy(dest, TRUE);
   }
   //сброс стд.значения
   data[0]= 4095-(tmp-1);
   PIL_WriteSub(cardNum[board],port,data);

   return NULL;
}
//---------------------------------------------------------------------------
void * _export WINAPI GetPluginClassPtr()
{
    pClass.link_name = "PCIPR_5_12";
    pClass.init_proc = init_proc;
    pClass.serv_proc = serv_proc;
    return &pClass;
}
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void* lpReserved)
{
    if (reason==DLL_PROCESS_ATTACH) hDll=LoadPCIPR("Pilpxi.dll");
    if (reason==DLL_PROCESS_DETACH) FreeLibrary(hDll);
    return 1;
}
//---------------------------------------------------------------------------

