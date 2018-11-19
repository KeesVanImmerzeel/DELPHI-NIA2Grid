program NIA2Grid;

uses
  Forms,
  Sysutils,
  Dialogs,
  IniFiles,
  uNIA2Grid in 'uNIA2Grid.pas' {MainForm},
  System.UITypes,
  OPWstring,
  uTTrishellDataSet,
  uError,
  AVGRIDIO,
  uNIA2GridshowHelp in 'uNIA2GridshowHelp.pas' {FormShowHelp1},
  uNIA2GridshowHelp2 in 'uNIA2GridshowHelp2.pas' {FormShowHelp2},
  uNIA2GridshowHelp3 in 'uNIA2GridshowHelp3.pas' {FormShowHelp3};

var
  FileExt, S, ParamStr1: String;
  Myfini: TiniFile;
  i: integer;
  DefaultResolution, aResolution: Double;

{$R *.RES}

begin
  Application.Initialize;

  InitialiseGridIO;

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormShowHelp1, FormShowHelp1);
  Application.CreateForm(TFormShowHelp2, FormShowHelp2);
  Application.CreateForm(TFormShowHelp3, FormShowHelp3);
  Try
    Try
      QGISbatName := fini.ReadString( 'PathNames', 'QgisBat', 'Error' );
      if ( QGISbatName='Error' ) or ( not FileExists( QGISbatName ) ) then
        raise Exception.CreateFmt('File [%s] does not exist', [ExpandFileName( QGISbatName )] )
      else begin
        QGISbatName := ExpandFileName( QGISbatName );
        WriteToLogFileFMT( 'QGIS batch file = [%s].', [QGISbatName] );
      end;

      Grid2ShapeExe := fini.ReadString( 'PathNames', 'Grid2ShapeExe', 'Error' );
      if ( Grid2ShapeExe='Error' ) or ( not FileExists( Grid2ShapeExe ) ) then
        raise Exception.CreateFmt('File [%s] does not exist', [ExpandFileName( Grid2ShapeExe )] )
      else begin
        Grid2ShapeExe := ExpandFileName( Grid2ShapeExe );
        WriteToLogFileFMT( 'Grid2ShapeExe = [%s].', [Grid2ShapeExe] );
      end;

      DefaultResolution := fini.ReadFloat( 'Settings', 'DefaultResolution', 5 );
      WriteToLogFileFMT( 'Default resolution = %f (m)', [DefaultResolution] );
      MainForm.SpinFloatEditResolution.Value := DefaultResolution;

      WriteToLogFileFMT( 'CurrentDir = [%s].', [GetCurrentDir] );

      Mode := Interactive;
      ApplicationFileName := ExpandFileName( ExtractFileName( ParamStr( 0 ) ) );

      if ( ParamCount = 1 ) and FileExists( ParamStr( 1 ) ) then begin
        WriteToLogFile( 'Test if mode is batch. If so, default resolution is used.');
        ParamStr1 := ExpandFileName( ParamStr( 1 ) );
        WriteToLogFileFMT( 'ParamStr( 1 ) = [%s].', [ParamStr1] );

        FileExt := Uppercase( ExtractFileExt( ParamStr1 ) );
        WriteToLogFile( 'FileExt = ' + FileExt );
        S := ''; // Triwaco grid filename
        if SameStr( FileExt, '.INI' ) and SameStr( JustName( ParamStr1 ), 'model' ) then begin
          WriteToLogFileFMT( 'Model.ini-file specified: [%s]', [ParamStr1] );
          Myfini := TIniFile.Create( ExpandFileName( ParamStr1 ) );
          i := Myfini.ReadInteger( 'Header', 'Type', -999 );

          WriteToLogFileFMT( 'Dataset number (=type) [%d] read from file: [%s] ', [i, ParamStr1] );
          if ( i = cGrid ) then begin // = ID of Triwaco Grid dataset
            S := ExtractFilePath( ParamStr1 ) + 'grid.teo';
            if FileExists( S ) then
              WriteToLogFileFmt( 'Triwaco Gridfile found: [%s].', [S] );
          end else
            raise Exception.CreateFmt( '[%s] Is not a Triwaco grid dataset.', [ParamStr1] );
          aResolution := Myfini.readFloat( 'POL', 'Options', -999 );
          if aResolution > 0 then begin
            MainForm.SpinFloatEditResolution.Value := aResolution;
            WriteToLogFileFMT( 'Resolution set to = %f (m)', [aResolution] );
          end else
            WriteToLogFileFMT( 'Resolution not specified in POL/options in %s ', [ParamStr1] );
          Myfini.Free;
        end else
          if SameStr( FileExt, '.TEO' )  then
            S := ExpandFileName( ParamStr( 1 ) );

        if ( S <> '' ) then begin
          Mode := Batch;
          MainForm.LabeledEditTriwacoGridFileName.Text := S;
          WriteToLogFileFmt( 'Mode = Batch.' + #13 +
                             'Triwaco grid file = [%s].' + #13 +
                             'Target resolution = %f.',
                             [S, MainForm.SpinFloatEditResolution.Value] );
        end;
      end;
      if ( Mode = Interactive ) then begin
        WriteToLogFile( 'Mode = Interactive.' );
        Application.Run;
      end else begin  // Mode = batch

        MainForm.Visible := False;
        MainForm.GoButton.Click;
      end;
    Except
      On E: Exception do begin
        HandleError( E.Message, true );
      end;
    End;
  Finally
  end;

end.
