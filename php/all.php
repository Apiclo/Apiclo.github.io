
<?php //网页Header,直接省略了<title>标签，分别卸载了在每个网页的<body>里
$head = <<<EOT
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
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
EOT?>

<?php //首页和导航的链接
    $index = '<a href="src.php" target="_blank" class="headmenu-btn">个人主页</a>';
    $intro = '<a href="intro.php" target="_blank" class="headmenu-btn">站点介绍</a>';
    $te = '<a href="te.php" target="_blank"  class="headmenu-btn">拓展资料</a>';
    $tasks = '<a href="../index.html" target="_blank" class="headmenu-btn">往期作业</a>';
?>

<?php //导航栏
$NavBar = <<<EOT
<div class="bg-dark">
<div class="navbar">
        <div class="animated fadeInDown">
                      <a href="index.php" target="_blank"  title="回到欢迎页" class="title-logo">Apiclo.</a>
                      <table border="0"  align="right">
                      <tr>
                      <td>$index</td>
                      <td>$te</td>
                      <td>$tasks</td>
                      <td>$intro</td>
                      <td>$index</td>
                      </tr>
                      </table>
        </div>
    </div>
</div>
</div>
EOT
?>


<?php //底部footer
$footer = '<div class="footer-all">窗外 Apiclo. </div></body></html>';?>



