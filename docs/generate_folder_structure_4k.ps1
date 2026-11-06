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

# Clear Background (Dark IDE Theme)
$bgDark = [System.Drawing.Color]::FromArgb(30, 30, 30)
$bgSidebar = [System.Drawing.Color]::FromArgb(37, 37, 38)
$bgActivity = [System.Drawing.Color]::FromArgb(48, 48, 48)
$bgHeader = [System.Drawing.Color]::FromArgb(45, 45, 45)
$bgCard = [System.Drawing.Color]::FromArgb(40, 44, 52)
$borderColor = [System.Drawing.Color]::FromArgb(65, 65, 65)

$g.Clear($bgDark)

# Brushes
$whiteBrush = [System.Drawing.Brushes]::White
$darkBrush = New-Object System.Drawing.SolidBrush($bgDark)
$sidebarBrush = New-Object System.Drawing.SolidBrush($bgSidebar)
$activityBrush = New-Object System.Drawing.SolidBrush($bgActivity)
$headerBrush = New-Object System.Drawing.SolidBrush($bgHeader)
$cardBrush = New-Object System.Drawing.SolidBrush($bgCard)

$textWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 235, 235))
$textMuted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 160, 160))
$textYellow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(229, 192, 123))
$textBlue = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(97, 175, 239))
$textGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(152, 195, 121))
$textCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(86, 182, 194))
$textOrange = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(209, 154, 102))
$textRed = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(224, 108, 117))

# Pens
$borderPen = New-Object System.Drawing.Pen($borderColor, (1.2 * $scale))
$accentPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0, 122, 204), (2.0 * $scale))

# Fonts
$fontFamily = "Segoe UI"
$codeFontFamily = "Consolas"

$titleFont = New-Object System.Drawing.Font($fontFamily, (13.0 * $scale), [System.Drawing.FontStyle]::Bold)
$headerFont = New-Object System.Drawing.Font($fontFamily, (11.5 * $scale), [System.Drawing.FontStyle]::Bold)
$treeFont = New-Object System.Drawing.Font($codeFontFamily, (10.0 * $scale), [System.Drawing.FontStyle]::Regular)
$treeBold = New-Object System.Drawing.Font($codeFontFamily, (10.2 * $scale), [System.Drawing.FontStyle]::Bold)
$cardTitleFont = New-Object System.Drawing.Font($fontFamily, (12.0 * $scale), [System.Drawing.FontStyle]::Bold)
$cardTextFont = New-Object System.Drawing.Font($fontFamily, (10.0 * $scale), [System.Drawing.FontStyle]::Regular)
$smallItalic = New-Object System.Drawing.Font($fontFamily, (9.5 * $scale), [System.Drawing.FontStyle]::Italic)

$sfCenter = New-Object System.Drawing.StringFormat
$sfCenter.Alignment = [System.Drawing.StringAlignment]::Center
$sfCenter.LineAlignment = [System.Drawing.StringAlignment]::Center

# 1. Outer IDE Window Frame
$rectWindow = New-Object System.Drawing.Rectangle((15 * $scale), (15 * $scale), (1070 * $scale), (650 * $scale))
$g.DrawRectangle($borderPen, $rectWindow)

# 2. Top Title Bar
$rectTitle = New-Object System.Drawing.Rectangle((15 * $scale), (15 * $scale), (1070 * $scale), (35 * $scale))
$g.FillRectangle($headerBrush, $rectTitle)
$g.DrawRectangle($borderPen, $rectTitle)

# Mac/VS Code window buttons (Red, Yellow, Green)
$g.FillEllipse([System.Drawing.Brushes]::IndianRed, (28 * $scale), (26 * $scale), (11 * $scale), (11 * $scale))
$g.FillEllipse([System.Drawing.Brushes]::Goldenrod, (45 * $scale), (26 * $scale), (11 * $scale), (11 * $scale))
$g.FillEllipse([System.Drawing.Brushes]::MediumSeaGreen, (62 * $scale), (26 * $scale), (11 * $scale), (11 * $scale))

$g.DrawString("Cloud Voyage & Inventory Auditing System - Visual Studio Code (Project Architecture)", $titleFont, $textWhite, (550 * $scale), (32 * $scale), $sfCenter)

# 3. Left Activity Bar
$rectActivity = New-Object System.Drawing.Rectangle((15 * $scale), (50 * $scale), (45 * $scale), (615 * $scale))
$g.FillRectangle($activityBrush, $rectActivity)
$g.DrawRectangle($borderPen, $rectActivity)

$g.DrawString("[E]", $headerFont, $textWhite, (37 * $scale), (75 * $scale), $sfCenter)
$g.DrawString("[S]", $headerFont, $textMuted, (37 * $scale), (120 * $scale), $sfCenter)
$g.DrawString("[G]", $headerFont, $textMuted, (37 * $scale), (165 * $scale), $sfCenter)
$g.DrawString("[D]", $headerFont, $textMuted, (37 * $scale), (210 * $scale), $sfCenter)
$g.DrawString("[X]", $headerFont, $textMuted, (37 * $scale), (255 * $scale), $sfCenter)
$g.DrawString("[*]", $headerFont, $textMuted, (37 * $scale), (630 * $scale), $sfCenter)

