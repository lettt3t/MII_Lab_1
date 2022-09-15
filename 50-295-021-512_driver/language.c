//---------------------------------------------------------------------------
#include <windows.h>
#pragma hdrstop
//---------------------------------------------------------------------------
char *def_locale[]=
{
#define PCIPR_OK 0
  "Фрегат",
#define PCIPR_UNKNOWN 1
  ": неизвестная ошибка",
#define PCIPR_INVALID_PARAMETERS 2
  ": неправильные параметры",
#define PCIPR_CANT_LOAD_DLL 3
  ": не могу загрузить Pilpxi.dll",
#define PCIPR_CANT_INIT_BOARD 4
  ": ошибка при инициализации устройства",
#define PCIPR_CANT_CLOSE_BOARD 5
  ": ошибка при закрытии устройства",
#define PCIPR_WRONG_CHAN 6
  ": неверный номер канала, допустимые значения : (0..4)",
#define PCIPR_WRONG_BOARD 7
  ": неверный номер устройства",
};
//---------------------------------------------------------------------------
void str_localize(DWORD key, char *dst_str, DWORD dst_len)
{
  static char lang_file_name[MAX_PATH];
  static BOOL lang_file_name_ready = FALSE;
  char   key_name[32];
  DWORD  i;

  if (!lang_file_name_ready)
  {
    i = GetModuleFileName(NULL, lang_file_name, sizeof(lang_file_name))-1;
    for(;i && lang_file_name[i]!='\\';i--);
    lstrcpy(lang_file_name+i+1, "fregat.lng");
  }
  wsprintf(key_name, "PCIPR_5_12_%08X", key);
  GetPrivateProfileString("Main", key_name, def_locale[key], dst_str, dst_len-1, lang_file_name);
  for(i=0;dst_str[i];i++)
    if (dst_str[i]=='¤') dst_str[i]='\n';
}
//---------------------------------------------------------------------------

