Add-Type -AssemblyName System.Drawing
$targets = @(
  @{ Path = 'AppScope/resources/base/media/app_icon.png'; Size = 114 },
  @{ Path = 'AppScope/resources/base/media/icon.png'; Size = 128 },
  @{ Path = 'entry/src/main/resources/base/media/icon.png'; Size = 128 },
  @{ Path = 'entry/src/main/resources/base/media/startIcon.png'; Size = 144 }
)
foreach ($target in $targets) {
  $size = [int]$target.Size
  $bitmap = [System.Drawing.Bitmap]::new($size, $size)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.ScaleTransform($size / 128.0, $size / 128.0)
  $white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
  $ink = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#0F0026'))
  $cyanPen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#00C9E5'), 9)
  $cyanPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $cyanPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $cyanPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  function New-RoundedRect([float]$x,[float]$y,[float]$w,[float]$h,[float]$r) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $d = $r * 2
    $path.AddArc($x,$y,$d,$d,180,90)
    $path.AddArc($x+$w-$d,$y,$d,$d,270,90)
    $path.AddArc($x+$w-$d,$y+$h-$d,$d,$d,0,90)
    $path.AddArc($x,$y+$h-$d,$d,$d,90,90)
    $path.CloseFigure()
    return $path
  }
  $graphics.Clear([System.Drawing.ColorTranslator]::FromHtml('#6024B5'))
  $graphics.FillPath($white,(New-RoundedRect 33 27 62 74 11))
  $graphics.FillPath($ink,(New-RoundedRect 44 43 27 6 3))
  $graphics.FillPath($ink,(New-RoundedRect 44 57 18 6 3))
  $check = [System.Drawing.PointF[]]@([System.Drawing.PointF]::new(47,78),[System.Drawing.PointF]::new(57,88),[System.Drawing.PointF]::new(80,64))
  $graphics.DrawLines($cyanPen,$check)
  $graphics.Dispose()
  $bitmap.Save((Join-Path (Get-Location) $target.Path),[System.Drawing.Imaging.ImageFormat]::Png)
  $bitmap.Dispose()
}