# 4. File Explorer Tree Panel (Left Column: width 480)
$rectSidebar = New-Object System.Drawing.Rectangle((60 * $scale), (50 * $scale), (480 * $scale), (615 * $scale))
$g.FillRectangle($sidebarBrush, $rectSidebar)
$g.DrawRectangle($borderPen, $rectSidebar)

# Explorer Header
$rectExpHeader = New-Object System.Drawing.Rectangle((60 * $scale), (50 * $scale), (480 * $scale), (30 * $scale))
$g.FillRectangle($headerBrush, $rectExpHeader)
$g.DrawString("EXPLORER : CLOUD-VOYAGE-SYSTEM", $headerFont, $textMuted, (75 * $scale), (56 * $scale))

# --- Project Tree Elements ---
$treeLines = @(
    @{ indent = 0; tag = "v [DIR]"; text = "JAVA / (Root Monorepo Workspace)"; color = $textYellow; bold = $true },
    
    # Backend section
    @{ indent = 1; tag = "v [DIR]"; text = "backend/"; color = $textBlue; bold = $true },
    @{ indent = 2; tag = "v [DIR]"; text = "src/main/java/com/cloudvoyage/api/"; color = $textBlue; bold = $true },
    @{ indent = 3; tag = "  [JAVA]"; text = "AuthController.java (Anti-bot Captcha & Roles)"; color = $textGreen; bold = $false },
    @{ indent = 3; tag = "  [JAVA]"; text = "VoyageController.java (Maritime Telematics)"; color = $textGreen; bold = $false },
    @{ indent = 3; tag = "  [JAVA]"; text = "InventoryController.java (SKU & Stock Bins)"; color = $textGreen; bold = $false },
    @{ indent = 3; tag = "  [JAVA]"; text = "InventoryAuditController.java (Stock Variance)"; color = $textGreen; bold = $false },
    @{ indent = 3; tag = "  [JAVA]"; text = "BlockchainAuditController.java (SHA-256 Verify)"; color = $textGreen; bold = $false },
    @{ indent = 3; tag = "  [JAVA]"; text = "DashboardController.java (Aggregated KPIs)"; color = $textGreen; bold = $false },
    @{ indent = 3; tag = "  [JAVA]"; text = "CloudVoyageApiApplication.java (Entrypoint)"; color = $textGreen; bold = $false },
    @{ indent = 2; tag = "  [CONF]"; text = "application.properties (RDS MySQL & Port 8080)"; color = $textCyan; bold = $false },
    @{ indent = 1; tag = "  [MAVN]"; text = "pom.xml (Maven, Java 21 LTS, Spring Boot 4.1.1)"; color = $textOrange; bold = $true },
    
    # Frontend section
    @{ indent = 1; tag = "v [DIR]"; text = "frontend/"; color = $textCyan; bold = $true },
    @{ indent = 2; tag = "v [DIR]"; text = "src/"; color = $textCyan; bold = $true },
    @{ indent = 3; tag = "v [DIR]"; text = "components/"; color = $textCyan; bold = $true },
    @{ indent = 4; tag = "  [JSX]"; text = "AuthModal.jsx (Login/Register & Role Select)"; color = $textBlue; bold = $false },
    @{ indent = 4; tag = "  [JSX]"; text = "CaptchaCanvas.jsx (Dynamic Canvas Distortion)"; color = $textBlue; bold = $false },
    @{ indent = 4; tag = "  [JSX]"; text = "CustomerTrackingView.jsx (Consignment Portal)"; color = $textBlue; bold = $false },
    @{ indent = 4; tag = "  [JSX]"; text = "Sidebar.jsx (Owner/Customer Division Switcher)"; color = $textBlue; bold = $false },
    @{ indent = 4; tag = "  [JSX]"; text = "Topbar.jsx & MetricCard.jsx (KPI Widgets)"; color = $textBlue; bold = $false },
    @{ indent = 3; tag = "  [JS ]"; text = "api.js (Centralized REST Client & Fetch API)"; color = $textYellow; bold = $false },
    @{ indent = 3; tag = "  [JSX]"; text = "App.jsx (Core State & View Controller)"; color = $textBlue; bold = $true },
    @{ indent = 3; tag = "  [CSS]"; text = "styles.css (Responsive Dark/Light System Theme)"; color = $textRed; bold = $false },
    @{ indent = 1; tag = "  [JSON]"; text = "package.json (React 19, Vite Frontend Bundler)"; color = $textOrange; bold = $true },
    
    # Root DevOps
    @{ indent = 1; tag = "  [DOCK]"; text = "docker-compose.yml (App on 8080 + MySQL 8.4 on 3306)"; color = $textCyan; bold = $true },
    @{ indent = 1; tag = "  [DOCK]"; text = "Dockerfile (Multi-Stage Production Container Build)"; color = $textCyan; bold = $false },
    @{ indent = 1; tag = "  [DOCS]"; text = "README.md & docs/ (AWS Deployment Guide & Manuals)"; color = $textWhite; bold = $false }
)

