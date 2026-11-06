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

# Theme Colors (VS Code Dark Modern)
$bgDark = [System.Drawing.Color]::FromArgb(30, 30, 30)
$bgHeader = [System.Drawing.Color]::FromArgb(45, 45, 45)
$bgTabBar = [System.Drawing.Color]::FromArgb(37, 37, 38)
$bgActiveTab = [System.Drawing.Color]::FromArgb(30, 30, 30)
$bgLineNum = [System.Drawing.Color]::FromArgb(30, 30, 30)
$borderColor = [System.Drawing.Color]::FromArgb(65, 65, 65)
$statusBg = [System.Drawing.Color]::FromArgb(0, 122, 204)

$g.Clear($bgDark)

# Brushes
$darkBrush = New-Object System.Drawing.SolidBrush($bgDark)
$headerBrush = New-Object System.Drawing.SolidBrush($bgHeader)
$tabBarBrush = New-Object System.Drawing.SolidBrush($bgTabBar)
$activeTabBrush = New-Object System.Drawing.SolidBrush($bgActiveTab)
$statusBrush = New-Object System.Drawing.SolidBrush($statusBg)

# Syntax Colors
$cText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(212, 212, 212))
$cLineNum = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(115, 115, 115))
$cComment = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(106, 153, 85))     # Green
$cTag = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(86, 156, 214))        # Blue
$cTagText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 220, 220))   # White/Light
$cAttr = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(156, 220, 254))       # Light Blue
$cString = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(206, 145, 120))     # Orange/Peach
$cKey = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(156, 220, 254))        # Cyan
$cEqual = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(212, 212, 212))
$cVal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(206, 145, 120))
$cSpecialVal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(181, 206, 168)) # Light Green

$borderPen = New-Object System.Drawing.Pen($borderColor, (1.2 * $scale))
$accentPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(0, 122, 204), (2.0 * $scale))
$splitPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(60, 60, 60), (1.5 * $scale))

# Fonts
$fontFamily = "Segoe UI"
$codeFontFamily = "Consolas"

$titleFont = New-Object System.Drawing.Font($fontFamily, (12.5 * $scale), [System.Drawing.FontStyle]::Bold)
$tabFont = New-Object System.Drawing.Font($fontFamily, (10.5 * $scale), [System.Drawing.FontStyle]::Regular)
$tabFontBold = New-Object System.Drawing.Font($fontFamily, (10.5 * $scale), [System.Drawing.FontStyle]::Bold)
$codeFont = New-Object System.Drawing.Font($codeFontFamily, (10.0 * $scale), [System.Drawing.FontStyle]::Regular)
$codeBold = New-Object System.Drawing.Font($codeFontFamily, (10.0 * $scale), [System.Drawing.FontStyle]::Bold)
$statusFont = New-Object System.Drawing.Font($fontFamily, (9.5 * $scale), [System.Drawing.FontStyle]::Regular)

$sfCenter = New-Object System.Drawing.StringFormat
$sfCenter.Alignment = [System.Drawing.StringAlignment]::Center
$sfCenter.LineAlignment = [System.Drawing.StringAlignment]::Center

$sfRight = New-Object System.Drawing.StringFormat
$sfRight.Alignment = [System.Drawing.StringAlignment]::Far

# --- 1. Outer Frame ---
$rectWindow = New-Object System.Drawing.Rectangle((15 * $scale), (15 * $scale), (1070 * $scale), (650 * $scale))
$g.DrawRectangle($borderPen, $rectWindow)

# --- 2. Title Bar ---
$rectTitle = New-Object System.Drawing.Rectangle((15 * $scale), (15 * $scale), (1070 * $scale), (35 * $scale))
$g.FillRectangle($headerBrush, $rectTitle)
$g.DrawRectangle($borderPen, $rectTitle)

# Mac buttons
$g.FillEllipse([System.Drawing.Brushes]::IndianRed, (28 * $scale), (26 * $scale), (11 * $scale), (11 * $scale))
$g.FillEllipse([System.Drawing.Brushes]::Goldenrod, (45 * $scale), (26 * $scale), (11 * $scale), (11 * $scale))
$g.FillEllipse([System.Drawing.Brushes]::MediumSeaGreen, (62 * $scale), (26 * $scale), (11 * $scale), (11 * $scale))

$g.DrawString("Cloud Voyage API - Configuration Manifest [pom.xml | application-prod.properties] - VS Code", $titleFont, $cText, (550 * $scale), (32 * $scale), $sfCenter)

# --- 3. Split Editor Layout ---
# Split width: Left = 535, Right = 535
$splitX = 550

