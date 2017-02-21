unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,math,PSAPI, TlHelp32, ComCtrls,CommCtrl, Grids;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ProgressBar1: TProgressBar;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


function GetModuleBase(const hProc: Cardinal; const sModuleName: string): DWORD;
var
  pModules, pTmp: PDWORD;
  szBuf: array[0..MAX_PATH] of Char;
  cModules: DWORD;
  i, aLen, CharsCount: integer;
begin
  Result := INVALID_HANDLE_VALUE;
  pModules := nil;
  if EnumProcessModules(hProc, pModules, 0, cModules) then
   begin
    GetMem(pModules, cModules);
    try
     pTmp := pModules;
     aLen := Length(sModuleName);
     if EnumProcessModules(hProc, pModules, cModules, cModules) then
      for i := 1 to (cModules div SizeOf(DWORD)) do
       begin
        CharsCount := GetModuleBaseName(hProc, pTmp^, szBuf, SizeOf(szBuf));
        if CharsCount = aLen then
         if CompareText(sModuleName, szBuf) = 0 then
          begin
           Result := pTmp^;
           Break;
          end;
        inc(pTmp);
       end;
     finally
      FreeMem(pModules);
     end;
   end;
end;





procedure TForm2.Button1Click(Sender: TObject);
var
wpid,count : Cardinal;
HP,MP,DP,SU1,SU2,Ex1,Ex2,LV,FLY,NM,p1,pTar1,TR,tar,p3,p4,p7,p8,p9,i: Cardinal;
S,exp1,exp2:integer;
buff: DWORD; addr2,p2,addrTar2,pTar2:DWord;
 bf,tar1:byte; name:String; targ:String;
WindowName,ThreadId,ProcessId,len,flying,targetet,c: integer;
s1,s2,e1,e2,Fl,Ta:string;
addr0,addr1:Cardinal;

begin

 WindowName:=FindWindow(nil,'AION Client');
  ThreadId := GetWindowThreadProcessId(WindowName,@ProcessId);
  wpid:= OpenProcess(PROCESS_ALL_ACCESS,False,ProcessId);
  addr0 := GetModuleBase(wpid, 'game.dll');

 addr1 := Cardinal(DWord(addr0));

        HP:=addr1+$A329B0;
        ReadProcessMemory(wpid,Pointer(HP),@buff,sizeof(buff), count);
        Label1.Caption:=Label1.Caption + Format('%.4d', [buff]);

        MP:=addr1+$A329B8;
        ReadProcessMemory(wpid,Pointer(MP),@buff,sizeof(buff), count);
        Label2.Caption:=Label2.Caption + Format('%.4d', [buff]);

        DP:=addr1+$A329BE;
        ReadProcessMemory(wpid,Pointer(DP),@buff,2, count);
        Label4.Caption:=Label4.Caption + Format('%.4d', [buff]);

        SU1:=addr1+$A329F4;
        ReadProcessMemory(wpid,Pointer(SU1),@buff,4, count);
        s1:=Format('%.2d', [buff]);
        SU2:=addr1+$A329F0;
        ReadProcessMemory(wpid,Pointer(SU2),@buff,4, count);
        s2:=Format('%.2d', [buff]); s:=(strtoint(s2))-(strtoint(s1));
        Label5.Caption:=Label5.Caption + IntToStr(s) + 'е сумки можно купить';


        Ex2:=addr1+$A32990;
        ReadProcessMemory(wpid,Pointer(Ex2),@buff,4, count);
        e2:=Format('%.8d', [buff]);  exp2:=(strtoint(e2));
        Ex1:=addr1+$A329A0;
        ReadProcessMemory(wpid,Pointer(Ex1),@buff,4, count);
        e1:=Format('%.8d', [buff]);  exp1:=(strtoint(e1));
        SendMessage(ProgressBar1.Handle, PBM_SETBARCOLOR, 0, clRed);
        ProgressBar1.Max:=exp2;  ProgressBar1.Max:=exp2;
        ProgressBar1.Position:=exp1;

        LV:=addr1+$A32988;
        ReadProcessMemory(wpid,Pointer(Lv),@bf,1, count);
        Label6.Caption:=Format('%.2d', [bf]);

        FLY:=addr1+$A329C8;
        ReadProcessMemory(wpid,Pointer(FLY),@bf,1, count);
        Fl:=Format('%.1d', [bf]); flying:=StrToInt(Fl);
        if flying = 1 then
         Label3.Caption:='Летаем..'
         else
         Label3.Caption:='Бегаем..';


         SetLength(name, 20);
        NM:=addr1+$A699A8;
        ReadProcessMemory(wpid,Pointer(NM),Pointer(name),20, count);
        Label7.Caption:=Label7.Caption + name;


       SetLength(targ, 10);
       TR := addr1+$639BBC;
       ReadProcessMemory(wpid, Pointer(TR), @addr2, 4, count);
       p1:=addr2+$1C4;
       ReadProcessMemory(wpid, Pointer(p1), @p2, 4, count);
       p2:=p2+$36;
       ReadProcessMemory(wpid, Pointer(p2), Pointer(targ),15, count);
       Label8.Caption:=Label8.Caption + targ;



       tar := addr1+$639BBC;
       ReadProcessMemory(wpid, Pointer(tar), @addrTar2, 4, count);
       pTar1:=addrTar2+$1C4;
       ReadProcessMemory(wpid, Pointer(pTar1), @pTar2, 4, count);
       pTar2:=pTar2+$32;
       ReadProcessMemory(wpid, Pointer(pTar2), Pointer(tar1),2, count);
       Ta:=Format('%.2d', [tar1]);
       Label9.Caption:=Ta;
       {targetet:=StrToInt(Fl);
       if targetet = 1 then
         Label9.Caption:='Цель взята'
         else
         Label9.Caption:='Возьми цель';
                                        }

 CloseHandle(wpid);
end;

end.

