unit uNIA2GridshowHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, uNIA2GridshowHelp2;

type
  TFormShowHelp1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormShowHelp1: TFormShowHelp1;

implementation

{$R *.dfm}

procedure TFormShowHelp1.Button1Click(Sender: TObject);
begin
  FormShowHelp2.ShowModal;
end;

procedure TFormShowHelp1.FormCreate(Sender: TObject);
begin
  Caption :=  ChangeFileExt( ExtractFileName( Application.ExeName ), '' );
end;

end.