# --- Tab Bar Left (pom.xml) ---
$rectTabLeft = New-Object System.Drawing.Rectangle((15 * $scale), (50 * $scale), (535 * $scale), (32 * $scale))
$g.FillRectangle($tabBarBrush, $rectTabLeft)
$g.DrawRectangle($borderPen, $rectTabLeft)

# Active tab Left
$rectActiveTabL = New-Object System.Drawing.Rectangle((15 * $scale), (50 * $scale), (220 * $scale), (32 * $scale))
$g.FillRectangle($darkBrush, $rectActiveTabL)
$g.DrawLine($accentPen, (15 * $scale), (50 * $scale), (235 * $scale), (50 * $scale))
$g.DrawString("[XML] pom.xml (Maven / Java 21)", $tabFontBold, $cText, (30 * $scale), (58 * $scale))

# --- Tab Bar Right (application.properties) ---
$rectTabRight = New-Object System.Drawing.Rectangle((550 * $scale), (50 * $scale), (535 * $scale), (32 * $scale))
$g.FillRectangle($tabBarBrush, $rectTabRight)
$g.DrawRectangle($borderPen, $rectTabRight)

# Active tab Right
$rectActiveTabR = New-Object System.Drawing.Rectangle((550 * $scale), (50 * $scale), (310 * $scale), (32 * $scale))
$g.FillRectangle($darkBrush, $rectActiveTabR)
$g.DrawLine($accentPen, (550 * $scale), (50 * $scale), (860 * $scale), (50 * $scale))
$g.DrawString("[CONF] application-prod.properties (AWS & RDS)", $tabFontBold, $cText, (565 * $scale), (58 * $scale))

# Vertical Split Line
$g.DrawLine($splitPen, ($splitX * $scale), (50 * $scale), ($splitX * $scale), (635 * $scale))

# --- LEFT PANE CONTENT: pom.xml ---
$pomLines = @(
    "<?xml version=""1.0"" encoding=""UTF-8""?>",
    "<project xmlns=""http://maven.apache.org/POM/4.0.0"">",
    "  <modelVersion>4.0.0</modelVersion>",
    "  <parent>",
    "    <groupId>org.springframework.boot</groupId>",
    "    <artifactId>spring-boot-starter-parent</artifactId>",
    "    <version>4.1.1</version>",
    "  </parent>",
    "  <groupId>com.cloudvoyage</groupId>",
    "  <artifactId>cloud-voyage-api</artifactId>",
    "  <version>0.0.1-SNAPSHOT</version>",
    "  <name>cloud-voyage-api</name>",
    "",
    "  <properties>",
    "    <java.version>21</java.version>",
    "    <maven.compiler.release>21</maven.compiler.release>",
    "  </properties>",
    "",
    "  <dependencies>",
    "    <!-- Spring Boot 4.x Starter Data JPA (Hibernate) -->",
    "    <dependency>",
    "      <groupId>org.springframework.boot</groupId>",
    "      <artifactId>spring-boot-starter-data-jpa</artifactId>",
    "    </dependency>",
    "    <!-- Validation & REST WebMVC Controllers -->",
    "    <dependency>",
    "      <groupId>org.springframework.boot</groupId>",
    "      <artifactId>spring-boot-starter-validation</artifactId>",
    "    </dependency>",
    "    <dependency>",
    "      <groupId>org.springframework.boot</groupId>",
    "      <artifactId>spring-boot-starter-webmvc</artifactId>",
    "    </dependency>",
    "    <!-- Production Relational Driver: MySQL 8.4 Connector -->",
    "    <dependency>",
    "      <groupId>com.mysql</groupId>",
    "      <artifactId>mysql-connector-j</artifactId>",
    "      <scope>runtime</scope>",
    "    </dependency>",
    "    <!-- Testing Driver: H2 In-Memory Database -->",
    "    <dependency>",
    "      <groupId>com.h2database</groupId>",
    "      <artifactId>h2</artifactId>",
    "      <scope>test</scope>",
    "    </dependency>",
    "  </dependencies>",
    "</project>"
)

$lineY = 92
$lineNum = 1
foreach ($line in $pomLines) {
    # Draw line number
    $g.DrawString($lineNum.ToString(), $codeFont, $cLineNum, (48 * $scale), ($lineY * $scale), $sfRight)
    
    # Syntax coloring based on content
    $xPos = 60 * $scale
    if ($line.Trim().StartsWith("<!--")) {
        $g.DrawString($line, $codeFont, $cComment, $xPos, ($lineY * $scale))
    } elseif ($line.Contains("java.version") -or $line.Contains("version>4.1.1")) {
        $g.DrawString($line, $codeBold, $cSpecialVal, $xPos, ($lineY * $scale))
    } elseif ($line.Contains("spring-boot-starter") -or $line.Contains("mysql-connector-j") -or $line.Contains("cloud-voyage-api")) {
        $g.DrawString($line, $codeFont, $cString, $xPos, ($lineY * $scale))
    } else {
        $g.DrawString($line, $codeFont, $cTag, $xPos, ($lineY * $scale))
    }
    
    $lineY += 13.5
    $lineNum++
}

