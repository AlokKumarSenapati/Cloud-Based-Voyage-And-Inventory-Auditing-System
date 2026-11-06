Add-Type -AssemblyName System.Drawing

$width = 3850
$height = 2380
$scale = 3.5

$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)

$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Clear White Background
$g.Clear([System.Drawing.Color]::White)

# Pens & Brushes
$blackPenThin = New-Object System.Drawing.Pen([System.Drawing.Color]::Black, (1.5 * $scale))
$blackPenMed = New-Object System.Drawing.Pen([System.Drawing.Color]::Black, (2.0 * $scale))
$blackPenThick = New-Object System.Drawing.Pen([System.Drawing.Color]::Black, (2.8 * $scale))

$dashPen = New-Object System.Drawing.Pen([System.Drawing.Color]::Black, (1.8 * $scale))
$dashPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash

$blackBrush = [System.Drawing.Brushes]::Black
$whiteBrush = [System.Drawing.Brushes]::White
$grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(244, 244, 244))

# Fonts
$fontFamily = "Arial"
$titleFont = New-Object System.Drawing.Font($fontFamily, (14.5 * $scale), [System.Drawing.FontStyle]::Bold)
$headerFont = New-Object System.Drawing.Font($fontFamily, (13.0 * $scale), [System.Drawing.FontStyle]::Bold)
$boxTitleFont = New-Object System.Drawing.Font($fontFamily, (12.0 * $scale), [System.Drawing.FontStyle]::Bold)
$bodyFont = New-Object System.Drawing.Font($fontFamily, (11.0 * $scale), [System.Drawing.FontStyle]::Regular)
$bodyBoldFont = New-Object System.Drawing.Font($fontFamily, (11.0 * $scale), [System.Drawing.FontStyle]::Bold)
$smallFont = New-Object System.Drawing.Font($fontFamily, (9.5 * $scale), [System.Drawing.FontStyle]::Regular)
$smallItalicFont = New-Object System.Drawing.Font($fontFamily, (9.5 * $scale), [System.Drawing.FontStyle]::Italic)

$sfCenter = New-Object System.Drawing.StringFormat
$sfCenter.Alignment = [System.Drawing.StringAlignment]::Center
$sfCenter.LineAlignment = [System.Drawing.StringAlignment]::Center

# Helper function to draw rounded or standard rectangle
function DrawBox($x, $y, $w, $h, $brush, $pen) {
    $rect = New-Object System.Drawing.Rectangle(($x * $scale), ($y * $scale), ($w * $scale), ($h * $scale))
    if ($brush -ne $null) { $g.FillRectangle($brush, $rect) }
    if ($pen -ne $null) { $g.DrawRectangle($pen, $rect) }
}

function DrawArrow($x1, $y1, $x2, $y2) {
    $p1 = New-Object System.Drawing.PointF(($x1 * $scale), ($y1 * $scale))
    $p2 = New-Object System.Drawing.PointF(($x2 * $scale), ($y2 * $scale))
    $g.DrawLine($blackPenThin, $p1, $p2)
    
    # Arrow head
    $angle = [Math]::Atan2($p2.Y - $p1.Y, $p2.X - $p1.X)
    $headLen = 14.0 * ($scale / 2.0)
    $arrP1 = New-Object System.Drawing.PointF(($p2.X - $headLen * [Math]::Cos($angle - [Math]::PI / 6)), ($p2.Y - $headLen * [Math]::Sin($angle - [Math]::PI / 6)))
    $arrP2 = New-Object System.Drawing.PointF(($p2.X - $headLen * [Math]::Cos($angle + [Math]::PI / 6)), ($p2.Y - $headLen * [Math]::Sin($angle + [Math]::PI / 6)))
    $g.FillPolygon($blackBrush, @($p2, $arrP1, $arrP2))
}

function DrawDoubleArrow($x1, $y1, $x2, $y2) {
    DrawArrow $x1 $y1 $x2 $y2
    DrawArrow $x2 $y2 $x1 $y1
}

