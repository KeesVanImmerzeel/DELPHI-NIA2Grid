unit uNIA2Grid;

interface

uses
  System.Win.Registry, Windows, Forms, SysUtils, StdCtrls, Controls, Classes{, uProgramSettingsNIA2Grid},
  Vcl.Dialogs, Vcl.ExtCtrls, uError, sfexec, uTabstractESRIgrid,
  uTSingleESRIgrid, SpinFloat, ShpAPI129, Vcl.Imaging.jpeg,
  uNIA2GridshowHelp, AVgridIO, uTriwacoGrid;

type
  TMainForm = class(TForm)
    LabeledEditTriwacoGridFileName: TLabeledEdit;
    OpenDialog1TriwacoGridFile: TOpenDialog;
    GoButton: TButton;
    sfAppExec1: TsfAppExec;
    SingleESRIgridNIA: TSingleESRIgrid;
    SpinFloatEditResolution: TSpinFloatEdit;
    Label1: TLabel;
    ButtonShowHelp: TButton;
    triwacoGrid1: TtriwacoGrid;
    procedure FormCreate(Sender: TObject);
    procedure LabeledEditTriwacoGridFileNameClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure ButtonShowHelpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  QGISbatName, Grid2ShapeExe: TFileName;

implementation
{$R *.DFM}

procedure TMainForm.ButtonShowHelpClick(Sender: TObject);
begin
  FormShowHelp1.ShowModal;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitialiseLogFile;
  Caption :=  ChangeFileExt( ExtractFileName( Application.ExeName ), '' );
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
FinaliseLogFile;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
var
  HlpBatFileName, {ResolutionStr,}DirStr{, ResultESRIGridName}: String;
  CmdList: TStringList;
  NonEmptyLineDeleted, Initiated: Boolean;
  i, iResult: integer;

  Function ConvertShapeToESRIIgrid( DirStr, InputShapeName,
    OutputESRIIgridName: TfileName; Resolution: Double ): Boolean;
  var
    ResolutionStr, ResultESRIGridName: String;
  begin
    Result := False;
    Try try
      // 1. Create 'hlp.bat' file.
      HlpBatFileName := ExtractFilePath( QGISbatName ) + '\hlp.bat';
      if not FileExists( QGISbatName ) then
        raise Exception.CreateFMT('QGIS batch file [%s] does not exist.', [QGISbatName] );
      // Delete last line in batch file (=call to QGIS desktop)
      CmdList := tstringList.Create;
      CmdList.LoadFromFile( QGISbatName );
      NonEmptyLineDeleted := false;
      i := CmdList.Count-1;
      while ( i > -1 ) and (not NonEmptyLineDeleted ) do begin
        if Trim( CmdList[ i ] ) <> '' then
          NonEmptyLineDeleted := true;
        CmdList.Delete( i );
        i := i-1;
      end;
      ResolutionStr := FloatToStr( Resolution );
      CmdList.Add( 'gdal_rasterize -a ID -tr ' + ResolutionStr + ' ' +
                    ResolutionStr + ' -l ' + InputShapeName + ' ' + DirStr +
                    InputShapeName + '.shp ' + DirStr + 'result.tif' );
      CmdList.Add( 'gdal_translate -a_nodata 0 -of AAIGrid ' + DirStr + 'result.tif ' +
                    DirStr + 'result.asc' );
      CmdList.SaveToFile( HlpBatFileName  );

      // 2. Run 'hlp.bat' to --> 'result.tiff' --> 'result.asc'
      DeleteFile( 'result.tiff' ); DeleteFile( 'result.asc' );
      with sfAppExec1 do begin
        ApplicationName := HlpBatFileName;
        Parameters := '';
        Wait := true;
        Execute;
        if ResultCode <> -1 then
          Raise Exception.CreateFmt( 'Error running [%s] ', [HlpBatFileName]);
        // sfAppExec1.ExitCode  werkt niet?
      end;

      // Convert 'result.asc' to Arc/View binary grid 'ClsNdsf'
      SingleESRIgridNIA := TSingleESRIgrid.CreateFromASCfile( DirStr + 'result.asc', iResult, self );
      if iResult <> cNoError then
        raise Exception.Create('Cannot initialise SingleESRIgridNIA');
      ResultESRIGridName := DirStr + OutputESRIIgridName;
      if SingleESRIgridNIA.SaveAs( ResultESRIGridName) <> cNoError then
        raise Exception.Create('Cannot write ResultESRIGrid');
      ShowMessageFmt( 'Arc/Info binary grid created:' + #13#13 +
                          '[%s]' + #13#13 +
                          'Type: floating point. Resolution: %f (m).',
                          [ResultESRIGridName, SingleESRIgridNIA.CellSize] );

      Result := True;
    Except
      On E: Exception do begin
        HandleError( E.Message, true );
      end;
    end;
    finally
    end;
  end;

