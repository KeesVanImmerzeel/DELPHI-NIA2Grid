unit uNIA2GridshowHelp2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls, uNIA2GridshowHelp3,
  Vcl.StdCtrls;

type
  TFormShowHelp2 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormShowHelp2: TFormShowHelp2;

implementation

{$R *.dfm}

procedure TFormShowHelp2.Button1Click(Sender: TObject);
begin
 FormShowHelp3.ShowModal;
end;

procedure TFormShowHelp2.FormCreate(Sender: TObject);
begin
  Caption :=  ChangeFileExt( ExtractFileName( Application.ExeName ), '' );
end;

end.