# --- 1. Outer Border Frame ---
DrawBox 15 15 1070 650 $whiteBrush $blackPenThick

# --- 2. Column Headings ---
$g.DrawString("LOGISTICS DATA SOURCES", $titleFont, $blackBrush, (145 * $scale), (45 * $scale), $sfCenter)
$g.DrawString("API & ROUTING", $titleFont, $blackBrush, (385 * $scale), (45 * $scale), $sfCenter)
$g.DrawString("PROCESSING & AUDITING", $titleFont, $blackBrush, (635 * $scale), (45 * $scale), $sfCenter)
$g.DrawString("DATA & AUDIT EVIDENCE", $titleFont, $blackBrush, (915 * $scale), (45 * $scale), $sfCenter)

# --- 3. Column 1: Data Sources ---
$sources = @(
    @{ y = 70; text = "Vessel Telematics & AIS" },
    @{ y = 130; text = "Cargo Consignments & Bills" },
    @{ y = 190; text = "Warehouse Inventory (SKUs)" },
    @{ y = 250; text = "Physical Stocktaking Logs" },
    @{ y = 310; text = "User Credentials & Roles" },
    @{ y = 370; text = "Anti-Bot Canvas CAPTCHA" }
)

foreach ($s in $sources) {
    DrawBox 35 $s.y 220 42 $whiteBrush $blackPenThin
    $g.DrawString($s.text, $bodyFont, $blackBrush, (145 * $scale), (($s.y + 21) * $scale), $sfCenter)
    DrawArrow 255 ($s.y + 21) 310 ($s.y + 21)
}

# --- 4. Column 2: API & Routing Tall Box ---
DrawBox 310 70 150 342 $whiteBrush $blackPenMed
$g.DrawString("Spring Boot", $headerFont, $blackBrush, (385 * $scale), (195 * $scale), $sfCenter)
$g.DrawString("REST API Layer", $headerFont, $blackBrush, (385 * $scale), (218 * $scale), $sfCenter)
$g.DrawString("endpoints,`ndivision filters &`nsecurity policies", $smallFont, $blackBrush, (385 * $scale), (268 * $scale), $sfCenter)

# Arrow from Routing to Processing
DrawArrow 460 241 515 241

# Error Handling Box (Dashed)
$pErr1 = New-Object System.Drawing.PointF((385 * $scale), (412 * $scale))
$pErr2 = New-Object System.Drawing.PointF((385 * $scale), (455 * $scale))
$g.DrawLine($dashPen, $pErr1, $pErr2)
$g.DrawString("rejected / invalid", $smallItalicFont, $blackBrush, (405 * $scale), (435 * $scale))
DrawBox 310 455 150 48 $whiteBrush $dashPen
$g.DrawString("Security Error Log &`nException Handler", $bodyFont, $blackBrush, (385 * $scale), (479 * $scale), $sfCenter)

# --- 5. Column 3: Processing & Engine ---
# Polygon Web3 Contract (Top Dashed Box)
DrawBox 525 65 220 32 $whiteBrush $dashPen
$g.DrawString("Polygon Amoy (Web3 Contract)", $bodyFont, $blackBrush, (635 * $scale), (81 * $scale), $sfCenter)
DrawDoubleArrow 635 97 635 120

# Main Engine Box
DrawBox 515 120 240 342 $whiteBrush $blackPenMed
$g.DrawString("Application Engine (Java 21)", $boxTitleFont, $blackBrush, (635 * $scale), (145 * $scale), $sfCenter)

# Step 1
DrawBox 527 165 216 52 $grayBrush $blackPenThin
$g.DrawString("1 Ingest, validate token &`nanti-bot Captcha challenge", $bodyBoldFont, $blackBrush, (635 * $scale), (191 * $scale), $sfCenter)
DrawArrow 635 217 635 232

# Step 2
DrawBox 527 232 216 52 $grayBrush $blackPenThin
$g.DrawString("2 Stock reconciliation &`nvariance: Counted - Expected", $bodyBoldFont, $blackBrush, (635 * $scale), (258 * $scale), $sfCenter)
DrawArrow 635 284 635 299

