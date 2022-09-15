(*
   HTML Help unit
   Coded by SVC 2004
*)

unit HtmlHelper;

interface

uses Windows, Sysutils;

const
  HELP_NAME  = 'FREGAT.CHM';

const
  HH_DISPLAY_TOPIC        = $0000;
  HH_HELP_FINDER          = $0000;  // WinHelp equivalent
  HH_DISPLAY_TOC          = $0001;
  HH_DISPLAY_INDEX        = $0002;
  HH_DISPLAY_SEARCH       = $0003;
  HH_SET_WIN_TYPE         = $0004;
  HH_GET_WIN_TYPE         = $0005;
  HH_GET_WIN_HANDLE       = $0006;
  HH_ENUM_INFO_TYPE       = $0007;  // Get Info type name, call repeatedly to enumerate, -1 at end
  HH_SET_INFO_TYPE        = $0008;  // Add Info type to filter.
  HH_SYNC                 = $0009;
  HH_RESERVED1            = $000A;
  HH_RESERVED2            = $000B;
  HH_RESERVED3            = $000C;
  HH_KEYWORD_LOOKUP       = $000D;
  HH_DISPLAY_TEXT_POPUP   = $000E;  // display string resource id or text in a popup window
  HH_HELP_CONTEXT         = $000F;  // display mapped numeric value in dwData
  HH_TP_HELP_CONTEXTMENU  = $0010;  // text popup help, same as WinHelp HELP_CONTEXTMENU
  HH_TP_HELP_WM_HELP      = $0011;  // text popup help, same as WinHelp HELP_WM_HELP
  HH_CLOSE_ALL            = $0012;  // close all windows opened directly or indirectly by the caller
  HH_ALINK_LOOKUP         = $0013;  // ALink version of HH_KEYWORD_LOOKUP
  HH_GET_LAST_ERROR       = $0014;  // not currently implemented // See HHERROR.h
  HH_ENUM_CATEGORY        = $0015;	// Get category name, call repeatedly to enumerate, -1 at end
  HH_ENUM_CATEGORY_IT     = $0016;  // Get category info type members, call repeatedly to enumerate, -1 at end
  HH_RESET_IT_FILTER      = $0017;  // Clear the info type filter of all info types.
  HH_SET_INCLUSIVE_FILTER = $0018;  // set inclusive filtering method for untyped topics to be included in display
  HH_SET_EXCLUSIVE_FILTER = $0019;  // set exclusive filtering method for untyped topics to be excluded from display
  HH_INITIALIZE           = $001C;  // Initializes the help system.
  HH_UNINITIALIZE         = $001D;  // Uninitializes the help system.
  HH_PRETRANSLATEMESSAGE  = $00fd;  // Pumps messages. (NULL, NULL, MSG*).
  HH_SET_GLOBAL_PROPERTY  = $00fc;  // Set a global property. (NULL, NULL, HH_GPROP)

type
  tagHH_AKLINK = record
  cbStruct    : integer;  // sizeof this structure
  fReserved   : boolean;  // must be FALSE (really!)
  pszKeywords : LPCSTR;   // semi-colon separated keywords
  pszUrl      : LPCSTR;   // URL to jump to if no keywords found (may be NULL)
  pszMsgText  : LPCSTR;   // Message text to display in MessageBox if pszUrl is NULL and no keyword match
  pszMsgTitle : LPCSTR;   // Message text to display in MessageBox if pszUrl is NULL and no keyword match
  pszWindow   : LPCSTR;   // Window to display URL in
  fIndexOnFail: boolean;  // Displays index if keyword lookup fails.
end;

function HtmlHelp(hwndCaller: THandle;
                  pszFile   : LPCSTR;
                  uCommand  : UINT;
                  dwData    : PDWORD): THandle; stdcall; external 'hhctrl.ocx' name 'HtmlHelpA';

{
 public procedure - ShowHtmlHelpByKeyWord
 arguments: string containing the keyword to open in *.chm file
 if no such keywords founded - first page shows
}
procedure ShowHtmlHelpByKeyWord(KeyWord: string);

implementation

procedure ShowHtmlHelpByKeyWord(KeyWord: string);
var
  link: tagHH_AKLINK;
  NullStr: array[0..255] of AnsiChar;
  kaal: string;
begin
  ZeroMemory(@NullStr,255);
  ZeroMemory(@link,SizeOf(tagHH_AKLINK));
  link.cbStruct:= SizeOf(tagHH_AKLINK);
  link.fReserved   := false;
  StrPcopy(@NullStr,KeyWord);
  link.pszKeywords := NullStr;
  link.pszUrl      := nil;
  link.pszMsgText  := nil;
  link.pszMsgTitle := nil;
  link.pszWindow   := nil;
  link.fIndexOnFail:= true;
  HtmlHelp(0,HELP_NAME,HH_KEYWORD_LOOKUP,@link);
end;

end.
