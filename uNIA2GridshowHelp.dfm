object FormShowHelp1: TFormShowHelp1
  Left = 0
  Top = 0
  Caption = 'FormShowHelp1'
  ClientHeight = 574
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 17
    Top = 24
    Width = 809
    Height = 481
    Lines.Strings = (
      
        'Maak Arc/Info binary grid (type: floating point) op basis van Tr' +
        'iwaco modelgrid (*.teo).  '
      'Tevens: clselmsf: elements (contains element numbers)'
      ''
      'Specify resolution in POL/options'
      ''
      ''
      
        'In dit grid (naam '#39'ClsNdsf'#39')  is in het Triwaco invloedsoppervla' +
        'k (node influence area) de waarde van het knoopnummer opgenomen.'
      
        'Het grid wordt in dezelfde folder gemaakt als waar het Triwaco m' +
        'odelgrid (*.teo) staat.'
      ''
      
        'Het Arc/Info binary grid '#39'ClsNdsf'#39' kan worden gebruikt om met Tr' +
        'iwaco berekende stijghoogten weer te geven t.o.v. een maaiveldsh' +
        'oogte grid (format  Arc/Info '
      
        'binary) met een relatief hoge resolutie. Hiervoor kan het progra' +
        'mma '#39'Gws'#39' of '#39'GLGGHGnap'#39' worden gebruikt.'
      ''
      
        'Voor de juiste werking van het programma NIA2Grid is het volgend' +
        'e nodig:'
      '       1. QGIS is geinstalleerd;'
      
        '       2. '#39'NIA2Grid.exe en'#39' en '#39'Grid2SHP.exe'#39' staan in de folder' +
        ' '#39'C:\ESRI\AV_GIS30\ARCVIEW\BIN32'#39';'
      
        '       3. Arc/View is eveneens geinstallerd in de bovenstaande f' +
        'older;'
      
        '       4. In de bovenstaande folder is tevens het bestand '#39'NIA2G' +
        'rid.exe en het bestand '#39'NIA2Grid.ini'#39' aanwezig. In het laatste b' +
        'estand zijn verwijzingen opgenomen '
      '           naar de '#39'qgis.bat'#39' en '#39'Grid2SHP.exe'#39': '
      '          [PathNames]'
      '          QgisBat=D:\Program Files\QGIS Lyon\bin\qgis.bat'
      
        '          Grid2ShapeExe=C:\ESRI\AV_GIS30\ARCVIEW\BIN32\Grid2SHP.' +
        'exe'
      ''
      
        '1. Bij gebruik in Trishell (Triwaco 4) kan het Arc/Info binary g' +
        'rid '#39'ClsNdsf'#39' '#39'automatisch'#39' worden aangemaakt bij de (Triwaco) g' +
        'rid generatie als het programma '
      
        'NIA2Grid.exe als postprocessor wordt gespecificeerd bij de gebru' +
        'ikte (Triwaco) gridder. Bij dit '#39'automatisch'#39' aanmaken van '#39'ClsN' +
        'dsf'#39' wordt altijd een resolutie van 5 '
      'meter gebruikt. Zie ook '#39'More Help'#39' hieronder.'
      ''
      
        'Om NIA2Grid.exe als postprocessor de specificeren ga in Trishell' +
        ' naar het menu '#39'Tools/Models'#39', tabblad '#39'Gridders'#39'. Geef bij de g' +
        'ebruikte gridder (meestal TestNet) '
      
        'NIA2Grid.exe op als postprocessor. Als nu het Triwaco grid wordt' +
        ' gegenereerd (Dataset/Run in de discretisation dataset) dan word' +
        't na het aanmaken van het'
      
        'Triwaco grid (grid.teo) tevens het Arc/Info binary grid '#39'ClsNdsf' +
        #39' gemaakt.'
      ''
      
        '2. Bij gebruik vanaf de command-prompt moet als eerste (en enige' +
        ' parameter) de naam van het  Triwaco modelgrid (*.teo) worden op' +
        'gegeven. Ook bij aanroep '
      
        'vanaf de command-prompt wordt de default resolutie van 5 meter g' +
        'ebruikt.'
      ''
      ''
      ''
      'KVI 18/12/207'
      '')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 696
    Top = 520
    Width = 114
    Height = 25
    Caption = 'More Help'
    TabOrder = 1
    OnClick = Button1Click
  end
end