# Step 3
DrawBox 527 299 216 52 $grayBrush $blackPenThin
$g.DrawString("3 Cryptographic SHA-256`ndigest & audit notarization", $bodyBoldFont, $blackBrush, (635 * $scale), (325 * $scale), $sfCenter)
DrawArrow 635 351 635 366

# Step 4: Approval Gate (Dashed)
DrawBox 527 366 216 42 $whiteBrush $dashPen
$g.DrawString("Supervisor Approval Gate (human)", $bodyFont, $blackBrush, (635 * $scale), (387 * $scale), $sfCenter)

# --- 6. Column 4: Data & Evidence ---
$evidence = @(
    @{ y = 80; title = "MySQL 8.4 Relational DB"; sub = "voyages, inventory & audit records"; fromY = 185 },
    @{ y = 150; title = "Amazon S3 Evidence Bucket"; sub = "audit PDF / JSON report archive"; fromY = 250 },
    @{ y = 220; title = "Polygon Blockchain Ledger"; sub = "immutable SHA-256 audit Tx proof"; fromY = 325 },
    @{ y = 290; title = "Amazon CloudWatch"; sub = "system logs, metrics & health alarms"; fromY = 350 },
    @{ y = 360; title = "Exception Alert Notifications"; sub = "email / SMS for stock variances"; fromY = 390 }
)

foreach ($e in $evidence) {
    DrawBox 805 $e.y 220 45 $whiteBrush $blackPenThin
    $g.DrawString($e.title, $bodyBoldFont, $blackBrush, (915 * $scale), (($e.y + 15) * $scale), $sfCenter)
    $g.DrawString($e.sub, $smallFont, $blackBrush, (915 * $scale), (($e.y + 31) * $scale), $sfCenter)
    DrawArrow 755 $e.fromY 805 ($e.y + 22)
}

# --- 7. Bottom Section: User & Dashboard ---
# User box
DrawBox 525 555 105 55 $whiteBrush $blackPenThin
$g.DrawString("Logistics Ops /`nAuditor /`nCustomer", $bodyFont, $blackBrush, (577 * $scale), (582 * $scale), $sfCenter)
DrawDoubleArrow 630 582 650 582

# Dashboard box
DrawBox 650 555 130 55 $grayBrush $blackPenThin
$g.DrawString("Dashboard`nReact 19 / Vite`n(Owner & Customer)", $bodyBoldFont, $blackBrush, (715 * $scale), (582 * $scale), $sfCenter)
DrawDoubleArrow 780 582 805 582

# Spring Boot REST API Box
DrawBox 805 555 150 55 $whiteBrush $blackPenThin
$g.DrawString("Spring Boot REST API`n(Port 8080 authenticated)", $bodyBoldFont, $blackBrush, (880 * $scale), (582 * $scale), $sfCenter)

# Feedback line from API to Approval Gate
$pFB1 = New-Object System.Drawing.PointF((880 * $scale), (555 * $scale))
$pFB2 = New-Object System.Drawing.PointF((880 * $scale), (435 * $scale))
$pFB3 = New-Object System.Drawing.PointF((755 * $scale), (435 * $scale))
$g.DrawLine($blackPenThin, $pFB1, $pFB2)
DrawArrow 880 435 755 435
$g.DrawString("approve / reject variance", $smallItalicFont, $blackBrush, (820 * $scale), (475 * $scale))

# Caption
$g.DrawString("Fig 2.1: End-to-End System Architecture of Cloud Voyage & Inventory Auditing System", $smallItalicFont, [System.Drawing.Brushes]::DimGray, (50 * $scale), (635 * $scale))

# Save Image as High-Resolution 4K PNG
$outputPath = "C:\Users\HP\OneDrive\Desktop\JAVA\docs\Fig_2_1_System_Architecture_4K.png"
$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Host "SUCCESS: Generated 4K Image at $outputPath"