$currY = 90
foreach ($item in $treeLines) {
    $xOffset = 75 + ($item.indent * 18)
    $f = if ($item.bold) { $treeBold } else { $treeFont }
    
    $lineStr = "$($item.tag) $($item.text)"
    $g.DrawString($lineStr, $f, $item.color, ($xOffset * $scale), ($currY * $scale))
    $currY += 20.5
}

# 5. Right Editor / Architecture Summary Area (Width: 545)
$rectEditor = New-Object System.Drawing.Rectangle((540 * $scale), (50 * $scale), (545 * $scale), (615 * $scale))
$g.FillRectangle($darkBrush, $rectEditor)

# Editor Tab Bar
$rectTabBar = New-Object System.Drawing.Rectangle((540 * $scale), (50 * $scale), (545 * $scale), (30 * $scale))
$g.FillRectangle($headerBrush, $rectTabBar)
$rectActiveTab = New-Object System.Drawing.Rectangle((540 * $scale), (50 * $scale), (240 * $scale), (30 * $scale))
$g.FillRectangle($darkBrush, $rectActiveTab)
$g.DrawLine($accentPen, (540 * $scale), (50 * $scale), (780 * $scale), (50 * $scale))
$g.DrawString("ARCHITECTURE-MANIFEST.md", $headerFont, $textWhite, (555 * $scale), (56 * $scale))

# --- Right Area: Detailed Structure Overview Cards ---
# Card 1: Backend Architecture Card
$card1Rect = New-Object System.Drawing.Rectangle((555 * $scale), (95 * $scale), (515 * $scale), (160 * $scale))
$g.FillRectangle($cardBrush, $card1Rect)
$g.DrawRectangle($borderPen, $card1Rect)
$g.DrawString("1. BACKEND ENTERPRISE MICROSERVICE (Java 21 LTS)", $cardTitleFont, $textGreen, (570 * $scale), (105 * $scale))
$g.DrawString("• Framework: Spring Boot 4.1.1 REST API + Spring Data JPA + Hibernate`n• Database Connector: MySQL Connector/J 8.4 & H2 In-Memory Driver`n• Authentication: Dynamic Anti-Bot Canvas Captcha + Role Permissions (RBAC)`n• Core Modules: Voyage telematics, warehouse item tracking & automated physical`n  audit stock variance calculations [Variance = Counted - Expected]`n• Security & Integrity: SHA-256 cryptographic report digests for blockchain notarization", $cardTextFont, $textWhite, (570 * $scale), (135 * $scale))

# Card 2: Frontend Client Card
$card2Rect = New-Object System.Drawing.Rectangle((555 * $scale), (270 * $scale), (515 * $scale), (150 * $scale))
$g.FillRectangle($cardBrush, $card2Rect)
$g.DrawRectangle($borderPen, $card2Rect)
$g.DrawString("2. CLIENT PRESENTATION DASHBOARD (React 19 + Vite)", $cardTitleFont, $textBlue, (570 * $scale), (280 * $scale))
$g.DrawString("• UI Engine: React 19 Single Page Application bundled with Vite`n• Dual-Division View Architecture:`n  - Owner Division: Full fleet command, inventory bins & physical audit reconciliations`n  - Customer Division: Public self-service consignment tracking (Cost data hidden)`n• Bot Protection: HTML5 Canvas noise distortion with mathematical verification challenges`n• Network Client: api.js centralized asynchronous REST communication", $cardTextFont, $textWhite, (570 * $scale), (310 * $scale))

# Card 3: Cloud & Containerization Card
$card3Rect = New-Object System.Drawing.Rectangle((555 * $scale), (435 * $scale), (515 * $scale), (150 * $scale))
$g.FillRectangle($cardBrush, $card3Rect)
$g.DrawRectangle($borderPen, $card3Rect)
$g.DrawString("3. DEVOPS & CLOUD DEPLOYMENT (Docker & AWS Architecture)", $cardTitleFont, $textOrange, (570 * $scale), (445 * $scale))
$g.DrawString("• Multi-stage Dockerfile: React frontend compiled into Spring Boot static web assets`n• Docker Compose: Single-command deployment (cloud-voyage-app + cloud-voyage-db)`n• AWS Target Infrastructure:`n  - AWS RDS: Multi-AZ managed MySQL 8.4 database (cloud_voyage_audit)`n  - AWS S3: Tamper-evident storage bucket for finalized audit JSON/PDF exports`n  - AWS EC2 / Beanstalk: Scalable application compute with CloudWatch metrics", $cardTextFont, $textWhite, (570 * $scale), (475 * $scale))

# Bottom Caption
$g.DrawString("Fig 3.1: Monorepo Project Directory Structure & Enterprise Module Breakdown (VS Code IDE)", $smallItalic, $textMuted, (555 * $scale), (635 * $scale))

# Save 4K PNG
$outputPath = "C:\Users\HP\OneDrive\Desktop\JAVA\docs\Fig_3_1_Project_Folder_Structure_4K.png"
$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Host "SUCCESS: Generated 4K Project Folder Structure Image at $outputPath"