begin
  Try
    // NIA2Grid veronderstelt dat:
    // 1. QGIS is geinstalleerd
    // 2. in de folder met NIA2Grid.exe het bestand 'NIA2Grid.ini' staat met
    //    verwijzingen naar de bestanden 'qgis.bat' en 'Grid2SHP.exe' (zie
    //    voorbeeld hieronder.
    // [PathNames]
    // QgisBat=D:\Program Files\QGIS Lyon\bin\qgis.bat
    // Grid2ShapeExe=C:\ESRI\AV_GIS30\ARCVIEW\BIN32\Grid2SHP.exe

    // Convert Triwaco grid (*.teo) to Arc/Info shape with Grid2Shape.exe -->
    // 'influencearea.shp' in the same folder as the Triwaco grid file.
    // Delete existing 'influencearea.shp' and Check grid.teo
    DeleteShape( DirStr + 'influencearea' );
    LabeledEditTriwacoGridFileName.Text := ExpandFileName( LabeledEditTriwacoGridFileName.Text );
    TriwacoGrid1 := TTriwacoGrid.InitFromTextFile( LabeledEditTriwacoGridFileName.Text, self, Initiated );
    if not Initiated then
      Raise Exception.CreateFMT( 'Cannot initiate Triwaco grid [%s].', [LabeledEditTriwacoGridFileName.Text] );
    TriwacoGrid1.Free;
    DirStr := ExtractFilePath( LabeledEditTriwacoGridFileName.Text );
    WriteToLogFileFmt( 'Directory of Triwaco Grid = [%s]', [DirStr] );
    Try
      with sfAppExec1 do begin
        ApplicationName := Grid2ShapeExe;
        Parameters := LabeledEditTriwacoGridFileName.Text;
        Wait := true;
        Execute;
        if ResultCode <> -1 then
          Exception.CreateFmt( 'Error running [%s] ', [Grid2ShapeExe]);
        // sfAppExec1.ExitCode  werkt niet?
      end;
    // Check if shape 'influencearea.shp' is created.
    if not FileExists( DirStr + 'influencearea.shp' ) then
      raise Exception.CreateFMT( 'Error: shape [%s] not created.', [DirStr + 'influencearea'] );

    if not ConvertShapeToESRIIgrid( DirStr, 'influencearea', 'ClsNdsf',
        SpinFloatEditResolution.Value ) then
      raise Exception.Create('NIA2Grid not succesfull.');
    if not ConvertShapeToESRIIgrid( DirStr, 'elems', 'ClsElmsf',
        SpinFloatEditResolution.Value ) then
      raise Exception.Create('NIA2Grid not succesfull.');

    Except
      On E: Exception do begin
        HandleError( E.Message, true );
      end;
    End;
  Finally
   if not DeleteFile( HlpBatFileName ) then;
   if not DeleteFile( DirStr + 'result.tif' ) then;
   // if not DeleteFile( DirStr + 'result.asc' ) then;
   if not DeleteFile( DirStr + 'result.asc.aux.xml' ) then;
   // DeleteShape( DirStr + 'influencearea' );
   // DeleteShape( DirStr + 'elems' );
   DeleteShape( DirStr + 'nodes' );
  End;
end;

procedure TMainForm.LabeledEditTriwacoGridFileNameClick(Sender: TObject);
begin
  with OpenDialog1TriwacoGridFile do begin
    if Execute then begin
      LabeledEditTriwacoGridFileName.Text := ExpandFileName( FileName );
    end;
  end;
end;

begin
  InitialiseGridIO;
end.
