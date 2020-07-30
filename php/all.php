<?php //网页Header,直接省略了<title>标签，分别卸载了在每个网页的<body>里
$head = <<<NODOC
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
<link rel="stylesheet" href="../css/style.default.css" id="theme-stylesheet">
<link rel="stylesheet" href="../css/custom.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/table.css">
<link rel="stylesheet" href="../css/font.css">
<link rel="stylesheet" href="../css/layout.css">
<link rel="stylesheet" href="../css/phptest.css">
<link rel="stylesheet" href="../css/text.css">
<link rel="shortcut icon" href="../img/favicon.png">
<link href="https://cdn.bootcss.com/animate.css/3.7.2/animate.css" rel="stylesheet">
</head>
<body>
NODOC?>

<?php //首页和导航的链接
        $index = '<a href="src.php" target="_blank" class="headmenu-btn">个人主页</a>';
        $intro = '<a href="intro.php" target="_blank" class="headmenu-btn">站点介绍</a>';
        $te = '<a href="te.php" target="_blank"  class="headmenu-btn">Test</a>';
        $demo = '<a href="demo.php" target="_blank"  class="headmenu-btn">Demo</a>';
        $tasks = '<a href="../index.html" target="_blank" class="headmenu-btn">往期作业</a>';
?>

<?php //识别移动设备和桌面设备，没识别出来按桌面处理
    function uaDist(){
        $userAgent = $_SERVER['HTTP_USER_AGENT'];
        if(preg_match("/intel|mac os|windows|desktop|ubuntu|x86|centos/i", $userAgent)) {
            return 'desktop';
        }
        elseif(preg_match("/android|iphone|mobile|quark|al00/i", $userAgent)){
            return 'mobile';
        }
        else{
            return 'desktop';
        }
    }
?>
<?php function mainCard(){ if(uaDist()=='mobile'){echo 'style="width:80%;height:auto;margin:5px 0 0 5%;"';}else{echo '';}}?>
<?php //导航栏头
$NavBarFoot = "</tr></table></div></div></div></div>";
$NavBarHead = <<<NODOC
        <div class="bg-dark">
        <div class="navbar">
        <div class="animated fadeInDown">
        <a href="index.php" target="_blank"  title="回到欢迎页" class="title-logo">Apiclo.</a>
        <table border="0"  align="right">
        <tr>
NODOC
?>

<?php //导航栏
        
        
        if(uaDist() == 'mobile'){
            $NavBar = "$NavBarHead<td>$te</td><td>$demo</td>$NavBarFoot";
        }
        else{
            $NavBar = "$NavBarHead<td>$index</td><td>$te</td><td>$tasks</td><td>$intro</td><td>$demo</td>$NavBarFoot";
        }
    
?>


<?php //底部footer
$footer = '<div class="footer-all">窗外 Apiclo. </div></body></html>';?>