# --- RIGHT PANE CONTENT: application-prod.properties ---
$propLines = @(
    "# ========================================================",
    "# AWS Cloud Production Profile: ""prod""",
    "# Cloud Voyage & Inventory Auditing System",
    "# ========================================================",
    "",
    "spring.application.name=cloud-voyage-api",
    "server.port=${PORT:8080}",
    "",
    "# --------------------------------------------------------",
    "# 1. AWS RDS MySQL 8.4 Database Connection",
    "# --------------------------------------------------------",
    "spring.datasource.url=jdbc:mysql://${RDS_ENDPOINT:localhost}:3306/",
    "   ${RDS_DB_NAME:cloud_voyage_audit}?useSSL=true&serverTimezone=UTC",
    "spring.datasource.username=${RDS_USERNAME:cloudvoyage_app}",
    "spring.datasource.password=${RDS_PASSWORD}",
    "spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver",
    "",
    "# --------------------------------------------------------",
    "# 2. Spring Data JPA & Hibernate ORM Configuration",
    "# --------------------------------------------------------",
    "spring.jpa.hibernate.ddl-auto=update",
    "spring.jpa.show-sql=false",
    "spring.jpa.open-in-view=false",
    "spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect",
    "spring.jpa.properties.hibernate.format_sql=true",
    "",
    "# --------------------------------------------------------",
    "# 3. AWS S3 Storage for Tamper-Evident Audit Reports",
    "# --------------------------------------------------------",
    "cloud.aws.region.static=${AWS_REGION:us-east-1}",
    "cloud.aws.s3.bucket=${S3_BUCKET_NAME:cloud-voyage-audit-reports}",
    "",
    "# --------------------------------------------------------",
    "# 4. Logging & CloudWatch Monitoring",
    "# --------------------------------------------------------",
    "logging.level.root=INFO",
    "logging.level.com.cloudvoyage.api=DEBUG"
)

$lineY = 92
$lineNum = 1
foreach ($line in $propLines) {
    # Draw line number
    $g.DrawString($lineNum.ToString(), $codeFont, $cLineNum, (585 * $scale), ($lineY * $scale), $sfRight)
    
    $xPos = 595 * $scale
    if ($line.Trim().StartsWith("#")) {
        $g.DrawString($line, $codeFont, $cComment, $xPos, ($lineY * $scale))
    } elseif ($line.Contains("=")) {
        $parts = $line.Split("=", 2)
        $k = $parts[0] + "="
        $v = $parts[1]
        
        $g.DrawString($k, $codeBold, $cKey, $xPos, ($lineY * $scale))
        $kWidth = $g.MeasureString($k, $codeBold).Width
        
        $vBrush = if ($v.Contains("true") -or $v.Contains("update") -or $v.Contains("8080")) { $cSpecialVal } else { $cVal }
        $g.DrawString($v, $codeFont, $vBrush, ($xPos + $kWidth), ($lineY * $scale))
    } else {
        $g.DrawString($line, $codeFont, $cVal, $xPos, ($lineY * $scale))
    }
    
    $lineY += 15.5
    $lineNum++
}

# --- 4. Bottom Status Bar ---
$rectStatus = New-Object System.Drawing.Rectangle((15 * $scale), (635 * $scale), (1070 * $scale), (30 * $scale))
$g.FillRectangle($statusBrush, $rectStatus)
$g.DrawRectangle($borderPen, $rectStatus)

$g.DrawString("main*  |  Java: 21 (LTS)  |  Spring Boot: 4.1.1  |  Database: MySQL 8.4  |  Port: 8080  |  Cloud: AWS RDS & S3", $statusFont, [System.Drawing.Brushes]::White, (30 * $scale), (642 * $scale))
$g.DrawString("UTF-8  |  Spaces: 2  |  XML / Properties  |  Prettier", $statusFont, [System.Drawing.Brushes]::White, (1060 * $scale), (642 * $scale), $sfRight)

# Save 4K PNG
$outputPath = "C:\Users\HP\OneDrive\Desktop\JAVA\docs\Fig_3_2_Backend_Configuration_pom_application_properties_4K.png"
$bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Host "SUCCESS: Generated 4K Configuration Screenshot at $outputPath"
