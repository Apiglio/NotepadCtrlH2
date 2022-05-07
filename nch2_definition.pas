unit nch2_definition;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, Apiglio_Useful, LazUtf8, RegExpr;

  procedure Func_NCH2_Generator(AufScpt:TAufScript);

implementation

uses NCH2_main;

  function strcmd_decode(str:string):string;
  var stmp:string;
  begin
    stmp:=str;
    stmp:=StringReplace(stmp,'\n',#10,[rfReplaceAll]);
    stmp:=StringReplace(stmp,'\r',#13,[rfReplaceAll]);
    stmp:=StringReplace(stmp,'\t',#9,[rfReplaceAll]);
    stmp:=StringReplace(stmp,'\e',#27,[rfReplaceAll]);
    result:=stmp;
  end;

  procedure Simply_Replace(src,dst:TStream;old_p,new_p:string);
  var old_len,new_len:integer;
      buffer:string;
  begin
    if old_p='' then exit;
    buffer:='';
    src.Position:=0;
    dst.Size:=0;
    dst.Position:=0;
    old_len:=length(old_p);
    new_len:=length(new_p);
    while src.Position<src.Size do
      begin
        buffer:=buffer+chr(src.ReadByte);
        if pos(buffer,old_p)<>1 then
          begin
            dst.Write(buffer[1],length(buffer));
            buffer:='';
          end
        else
          begin
            if buffer=old_p then
              begin
                dst.Write(new_p[1],new_len);
                buffer:='';
              end;
          end;
        if length(buffer)>old_len then
          begin
            //这种情况不应该出现
            dst.Write(buffer[1],length(buffer));
            buffer:='';
          end;
      end;
  end;


  procedure StreamReplace(src,dst:TStream;pre,post,old_mid,new_mid:string);
  begin
    dst.Size:=0;

  end;

  procedure StreamReplace_CA(src,dst:TStream;old_p,new_p:string);
  var loop:array[0..255]of char;
      loop_ptr:integer;
    function loop_string(ptr,len:byte):string;
    var seg_1,seg_2:string;
    begin

    end;

  begin
    dst.Size:=0;
    for loop_ptr:=0 to 255 do loop[loop_ptr]:=#0;
    loop_ptr:=0;

  end;



  {
  procedure func_*(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;

  end;
  }

  procedure memo_update;
  begin
    if not updating then begin
      Form_Main.Memo_File.Clear;
      mem.Position:=0;
      Form_Main.Memo_File.Lines.LoadFromStream(mem);
      Form_Main.Memo_File.Repaint;
    end;
  end;

  procedure func_load(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
      filename:string;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    if not AAuf.CheckArgs(2) then exit;
    if not AAuf.TryArgToString(1,filename) then exit;
    try
      //Form_Main.Memo_File.Lines.LoadFromFile(filename);
      mem.LoadFromFile(filename);
    except
      AufScpt.send_error('文件“'+filename+'”导入失败。');
      exit;
    end;
    AufScpt.writeln('文件“'+filename+'”成功导入。');
    memo_update;
  end;
  procedure func_save(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
      filename:string;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    if not AAuf.CheckArgs(2) then exit;
    if not AAuf.TryArgToString(1,filename) then exit;
    try
      //Form_Main.Memo_File.Lines.SaveToFile(filename);
      mem.SaveToFile(filename);
    except
      AufScpt.send_error('文件“'+filename+'”导出失败。');
      exit;
    end;
    AufScpt.writeln('文件“'+filename+'”成功导出。');
  end;
  procedure func_beginupdate(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    //Form_Main.Memo_File.Visible:=false;
    updating:=true;
  end;
  procedure func_endupdate(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    //Form_Main.Memo_File.Visible:=true;
    updating:=false;
  end;
  procedure func_wincp2utf8(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
      pi:longint;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    //for pi:=0 to Form_Main.Memo_File.Lines.Count-1 do
    //  Form_Main.Memo_File.Lines[pi]:=WinCPToUTF8(Form_Main.Memo_File.Lines[pi]);
  end;
  procedure func_utf82wincp(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
      pi:longint;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    //for pi:=0 to Form_Main.Memo_File.Lines.Count-1 do
    //  Form_Main.Memo_File.Lines[pi]:=UTF8ToWinCP(Form_Main.Memo_File.Lines[pi]);
  end;


  procedure func_xor(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
      btmp:byte;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    mem.Position:=0;
    while mem.Position<mem.Size do
      begin
        btmp:=mem.ReadByte;
        mem.Seek(-1,soFromCurrent);
        btmp:=btmp xor $ff;
        mem.WriteByte(btmp);
      end;
    //for pi:=0 to Form_Main.Memo_File.Lines.Count-1 do
    //  Form_Main.Memo_File.Lines[pi]:=UTF8ToWinCP(Form_Main.Memo_File.Lines[pi]);
    memo_update;
  end;
  procedure func_replace_mono(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
      tar,rep,btmp:byte;
      tars,reps:string;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    if not AAuf.CheckArgs(3) then exit;

    if not AAuf.TryArgToString(1,tars) then exit;
    if length(tars)<>1 then begin
      AufScpt.send_error('第1个参数不为char类型，代码未执行。');
    end;
    if not AAuf.TryArgToString(2,reps) then exit;
    if length(reps)<>1 then begin
      AufScpt.send_error('第2个参数不为char类型，代码未执行。');
    end;

    tar:=ord(tars[1]);
    rep:=ord(reps[1]);
    //AufScpt.writeln(IntToStr(tar)+'-'+IntToStr(rep));

    mem.Position:=0;
    while mem.Position<mem.Size do
      begin
        btmp:=mem.ReadByte;
        mem.Seek(-1,soFromCurrent);
        if btmp=tar then btmp:=rep;
        mem.WriteByte(btmp);
      end;
    //for pi:=0 to Form_Main.Memo_File.Lines.Count-1 do
    //  Form_Main.Memo_File.Lines[pi]:=UTF8ToWinCP(Form_Main.Memo_File.Lines[pi]);
    memo_update;
  end;
  procedure func_replace_normal(Sender:TObject);
  var AufScpt:TAufScript;
      AAuf:TAuf;
      tar,rep,btmp:byte;
      tars,reps:string;
  begin
    AufScpt:=Sender as TAufScript;
    AAuf:=AufScpt.Auf as TAuf;
    if not AAuf.CheckArgs(3) then exit;

    if not AAuf.TryArgToString(1,tars) then exit;
    if not AAuf.TryArgToString(2,reps) then exit;

    tars:=strcmd_decode(tars);
    reps:=strcmd_decode(reps);


    Simply_Replace(mem,cvt,tars,reps);
    mem.LoadFromStream(cvt);
    memo_update;
  end;








  procedure Func_NCH2_Generator(AufScpt:TAufScript);
  begin
    AufScpt.add_func('nch.load',@func_load,'filename','导入文件到内存流中。');
    AufScpt.add_func('nch.save',@func_save,'filename','导出内存流到文件中。');
    AufScpt.add_func('nch.beginupdate',@func_beginupdate,'','禁用内存流变化实时呈现。');
    AufScpt.add_func('nch.endupdate',@func_endupdate,'','启用内存流变化实时呈现。');
    //AufScpt.add_func('nch.wincp2utf8',@func_wincp2utf8,'','内存流WinCP转UTF8。');
    //AufScpt.add_func('nch.utf82wincp',@func_utf82wincp,'','内存流UTF8转WinCP。');

    AufScpt.add_func('nch.xor',@func_xor,'','对内存流进行异或操作。');
    AufScpt.add_func('nch.mono,mono_replace',@func_replace_mono,'','替换单个字符');
    AufScpt.add_func('nch.norm,normal_replace',@func_replace_normal,'','替换字符串');


  end;

end.

