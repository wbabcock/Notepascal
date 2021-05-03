unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ActnList, StdActns, LCLType, PrintersDlgs, Printers, Types;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actFileNew: TAction;
    actFormatWordWrap: TAction;
    actFilePrint: TAction;
    actSave: TAction;
    actionList: TActionList;
    actFileOpen: TFileOpen;
    actFileSaveAs: TFileSaveAs;
    actEditCut: TEditCut;
    actEditCopy: TEditCopy;
    actEditDelete: TEditDelete;
    actEditPaste: TEditPaste;
    actEditSelectAll: TEditSelectAll;
    actFileExit: TFileExit;
    actFontEdit: TFontEdit;
    mainMenu: TMainMenu;
    mnuFilePageSetup: TMenuItem;
    mnuFilePrint: TMenuItem;
    N3: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuFormatWordWrap: TMenuItem;
    mnuFormatFontEdit: TMenuItem;
    mnuFileSave: TMenuItem;
    mnuHelp: TMenuItem;
    mnuFormat: TMenuItem;
    mnuEditDelete: TMenuItem;
    mnuEditSelectAll: TMenuItem;
    N2: TMenuItem;
    mnuEditPaste: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditCut: TMenuItem;
    mnuEdit: TMenuItem;
    mnuFileExt: TMenuItem;
    N1: TMenuItem;
    mnuFileSaveAs: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileNew: TMenuItem;
    mnuFile: TMenuItem;
    mDocument: TMemo;
    dlgPrint: TPrintDialog;
    dlgPageSetup: TPageSetupDialog;
    procedure actFileNewExecute(Sender: TObject);
    procedure actFileOpenAccept(Sender: TObject);
    procedure actFilePrintExecute(Sender: TObject);
    procedure actFileSaveAsAccept(Sender: TObject);
    procedure actFontEditAccept(Sender: TObject);
    procedure actFontEditBeforeExecute(Sender: TObject);
    procedure actFormatWordWrapExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure mDocumentChange(Sender: TObject);
    procedure mnuFilePageSetupClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
  private
    boolUnsavedChanges: Boolean;
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses About;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.actFileSaveAsAccept(Sender: TObject);
begin
  mDocument.Lines.SaveToFile(actFileSaveAs.Dialog.FileName);
  boolUnsavedChanges := False;
end;

procedure TfrmMain.actFontEditAccept(Sender: TObject);
begin
  mDocument.Font := actFontEdit.Dialog.Font;
end;

procedure TfrmMain.actFontEditBeforeExecute(Sender: TObject);
begin
  actFontEdit.Dialog.Font := mDocument.Font;
end;

procedure TfrmMain.actFormatWordWrapExecute(Sender: TObject);
begin
  if mDocument.WordWrap then
  begin
    mDocument.WordWrap := False;
    actFormatWordWrap.Checked := False;
  end
  else
  begin
    mDocument.WordWrap := True;
    actFormatWordWrap.Checked := True;
  end;
end;

procedure TfrmMain.actFileOpenAccept(Sender: TObject);
begin
  mDocument.Lines.LoadFromFile(actFileOpen.Dialog.FileName);
end;

procedure TfrmMain.actFilePrintExecute(Sender: TObject);
var
  I, Line: integer;
begin
  if dlgPrint.Execute then
  begin
    I := 0;
    Line := 0;
    Printer.BeginDoc;
    Printer.Canvas.Font := mDocument.Font;
    try
      for I := 0 to mDocument.Lines.Count-1 do
      begin
        Printer.Canvas.TextOut(dlgPageSetup.MarginLeft, dlgPageSetup.MarginTop + Line, mDocument.Lines[I]);
        Line := Line + ((mDocument.Font.Size) * 13);
        if (dlgPageSetup.MarginTop + dlgPageSetup.MarginBottom + Line >= Printer.PageHeight) then
           Printer.NewPage;
      end;
    finally
      Printer.EndDoc;
    end;
  end;
end;

procedure TfrmMain.actFileNewExecute(Sender: TObject);
var
  intAnswer: Integer;
begin
  if boolUnsavedChanges then
  begin
    intAnswer := Application.MessageBox('Would you like to save your changes?', 'Unsaved Changes', MB_ICONQUESTION + MB_YESNOCANCEL);

    if intAnswer = mrYes then
    begin
       actFileSaveAs.Execute;
       if actFileSaveAs.Dialog.FileName <> '' then
       begin
         mDocument.Lines.Clear;
         boolUnsavedChanges := False;
       end;
    end
    else if intAnswer = mrNo then
    begin
      mDocument.Lines.Clear;
      boolUnsavedChanges := False;
    end;
  end;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
begin
  if not FileExists(actFileSaveAs.Dialog.FileName) then
    actFileSaveAs.Execute
  else
  begin
    mDocument.Lines.SaveToFile(actFileSaveAs.Dialog.FileName);
    boolUnsavedChanges := False;
  end;
end;

procedure TfrmMain.mDocumentChange(Sender: TObject);
begin
  if boolUnsavedChanges = False then
     boolUnsavedChanges := True;
end;

procedure TfrmMain.mnuFilePageSetupClick(Sender: TObject);
begin
  dlgPageSetup.Execute;
end;

procedure TfrmMain.mnuHelpAboutClick(Sender: TObject);
begin
  frmAbout.Show
end;

end.

